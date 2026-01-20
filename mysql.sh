#!/bin/bash
# THIS SCRIPT IS TO INSTALL MYSQL SERVER AND SET THE ROOT PASSWORD
# CREATED SEPARATE COMMON.SH FILE
# THIS SCRIPT IS TO BE SOURCED IN OTHER SCRIPTS TO AVOID CODE REPLICATION
# AND THIS SCRIPT CONTAINS COMMON VARIABLES AND FUNCTIONS USED ACROSS MULTIPLE SCRIPTS

source ./common.sh # sourcing the common.sh file to use common functions and variables

check_root # calling the check_root function to ensure the script is run as root user

dnf install mysql-server -y &>>$LOG_FILE # installing mysql server
VALIDATE $? "Installing MySQL Server"
systemctl enable mysqld &>>$LOG_FILE # enabling mysql server
systemctl start mysqld  #&>>$LOG_FILE # starting mysql server
VALIDATE $? "Enabling and Starting MySQL Server"
mysql_secure_installation --set-root-pass RoboShop@1 &>>$LOG_FILE  # setting root password to mysql server
VALIDATE $? "Setting root password to MySQL Server"
print_total_time