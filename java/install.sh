#!/bin/bash -e

echo "================= Installing default-jdk & jre ==================="
apt-get install -qq default-jre=2:1.8*
apt-get install -qq default-jdk=2:1.8*

echo "================= Installing openjdk-10-jdk ==================="
add-apt-repository -y ppa:openjdk-r/ppa
apt-get update -qq
apt-get install -qq -y openjdk-10-jdk
sudo update-alternatives --install /usr/bin/java java /usr/lib/jvm/java-10-openjdk-amd64/bin/java 1
sudo update-alternatives --install /usr/bin/javac javac /usr/lib/jvm/java-10-openjdk-amd64/bin/javac 1
sudo update-alternatives --set java /usr/lib/jvm/java-10-openjdk-amd64/bin/java
sudo update-alternatives --set javac /usr/lib/jvm/java-10-openjdk-amd64/bin/javac



