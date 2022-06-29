#!/bin/sh

iptables -F -t nat
iptables-save

cp named.conf /etc/named.conf
chown root.named /etc/named.conf

cp forward /var/named/forward
chown root.named /var/named/forward

cp reverse /var/named/reverse
chown root.named /var/named/reverse

systemctl start named
systemctl enable named

cat <<EOF >/etc/resolv.conf
search example.com
nameserver 172.24.0.10
EOF