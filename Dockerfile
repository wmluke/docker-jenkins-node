FROM ubuntu:14.04
MAINTAINER Luke Bunselmeyer <wmlukeb@gmail.com>

COPY bootstrap bootstrap
RUN chmod +x -Rv bootstrap

#RUN echo "deb http://archive.ubuntu.com/ubuntu trusty main universe" > /etc/apt/sources.list
RUN apt-get -qq update
RUN apt-get install -y build-essential python-software-properties software-properties-common wget curl git

# SSH server
RUN apt-get install -y openssh-server
RUN sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd
RUN mkdir -p /var/run/sshd

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

USER postgres

RUN ./bootstrap/postgres.sh

#VOLUME  ["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql"]

USER root

# Add user jenkins to the image
RUN adduser --quiet jenkins
RUN echo "jenkins:jenkins" | chpasswd

# NVM
RUN mkdir -p /opt/nvm
RUN git clone https://github.com/creationix/nvm.git /opt/nvm
RUN ./bootstrap/nvm.sh

# Adjust perms for jenkins user
RUN chown -R jenkins /opt/nvm
RUN touch /home/jenkins/.profile
RUN echo "source /opt/nvm/nvm.sh" >> /home/jenkins/.profile
RUN chown jenkins /home/jenkins/.profile

RUN locale-gen en_US.UTF-8
RUN dpkg-reconfigure locales

# Ruby
RUN apt-get install ruby1.9.1 ruby1.9.1-dev rubygems1.9.1 -y
RUN gem install compass


# Standard SSH port
EXPOSE 22

# Startup services when running the container
ENTRYPOINT ["./bootstrap/init.sh"]
