#!/bin/bash

VOLUME_HOME="/app"
VOLUME_HOME_MYSQL="/var/lib/mysql"


# Test if VOLUME_HOME has content
if [[ ! "$(ls -A $VOLUME_HOME)" ]]; then
     echo "Add Spree at $VOLUME_HOME"
     cp -R /tmp/app/* $VOLUME_HOME
  fi



# Test MySQL VOLUME_HOME_MYSQL has content
if [[ ! -d $VOLUME_HOME/mysql ]]; then
     echo "=> An empty or uninitialized MySQL volume is detected in $VOLUME_HOME_MYSQL"
     echo "=> Installing MySQL ..."
     mysql_install_db > /dev/null 2>&1
     echo "=> Done!"
     /create_mysql_admin_user.sh
 else
     echo "=> Using an existing volume of MySQL"
 fi


# Start MySQL
/usr/bin/mysqld_safe > /dev/null 2>&1 &

RET=1
while [[ RET -ne 0 ]]; do
  echo "=> Waiting for confirmation of MySQL service startup"
  sleep 5
  mysql -uroot -e "status" > /dev/null 2>&1
  RET=$?
done


# Create Spree database
cd /app && rake db:create db:migrate


# Start the Rails Server
echo "Start Rails Server"
/app/bin/bundle exec rails server
