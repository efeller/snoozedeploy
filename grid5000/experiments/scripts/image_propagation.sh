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

propagate_base_image() {
    $scp_tsunami_command $images_location/$backing_file_name $images_location/$backing_file_name -u root -f $local_controllers_file 
}

propagate_virtual_cluster() {
    echo "$log_tag Starting virtual cluster $1 images propagation"
    for local_controller in `cat $local_controllers_file`
    do
       synchronize_with_scp $local_controller $images_location/$1 $images_location
    done
}
