#!/bin/bash
#
# Copyright (C) 2010-2012 Eugen Feller, INRIA <eugen.feller@inria.fr>
#
# This file is part of Snooze, a scalable, autonomic, and
# energy-aware virtual machine (VM) management framework.
#
# This program is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation, either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, see <http://www.gnu.org/licenses>.
#

perform_virtual_cluser_tasks () 
{
    echo "$log_tag Creating virtual cluster, propagating images, and starting"
    prepare_and_create_virtual_cluster $1 $2
    propagate_base_image
    propagate_virtual_cluster $1
    start_virtual_cluster $1
}

configure_mapreduce ()
{
    case "$1" in
    'one_data') echo "$log_tag Configuring MapReduce with one data node VM per physical machine"
        $python "$mapreduce_filter_compute_and_data_script" $snoozeclient_output_formatted $mapreduce_data_nodes_file $mapreduce_compute_nodes_file
        $python "$mapreduce_script" "mapreduce_separatedata" "--data" `cat $mapreduce_data_nodes_file` "--compute" `cat $mapreduce_compute_nodes_file`
        local master_node=$(get_first_host `cat $mapreduce_data_nodes_file`)
        echo $master_node > $mapreduce_master_node
        ;;
    'variable_data') echo "$log_tag Configuring MapReduce with variable number of compute and data VMs"
        echo "$log_tag Number of data nodes:"
        read number_of_data_nodes
        echo "$log_tag Number of compute nodes:"
        read number_of_compute_nodes
        data_nodes=`cat $virtual_machine_hosts | sed -n 1,"$number_of_data_nodes"p`
        number_of_virtual_machines=$(get_number_of_virtual_machines)
        compute_nodes=`cat $virtual_machine_hosts | sed -n $(($number_of_data_nodes+1)),"$number_of_virtual_machines"p`
        $python "$mapreduce_script" "mapreduce_separatedata" "--data" $data_nodes "--compute" $compute_nodes
        local master_node=$(get_first_host $data_nodes)
        echo $master_node > $mapreduce_master_node
        ;;
    'normal')
        local hosts_list=$(get_virtual_machine_hosts)
        echo "$log_tag Configuring MapReduce in normal mode on: $hosts_list"
        $python "$mapreduce_script" "mapreduce_normal" "--hosts" $hosts_list
        local master_node=$(get_first_host $hosts_list)
        echo $master_node > $mapreduce_master_node
        ;;
    *) echo "$log_tag Unknown command received!"
       ;;
    esac
}

start_mapreduce_test_case () 
{
    case "$1" in
    'start')
        echo "$log_tag Cluster name:"
        read cluster_name
        echo "$log_tag Number of VMs:"
        read number_of_vms
        perform_virtual_cluser_tasks $cluster_name $number_of_vms
        ;;
    'storage')
        local hosts_list=$(get_virtual_machine_hosts)
        $python $mapreduce_script "storage" "--hosts" $hosts_list "--job_id" $mapreduce_storage_jobid
        ;;
    'configure') 
        echo "$log_tag Configuration mode (normal, one_data, variable_data):"
        read configuration_mode
        configure_mapreduce $configuration_mode
        ;;
    'benchmark')
        echo "$log_tag Benchmark name (e.g. dfsio, dfsthroughput, mrbench, nnbench, pi, teragen, terasort, teravalidate, censusdata, censusbench, wikidata, wikibench):"
        read benchmark_name
        local master_node=$(get_hadoop_master_node)
        $python "$mapreduce_script" "benchmark" "--name" $benchmark_name "--master" $master_node
        ;;
    *) echo "$log_tag Unknown command received!"
       ;;
    esac
}
