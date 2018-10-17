#!/bin/bash -e

export OPENJDK_VERSION=11
echo "================ Installing openjdk"$OPENJDK_VERSION"-installer ============================="
sudo add-apt-repository ppa:openjdk-r/ppa
sudo apt-get update
sudo apt install -y openjdk-"$OPENJDK_VERSION"-jdk --allow-unauthenticated

