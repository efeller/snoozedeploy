#!/bin/bash

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get -y install pm-utils sudo openjdk-6-jre bridge-utils nfs-common sudo
