# My jenkin docker

# Setting the base image of which docker image is being created
FROM jenkins/jenkins:jdk11

LABEL maintainer="minhnhut0602@gmail.com"
LABEL description="A docker image made from jenkins lts and flutter installed"

# Switching to root user to install dependencies and flutter
USER root

RUN apt-get update


RUN apt-get -y install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
RUN apt-key fingerprint 0EBFCD88
RUN add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"

RUN apt-get update
RUN apt-get -y install docker-ce docker-ce-cli containerd.io

# Installing the different dependencies required for Flutter, installing flutter from beta channel from github and giving permissions to jenkins user to the folder
RUN apt-get update && apt-get install -y --force-yes git wget unzip libgconf-2-4 gdb libstdc++6 libglu1-mesa fonts-droid-fallback lib32stdc++6 python3 \
    && apt-get clean \
    && git clone -b beta https://github.com/flutter/flutter.git /usr/local/flutter \
    && chown -R jenkins:jenkins /usr/local/flutter

# Switching to jenkins user - a good practice
USER jenkins

# Running flutter doctor to check if flutter was installed correctly
RUN /usr/local/flutter/bin/flutter doctor -v \
    && rm -rfv /flutter/bin/cache/artifacts/gradle_wrapper

# Setting flutter and dart-sdk to PATH so they are accessible from terminal
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"
