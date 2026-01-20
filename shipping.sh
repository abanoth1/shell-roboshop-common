#!/bin/bash
# CREATED SEPARATE COMMON.SH FILE
# THIS SCRIPT IS TO BE SOURCED IN OTHER SCRIPTS TO AVOID CODE REPLICATION
# AND THIS SCRIPT CONTAINS COMMON VARIABLES AND FUNCTIONS USED ACROSS MULTIPLE SCRIPTS  

source ./common.sh
app_name=shipping  # Created a app_name variable to hold the application name
check_root  # calling the check_root function to ensure the script is run as root user
app_setup  # calling the app_setup function to setup the application directory
java_setup  # calling the java_setup function to setup Java application
systemd_setup  # calling the systemd_setup function to setup systemd service
dnf install mysql -y &>> $LOGS_FILE # installing mysql client
VALIDATE $? "Installing Mysql Client"
mysql -h $MYSQL_HOST -uroot -pRoboShop@1 -e 'use cities'  &>>$LOG_FILE
if [ $? -ne 0 ]; then
    mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/schema.sql &>>$LOG_FILE
    mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/app-user.sql &>>$LOG_FILE
    mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/master-data.sql &>>$LOG_FILE
else
    echo -e "shipping database is already present ... $Y SKIPPING $N"
fi 
app_restart  # calling the app_restart function to restart the application service
print_total_time  # calling the print_total_time function to print the total time taken for script
