#!/bin/bash
# HERE I HAVE TO CREATE A COMMON.SH FILE AND MOVE THE COMMON CODE FROM MONGODB.SH TO COMMON.SH
# AND THEN SOURCE THE COMMON.SH FILE IN MONGODB.SH TO AVOID CODE REPLICATION

source ./common.sh
check_root

cp mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? " Adding Mongo Repo"

dnf install mongodb-org -y &>> $LOGS_FILE
VALIDATE $? "installing Mongodb"

systemctl enable mongod &>> $LOGS_FILE
VALIDATE $? "Mongodb Enable"

systemctl start mongod &>> $LOGS_FILE
VALIDATE $? "Mongodb Start"

# Here i'm using the sed command to replace the bindIp value from
# 127.0.0.1 to 0.0.0.0 in the mongod.conf file
sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
VALIDATE $? "Allowing remote connections in Mongodb"

systemctl restart mongod &>> $LOGS_FILE
VALIDATE $? "Restarting Mongodb"
# Mongodb is installed and configured to allow remote connections

print_total_time