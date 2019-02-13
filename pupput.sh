#!/bin/bash
sudo nmap -F 192.168.125.112-114 | grep 'Nmap scan report for' | awk '{print $5}' &> /root/Desktop/scanedip3.txt
IP=$(cat /root/Desktop/scanedip3.txt)
for IP in $IP;
do
sshpass -f '/root/.smbcredentialsssh' ssh -o ConnectTimeout=05 -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no root@$IP /SCRIPT/.pytho.sh
done
