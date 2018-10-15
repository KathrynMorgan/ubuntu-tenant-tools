#!/bin/bash
# YOU NEED TO CONFIGURE THESE VALUES:
# Landscape account name
ACCOUNT="your-landscape-account"

# the landscape server to use
SERVER_URL="https://landscape.canonical.com"

# landscape-config options. Note that "--silent" is always used
OPTIONS="-a $ACCOUNT -t $HOSTNAME \
  --url=${SERVER_URL%/}/message-system \
  --ping-url=${SERVER_URL%/}/ping"

# END OF USER CONFIGURABLE PART
##############################################################################
# $1: status code
# $2: error message
# $3: optional ok message. If not supplied, "done!" will be used
function check_status() {
    if [ "$1" -ne "0" ]; then
        echo -e "$2"
        exit $1
    else
        echo -e ${3:-'done!'}
        return 0
    fi
}

# install landscape-client
echo -n "Updating repository... "
apt-get -q -q update
check_status $? "ERROR while running apt-get update"

echo -n "Installing landscape-client... "
output=$(apt-get -q -y install landscape-client)
check_status $? "ERROR while installing landscape-client:\n$output"

# configure it
echo -n "Configuring landscape-client and requesting a registration... "
output=$(landscape-config --silent $OPTIONS)
check_status $? "There was an error configuring landscape-client:\n$output"
echo
echo "landscape-client configuration successfull!"

exit 0