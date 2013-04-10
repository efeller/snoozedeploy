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

install_dependencies() {
	create_component_host_files
	if [[ $? -ne $success_code ]]
	then
	 return $error_code
	fi

	echo "$log_tag Installing system dependencies"
    copy_ssh_keys
    run_taktuk "$tmp_directory/bootstrap_nodes.txt" exec "[ $remote_scripts_directory/install_bootstrap_dependencies.sh ]"
    run_taktuk "$tmp_directory/group_managers.txt" exec "[ $remote_scripts_directory/install_groupmanager_dependencies.sh ]"
    run_taktuk "$tmp_directory/group_managers.txt" exec "[ dpkg -i --force-all -R $kapower_packages_directory ]"
    run_taktuk "$tmp_directory/local_controllers.txt" exec "[ $remote_scripts_directory/install_localcontroller_dependencies.sh ]"
    run_taktuk "$tmp_directory/hosts_list.txt" exec "[ apt-get -f -y install ]"
    install_snooze_packages
}

install_snooze_packages() {
    echo "$log_tag Installing packages on all hosts"
	run_taktuk "$tmp_directory/hosts_list.txt" exec "[ export TERM=linux; dpkg -i --force-all -R $snooze_packages_directory ]"
}
