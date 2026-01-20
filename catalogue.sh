#!/bin/bash
# CREATED SEPARATE COMMON.SH FILE
# THIS SCRIPT IS TO BE SOURCED IN OTHER SCRIPTS TO AVOID CODE REPLICATION
# AND THIS SCRIPT CONTAINS COMMON VARIABLES AND FUNCTIONS USED ACROSS MULTIPLE SCRIPTS 

source ./common.sh
app_name=catalogue  # Created a app_name variable to hold the application name

app_setup  # calling the app_setup function to setup the application directory
node_js_setup  # calling the node_js_setup function to setup NodeJS repository
systemd_setup  # calling the systemd_setup function to setup systemd service

cp $SCRIPT_DIR/mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "Copy mongo repo"

dnf install mongodb-mongosh -y &>> $LOGS_FILE
VALIDATE $? "Installing Mongodb Shell Client"

INDEX=$(mongosh mongodb.daws86s.me --quiet --eval "db.getMongo().getDBNames().indexOf('catalogue')")
if [ $INDEX -le 0 ]; then
    mongosh --host $MONGODB_HOST </app/db/master-data.js &>> $LOGS_FILE
    VALIDATE $? "Loading $app_name Schema to Mongodb"
else
    echo -e "$app_name Schema is already present in Mongodb .... $Y skipped $N"
fi

app_restart  # calling the app_restart function to restart the application service
print_total_time_taken  # calling the print_total_time function to print the total time taken for script execution
