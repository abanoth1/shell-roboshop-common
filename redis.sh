#!/bin/bash
# CREATED SEPARATE COMMON.SH FILE
# THIS SCRIPT IS TO BE SOURCED IN OTHER SCRIPTS TO AVOID CODE REPLICATION
# AND THIS SCRIPT CONTAINS COMMON VARIABLES AND FUNCTIONS USED ACROSS MULTIPLE SCRIPTS

source ./common.sh

check_root  # calling the check_root function to ensure the script is run as root user

check_root  # calling the check_root function to ensure the script is run as root user

dnf module disable redis -y &>> $LOGS_FILE # disabling the default redis module
VALIDATE $? "Disabling Redis Module"

dnf module enable redis:7 -y &>> $LOGS_FILE # enabling redis version 7
VALIDATE $? "Enabling Redis:7"

dnf install redis -y &>> $LOGS_FILE # installing redis
VALIDATE $? " Installing Redis"

sed -i -e 's/127.0.0.1/0.0.0.0/g' -e '/protected-mode/ c protected-mode no' /etc/redis/redis.conf  # allowing remote connections
VALIDATE $? "Allowing remote connections in Redis"
 
systemctl enable redis &>> $LOGS_FILE # enabling redis service
VALIDATE $? "Enabling Redis Service"

systemctl start redis &>> $LOGS_FILE # starting redis service
VALIDATE $? "Starting Redis Service"

print_total_time