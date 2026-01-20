#!/bin/bash
# CREATED SEPARATE COMMON.SH FILE
# THIS SCRIPT IS TO BE SOURCED IN OTHER SCRIPTS TO AVOID CODE REPLICATION
# AND THIS SCRIPT CONTAINS COMMON VARIABLES AND FUNCTIONS USED ACROSS MULTIPLE SCRIPTS
source ./common.sh
app_name=cart  # Created a app_name variable to hold the application name
check_root  # calling the check_root function to ensure the script is run as root user
app_setup  # calling the app_setup function to setup the application directory
node_js_setup  # calling the node_js_setup function to setup NodeJS repository
systemd_setup  # calling the systemd_setup function to setup systemd service
app_restart  # calling the app_restart function to restart the application service
print_total_time  # calling the print_total_time function to print the total time taken for script execution