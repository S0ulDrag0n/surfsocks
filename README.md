# SurfSocks

SurfSocks is a SOCK5 proxy that proxies through the SurfShark VPN. This repo can be built for various architectures although my main use was for the Raspberry Pi 4 (armv71).

This image was inspired by and based on the following:

[arch-privoxyvpn](https://github.com/binhex/arch-privoxyvpn)

[wollen-socks](https://github.com/WoLpH/wollen-socks)

[ovpn-openvpn-privoxy](https://github.com/joltcan/ovpn-openvpn-privoxy)

# Usage

**Docker Run**
```
docker run -d \
    --cap-add=NET_ADMIN \
    -p 8118:8118 \
    --name=<container name> \
    -v /etc/localtime:/etc/localtime:ro \
    -e VPN_USER=<vpn username from SurfShark manual setup> \
    -e VPN_PASS=<vpn password from SurfShark manual setup> \
    -e VPN_FILE=</surfshark/*server location*.ovpn> \
    -e PRIVATE_NET=<lan ipv4 network>/<cidr notation> \
    s0uldrag0n/surfsocks
```
**Docker Compose**
```
version: '3'

services:
  vpnproxy:
    image: "s0uldrag0n/surfsocks"
    environment:
     - VPN_USER=<vpn username from SurfShark manual setup>
     - VPN_PASS=<vpn password from SurfShark manual setup>
     - VPN_FILE=</surfshark/*server location*.ovpn>
     - PRIVATE_NET=<lan ipv4 network>/<cidr notation>
    ports:
     - "8118:8118"
    cap_add:
     - NET_ADMIN
```
&nbsp;
Please replace all user variables in the above command defined by <> with the correct values.

**Access Privoxy**

`http://<host ip>:8118`

# Environment Variables

VPN_USER - This is the username provided by SurfShark from the manual setup section.

VPN_PASS - This is the password provided by SurfShark from the manual setup section.

VPN_FILE - This should be the path to the OVPN file used by OpenVPN. This is provided by SurfShark and is already part of the container. You will just have to specify the filename preceeded by `/surfshark/` to reference the file in the existing location (ex. `/surfshark/nl-ams.prod.surfshark.com_udp.ovpn`).

PRIVATE_NET - The CIDR mask of the local IP addresses (e.g. 192.168.1.0/24, 10.1.1.0/24) which will be acessing the proxy. This is so the response to a request can be returned to the client (i.e. your browser). (Credits to [joltcan](https://github.com/joltcan/ovpn-openvpn-privoxy))

# Privoxy Configuration

You can override the privoxy settings by mounting your own config to `/etc/privoxy`.
