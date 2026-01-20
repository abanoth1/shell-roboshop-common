#!/bin/bash
# CREATED SEPARATE COMMON.SH FILE
# THIS SCRIPT IS TO BE SOURCED IN OTHER SCRIPTS TO AVOID CODE REPLICATION
# AND THIS SCRIPT CONTAINS COMMON VARIABLES AND FUNCTIONS USED ACROSS MULTIPLE SCRIPTS  

source ./common.sh
check_root  # calling the check_root function to ensure the script is run as root user

cp $SCRIPT_DIR/rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo &>> $LOGS_FILE
VALIDATE $? "Copying RabbitMQ Repo" # copying rabbitmq repo

dnf install rabbitmq-server -y &>> $LOGS_FILE
VALIDATE $? " Installing RabbitMQ Server" # installing rabbitmq server

systemctl enable rabbitmq-server &>> $LOGS_FILE
VALIDATE $? " Enabling RabbitMQ Service" # enabling rabbitmq service

systemctl start rabbitmq-server &>> $LOGS_FILE
VALIDATE $? " Starting RabbitMQ Service" # starting rabbitmq service

rabbitmqctl add_user roboshop roboshop123 &>> $LOGS_FILE
VALIDATE $? " Adding RabbitMQ Application User" # adding application user

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>> $LOGS_FILE
VALIDATE $? " Setting RabbitMQ Application User Permissions" # setting application user permissions

print_total_time  # calling the print_total_time function to print the total time taken for script execution