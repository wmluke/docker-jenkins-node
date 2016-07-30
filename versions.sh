#!/usr/bin/env bash

#source /root/.profile
source /opt/nvm/nvm.sh;
source /usr/local/rvm/scripts/rvm

echo "Installed"
echo ""
echo "> java versions"
java -version 2>&1
mvn -version

echo ""
echo "> ruby versions"
ruby -v
echo "gem version: $(gem -v)"
compass -v

echo ""
echo "> node versions"
echo "node $(node -v)"
echo "npm $(npm -v)"
echo "bower $(bower -v)"
echo "$(grunt -version)"
echo "phantomjs $(phantomjs -v)"

echo ""
echo "> postgres version"
psql --version

echo ""
echo "> browser versions"
firefox -v 2> /dev/null
chromium-browser -version 2> /dev/null
google-chrome -version
echo ""