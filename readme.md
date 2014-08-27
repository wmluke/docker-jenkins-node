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

```
USAGE: docker run -d -P [VOLUMES] wmluke/jenkins-slave [OPTIONS]

Starts a SSH server accessible by a `jenkins` user with password `jenkins`.

OPTIONS:
    --uid                   User ID to assign to the container's `jenkins` user
    --gid                   Group ID to assign to the container's `jenkins` user
    --password              Sets the password of the `jenkins` user.  Default password is `jenkins`.
    --with-postgres true    Start postgres server.  Default is `true`.
    
VOLUMES:
    All volumes mounted under `/home/jenkins` will be `chown`ed to the container's `jenkins` user.
    
    To inject SSH keys into the container, specify a host volume:
    
        -v /home/jenkins/.ssh:/home/jenkins/.ssh
        
    Other helpful volumes:
    
        -v /var/lib/jenkins/jobs:/home/jenkins/jobs
        -v /home/jenkins/.m2:/home/jenkins/.m2
        -v /home/jenkins/.npm:/home/jenkins/.npm
        -v /home/jenkins/.bower:/home/jenkins/.bower
```
