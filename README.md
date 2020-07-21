# Jenkins-node

 A docker image to be used for Jenkins testing

 This image provides
 * Ubuntu:16.04
 * Languages
    * JDK 1.8.0_91 / Maven 3.0.5
    * Node 6.9.1 via nvm
    * Ruby 2.1.2 via RVM
 * Tools
    * bower 1.7.9
    * grunt 1.2.0
    * phantomjs 2.1.1
    * compass 1.0.3
    * gem 2.4.8
 * Services
    * Postgres 9.4.8
    * Xvfb
 * Browsers
     * Firefox 36.0.4
     * Chromium 51.0.2704.79
     * Chrome 52.0.2743.82

### Environment Variables

* `JAVA_OPTS`, Default: `-Xmx2G -Xms2G -XX:PermSize=256M -XX:MaxPermSize=256m`
* `DISPLAY`, Default `:10`
* `XVFB_SCREEN_SIZE`, Default `1024x768x24`

### Examples

> `BUILD_TAG` and `WORKSPACE` are jenkins environment variables.

#### MVN Usage

```
$ docker run -i --rm --name $BUILD_TAG -v $WORKSPACE:$WORKSPACE --workdir="$WORKSPACE" wmluke/jenkins-node /bin/bash -c "/etc/init.d/postgresql start && mvn clean install"
```

#### Cucumber Usage

```
$ docker run -i --rm --name $BUILD_TAG -v $WORKSPACE:$WORKSPACE --workdir="$WORKSPACE" --env XVFB_SCREEN_SIZE=1920x1080x24 wmluke/jenkins-node /bin/bash -c "/etc/init.d/xvfb start && bundle install && cucumber features/xyz.feature"
```

#### Utils

```bash
$ /etc/init.d/xvfb start|stop|restart
```

#### Shims

`google-chrome` has been shimed disable sandboxing. See See https://github.com/docker/docker/issues/1079 for details.
