# Jenkins-slave

 A docker image to be used for Jenkins testing
 
 This image provides
 * Languages
    * JDK 1.7, 1.8 / Maven 3.0.5
    * Node 0.10.24 via nvm
    * Ruby 2.1.2 via RVM
 * Services
    * Postgres 9.3
    * Xvfb
 * Browsers
     * Firefox
     * Chrome
     * Chromium

### Environment Variables

* `JAVA_OPTS`, Default: `-Xmx2G -Xms2G -XX:PermSize=256M -XX:MaxPermSize=256m`
* `DISPLAY`, Default `:10`
* `XVFB_SCREEN_SIZE`, Default `1024x768x24`

### Examples

> `BUILD_TAG` and `WORKSPACE` are jenkins environment variables.

#### MVN Usage

```
$ docker run -i --rm --name $BUILD_TAG -v $WORKSPACE:$WORKSPACE --workdir="$WORKSPACE" wmluke/jenkins-slave /bin/bash -c "/etc/init.d/postgresql start && mvn clean install"
```

#### Cucumber Usage

```
$ docker run -i --rm --name $BUILD_TAG -v $WORKSPACE:$WORKSPACE --workdir="$WORKSPACE" --env XVFB_SCREEN_SIZE=1920x1080x24 wmluke/jenkins-slave /bin/bash -c "/etc/init.d/xvfb start && bundle install && cucumber features/xyz.feature"
```

#### Utils

```bash
$ /etc/init.d/xvfb start|stop|restart
```

#### Shims

`google-chrome` has been shimed disable sandboxing. See See https://github.com/docker/docker/issues/1079 for details.
