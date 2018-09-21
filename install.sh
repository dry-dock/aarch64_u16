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
mkdir -p /etc/drydock

echo "================= Installing basic packages ==================="
apt-get install -y -q \
  build-essential=12.1ubuntu2 \
  curl=7.47* \
  gcc=4:5.3* \
  gettext=0.19* \
  htop=2.0* \
  libxml2-dev=2.9* \
  libxslt1-dev=1.1* \
  make=4.1* \
  nano=2.5* \
  openssh-client=1:7* \
  openssl=1.0* \
  software-properties-common=0.96* \
  sudo=1.8*  \
  texinfo=6.1* \
  unzip=6.0* \
  zip=3.0* \
  wget=1.17* \
  rsync=3.1* \
  psmisc=22.21* \
  vim=2:7.4.*

echo "================= Installing Python packages ========================="
apt-get install -y -q \
  python-pip=8.1* \
  python-software-properties=0.96* \
  python-dev=2.7*

pip install virtualenv

export GIT_VERSION=1:2.*
echo "================= Installing Git $GIT_VERSION =========================="
add-apt-repository ppa:git-core/ppa -y
apt-get update -qq
apt-get install -y -q git="$GIT_VERSION"

export JQ_VERSION=1.5*
echo "================= Adding JQ $JQ_VERSION ================================="
apt-get install -y -q jq="$JQ_VERSION"

echo "================= Installing Node  ================================"
. /u16/node/install.sh

echo "================= Installing Java  ================================"
. /u16/java/install.sh

echo "================= Installing Ruby  ================================"
. /u16/ruby/install.sh

export CLOUD_SDKREPO=216.0*
echo "================= Adding gcloud $CLOUD_SDK_REPO =========================================="
CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)"
echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | tee /etc/apt/sources.list.d/google-cloud-sdk.list
curl -sS https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
sudo apt-get update && sudo apt-get install google-cloud-sdk="$CLOUD_SDKREPO"

KUBECTL_VERSION=1.11.0
echo "================= Adding kubectl $KUBECTL_VERSION ========================="
curl -sSLO https://storage.googleapis.com/kubernetes-release/release/v"$KUBECTL_VERSION"/bin/linux/arm64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

export AWS_VERSION=1.16.14
echo "================= Adding awscli $AWS_VERSION ================================"
sudo pip install awscli=="$AWS_VERSION"

export AWSEBCLI_VERSION=3.14.6
echo "================= Adding awsebcli $AWSEBCLI_VERSION =========================="
sudo pip install awsebcli=="$AWSEBCLI_VERSION"

export OPENSTACKCLIENT_VERSION=3.16.1
echo "================= Adding openstack client $OPENSTACKCLIENT_VERSION ==========="
sudo pip install python-openstackclient=="$OPENSTACKCLIENT_VERSION"

export SHADE_VERSION=1.29.0
echo "================= Adding shade $SHADE_VERSION ================================="
sudo pip install shade=="$SHADE_VERSION"

export ANSIBLE_VERSION=2.6.4
echo "================ Adding ansible $ANSIBLE_VERSION =============================="
sudo pip install ansible=="$ANSIBLE_VERSION"

export BOTO_VERSION=2.49.0
echo "================ Adding boto $BOTO_VERSION ==================================="
sudo pip install boto=="$BOTO_VERSION"

export BOTO3_VERSION=1.9.4
echo "================ Adding boto3 $BOTO3_VERSION =================================="
sudo pip install boto3=="$BOTO3_VERSION"

export APACHE_LIBCLOUD=2.3.0
echo "================ Adding apache-libcloud "$APACHE_LIBCLOUD" ===================="
sudo pip install apache-libcloud=="$APACHE_LIBCLOUD"

export AZURE_VERSION=3.0.0
echo "================ Adding azure $AZURE_VERSION ==================================="
sudo pip install azure=="$AZURE_VERSION"

export DOPY_VERSION=0.3.7
echo "================ Adding dopy $DOPY_VERSION ====================================="
sudo pip install dopy=="$DOPY_VERSION"

export PK_VERSION=1.3.1
echo "================ Adding packer $PK_VERSION  ====================================="
export PK_FILE=packer_"$PK_VERSION"_linux_arm64.zip

echo "Fetching packer"
echo "-----------------------------------"
rm -rf /tmp/packer
mkdir -p /tmp/packer
wget -nv https://releases.hashicorp.com/packer/$PK_VERSION/$PK_FILE
unzip -o $PK_FILE -d /tmp/packer
sudo chmod +x /tmp/packer/packer
mv /tmp/packer/packer /usr/bin/packer

echo "Added packer successfully"
echo "-----------------------------------"

echo "================= Intalling Shippable CLIs ======================================="

git clone https://github.com/Shippable/node.git nodeRepo
./nodeRepo/shipctl/aarch64/Ubuntu_16.04/install.sh
rm -rf nodeRepo

echo "Installed Shippable CLIs successfully"
echo "-------------------------------------"

echo "================= Cleaning package lists ==================="
apt-get clean
apt-get autoclean
apt-get autoremove
