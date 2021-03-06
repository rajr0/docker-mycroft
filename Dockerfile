FROM ubuntu:16.04

MAINTAINER  Paul Scott <pscott209@gmail.com>

ENV TERM linux
ENV ENV DEBIAN_FRONTEND noninteractive

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Install.
RUN \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  apt-get update && \
  apt-get --allow-unauthenticated -y upgrade
RUN \
  apt-get install --allow-unauthenticated-y build-essential && \
  apt-get install --allow-unauthenticated-y software-properties-common && \
  apt-get install --allow-unauthenticated-y byobu curl git htop man unzip vim wget && \
  apt-get install --allow-unauthenticated-y python python-dev python-pip python-virtualenv python-setuptools python-gobject-dev && \
  apt-get install --allow-unauthenticated-y virtualenvwrapper && \
  apt-get install --allow-unauthenticated-y libtool autoconf bison swig alsa-utils libglib2.0-dev s3cmd && \
  apt-get install --allow-unauthenticated-y libglib2.0-dev portaudio19-dev mpg123 espeak supervisor screen flac && \
  apt-get install --allow-unauthenticated-y libffi6 libffi-dev libssl-dev && \
  rm -rf /var/lib/apt/lists/* && \
  mkdir /mycroft && \
  TOP=/mycroft && \
  cd /mycroft && \

  #git clone --recursive https://github.com/cmusphinx/pocketsphinx-python && \
  #cd /mycroft/pocketsphinx-python/sphinxbase && \
  #./autogen.sh && \
  #./configure && \
  #make && \
  #cd /mycroft/pocketsphinx-python/pocketsphinx && \
  #./autogen.sh && \
  #./configure && \
  #make && \
  #cd ../../ && \
  #cd /mycroft && \  
  
  # build and install pocketsphinx python bindings
  #cd /mycroft/pocketsphinx-python && \
  #python setup.py install && \
  #cd ../ && \
  #cd /mycroft && \

  # Checkout Mycroft
  git clone https://github.com/MycroftAI/mycroft-core.git /mycroft/ai/ && \
  cd /mycroft/ai && \
  # git fetch && git checkout dev && \ this branch is now merged to master
  easy_install pip==7.1.2 && \
  pip install -r requirements.txt --trusted-host pypi.mycroft.team && \
  pip install supervisor && \
  ./scripts/install-mimic.sh

  # install pygtk for desktop_launcher skill (will have to do this manually WIP)
  
# Set environment variables.
ENV HOME /mycroft

# Define working directory.
WORKDIR /mycroft
  
ENV PYTHONPATH $PYTHONPATH:/mycroft/ai/mycroft/client/speech/main.py
ENV PYTHONPATH $PYTHONPATH:/mycroft/ai/mycroft/client/messagebus/service/main.py
ENV PYTHONPATH $PYTHONPATH:/mycroft/ai/mycroft/client/skills/main.py

EXPOSE 8000

CMD ["/bin/bash"]
