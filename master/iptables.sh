#!/bin/sh

iptables -F -t nat
iptables-save
