#!/bin/bash
# This script will install the demo configuration to test user systemd units
#################################################################################
# Write sudoers rule
cat <<EOF >/etc/sudoers.d/login-log
ALL ALL=(root) NOPASSWD: /usr/local/bin/login-log
EOF

#################################################################################
# Write action script for execution by systemd user unit
cat <<EOF >/usr/local/bin/login-log
#!/bin/bash

# Set Login/Logoff Message
if [[ \$1 == "login" ]]; then
    play_MSG="Logging in as"
elif [[ \$1 == "logoff" ]]; then
    play_MSG="Logging off user"
fi

# Log User Session In/Out
echo "\$play_MSG \$SUDO_USER @ \$(date)" >> /root/login.log
EOF

#################################################################################
# Write systemd user unit 
cat <<EOF >/etc/systemd/user/login-log.service
# cat /etc/systemd/user/login-exec.service
[Unit]
Description=Report Login Time @ /root/login.log
PartOf=default.target

[Service]
Type=oneshot
ExecStart=/usr/bin/sudo /usr/local/bin/login-log login
RemainAfterExit=true
ExecStop=/usr/bin/sudo /usr/local/bin/login-log logoff
StandardOutput=journal

[Install]
WantedBy=default.target
EOF

#################################################################################
# Set sudo only permissions & enable executable
chmod 4700 /usr/local/bin/login-log

#################################################################################
# Create Log File
touch /root/login.log

#################################################################################
# Enable systemd user unit globally
systemctl daemon-reload
systemctl enable --global login-log.service

#################################################################################
# Enable SSH Password Auth
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sed -i 's/#PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
systemctl restart sshd

#################################################################################
# Create 'testing' User Account
useradd -s /bin/bash -m -d /home/testing -p testing testing
yes testing | passwd testing

#################################################################################
# Execute in shell of demo to monitor example behavior
clear && echo "
Installed Demo:

  Created the following files:
    /etc/sudoers.d/login-log
    /usr/local/bin/login-log.sh
    /etc/systemd/user/login-log.service

To Test:

  In Console (1)
  Tail the log file as root to monitor:

    tail -f /root/login.log

  In Console (2)
  SSH into this box with User:Pass [testing:testing]

    ssh testing@$(ip r | awk '/link/ {print $9}' | head -n 1)

  In Console (2)
  Continue watching the login.log as you exit the ssh session
"
