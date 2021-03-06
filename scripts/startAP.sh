#!/bin/bash

rm -f /etc/hostapd/hostapd.conf

echo "interface=wlan1" >> /etc/hostapd/hostapd.conf

echo "ssid=CopyOf_$1" >> /etc/hostapd/hostapd.conf

# mode Wi-Fi (a = IEEE 802.11a, b = IEEE 802.11b, g = IEEE 802.11g)
echo "hw_mode=g" >> /etc/hostapd/hostapd.conf

# canal de fréquence Wi-Fi (1-14)
echo "channel=6" >> /etc/hostapd/hostapd.conf

echo "wmm_enabled=0" >> /etc/hostapd/hostapd.conf

echo "macaddr_acl=0" >> /etc/hostapd/hostapd.conf

echo "auth_algs=1" >> /etc/hostapd/hostapd.conf
echo "ignore_broadcast_ssid=0" >> /etc/hostapd/hostapd.conf
echo "wpa=2" >> /etc/hostapd/hostapd.conf
echo "wpa_passphrase=1234567890" >> /etc/hostapd/hostapd.conf
echo "wpa_key_mgmt=WPA-PSK" >> /etc/hostapd/hostapd.conf
echo "wpa_pairwise=TKIP" >> /etc/hostapd/hostapd.conf
echo "rsn_pairwise=CCMP" >> /etc/hostapd/hostapd.conf


rm -f /etc/dnsmasq.conf

#RPiHotspot config - Internet
echo "interface=wlan1" >> /etc/dnsmasq.conf
echo "bind-dynamic" >> /etc/dnsmasq.conf
echo "domain-needed" >> /etc/dnsmasq.conf
echo "bogus-priv" >> /etc/dnsmasq.conf
echo "dhcp-range=192.168.50.150,192.168.50.200,255.255.255.0,12h" >> /etc/dnsmasq.conf

echo 1 > /proc/sys/net/ipv4/ip_forward
iptables -A FORWARD -i wlan1 -o wlan0 -j ACCEPT
iptables -A FORWARD -i wlan0 -o wlan1 -m state --state ESTABLISHED,RELATED \
         -j ACCEPT
iptables -t nat -A POSTROUTING -o wlan0 -j MASQUERADE

ifconfig wlan1 192.168.50.1
service isc-dhcp-server restart &

hostapd /etc/hostapd/hostapd.conf
