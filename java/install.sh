#!/bin/bash -e

echo "================= Installing default-jdk & jre ==================="
apt-get install -qq default-jre=2:1.8-56ubuntu2
apt-get install -qq default-jdk=2:1.8-56ubuntu2

echo "================= Installing openjdk-8-jdk ==================="
add-apt-repository -y ppa:openjdk-r/ppa
apt-get update -qq
apt-get install -qq -y openjdk-8-jdk=8u131-b11-2ubuntu1.16.04.3
update-alternatives --set java /usr/lib/jvm/java-8-openjdk-arm64/jre/bin/java
update-alternatives --set javac /usr/lib/jvm/java-8-openjdk-arm64/bin/javac
add-apt-repository ppa:maarten-fonville/ppa
apt-get update -qq
apt-get install -qq icedtea-8-plugin=1.6.2-3ubuntu1
update-alternatives --set javaws /usr/lib/jvm/java-8-openjdk-arm64/jre/bin/javaws

