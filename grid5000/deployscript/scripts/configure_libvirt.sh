#!/bin/bash

run_taktuk "$tmp_directory/local_controllers.txt" put "[ $config_templates_directory/libvirt-bin ] [ /etc/default/libvirt-bin ]"
run_taktuk "$tmp_directory/local_controllers.txt" put "[ $config_templates_directory/libvirtd.conf ] [ /etc/libvirt/libvirtd.conf ]"
run_taktuk "$tmp_directory/local_controllers.txt" exec "[ /etc/init.d/libvirt-bin restart ]"
