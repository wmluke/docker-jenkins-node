FROM ubuntu:16.04
MAINTAINER Luke Bunselmeyer <wmlukeb@gmail.com>

ENV DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true

RUN locale-gen --purge en_US.UTF-8
RUN dpkg-reconfigure locales
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

COPY locale /etc/default/locale

#RUN echo "deb http://archive.ubuntu.com/ubuntu trusty main universe" > /etc/apt/sources.list
RUN apt-get -qq update
RUN apt-get -y -q install build-essential python-software-properties software-properties-common wget curl git fontconfig rpm

# Java 1.8
RUN apt-get -y -q install openjdk-8-jdk

# Maven 3.0.5
COPY maven /opt/maven
RUN tar -zxf /opt/maven/apache-maven-3.0.5-bin.tar.gz -C /opt/maven
RUN ln -s /opt/maven/apache-maven-3.0.5/bin/mvn /usr/bin

# Set Java and Maven env variables
ENV M2_HOME /opt/maven/apache-maven-3.0.5
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
ENV JAVA_OPTS -Xmx2G -Xms2G -XX:PermSize=256M -XX:MaxPermSize=256m

# Postgresql 9.4
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main" > /etc/apt/sources.list.d/pgdg.list
RUN apt-get -qq update
RUN apt-get -y -q install postgresql-9.4 postgresql-client-9.4 postgresql-contrib-9.4

# Workaround for AUFS perms issue: https://github.com/docker/docker/issues/783#issuecomment-56013588
# RUN mkdir /etc/ssl/private-copy; mv /etc/ssl/private/* /etc/ssl/private-copy/; rm -r /etc/ssl/private; mv /etc/ssl/private-copy /etc/ssl/private; chmod -R 0700 /etc/ssl/private; chown -R postgres /etc/ssl/private

# Load scripts
COPY bootstrap bootstrap
RUN chmod +x -Rv bootstrap

USER postgres

RUN ./bootstrap/postgres.sh

USER root

# Add user jenkins to the image
RUN adduser --quiet jenkins
RUN adduser jenkins sudo
RUN echo "jenkins:jenkins" | chpasswd

# NVM
RUN mkdir -p /opt/nvm
RUN git clone https://github.com/creationix/nvm.git /opt/nvm
RUN ./bootstrap/nvm.sh
RUN echo "source /opt/nvm/nvm.sh" >> /root/.profile

# Adjust perms for jenkins user
RUN chown -R jenkins /opt/nvm
RUN touch /home/jenkins/.profile
RUN echo "source /opt/nvm/nvm.sh" >> /home/jenkins/.profile
RUN chown jenkins /home/jenkins/.profile

# Ruby via RVM
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
RUN \curl -sSL https://get.rvm.io | bash -s stable
RUN ./bootstrap/rvm.sh
#RUN . /usr/local/rvm/scripts/rvm && rvm install 2.1.2
RUN echo "source /usr/local/rvm/scripts/rvm" >> /root/.profile
RUN echo "source /usr/local/rvm/scripts/rvm" >> /home/jenkins/.profile

# Browsers
RUN apt-get -y -q install xvfb x11-xkb-utils xfonts-100dpi xfonts-75dpi xfonts-scalable xfonts-cyrillic dbus-x11 libfontconfig1-dev
RUN apt-get -y -q install chromium-browser ca-certificates

COPY firefox/firefox-46.0.tar.bz2 /opt/firefox-46.0.tar.bz2
COPY firefox/profile /root/.mozilla/firefox
RUN tar -jxvf /opt/firefox-46.0.tar.bz2 -C /opt
ENV PATH /opt/firefox:$PATH

COPY chrome/google-chrome-stable_current_amd64.deb /opt/google-chrome-stable_current_amd64.deb
RUN dpkg -i /opt/google-chrome-stable_current_amd64.deb || true
RUN apt-get install -fy

# Shim chrome to disable sandbox
# See https://github.com/docker/docker/issues/1079
RUN mv /usr/bin/google-chrome /usr/bin/google-chrome.orig
COPY shims/google-chrome /usr/bin/google-chrome
RUN chmod +x /usr/bin/google-chrome

# xvfb
COPY init.d/xvfb /etc/init.d/xvfb
RUN chmod +x /etc/init.d/xvfb

ENV DISPLAY :10
ENV LD_LIBRARY_PATH /usr/lib/x86_64-linux-gnu/
ENV XVFB_SCREEN_SIZE 1024x768x24

# Need some fonts
COPY fonts/sourcesanspro /usr/share/fonts/sourcesanspro
RUN fc-cache -v /usr/share/fonts/sourcesanspro

## Install yarn
RUN apt-key adv --fetch-keys http://dl.yarnpkg.com/debian/pubkey.gpg
RUN echo "deb http://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install yarn -y

COPY versions.sh /tmp/versions.sh
RUN chmod +x /tmp/versions.sh
RUN /tmp/versions.sh
