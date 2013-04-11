#!/bin/bash
#
# Copyright (C) 2011-2012 Eugen Feller, INRIA <eugen.feller@inria.fr>
#
# This file is part of Snooze. Snooze is free software: you can
# redistribute it and/or modify it under the terms of the GNU General Public
# License as published by the Free Software Foundation, version 2.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
# 02110-1301, USA
#

copy_ssh_keys() {
    for i in `cat $tmp_directory/hosts_list.txt`;
    do
	scp -pr $ssh_private_key root@$i:~/.ssh/$ssh_key_name
    done
}

# Creates a list of hosts
create_hosts_list () {
    local job_resource_list="/var/lib/oar/$1"
    if [ ! -f $job_resource_list ]
    then
        return $error_code
    fi
    
    uniq $job_resource_list > $tmp_directory/hosts_list.txt
    local total_hosts=$(get_total_number_of_nodes)
    echo "$log_tag Total number of hosts: $total_hosts"
    echo "$log_tag Hosts list:" $(uniq $job_resource_list)
}

# Returns the total number of reserved nodes
get_total_number_of_nodes () {
    local nodes=`cat $tmp_directory/hosts_list.txt | wc -l`
    echo $nodes
}

get_total_cluster_size () {
    local size=$(($number_of_bootstrap_nodes+$number_of_group_managers+$number_of_local_controllers))
    echo $size
}

# Creates host files for the components
create_component_host_files () {
    echo "$log_tag Generating host files according to the settings"
        
    local total_number_of_reserved_hosts=$(get_total_number_of_nodes)
    if $centralized_deployment; then
        if [ $total_number_of_reserved_hosts -lt 2 ]; then
            echo "$log_tag Not enough reserved resources available!"
            exit $error_code
        fi
        create_centralized_host_files
    else
        local cluster_size=$(get_total_cluster_size)
        if [ $total_number_of_reserved_hosts -lt $cluster_size ]; then
            echo "$log_tag Not enough reserved resources available!"
            exit $error_code
        fi
    
        create_distributed_host_files
    fi
}

# Creates host files for distributed setup
create_distributed_host_files () {
    echo "$log_tag Creating host files for distributed setup"
    cat $tmp_directory/hosts_list.txt | sed -n 1,"$number_of_bootstrap_nodes"p > $tmp_directory/bootstrap_nodes.txt
    
    local start=$(($number_of_bootstrap_nodes+1))
    local end=$(($number_of_bootstrap_nodes+$number_of_group_managers))
    cat $tmp_directory/hosts_list.txt | sed -n $start,"$end"p > $tmp_directory/group_managers.txt
    
    start=$(($number_of_bootstrap_nodes + $number_of_group_managers+1))
    end=$(($number_of_bootstrap_nodes + $number_of_group_managers + $number_of_local_controllers))
    cat $tmp_directory/hosts_list.txt | sed -n $start,"$end"p > $tmp_directory/local_controllers.txt
}

# Creates host files for centralized setup
create_centralized_host_files () {
    echo "$log_tag Creating host files for centralized setup"
    local first_host=$(get_first_host_address)
    echo $first_host > $tmp_directory/bootstrap_nodes.txt
    echo $first_host > $tmp_directory/group_managers.txt
    
    local end=$(get_total_number_of_nodes)
    cat $tmp_directory/hosts_list.txt | sed -n 2,"$end"p > $tmp_directory/local_controllers.txt
}

# Copy directory to remote host
copy_directory_to_host () {
    echo "$log_tag Copying directory $1 to host $2 in directory $3"
    scp -pr $1 root@$2:$3
}

# Get job identifier from file
get_job_id () {
    # local job_id=$(grep "^OAR_JOB_ID" $tmp_directory/job_id.txt | awk -F\, '{print $1}' | cut -c 12-)
    echo $OAR_JOB_ID
}

# Attach port to hosts
attach_port_to_hosts () {
    local addresses
    let line_counter=0
        
    for line in $(cat "$tmp_directory/$1"); do
        let line_counter=$(($line_counter+1))
        
        if [ $line_counter -eq 1 ] ; then
            addresses=$line:$2
        else
            addresses+=","$line:$2
        fi
    done
    
    echo $addresses
}

# Returns the first host address
get_first_host_address () {
    local first_host=`cat $tmp_directory/hosts_list.txt | head -n 1`
    echo $first_host
}

# Gets the first bootstrap address
get_first_bootstrap_address() {      
    local first_bootstrap_address=`cat $tmp_directory/bootstrap_nodes.txt | head -n 1`
    echo $first_bootstrap_address
}

# Returns the subnets of a job
get_virtual_machine_subnet () 
{
    local virtual_machine_subnet=$(g5k-subnets -j $1 -a | awk '{print $1}' | sed 's/\//\\\//g')    
    echo $virtual_machine_subnet
}
