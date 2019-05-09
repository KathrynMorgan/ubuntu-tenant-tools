apt install -y snapd neovim --install-recommends

mkdir /usr/local/share/ca-certificates/proxy
wget -P /usr/local/share/ca-certificates/proxy/ http://10.10.0.52:8080/squid-ca.crt
chmod 400 /usr/local/share/ca-certificates/proxy/squid-ca.crt
update-ca-certificates

cat <<EOF >>/etc/profile.d/proxy.sh
export ftp_proxy=http://10.10.0.52:80
export http_proxy=http://10.10.0.52:80
export https_proxy=http://10.10.0.52:443
EOF
chmod +x /etc/profile.d/proxy.sh
source /etc/profile.d/proxy.sh

echo "source /etc/profile.d/proxy.sh" >>.bashrc 
cat <<EOF >>/etc/apt/apt.conf.d/99-proxy
Acquire::http::Proxy "http://10.10.0.52:80/";
Acquire::https::Proxy "http://10.10.0.52:443";
EOF

sudo snap set core proxy.http=http://10.10.0.52:80
sudo snap set core proxy.https=http://10.10.0.52:443

cat <<EOF >>/etc/wgetrc
https_proxy = http://10.10.0.52:443
http_proxy = http://10.10.0.52:80
ftp_proxy = http://10.10.0.52:80
EOF

cat <<EOF >>/etc/skel/.curlrc
no-proxy=127.0.0.1,localhost,10.10.0.0/24
proxy = http://10.10.0.52:443
#proxy-user = "admin:admin"
EOF

cp /etc/skel/.curlrc ~/

#################################################################################

sudo apt update
sudo apt upgrade -y
export DEBIAN_FRONTEND=noninteractive
sudo sed -i 's/Prompt=lts/Prompt=normal/g' /etc/update-manager/release-upgrades
sudo sed -i 's/# conf_force_conffold=YES/conf_force_conffold=YES/g' /etc/ucf.conf 
sudo apt-get --option=Dpkg::Options::=--force-confold --option=DPKG::options::=--force-unsafe-io --assume-yes --quiet dist-upgrade
sudo apt-get --option=Dpkg::Options::=--force-confold --option=DPKG::options::=--force-unsafe-io --quiet full-upgrade
sudo apt-get --option=Dpkg::Options::=--force-confold --option=DPKG::options::=--force-unsafe-io --assume-yes --quiet autoremove
sudo shutdown -r now
sudo do-release-upgrade -f DistUpgradeViewNonInteractive
