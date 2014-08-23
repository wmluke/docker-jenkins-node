#!/bin/bash

/etc/init.d/postgresql start
psql --command "ALTER USER postgres with password 'postgres';"
psql --command 'CREATE EXTENSION "adminpack";'
psql --command 'CREATE EXTENSION "uuid-ossp";'
psql --command "CREATE USER jenkins WITH PASSWORD 'jenkins';"
createdb -O postgres jenkins_db_1
createdb -O postgres jenkins_db_2
psql --command "GRANT ALL ON DATABASE jenkins_db_1 TO jenkins;"
psql --command "GRANT ALL ON DATABASE jenkins_db_2 TO jenkins;"
