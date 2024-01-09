#!/bin/sh

# Firewall commands to stop all incoming traffic from WiFi
iptables -A INPUT -p udp --destination-port 5353 -m comment --comment "Allow mDNS for .local hostnames" -j ACCEPT -i wlan0
iptables -A INPUT -p tcp --destination-port 22 -m comment --comment "Allow SSH" -j ACCEPT -i wlan0
iptables -A INPUT -p tcp --destination-port 53 -m comment --comment "Allow DNS over TCP" -j ACCEPT -i wlan0
iptables -A INPUT -p udp --destination-port 53 -m comment --comment "Allow DNS over UDP" -j ACCEPT -i wlan0
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT -i wlan0
# iptables -A INPUT -p tcp --destination-port 8053 -m comment --comment "Drop requests to PiHole admin portal" -j DROP -i wlan0
iptables -A INPUT -j DROP -i wlan0
ip6tables -I INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT -i wlan0
ip6tables -A INPUT -j DROP -i wlan0
