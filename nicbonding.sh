########################################
##Created By Ajay Dalvi & Sharjeel Nabi#
########################################
#!/bin/bash
read -p "Are you sure you want to Enter DNS Servers? <y/N> " prompt
if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
then
/bin/cp /etc/resolv.conf /etc/resolv.conf.bkp
read $DNS -p "Enter 1st Domain Name Server:" a
echo "nameserver $a" >> /etc/resolv.conf
read $DNS -p "Enter 2nd Domain Name Server:" b
echo "nameserver $b" >> /etc/resolv.conf
else
echo "Domain Name Server Process is Completed...!!! "
fi
echo "############################################################"
read -p "Are you sure you want to Enter NTP server? <y/N> " prompt
if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
then
/bin/cp /etc/ntp.conf /etc/ntp.conf.bkp
read $DNS -p "Enter 1st NTP Server:" a
echo "server $a" >> /etc/ntp.conf
read $DNS -p "Enter 2nd NTP Server:" b
echo "server $b" >> /etc/ntp.conf
else
echo -e  "NTP Server Process  is completed...!!!"
fi
echo "############################################################"
read -p "Are you sure you want to set Hostname? <y/n> " prompt
if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
then
read $Hostname -p "Enter the HOSTNAME:" h
echo "HOSTNAME=$h" >> /etc/sysconfig/network
else
echo -e "Entering HOSTNAME of Server is Completed...!!! "
fi
echo "############################################################"
read -p "Are you sure you want to Check Link Status of NIC...? <y/N> " prompt
if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
then
echo -e "##################################################"
echo -e "Checking Link Status and Speed of Interfaces...!!!\n"
sleep 1
/bin/ls -l /etc/sysconfig/network-scripts/ifcfg-* | awk -F' ' '{print$9}' | cut -d- -f3 > inter
for i in `cat inter`
do
echo -e "\n"
echo "==============================="
echo "Details of Interface $i"
echo "==============================="
ethtool $i  | grep -E 'Link detected:|Speed' ; sleep 2; done
read -p "Are you sure you want to Proceed Bonding...? <y/N> " prompt
if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
then
echo -e "##################################################"
echo -e "Created new Directory /opt/NWinterfaces for Backup of files of ifcfg-* interfaces\n"
sleep 2
mkdir /opt/NWinterfaces
cp /etc/sysconfig/network-scripts/ifcfg-eth* /opt/NWinterfaces
cp /etc/sysconfig/network-scripts/ifcfg-p* /opt/NWinterfaces
cp /etc/sysconfig/network-scripts/ifcfg-em* /opt/NWinterfaces
read $NEWFILE -p "ENTER 1st INTERFACE FILE NAME:" b
/bin/echo "DEVICE=$b
BOOTPROTO=none
ONBOOT=yes
MASTER=bond0
SLAVE=yes
USERCTL=no" > /etc/sysconfig/network-scripts/ifcfg-$b
sleep 1
read $NEWFILE -p "ENTER 2st INTERFACE FILE NAME:" b
/bin/echo "DEVICE=$b
BOOTPROTO=none
ONBOOT=yes
MASTER=bond0
SLAVE=yes
USERCTL=no" > /etc/sysconfig/network-scripts/ifcfg-$b
sleep 1
/bin/touch /etc/sysconfig/network-scripts/ifcfg-bond0
/bin/echo "DEVICE=bond0
USERCTL=no
BOOTPROTO=none
ONBOOT=yes" > /etc/sysconfig/network-scripts/ifcfg-bond0
read $IPADDR -p "ENTER The IPADDR:" a
echo IPADDR=$a  >> /etc/sysconfig/network-scripts/ifcfg-bond0
read $GEATWAY -p "ENTER The GATEWAY:" a
echo GATEWAY=$a  >> /etc/sysconfig/network-scripts/ifcfg-bond0
read $NETMASK -p "ENTER The NETMASK:" a
echo NETMASK=$a  >> /etc/sysconfig/network-scripts/ifcfg-bond0
read $BONDING_OPTS -p "ENTER The Bonding MODE:" b
echo  BONDING_OPTS=\"mode=$b miimon=100\"  >> /etc/sysconfig/network-scripts/ifcfg-bond0
/bin/echo "alias bond0 bonding
options bond0 mode=$b miimon=100 xmit_hash_policy=1 " > /etc/modprobe.d/bonding.conf
sleep 1
/sbin/modprobe bonding
/etc/init.d/network restart
sleep 2
/bin/cat /proc/net/bonding/bond0
fi
fi
exit 0
