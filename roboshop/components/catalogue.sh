#!/bin/bash

COMPONENT=catalogue
LOGFILE="/tmp/${COMPONENT}.log"
APPUSER="roboshop"

echo "The catalogue is the service in roboshop "
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

echo -e *************"\e[32m $COMPONENT Installation is started \e[0m"*************

echo -n "Configuring the $COMPONENT repo: "
curl --silent --location https://rpm.nodesource.com/setup_16.x | sudo bash - &>> $LOGFILE
stat $?

echo -n "Installing NodeJS"
yum install nodejs -y  &>> $LOGFILE
stat $?

id $APPUSER
if [ $? -ne 0 ] ;then
echo -n "Creating the service Account:"
useradd $APPUSER  &>> $LOGFILE
stat $?
fi

echo -n "Installing $COMPONENT :"
echo -n "Download the $COMPONENT component: "
curl -s -L -o /tmp/catalogue.zip "https://github.com/stans-robot-project/catalogue/archive/main.zip"
stat $?

echo -n "Copying the $COMPONENT to $APPUSER home directory: "
cd /home/roboshop
rm -rf ${COMPONENT} &>> $LOGFILE
unzip -o /tmp/catalogue.zip  &>> $LOGFILE
stat $?

echo -n "Modifying the ownership: "
mv $COMPONENT-main/ $COMPONENT
chown -R $APPUSER:$APPUSER /home/roboshop/$COMPONENT/
stat $?

echo -n " Generating npm $COMPONENT artifacts: "
cd /home/${APPUSER}/${COMPONENT}/ &>> $LOGFILE
npm install &>> $LOGFILE
stat $?

echo -n " update the IP address of $COMPONENT systemd file: "
sed -i -e "s/MONGO_DNSNAME/mongodb.roboshop.internal.b54-roboshop.online"  /home/${APPUSER}/${COMPONENT}/systemd.service
mv /home/roboshop/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service
stat $?

echo -n "Starting the ${COMPONENT} service:"
systemctl daemon-reload &>> $LOGFILE
systemctl enable $COMPONENT &>> $LOGFILE
systemctl restart $COMPONENT &>> $LOGFILE
stat $?



# Let's now set up the catalogue application.

# As part of operating system standards, we run all the applications and databases as a normal user but not with root user.

# So to run the catalogue service we choose to run as a normal user and that user name should be more relevant to the project. Hence we will use roboshop as the username to run the service.

# # useradd roboshop
# So let's switch to the roboshop user and run the following commands.

# $ curl -s -L -o /tmp/catalogue.zip "https://github.com/stans-robot-project/catalogue/archive/main.zip"
# $ cd /home/roboshop
# $ unzip /tmp/catalogue.zip
# $ mv catalogue-main catalogue
# $ cd /home/roboshop/catalogue
# $ npm install 
# NOTE: We need to update the IP address of MONGODB Server in systemd.service file
# Now, lets set up the service with systemctl.

# # mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service
# # systemctl daemon-reload
# # systemctl start catalogue
# # systemctl enable catalogue