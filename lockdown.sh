#!/bin/bash
clear
echo "Welcome to Matt's lockdown script for CentOS7!"
sleep 3
echo
echo "This script will:"
sleep 1
echo "          - Create you a sudo user"
sleep 1
echo "          - Update your OS and packages"
sleep 1
echo "          - Install and configure automatic updates"
sleep 1
echo "          - Move the default SSH port to one of your choosing"
sleep 1
echo "          - Secure SSH with Fail2Ban (brute-force protection)"
sleep 1
echo "          - Disable root SSH login"
sleep 1
echo "          - Install anti-virus and root-kit detection and configure weekly scans (ClamAV + RkHunter)"
echo
sleep 2
echo "IMPORTANT:"
echo "The use of this script does not in any way guarantee the security of your server, it simply automates the hardening of it."
echo
echo "Passwords should always be complex, updated regularly and never shared."
echo "Key-based access is even more secure, and highly advised."
echo
sleep 4
echo "This script is built for CentOS 7, if you are using any other yum-based distribution, proceed with caution!"
sleep 1
echo
echo 'You have been warned....'
sleep 3
echo
echo '=============================================================='
echo
echo "First, let's create you a sudo user, so we can stop using root!"
echo
sleep 2
if [ $(id -u) -eq 0 ]; then
        read -p "Enter username : " username
        read -s -p "Enter password : " password
        egrep "^$username" /etc/passwd >/dev/null
        if [ $? -eq 0 ]; then
                echo "$username exists! Re-run the script and choose another name"
                exit 1
        else
                pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)
                useradd -m -p $pass $username
                echo
                echo
                [ $? -eq 0 ] && echo "$username has been created!" || echo "Failed to add a user!"
                echo
                echo "Please use this for future SSH logins, as we will disable root SSH access."
                usermod -aG wheel $username
                sleep 5
        fi
else
        echo "Only root may add a user to the system"
        exit 2
fi
echo
echo '=============================================================='
echo
echo 'Now, let me bring your system up to date and configure automatic updates...'
echo
echo 'This may take several minutes, do NOT cancel this process...'
echo
sleep 5
yum -y -q install epel-release
yum update -y -q
yum -y -q install yum-cron
sed -i 's/apply_updates = no/apply_updates = yes/g' /etc/yum/yum-cron.conf
systemctl start yum-cron
systemctl enable yum-cron
echo
sleep 5
echo
echo '=============================================================='
echo
echo "OK, that's done - We're now going to obfuscate your SSH port (make it harder to find)."
echo
sleep 4
read -p "Enter a port number to move SSH to (793 is advised) : " ssh
sed -i "s/#Port 22/Port $ssh/g" /etc/ssh/sshd_config
echo
systemctl restart sshd
echo
echo '=============================================================='
echo
echo "Getting there, now I'll install and configure Fail2Ban to protect your SSH port number from brute-force attacks."
echo
sleep 5
yum install fail2ban -y -q
cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
sed -i 's/bantime  = 600/bantime  = 3600/g' /etc/fail2ban/jail.local
sed -i 's/maxretry = 5/maxretry = 3/g' /etc/fail2ban/jail.local
echo
sed -i '/sshd-aggressive/a enabled = true' /etc/fail2ban/jail.local
sed -i "s/port    = ssh/port    = $ssh/g" /etc/fail2ban/jail.local
echo
systemctl restart fail2ban
systemctl enable fail2ban
echo
echo '=============================================================='
echo
echo "Now, I'm going to disable root login via SSH for this system..."
echo
sleep 4
sed -i "s/#PermitRootLogin yes/PermitRootLogin no/g" /etc/ssh/sshd_config
systemctl restart sshd
echo '=============================================================='
echo
echo "Finally, let's wrap this up by installing anti-virus and root-kit removal tools...(ClamAV and RKHunter"
echo
echo 'This may take several minutes, do NOT cancel this process...'
echo
# ClamAV install
yum -y -q install clamav-server clamav-data clamav-update clamav-filesystem clamav clamav-scanner-systemd clamav-devel clamav-lib clamav-server-systemd
setsebool -P antivirus_can_scan_system 1
setsebool -P clamd_use_jit 1
sed -i -e "s/^Example/#Example/" /etc/clamd.d/scan.conf
sudo sed -i -e "0,/^#LocalSocket/s/^#LocalSocket/LocalSocket/" /etc/clamd.d/scan.conf
sed -i -e "s/^Example/#Example/" /etc/freshclam.conf
freshclam
systemctl start clamd@scan
systemctl enable clamd@scan
echo "#!/bin/bash
clamscan --infected --recursive --exclude-dir='^/sys' /" > /etc/cron.weekly/weeklyscan.sh
chmod -x /etc/cron.weekly/weeklyscan.sh
# RKHunter install
yum install rkhunter -y -q
rkhunter --update
rkhunter --propupd
sed -i "s/ALLOW_SSH_ROOT_USER=unset/ALLOW_SSH_ROOT_USER=no/g" /etc/rkhunter.conf
echo '=============================================================='
echo
echo "OK, We're done! Remember, root is now disabled, you'll need to reconnect using:"
echo
echo "          username: $username"
echo "          password: $password"
echo "          port number: $ssh"
echo
echo "If you accidentally ban your IP through multiple failed login attempts, you'll need to run the below via console:"
echo "          fail2ban-client set sshd unbanip your.ip.address.here"
echo
sleep 3
echo "Thanks for using Matt's lockdown script!"
echo
sleep 10
