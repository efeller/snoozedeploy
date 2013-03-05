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

# Configure networking
configure_network() {
    echo "$log_tag Starting network configuration on all hosts"
    run_taktuk "$tmp_directory/hosts_list.txt" put "[ $remote_configs_directory/interfaces ] [ /etc/network/interfaces ]"
    run_taktuk "$tmp_directory/hosts_list.txt" exec "[ $remote_scripts_directory/configure_network.sh ]"
}
