# Jenkins-slave

 A docker image to be used with the Jenkins [docker-plugin](https://wiki.jenkins-ci.org/display/JENKINS/Docker+Plugin)
 
 This image provides
 * Languages
    * JDK 1.7, 1.8 / Maven 3.0.5
    * Node 0.10.24 via nvm
    * Ruby 1.9.1
 * Services
    * Postgres 9.3
    * Open SSH
    * Xvfb
 * Browsers
     * Firefox
     * Chrome
     * Chromium

### Usage

#### SSH

By default starts a SSH server accessible by a `jenkins` user with password `jenkins` with following OPTIONS...

```
USAGE: docker run -d -P [VOLUMES] wmluke/jenkins-slave [OPTIONS]

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

#### Custom

Alternatively, you can forgo ssh to run custom commands

```
$ docker run -i --rm --name $BUILD_TAG -v $WORKSPACE:$WORKSPACE --workdir="$WORKSPACE" wmluke/jenkins-slave /bin/bash -c "/etc/init.d/postgresql start && mvn clean install"
```

Where `BUILD_TAG` and `WORKSPACE` are jenkins environment variables.

#### Utils

```bash
$ /etc/init.d/xvfb start|stop|restart
```

#### Shims

`google-chrome` has been shimed disable sandboxing. See See https://github.com/docker/docker/issues/1079 for details.
