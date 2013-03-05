#!/bin/bash

FILE_DIRECTORY="//home/efeller/apps"
FILE_NAME="$FILE_DIRECTORY/wikiproc.jar"
USER="hadoop"
SSH_PRIVATE_KEY="/home/efeller/.ssh/id_rsa.vms"
SCP_BIN="/usr/bin/scp -i $SSH_PRIVATE_KEY"
DESTINATION_DIRECTORY="/home/hadoop/lbnl/"
DESTINATION_HOSTS="/home/efeller/apps/virtual_machine_hosts.txt"

for host in `cat $DESTINATION_HOSTS`
do 
  $SCP_BIN $FILE_NAME $USER@"$host":$DESTINATION_DIRECTORY
done
