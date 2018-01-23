#!/bin/bash -e

export DEBIAN_FRONTEND=noninteractive

echo "================ Installing locales ======================="
apt-get clean && apt-get update
apt-get install -qq locales=2.23*

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
apt-get install -y -q \
  build-essential=12.1ubuntu2 \
  curl=7.47.0* \
  gcc=4:5.3.1* \
  gettext=0.19.7* \
  htop=2.0.1* \
  libxml2-dev=2.9.3+dfsg1* \
  libxslt1-dev=1.1.28* \
  make=4.1* \
  nano=2.5.3* \
  openssh-client=1:7.2p2* \
  openssl=1.0.2g* \
  software-properties-common=0.96.20.7 \
  sudo=1.8.16*  \
  texinfo=6.1.0.dfsg.1* \
  unzip=6.0* \
  wget=1.17.1* \
  rsync=3.1.1* \
  psmisc=22.21* \
  vim=2:7.4.1689*

echo "================= Installing Python packages ==================="
apt-get install -y -q \
  python-pip=8.1.1* \
  python-software-properties=0.96.20.7 \
  python-dev=2.7.11*

pip install virtualenv

echo "================= Installing Git ==================="
add-apt-repository ppa:git-core/ppa -y
apt-get update -qq
apt-get install -y -q git=1:2.15.*

echo "================= Adding JQ 1.5.1 ==================="
apt-get install -y -q jq=1.5+dfsg*

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

git clone https://github.com/Shippable/node.git nodeRepo
./nodeRepo/shipctl/aarch64/Ubuntu_16.04/install.sh
rm -rf nodeRepo

echo "Installed Shippable CLIs successfully"
echo "-------------------------------------"

echo "================= Cleaning package lists ==================="
apt-get clean
apt-get autoclean
apt-get autoremove
