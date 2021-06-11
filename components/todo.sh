#!/bin/bash

source components/common.sh

#Used export instead of service file
DOMAIN=ksrihari.online

OS_PREREQ

Head "Installing npm"
apt install npm -y &>>$LOG
Stat $?

Head "User adding"
deluser app
useradd -m -s /bin/bash app &>>$LOG
cd /home/app/
Stat $?

rm -rf todo
DOWNLOAD_COMPONENT
Stat $?

cd todo/
Stat $?

Head "installing npm in todo"
npm install -y &>>$LOG
Stat $?

Head "pass the EndPoints in Service File"
sed -i -e "s/redis-endpoint/redis.${DOMAIN}/" systemd.service
Stat $?

Head "Setup the systemd Service"
mv systemd.service /etc/systemd/system/todo.service &>>$LOG
Stat $?
systemctl daemon-reload && systemctl start todo && systemctl enable todo &>>$LOG
Stat $?