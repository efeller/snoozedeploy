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

# Binaries
ifconfig="/sbin/ifconfig"
dstat="/usr/bin/dstat"

# Dstat settings
dstat_collection_count=5000
dstat_collection_delay=2
log_directory="/tmp/snooze/logs"
node_hostname=$(hostname)
dstat_output_file="$log_directory/$node_hostname".dat

# Init script settings
main_init_script="/etc/init.d/snoozenode"
main_init_script_backup="/etc/init.d/snoozenode_backup"
bootstrap_init_script=/"etc/init.d/snoozenode_bs"
group_manager1_init_script=/"etc/init.d/snoozenode_gm1"
group_manager2_init_script="/etc/init.d/snoozenode_gm2"
zookeeper_init_script="/etc/init.d/zookeeper"

# G5K settings
grid5000_user="test"
tmp_directory="/home/$grid5000_user/snoozedeploy/grid5000/deployscript/tmp"

# Configs settings
configs_directory="/usr/share/snoozenode/configs/"
bootstrap_config_file="$configs_directory/snooze_node_bs.cfg"
groupmanager1_config_file="$configs_directory/snooze_node_gm1.cfg"
groupmanager2_config_file="$configs_directory/snooze_node_gm2.cfg"

main_log4j_config="$configs_directory/log4j.xml"
bootstrap_log4j_file="$configs_directory/log4j_bs.xml"
groupmanager1_log4j_file="$configs_directory/log4j_gm1.xml"
groupmanager2_log4j_file="$configs_directory/log4j_gm2.xml"

zookeeper_myid_file="/etc/zookeeper/conf/myid"

# Prepare environment settings
user="snoozeadmin"
group="snooze"
nfs_directory="/tmp/snooze/"
images_directory="$nfs_directory/images"
templates_directory="$nfs_directory/templates"
logs_directory="$nfs_directory/logs"

# NFS settings
nfs_exports="$nfs_directory *(rw,async,no_subtree_check,no_root_squash)"
