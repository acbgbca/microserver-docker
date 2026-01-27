# Static IP Addresses

## ctr-network

Subnet: 172.18.0.0/16 (172.18.0.1 - 172.18.255.254)
Docker assigned IPs: 172.18.0.0/17 (172.18.0.1 - 172.18.127.254)
Manually assigned IPs: 172.18.128.0/17 (172.18.128.1 - 172.18.255.254)

Traefik - 172.18.128.10
Cloudflare Tunnel - 172.18.128.11
Nginx - 172.18.128.12

## lan-network

Subnet: 192.168.94.64/26 (192.168.94.65 - 192.168.94.126)

Minecraft: 192.168.94.70
Steam: 192.168.94.71
Dev Container: 192.168.94.72
