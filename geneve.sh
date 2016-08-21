#!/bin/bash
sudo /sbin/route add default gw 192.168.1.1
sudo /sbin/route del default gw 10.122.18.254
sudo /sbin/route add default metric 100 gw 10.122.18.254
sudo /sbin/route add -net 10.0.0.0 netmask 255.0.0.0 gw 10.122.18.254
sudo /sbin/route -n
