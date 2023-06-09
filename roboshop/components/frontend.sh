#!/bin/bash

COMPONENT=frontend
LOGFILE="/tmp/${COMPONENT}.log"

echo "The frontend is the service in RobotShop to serve the web content over Nginx "
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

echo -n "Installing Nginx :"
yum install nginx -y &>> $LOGFILE
stat $?

echo -n "Downloading the ${COMPONENT} component :"
curl -s -L -o /tmp/frontend.zip "https://github.com/stans-robot-project/frontend/archive/main.zip"
stat $?

echo -n "Performing clean-up: "
cd /usr/share/nginx/html
rm -rf * &>> $LOGFILE
stat $?

echo -n "Extracting ${COMPONENT} component :"
unzip /tmp/${COMPONENT}.zip   &>> $LOGFILE
mv $COMPONENT-main/* .
mv static/* .
rm -rf ${COMPONENT}-main README.md .
mv localhost.conf /etc/nginx/default.d/roboshop.conf
stat $?

##Finally restart the service once to effect the changes.
