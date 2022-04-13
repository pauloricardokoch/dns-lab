FROM centos


WORKDIR /etc/yum.repos.d/
RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
RUN sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*


RUN yum update -y \
  && yum install --enablerepo=powertools net-tools iptables iptables-services \
  elinks wget git curl bind bind-utils httpd vsftpd -y \
  && yum -y clean all \
  && rm -rf /var/cache


ARG IPADDR
ARG NETMASK
ARG SERVICE


RUN sed -i 's/BOOTPROTO=dhcp/BOOTPROTO=static/g' /etc/sysconfig/network-scripts/ifcfg-ens3
RUN echo IPADDR=${IPADDR} >> /etc/sysconfig/network-scripts/ifcfg-ens3
RUN echo NETMASK=${NETMASK} >> /etc/sysconfig/network-scripts/ifcfg-ens3
RUN echo ${IPADDR} $(hostname) ${SERVICE} >> /etc/hosts


COPY ./master/code /code
WORKDIR /code
