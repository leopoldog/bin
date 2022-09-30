#/bin/bash

route delete 192.168.208.0 mask 255.255.255.0 0.0.0.0
route add 192.168.208.0 mask 255.255.255.0 0.0.0.0 if $(netsh int ipv4 show interfaces | sed -n "s/^[[:space:]]*\([[:digit:]]*\).*connected[[:space:]]*WiFi.*/\1/p") /p
