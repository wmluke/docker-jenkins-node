FROM ubuntu:14.04
MAINTAINER Luke Bunselmeyer <wmlukeb@gmail.com>

RUN locale-gen en_US.UTF-8
RUN dpkg-reconfigure locales
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

COPY locale /etc/default/locale

#RUN echo "deb http://archive.ubuntu.com/ubuntu trusty main universe" > /etc/apt/sources.list
RUN apt-get -qq update
RUN apt-get install -y build-essential python-software-properties software-properties-common wget curl git fontconfig

# Java 1.7
RUN wget --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/7u67-b01/jdk-7u67-linux-x64.tar.gz
RUN mkdir -p /opt/jdk
RUN tar -zxf jdk-7u67-linux-x64.tar.gz -C /opt/jdk

# Java 1.8
RUN wget --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u11-b12/jdk-8u11-linux-x64.tar.gz
RUN mkdir -p /opt/jdk
RUN tar -zxf jdk-8u11-linux-x64.tar.gz -C /opt/jdk

# Maven 3.0.5
RUN wget http://apache.petsads.us/maven/maven-3/3.0.5/binaries/apache-maven-3.0.5-bin.tar.gz
RUN mkdir -p /opt/maven
RUN tar -zxf apache-maven-3.0.5-bin.tar.gz -C /opt/maven
RUN ln -s /opt/maven/apache-maven-3.0.5/bin/mvn /usr/bin

# Set the default java version to 1.7
RUN update-alternatives --install /usr/bin/java java /opt/jdk/jdk1.7.0_67/bin/java 100
RUN update-alternatives --install /usr/bin/javac javac /opt/jdk/jdk1.7.0_67/bin/javac 100

# Set Java and Maven env variables
ENV M2_HOME /opt/maven/apache-maven-3.0.5
ENV JAVA_HOME /opt/jdk/jdk1.7.0_67
ENV JAVA_OPTS -Xmx2G -Xms2G -XX:PermSize=256M -XX:MaxPermSize=256m

# Postgresql 9.3
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" > /etc/apt/sources.list.d/pgdg.list
RUN apt-get update
RUN apt-get -y -q install postgresql-9.3 postgresql-client-9.3 postgresql-contrib-9.3

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
RUN apt-get -y install xvfb x11-xkb-utils xfonts-100dpi xfonts-75dpi xfonts-scalable xfonts-cyrillic dbus-x11 libfontconfig1-dev
RUN apt-get -y install firefox chromium-browser ca-certificates
COPY firefox /root/.mozilla/firefox

RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -P /tmp/
RUN dpkg -i /tmp/google-chrome-stable_current_amd64.deb || true
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
