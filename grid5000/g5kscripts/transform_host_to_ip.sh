#!/bin/bash

for host in `cat $OAR_NODE_FILE | uniq`
do
   result=$(host -t A $host)
   echo "${result##* }" >> $1
done
