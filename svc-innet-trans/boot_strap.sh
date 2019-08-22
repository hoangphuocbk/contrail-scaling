#!/bin/bash

# Update new password and allow connecting by password
echo -e "a\na" | passwd centos
sed -i "/^[^#]*PasswordAuthentication[[:space:]]no/c\PasswordAuthentication yes" /etc/ssh/sshd_config
sed -i "s/^#Port 22/Port 8922/" /etc/ssh/sshd_config
semanage port -a -t ssh_port_t -p tcp 8922
systemctl restart sshd.service

# Enable network interfaces
cat << EOL >> /etc/sysconfig/network-scripts/ifcfg-eth1
DEVICE=eth1
BOOTPROTO=dhcp
TYPE=Ethernet
ONBOOT=yes
EOL

ifconfig eth1 up
cat << EOL >> /etc/sysconfig/network-scripts/ifcfg-eth2
DEVICE=eth2
BOOTPROTO=dhcp
TYPE=Ethernet
ONBOOT=yes
EOL

ifconfig eth2 up

echo "GATEWAY=mgmt_gateway" >> /etc/sysconfig/network

systemctl restart network

# Create bridge between 2 network interfaces
ip link add name br0 type bridge
ip link set dev br0 up
ip link set dev eth0 master br0
ip link set dev eth1 master br0

wc_notify --data-binary '{"status": "SUCCESS"}'
