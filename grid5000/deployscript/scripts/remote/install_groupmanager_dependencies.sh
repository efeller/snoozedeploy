#!/bin/bash

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get -o Dpkg::Options::="--force-confnew" -y install dstat pm-utils sudo openjdk-6-jre bridge-utils nfs-common sudo
apt-get -f -y install 
