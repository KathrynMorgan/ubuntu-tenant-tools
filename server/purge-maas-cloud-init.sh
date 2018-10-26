#!/bin/bash 
# NOTICE: Script provided for example only and should not be run
#         in production without prior testing
#
# This script performs basic removal of MAAS curtin+cloud-init configuration
# The following explain remaining cloud-init files after purge
#
# Sudoer permissions declared in this file
# /etc/sudoers.d/90-cloud-init-users
#
# Network Configuration in these files
# /etc/network/interfaces.d/50-cloud-init.cfg
# /etc/sysctl.d/99-cloudimg-ipv6.conf
#
clear
##########################################################################
# Packages & Files to remove
remove_debs="cloud-init"
file_01="/etc/apt/apt.conf.d/90curtin-aptproxy"
file_02="/etc/apt/apt.conf.d/90cloud-init-pipelining "
file_03="/etc/cloud/cloud.cfg.d/90_maas_datasource.cfg"
file_04="/etc/cloud/cloud.cfg.d/90_maas_cloud_config.cfg"
file_05="/etc/cloud/cloud.cfg.d/90_maas_cloud_init_reporting.cfg"
file_06="/etc/cloud/cloud.cfg.d/90_maas_ubuntu_sso.cfg"
file_07="/etc/default/grub.d/50-curtin-settings.cfg"
file_08="/etc/apt/apt.conf.d/90curtin-aptproxy"

##########################################################################
# Remove File and Declare if removed
rm_file () {
[[ -f $i ]] && rm $i
[[ $? == "0" ]] && echo ">> Removed $current_file"
}

echo "
>> Removing cloud-init configuration"
for num in 01 02 03 04 05 06 07 08; do
  rm_file "$file_${num}"
done

##########################################################################
# Replace Default Xenial Sources 
apt_SOURCES="/etc/apt/sources.list"
apt_orig_SOURCES="/etc/apt/sources.list.curtin.old"
[[ -f $apt_orig_SOURCES ]] && echo "
>> Restoring original apt sources.list configuration"
[[ -f $apt_orig_SOURCES ]] && mv -f $apt_orig_SOURCES $apt_SOURCES

##########################################################################
# Confirm new sources list works && Remove Cloud-init
echo "
>> Updating apt from restored sources.list"
apt-get update -q && \
echo "
>> Purging cloud-init packages" && \
apt-get purge -q $remove_debs

##########################################################################
# Update Grub & initrd
echo "
>> Updating grub"
update-grub 
echo "
>> Updating initramfs"
update-initramfs -u -k all 

##########################################################################
# Done
echo "
>> Cloud-init has been removed from this system"
echo ">> Reboot to confirm removal was successful"
