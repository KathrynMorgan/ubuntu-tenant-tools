#!/bin/bash
# Client IPA Enrollment Template
#
# USAGE:
#   ./install-client-ipa.sh [ipa admin name] [ipa admin passwd]
# EG:
#   ./install-client-ipa.sh admin SecretPass1\!

# Set Vars
PRINCIPAL_UNAME=$1
PRINCIPAL_PASSWD=$2
CURR_HOSTNAME=$(hostname --short)
DEFAULT_DOMAIN=corp.braincraft.io
DEFAULT_REALM=CORP.BRAINCRAFT.IO 

# Set Package Install List
PKG_LIST="sssd libnss-sss libpam-sss krb5-user freeipa-client"

# Install Packages
sudo apt install ${PKG_LIST}

# Generate Device SSH Keys
yes y | ssh-keygen -q -t rsa -N '' >/dev/null

# Purge Existing Config
ipa-client-install --uninstall --unattended --debug

# Kinit Admin
echo ${PRINCIPAL_PASSWD} | kinit admin

# Client Enrollment Command
ipa-client-install \
  --principal ${PRINCIPAL_UNAME} \
  --password=${PRINCIPAL_PASSWD} \
  --mkhomedir \
  --request-cert \
  --enable-dns-updates \
  --ssh-trust-dns \
  --permit \
  --force-ntpd \
  --debug \
  --force \
  --hostname $CURR_HOSTNAME.$DEFAULT_DOMAIN \
  --domain=$DEFAULT_DOMAIN \
  --realm=$DEFAULT_REALM \
  --unattended
