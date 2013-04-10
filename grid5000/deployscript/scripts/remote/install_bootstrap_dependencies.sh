#!/bin/bash

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get -o Dpkg::Options::="--force-confnew" -y install dstat nfs-server openjdk-6-jre qemu-utils zookeeper zookeeperd nfs-common bridge-utils
