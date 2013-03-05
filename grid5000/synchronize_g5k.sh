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

# SSH private key for Grid 5000
ssh_private_key="$HOME/.ssh/id_rsa_g5k"

# Client and server configuration templates
client_config="$HOME/git/snoozeclient/configs/snooze_client.cfg"
node_config="$HOME/git/snoozenode/configs/framework/snooze_node.cfg"

# Client/node debian packages
version="1.0.1-0"
client_deb_package="$HOME/git/snoozeclient/distributions/deb-package/snoozeclient_"$version"_all.deb"
node_deb_package="$HOME/git/snoozenode/distributions/deb-package/snoozenode_"$version"_all.deb"

# Local deployment script directory
local_deploy_root_directory="./"

# Local environment directory
local_packages_directory="./deployscript/deb_packages"

# Local config templates directory
local_config_templates_directory="./deployscript/config_templates"

# Grid5000 settings
# Username
grid5000_username="efeller"
# Site hostname
grid5000_site="lyon"
# Remote deployment scripts directory
grid5000_deploy_root_directory="/home/efeller/snoozedeploy"

# Update config templates
cp $client_config $local_config_templates_directory
cp $node_config $local_config_templates_directory

# Update debian packages
cp $client_deb_package $local_packages_directory
cp $node_deb_package $local_packages_directory

# Sync everything to the specified Grid5000 site/frontend
rsync -avz --exclude .svn --exclude synchronize_g5k.sh --exclude id_rsa_g5k -e ssh -i $ssh_private_key $local_deploy_root_directory $grid5000_username@$grid5000_site:$grid5000_deploy_root_directory
