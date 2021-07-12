#!/bin/bash

source components/common.sh

#Used export instead of service file
DOMAIN=msarathkumar.online

OS_PREREQ

Head "Installing Nginx"
apt install nginx -y &>>$LOG
Stat $?

Head "Starting Nginx Service & Enable Nginx"
systemctl start nginx
systemctl enable nginx
Stat $?

Head "Installing npm and nodejs"
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash - &>>$LOG
sudo apt-get install nodejs -y &>>$LOG
Stat $?

Head "Installing NPM"
apt install npm -y &>>$LOG
Stat $?

Head "change and create the directories"
cd /var/www/html
rm -rf app
mkdir app &>>$LOG
cd app
Stat $?

DOWNLOAD_COMPONENT

Head "Changing to frontend directory"
cd frontend
Stat $?

Head "Installing npm"
npm install &>>$LOG


Head "run and build npm"
npm install node-sass &>>$LOG
npm run build &>>$LOG
sudo npm install --save-dev  --unsafe-perm node-sass &>>$LOG
Stat $?

#Head "Installing NPM under the frontend path"
#npm install npm@latest --save-dev  --unsafe-perm node-sass &>>$LOG
#Stat $?

Head "Updating private-ip's of Login & Todo with domain name's"
sed -i "32 s/127.0.0.1/login.'$DOMAIN'/g" /var/www/html/app/frontend/config/index.js
sed -i "36 s/127.0.0.1/todo.'$DOMAIN'/g" /var/www/html/app/frontend/config/index.js
#sed -i '40 s/127.0.0.1/0.0.0.0/g' /var/www/html/app/frontend/config/index.js
Stat $?

Head "Starting NPM"
systemctl restart nginx
npm start
Stat $?
