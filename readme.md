# Jenkins-slave

 A docker image to be used with the Jenkins [docker-plugin](https://wiki.jenkins-ci.org/display/JENKINS/Docker+Plugin)
 
 This image provides
 * JDK 1.7, 1.8
 * Maven 3.0.5
 * Node 0.10.24 via nvm
 * Ruby 1.9.1
 * Postgres 9.3
 * Open SSH

### Usage

To inject SSH keys into the container, specify a host volume, `[PATH_TO_SSH_FOLDER_ON_HOST]:/home/jenkins/.ssh`:

```
docker run -d -P -v [PATH_TO_SSH_FOLDER_ON_HOST]:/home/jenkins/.ssh wmluke/jenkins-slave
```
