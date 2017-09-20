#!/bin/bash -e

export DEBIAN_FRONTEND=noninteractive

echo "================ Installing locales ======================="
apt-get clean && apt-get update 
apt-get install -qq locales=2.23-0ubuntu9

dpkg-divert --local --rename --add /sbin/initctl
locale-gen en_US en_US.UTF-8
dpkg-reconfigure locales

echo "HOME=$HOME"
cd /u16

echo "================= Updating package lists ==================="
apt-get update

echo "================= Adding some global settings ==================="
mv gbl_env.sh /etc/profile.d/
mkdir -p "$HOME/.ssh/"
mv config "$HOME/.ssh/"
mv 90forceyes /etc/apt/apt.conf.d/
touch "$HOME/.ssh/known_hosts"

echo "================= Installing basic packages ==================="
apt-get install -y \
  build-essential=12.1ubuntu2 \
  curl=7.47.0-1ubuntu2.2 \
  gcc=4:5.3.1-1ubuntu1 \
  gettext=0.19.7-2ubuntu3 \
  htop=2.0.1-1ubuntu1 \
  libxml2-dev=2.9.3+dfsg1-1ubuntu0.3 \
  libxslt1-dev=1.1.28-2.1ubuntu0.1 \
  make=4.1-6 \
  nano=2.5.3-2ubuntu2 \
  openssh-client=1:7.2p2-4ubuntu2.1 \
  openssl=1.0.2g-1ubuntu4.6 \
  software-properties-common=0.96.20.7 \
  sudo=1.8.16-0ubuntu1.4  \
  texinfo=6.1.0.dfsg.1-5 \
  unzip=6.0-20ubuntu1 \
  wget=1.17.1-1ubuntu1.1 \
  rsync=3.1.1-3ubuntu1 \
  psmisc=22.21-2.1build1 \
  vim=2:7.4.1689-3ubuntu1.2

echo "================= Installing Python packages ==================="
apt-get install -y \
  python-pip=8.1.1-2ubuntu0.4 \
  python-software-properties=0.96.20.7 \
  python-dev=2.7.11-1

pip install virtualenv

echo "================= Installing Git ==================="
add-apt-repository ppa:git-core/ppa -y
apt-get update -qq
apt-get install -y git=1:2.14.1-1.1~ppa0~ubuntu16.04.1

echo "================= Adding JQ 1.5.1 ==================="
apt-get install jq=1.5+dfsg-1

echo "================= Installing Node 7.x ==================="
. /u16/node/install.sh

echo "================= Installing Java 1.8.0 ==================="
. /u16/java/install.sh

echo "================= Installing Ruby 2.3.3  ==================="
. /u16/ruby/install.sh


echo "================= Adding gcloud ============"
CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)"
echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | tee /etc/apt/sources.list.d/google-cloud-sdk.list
curl -sS https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
sudo apt-get update && sudo apt-get install google-cloud-sdk=160.0.0-0

KUBECTL_VERSION=1.5.1
echo "================= Adding kubectl $KUBECTL_VERSION ==================="
curl -sSLO https://storage.googleapis.com/kubernetes-release/release/v"$KUBECTL_VERSION"/bin/linux/arm64/kubectl
curl -sSLO https://storage.googleapis.com/kubernetes-release/release/v1.5.1/bin/linux/arm64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

echo "================= Adding awscli 1.11.91 ============"
sudo pip install 'awscli==1.11.91'

echo "================= Adding awsebcli 3.9.0 ============"
sudo pip install 'awsebcli==3.9.0'

echo "================ Adding ansible 2.3.0.0 ===================="
sudo pip install 'ansible==2.3.0.0'

echo "================ Adding boto 2.46.1 ======================="
sudo pip install 'boto==2.46.1'

echo "================ Adding apache-libcloud 2.0.0 ======================="
sudo pip install 'apache-libcloud==2.0.0'

echo "================ Adding azure 2.0.0rc5 ======================="
sudo pip install 'azure==2.0.0rc5'

echo "================ Adding dopy 0.3.7a ======================="
sudo pip install 'dopy==0.3.7a'

echo "================= Intalling Shippable CLIs ================="
echo "Installing shippable_decrypt"
cp /u16/shippable_decrypt /usr/local/bin/shippable_decrypt

echo "Installing shippable_retry"
cp /u16/shippable_retry /usr/local/bin/shippable_retry

echo "Installing shippable_replace"
cp /u16/shippable_replace /usr/local/bin/shippable_replace

echo "Installing shipctl"
cp /u16/shipctl /usr/local/bin/shipctl

echo "Installing utility.sh"
cp /u16/utility.sh /usr/local/bin/utility.sh

echo "Installed Shippable CLIs successfully"
echo "-------------------------------------"

echo "================= Cleaning package lists ==================="
apt-get clean
apt-get autoclean
apt-get autoremove
