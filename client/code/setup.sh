#!/bin/sh

iptables -F -t nat
iptables-save

cat <<EOF >/etc/resolv.conf
search example.com
nameserver 172.24.0.10
EOF
