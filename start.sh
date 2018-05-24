#!/bin/bash

check_status() {
    status=$?
    if [ $status -ne 0 ]; then
	echo "Failed the start $1: $status"
	exit $status
    fi
}

### Initialize all the services ###
/etc/lab1 1001 &
check_status "lab1"

/etc/lab2 1002 &
check_status "lab2"

/etc/lab3 1003 &
check_status "lab3"

/etc/lab4 1004 &
check_status "lab4"

python /etc/sponge.py &
check_status "sponge.py"

python /etc/compiler_server.py &
check_status "compiler_server.py"

/etc/echoserver 4445 &
check_status "echoserver"

python /etc/BockServe.py &
check_status "BockServe.py"

echo "Successfully started all services!"

while sleep 60; do
    ### Services that need to be checked ###
    
    ps aux | grep sponge.py | grep -q -v grep
    PROCESS_5_STATUS=$?
    ps aux | grep compiler_server.py | grep -q -v grep
    PROCESS_6_STATUS=$?
    ps aux | grep echoserver | grep -q -v grep
    PROCESS_7_STATUS=$?
    ps aux | grep BockServe.py | grep -q -v grep
    PROCESS_8_STATUS=$?

    ### Services that need to be restarted ###
    
    # if lab1 is not running bring it back up
    ps aux | grep lab1 | grep -q -v grep
    PROCESS_1_STATUS=$?
    if [ $PROCESS_1_STATUS -ne 0 ]; then
       /etc/lab1 1001 &
       ps aux | grep lab1 | grep -q -v grep
       PROCESS_1_STATUS=$?
    fi

    # if lab2 is not running bring it back up
    ps aux | grep lab2 | grep -q -v grep
    PROCESS_2_STATUS=$?
    if [ $PROCESS_2_STATUS -ne 0 ]; then
       /etc/lab2 1002 &
       ps aux | grep lab2 | grep -q -v grep
       PROCESS_2_STATUS=$?
    fi
 
    # if lab2 is not running bring it back up
    ps aux | grep lab3 | grep -q -v grep
    PROCESS_3_STATUS=$?
    if [ $PROCESS_3_STATUS -ne 0 ]; then
       /etc/lab3 1003 &
       ps aux | grep lab3 | grep -q -v grep
       PROCESS_3_STATUS=$?
    fi

    # if lab2 is not running bring it back up
    ps aux | grep lab4 | grep -q -v grep
    PROCESS_4_STATUS=$?
    if [ $PROCESS_4_STATUS -ne 0 ]; then
       /etc/lab4 1004 &
       ps aux | grep lab4 | grep -q -v grep
       PROCESS_4_STATUS=$?
    fi

    # If the greps above find anything, they exit with 0 status
    # If they are not both 0, then something is wrong
    if [ $PROCESS_1_STATUS -ne 0 -o $PROCESS_2_STATUS -ne 0 ]; then
	echo "One of the processes has already exited."
	exit 1
    fi
    if [ $PROCESS_3_STATUS -ne 0 -o $PROCESS_4_STATUS -ne 0 ]; then
	echo "One of the processes has already exited."
	exit 1
    fi
    if [ $PROCESS_5_STATUS -ne 0 -o $PROCESS_6_STATUS -ne 0 ]; then
	echo "One of the processes has already exited."
	exit 1
    fi
    if [ $PROCESS_7_STATUS -ne 0 -o $PROCESS_8_STATUS -ne 0 ]; then
	echo "One of the processes has already exited."
	exit 1
    fi
done
