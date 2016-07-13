#!/bin/bash

. /usr/local/rvm/scripts/rvm
rvm install 2.2.2
gem install compass bundle
rvm install 2.1.2
rvm --default use 2.1.2
gem install compass bundle
