#!/bin/bash

COMPONENT=mongodb
LOGFILE="/tmp/${COMPONENT}.log"

ID=$(id -u)
if [ $ID -ne 0 ] ; then
    echo "\e[31m This script is expectd to be run by root user or with sudo previlage \e[0m"
    exit 1
fi

stat(){
if [ $1 -eq 0 ] ; then
    echo -e "\e[32m success \e[0m"
else
    echo -e "\e[32m failure \e[0m"
    exit 2
fi   
}

echo -n "Configuring the $COMPONENT repo: "
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/stans-robot-project/mongodb/main/mongo.repo
stat $?

echo -n "Installing $COMPONENT :"
yum install mongodb-org -y &>> $LOGFILE
stat $?

echo -n "starting $COMPONENT :"
systemctl enable mongod    &>> $LOGFILE
systemctl start mongod     &>> $LOGFILE
stat $?

echo -n " Enabling the DB visibility"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongo.conf
stat $?





##Setup MongoDB repos.
##echo '[mongodb-org-4.2]
##name=MongoDB Repository
##baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/4.2/x86_64/
##gpgcheck=1
##enabled=1
##gpgkey=https://www.mongodb.org/static/pgp/server-4.2.asc' >/etc/yum.repos.d/mongodb.repo
##Install Mongo & Start Service.
# systemctl enable mongod
# systemctl start mongod
Update Liste IP address from 127.0.0.1 to 0.0.0.0 in config file
Config file: /etc/mongod.conf

##then restart the service

# systemctl restart mongod
##Every Database needs the schema to be loaded for the application to work.
##Download the schema and load it.

# curl -s -L -o /tmp/mongodb.zip "https://github.com/stans-robot-project/mongodb/archive/main.zip"

# cd /tmp
# unzip mongodb.zip
# cd mongodb-main
# mongo < catalogue.js
# mongo < users.js 