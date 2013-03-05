#!/bin/bash

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get -y install nfs-server openjdk-6-jre qemu-utils zookeeper zookeeperd nfs-common bridge-utils
