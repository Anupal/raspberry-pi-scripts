#!/bin/sh

# Cleanup
systemctl stop hostapd.service
systemctl unmask hostapd.service
iw dev ap0 del
iw dev wlan0 interface add ap0 type __ap

# Enable routing and NAT between ap0 and wlan0
sysctl net.ipv4.ip_forward=1
iptables -t nat -A  POSTROUTING -o wlan0 -j MASQUERADE

# Enable ap interface
ifconfig ap0 up
systemctl start hostapd.service
