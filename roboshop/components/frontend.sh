#!/bin/bash
ID=$(id -u)
if [ $id -ne 0 ] ; then
    echo "This script is xpectd to be run by oot user or with sudo previlage"
    exit -1
fi

echo "The frontend is the service in RobotShop to serve the web content over Nginx "
echo "Installing Nginx :"
yum install nginx -y
exit 1



To Install Nginx.

# yum install nginx -y
# systemctl enable nginx 
# systemctl start nginx 
Let's download the HTDOCS content and deploy under the Nginx path.

# curl -s -L -o /tmp/frontend.zip "https://github.com/stans-robot-project/frontend/archive/main.zip"
Deploy in Nginx Default Location.

# cd /usr/share/nginx/html
# rm -rf * 
# unzip /tmp/frontend.zip
# mv frontend-main/* .
# mv static/* .
# rm -rf frontend-master README.md
# mv localhost.conf /etc/nginx/default.d/roboshop.conf
Finally restart the service once to effect the changes.

# systemctl restart nginx 