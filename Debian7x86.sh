#
#!/bin/bash
#by: hajimxmiku12
# 

# Functions
ok() {
    echo -e '\e[32m'$1'\e[m';
}

die() {
    echo -e '\e[1;31m'$1'\e[m'; exit 1;
}

#requirement check

if [[ "$EUID" -ne 0 ]]; then
	echo "Sorry, you need to run this as root"
	exit q
fi
if [[ -e /etc/debian_version ]]; then
	OS=debian
	GROUPNAME=nogroup
	RCLOCAL='/etc/rc.local'
else
	echo "Looks like you aren't running this installer on Debian
exit 2

if [[ ! -e /dev/net/tun ]]; then
	echo "The TUN device is not available
You need to enable TUN before running this script"
	exit 3

# Sanity check
if [[ $(id -g) != "0" ]] ; then
    die "❯❯❯ Script must be run as root."
fi

if [[  ! -e /dev/net/tun ]] ; then
    die "❯❯❯ TUN/TAP device is not available."
fi

dpkg -l openvpn > /dev/null 2>&1
if [[ $? -eq 0 ]]; then
    die "❯❯❯ OpenVPN is already installed."
fi

#install essential package
apt-get-update
apt-get-upgrade
apt-get install nano
apt-get install wget

#Initialisasi Var
export DEBIAN_FRONTEND=noninteractive
OS=`uname -m`;
MYIP=$(wget -qO- ipv4.icanhazip.com);
MYIP2="s/xxxxxxxxx/$MYIP/g";

#Root User
cd

#Disable IPv6
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
sed -i '$ i\echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' /etc/rc.local

#Set Localtime
ln -fs /usr/share/zoneinfo/Asia/Kuala_Lumpur /etc/localtime

#Install Wget Curl
apt-get update; apt-get -y install wget curl;

#Set Locale
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config
service ssh restart

#Set Repo
wget -O /etc/apt/sources.list "https://raw.githubusercontent.com/hajimxmiku/debian-setup-wizard/master/sources.list.debian7"
wget "http://www.dotdeb.org/dotdeb.gpg"
wget "http://www.webmin.com/jcameron-key.asc"
cat dotdeb.gpg | apt-key add -;rm dotdeb.gpg
cat jcameron-key.asc | apt-key add -;rm jcameron-key.asc

#Updating
apt-get update

#Install Essential Package
apt-get -y install bmon iftop htop nmap axel nano iptables traceroute sysv-rc-conf dnsutils bc nethogs openvpn vnstat less screen psmisc apt-file whois ptunnel ngrep mtr git zsh mrtg snmp snmpd snmp-mibs-downloader unzip unrar rsyslog debsums rkhunter

#Install Essential
apt-get -y install build-essential

#Disable Exim4
service exim4 stop

cd

#Install Figlet
apt-get install figlet
echo "clear" >> .bashrc
echo 'figlet -k "$HOSTNAME"' >> .bashrc
echo 'echo -e "======= Script by Hajimxmiku12 ======="' >> .bashrc
echo 'echo -e "Contact Us"' >> .bashrc
echo 'echo -e "Telegram: t.me/systemless_root"' >> .bashrc
echo 'echo -e "===== Hajimxmoku12 Script ====="' >> .bashrc
echo 'echo -e ""' >> .bashrc

cd

#Install Webmin
wget -O webmin-current.deb "http://prdownloads.sourceforge.net/webadmin/webmin_1.840_all.deb"
dpkg -i --force-all webmin-current.deb;
apt-get -y -f install;
rm /root/webmin-current.deb
service webmin restart

cd

#Install Nginx
apt-get -y install nginx

cd

#Install Webserver
rm /etc/nginx/sites-enabled
rm /etc/nginx/sites-available
wget -O /etc/nginx/nginx.conf "https://raw.githubusercontent.com/hajimxmiku/debian-setup-wizard/master/nginx.conf"
mkdir -p /etc/nginx/sites/main
echo "<center><h1>Sunan | Explore Network Unlimited</h1></center>" > /etc/nginx/sites/main/index.html
wget -O /etc/nginx/conf.d/sites.conf "https://raw.githubusercontent.com/hajimxmiku/debian-setup-wizard/master/sites.conf"
service nginx restart
chown -R www-data:www-data /etc/nginx/sites/main

cd

#Configuring SSH
sed -i 's/Port 22/Port 22/g' /etc/ssh/sshd_config
service ssh restart

cd

#Install OpenVPN
wget -O /etc/openvpn/openvpn.tar "https://raw.githubusercontent.com/hajimxmiku/debian-setup-wizard/master/openvpn-debian.tar"
cd /etc/openvpn/
tar xf openvpn.tar
wget -O /etc/openvpn/server.conf "https://raw.githubusercontent.com/hajimxmiku/debian-setup-wizard/master/server.conf"
service openvpn restart
sysctl -w net.ipv4.ip_forward=1
sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf
iptables -t nat -I POSTROUTING -s 192.168.100.0/24 -o eth0 -j MASQUERADE
iptables-save > /etc/newiptables.conf
wget -O /etc/network/if-up.d/iptables "https://raw.githubusercontent.com/hajimxmiku/debian-setup-wizard/master/iptables"
chmod +x /etc/network/if-up.d/iptables
service openvpn restart

#Configure OpenVPN
cd /etc/openvpn/
wget -O /etc/openvpn/client.ovpn "https://raw.githubusercontent.com/hajimxmiku/debian-setup-wizard/master/client.conf"
sed -i $MYIP2 /etc/openvpn/client.ovpn;
cp client.ovpn /etc/nginx/sites/main/

cd

#Install Dropbear
apt-get -y install dropbear
sed -i 's/NO_START=1/NO_START=0/g' /etc/default/dropbear
sed -i 's/DROPBEAR_PORT=22/DROPBEAR_PORT=443/g' /etc/default/dropbear
sed -i 's/DROPBEAR_EXTRA_ARGS=/DROPBEAR_EXTRA_ARGS="-p 443"/g' /etc/default/dropbear
echo "/bin/false" >> /etc/shells
echo "/usr/sbin/nologin" >> /etc/shells
service ssh restart
service dropbear restart

cd

#Install Squid3
apt-get -y install squid3
wget -O /etc/squid3/squid.conf "https://raw.githubusercontent.com/hajimxmiku/debian-setup-wizard/master/squid3.conf"
sed -i $MYIP2 /etc/squid3/squid.conf;
service squid3 restart

cd

#Command script
wget -O /usr/bin/Menu "https://raw.githubusercontent.com/hajimxmiku/debian-setup-wizard/master/Menu.sh"
wget -O /usr/bin/01 "https://raw.githubusercontent.com/hajimxmiku/debian-setup-wizard/master/01.sh"
wget -O /usr/bin/02 "https://raw.githubusercontent.com/hajimxmiku/debian-setup-wizard/master/02.sh"
wget -O /usr/bin/03 "https://raw.githubusercontent.com/hajimxmiku/debian-setup-wizard/master/03.sh"
wget -O /usr/bin/04 "https://raw.githubusercontent.com/hajimxmiku/debian-setup-wizard/master/04.sh"
wget -O /usr/bin/05 "https://raw.githubusercontent.com/hajimxmiku/debian-setup-wizard/master/05.sh"
wget -O /usr/bin/06 "https://raw.githubusercontent.com/hajimxmiku/debian-setup-wizard/master/06.sh"
wget -O /usr/bin/07 "https://raw.githubusercontent.com/hajimxmiku/debian-setup-wizard/master/07.sh"
wget -O /usr/bin/08 "https://raw.githubusercontent.com/hajimxmiku/debian-setup-wizard/master/08.sh"
wget -O /usr/bin/09 "https://raw.githubusercontent.com/hajimxmiku/debian-setup-wizard/master/09.sh"
wget -O /usr/bin/10 "https://raw.githubusercontent.com/hajimxmiku/debian-setup-wizard/master/10.sh"
wget -O /usr/bin/11 "https://raw.githubusercontent.com/hajimxmiku/debian-setup-wizard/master/11.sh"

chmod +x /usr/bin/Menu
chmod +x /usr/bin/01
chmod +x /usr/bin/02
chmod +x /usr/bin/03
chmod +x /usr/bin/04
chmod +x /usr/bin/05
chmod +x /usr/bin/06
chmod +x /usr/bin/07
chmod +x /usr/bin/08
chmod +x /usr/bin/09
chmod +x /usr/bin/10
chmod +x /usr/bin/11

cd

#Last step
service nginx start
service openvpn restart
service ssh restart
service dropbear restart
service squid3 restart
service webmin restart

cd

#Finishing
echo ""
echo "You need to reboot server."
echo ""
echo "==============================================="
echo "Script By: Hajimxmiku12"
echo "squid proxy port: 8080"
echo "server host ip: $myip2
echo "==============================================="
echo ""
