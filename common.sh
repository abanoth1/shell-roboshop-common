#!/bin/bash
# CREATED SEPARATE COMMON.SH FILE
# THIS SCRIPT IS TO BE SOURCED IN OTHER SCRIPTS TO AVOID CODE REPLICATION
# THIS SCRIPT CONTAINS COMMON VARIABLES AND FUNCTIONS USED ACROSS MULTIPLE SCRIPTS

R='\e[31m' # RED COLOR
G='\e[32m' # GREEN COLOR
Y='\e[33m' # YELLOW COLOR
B='\e[34m' # BLUE COLOR
M='\e[35m' # MAGENTA COLOR
C='\e[36m' # CYAN COLOR
W='\e[37m' # WHITE COLOR
N='\e[0m'  # NO COLOR

LOGS_FOLDER="/var/log/shell-roboshop"
SCRIPT_NAME=$( echo $0 | cut -d "." -f1 )
LOGS_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"
SCRIPT_DIR=$PWD
MONGODB_HOST="mongodb.daws86s.me"
START_TIME=$(date +%s)  # to capture script start time
# log file path /var/log/shell-roboshop/16-logs.log

mkdir -p $LOGS_FOLDER
echo "script execution started at : $(date)" | tee -a $LOGS_FILE

check_root() {      # function to check if the script is run as root user
    if [ "$USERID" -ne 0 ]; then
        echo "Error: Please run this script as root user or using sudo."
        exit 1 # failure is indicated by non-zero exit status
    fi
}

VALIDATE() {
    if [ $1 -ne 0 ]; then
        echo -e "$2 .... $R failure $N" | tee -a $LOGS_FILE
        exit 1
    else
        echo -e "$2 .... $G success $N" | tee -a $LOGS_FILE

        # HERE $1 is the exit status of the last executed command
        # and $2 is the name of the package
        # addingn colors to the output
        # adding loops to install multiple packages
    fi
}

node_js_setup(){  # function to setup NodeJS repository
    dnf module disable nodejs -y &>> $LOGS_FILE
    VALIDATE $? "Disabling Nodejs Module"

    dnf module enable nodejs:20 -y &>> $LOGS_FILE
    VALIDATE $? "Enabling Nodejs:20"

    dnf install nodejs -y &>> $LOGS_FILE
    VALIDATE $? " Installing Nodejs"

    npm install &>> $LOGS_FILE
    VALIDATE $? "Installing Nodejs Dependencies"
}
java_setup(){
    dnf install maven -y &>> $LOGS_FILE
    VALIDATE $? "Installing Maven"
    mvn clean package &>> $LOGS_FILE
    VALIDATE $? "Building $app_name Application"
    mv target/$app_name-1.0.jar $app_name.jar &>> $LOGS_FILE
    VALIDATE $? "Renaming $app_name Application Jar File"
}

python_setup(){
    dnf install python36 gcc python3-devel -y &>> $LOGS_FILE
    VALIDATE $? "Installing Python3 and Dependencies"

    pip3 install -r requirements.txt &>> $LOGS_FILE
    VALIDATE $? "Installing Python3 Dependencies"
   
}

app_setup(){
    mkdir -p /app
    VALIDATE $? "Creating Application Directory"

        id roboshop &>> $LOGS_FILE 
        if [ $? -ne 0 ]; then
            useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>> $LOGS_FILE
            VALIDATE $? "creating system user"
        else
            echo -e "roboshop user is already present .... $Y skipped $N"
        fi

    curl -o /tmp/$app_name.zip https://roboshop-artifacts.s3.amazonaws.com/$app_name-v3.zip &>> $LOGS_FILE
    VALIDATE $? "Downloading $app_name App Content"

    cd /app
    VALIDATE $? "Changing Directory to /app"

    rm -rf /app/* # remove old content if any
    VALIDATE $? "Removing Old Content"

    unzip /tmp/$app_name.zip &>> $LOGS_FILE
    VALIDATE $? "Extracting $app_name App Content"
    # Removed hardcoded application name and replaced with variable called app_name
}

systemd_setup(){  # function to setup systemd service
    cp $SCRIPT_DIR/$app_name.service /etc/systemd/system/$app_name.service &>> $LOGS_FILE
    VALIDATE $? "Copying $app_name service file"

    systemctl daemon-reload &>> $LOGS_FILE
    VALIDATE $? "Reloading systemd daemon"

    systemctl enable $app_name &>> $LOGS_FILE
    VALIDATE $? "Enabling $app_name service"
}

app_restart(){
    systemctl restart $app_name &>> $LOGS_FILE
    VALIDATE $? "Restarting $app_name service"
}

print_total_time() {  # function to print total time taken to execute the script
    END_TIME=$(date +%s)  # to capture script end time
    TOTAL_TIME=$(($END_TIME - $START_TIME))
    echo -e "Total time taken to execute the script: $Y $TOTAL_TIME seconds $N" #adding colors and outputting total time taken to execute the script
}