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

cat <<EOF > /var/www/html/index.html
hello there
EOF

sed -i 's/^#ServerName.*$/ServerName 172.24.0.10/g' /etc/httpd/conf/httpd.conf

systemctl start httpd
systemctl enable httpd

sed -i 's/^anonymous_enable=NO$/anonymous_enable=YES/g' /etc/vsftpd/vsftpd.conf

systemctl start vsftpd
systemctl enable vsftpd