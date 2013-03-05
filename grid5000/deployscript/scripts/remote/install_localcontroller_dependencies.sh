#!/bin/bash

export DEBIAN_FRONTEND=noninteractive
apt-get update -y
apt-get install -y kvm qemu-kvm libvirt-bin libvirt-dev bridge-utils nfs-common sudo openjdk-6-jre
