#!/bin/bash

. /opt/nvm/nvm.sh;
nvm install v4.4.3;
nvm alias default v4.4.3;
npm install -g grunt-cli;
npm install -g bower;
npm install -g phantomjs-prebuilt;
