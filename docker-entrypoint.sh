#!/bin/bash

# Run the config
/rad-cfg.sh

# Start Radius and save the PID
printf "Starting Radius Server\n"
su -c "freeradius -X" root &
export RAD_PID=$!
printf "The PID = ${RAD_PID}\n"

# Trap the signals and
# stop RAD gracefully...sort of
trap "{ kill -9 ${RAD_PID}; exit $?; }" SIGTERM SIGINT

# Check if the process has gone away; if so, exit with non-zero
# Loop until signal
printf "Going to loop until signal\n"
while :
do
    sleep 4
    # Die if Radius has shutdown
    ## Check for the startup pid
    ps -ef|awk '{ print $2 }'|grep ${RAD_PID}; radius_alive=`echo $?`
    ## If we don't find the pid, exit non-zero
    if [[ ${radius_alive} -eq 1 ]] ; then
        exit 4
    fi
done
