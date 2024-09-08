#!/usr/bin/bash


############################################                      script info                 ###############################################

# script purpose : Create a Bash script that serves as a simple process monitor,
# allowing users to view, manage, and analyze running processes on a Unix-like system



 


############################################  function declration & glopal varibles & sourcing files   ##############################################

declare LOG_FILE=Process_Monitor.log

# source configration file .
    if [[ -f "Process_Monitor.conf" ]]; then
    source "Process_Monitor.conf"
else
    echo "Error: Configuration file not found." >>$LOG_FILE
    exit 1
fi
 
###########################################      Print Function   #######################################

  function print(){
    echo $1
  }


#######################################  Function to LIST Running  Processes    #########################

function ListRunningProcesses(){

# list PID, name, CPU , Memory usage and command .
   ps aux | awk '{print $1, $2, $3, $4, $11}' | column -t 
}


#######################################  Function to get Information about Processes    #########################

function Process_Info(){

    declare -i PID
    print " Please Enter Process ID :"
    read PID
    print $'\n'

    # Checking if a Process Does Not Exist Using
   if ps aux | grep -v 'grep' | grep -q $PID; then
   ps -p $PID -o user,ppid,pid,%mem,%cpu,command
   else
   echo "Process with PID $PID does not exist."
   print $'\n'
   fi


}

#######################################  Function to Kill Process    #########################

function Kill_Process(){

    declare -i PID
    print " Please Enter Process ID :"
    read PID
    print $'\n'
    
   # Checking if a Process Does Not Exist Using
   if ps aux | grep -v 'grep' | grep -q $PID; then
   kill $PID
   echo "Process with ID: $PID is Killed "
   else
   echo "Process with PID $PID does not exist."
   print $'\n'
   fi

}

#######################################  Function to Display overall system process statistics   #########################

function Process_Statistics(){

print " Total Number of Running Processes : "  
   ps aux |  wc -l 
print $'\n'
print "  Memory Usage :" 
  free
print $'\n'
print " CPU Load : " 
   mpstat
print $'\n'   
}


#######################################  Function to update the display at regular intervals  #########################

function RealTimeMonitoring(){

    top -d $UPDATE_INTERVAL
}


#######################################  Function to search for processes based on criteria such as name, user, or resource usage #########################

function Search_Filter(){
 
    declare -i OPTION
    declare USER_NAME
    declare PROCESS_NAME

    print "Choose Filter Option :"
    print "1.User Name "
    print "2.Process Name"
    
    read OPTION
    print $'\n'
    
        case "${OPTION}" in
        1)
                print " Please Enter User Name :"
                read USER_NAME
                print $'\n'
                 # Checking if a Process Does Not Exist Using
                if ps aux | grep -v 'grep' | grep "$USER_NAME"; then
                 ps aux | grep -v 'grep' | grep "$USER_NAME"
                else
                echo "Process with User Name $USER_NAME does not exist."
                print $'\n'
                fi

        ;;
        2)
                print " Please Enter Process Name :"
                read PROCESS_NAME
                print $'\n'
                 # Checking if a Process Does Not Exist Using
                if ps aux | grep -v 'grep' | grep "$PROCESS_NAME"; then
                 ps aux | grep -v 'grep' | grep "$PROCESS_NAME"
                else
                echo "Process with Name $PROCESS_NAME does not exist."
                print $'\n'
                fi
        ;;
        *)
             print "Invalid Option "
        ;;
    esac
    
}
    
    
#######################################  Function to alerts for processes exceeding predefined resource usage #########################


function Resource_Usage_Alerts(){

  while true; do
  top -n 1 | grep -v 'grep' | awk '$3 > $CPU_ALERT_THRESHOLD {print "High CPU usage detected for process:", $2}' >>$LOG_FILE
  top -n 1 | grep -v 'grep' | awk '$4 > $MEMORY_ALERT_THRESHOLD {print "High Memory usage detected for process:", $2}'>>$LOG_FILE

  sleep 60
done & 
 
}


###########################################     Menu Function    #######################################

  function Show_Menu(){
     print $'\n'
    print "Choose Operation From Menu :"
    print $'\n'
    print "1.List Running Processes "
    print "2.Process Information "
    print "3.Kill Process "
    print "4.Process Statistics "
    print "5.Real-time Monitoring "
    print "6.Search and Filter "
    print "8.Exit Menu "
    print $'\n'

  }

###########################################     Select Option  #######################################

function Select_Option(){

 declare -i OPTION
 print "Please Enter Your Option : "
 read OPTION       # read option from user 
print $'\n'
    case "${OPTION}" in
        1)
            ListRunningProcesses
        ;;
        2)
            Process_Info
        ;;
        3)
            Kill_Process
        ;;    
        4)
            Process_Statistics
        ;;
        5)
            RealTimeMonitoring
        ;;
        6)
            Search_Filter
        ;;
       7)
            print " End Program "
            exit 0
            
        ;;
        *)
            print " Invalid option "
            
        ;;
        
    esac
    
}



####################################   #################################



###########################################################        main function           ############################################################### 

function main(){

while [ true ]; do
     
     Show_Menu 
     Select_Option
done

}



###########################################################      calling main            ##################################################################### 
main 