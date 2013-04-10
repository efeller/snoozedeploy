#!/bin/bash

export DEBIAN_FRONTEND=noninteractive
apt-get update -y
apt-get -o Dpkg::Options::="--force-confnew" install -y dstat kvm qemu-kvm libvirt-bin libvirt-dev bridge-utils nfs-common sudo openjdk-6-jre
