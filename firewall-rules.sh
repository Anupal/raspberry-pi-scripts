#!/bin/sh

# Firewall commands to stop all incoming traffic from WiFi
iptables -A INPUT -p tcp --destination-port 53 -m comment --comment "Allow DNS over TCP" -j ACCEPT -i wlan0
iptables -A INPUT -p udp --destination-port 53 -m comment --comment "Allow DNS over UDP" -j ACCEPT -i wlan0
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -j DROP -i wlan0
ip6tables -I INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
ip6tables -A INPUT -j DROP -i wlan0
