#!/bin/bash
# Full Release Upgrade (Unattended)
################################################################################
# Export Vars
export UCF_FORCE_CONFFOLD=YES
export DEBIAN_FRONTEND=noninteractive

################################################################################
# Refresh Sources
sudo apt-get update

################################################################################
# Upgrade / Dist Upgrade / Clean
sudo apt-get --option=Dpkg::Options::=--force-confold \
             --option=Dpkg::options::=--force-unsafe-io \
             --assume-yes --quiet \
             upgrade

sudo apt-get --option=Dpkg::Options::=--force-confold \
             --option=Dpkg::options::=--force-unsafe-io \
             --assume-yes --quiet \
             dist-upgrade

sudo apt-get --option=Dpkg::Options::=--force-confold \
             --option=Dpkg::options::=--force-unsafe-io \
             --assume-yes --quiet \
             autoremove

################################################################################
# Upgrade to new release
sudo do-release-upgrade --quiet --frontend=DistUpgradeViewNonInteractive
