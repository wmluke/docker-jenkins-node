#!/bin/bash

. /opt/nvm/nvm.sh;
nvm install v4.4.3;
nvm install v6.9.1;
nvm alias default v6.9.1;
npm install -g grunt-cli;
npm install -g bower;
npm install -g phantomjs-prebuilt;
