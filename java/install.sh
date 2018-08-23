#!/bin/bash -e

echo "================= Installing default-jdk & jre ==================="
apt-get install -qq default-jre=2:1.8*
apt-get install -qq default-jdk=2:1.8*

echo "================= Installing openjdk-10-jdk ==================="
add-apt-repository -y ppa:openjdk-r/ppa
apt-get update -qq
apt-get install -qq -y openjdk-10-jdk



