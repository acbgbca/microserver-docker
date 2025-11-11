#!/bin/bash

docker run -it --rm --name certbot \
    -v "./etc_letsencrypt:/etc/letsencrypt" \
    -v "./lib_letsencrypt:/var/lib/letsencrypt" \
    -v "./log_letsencrypt:/var/log/letsencrypt" \
    -v "./cloudflare.ini:/cloudflare.ini" \
    --user 9001:9001 \
    certbot/dns-cloudflare renew \
    --max-log-backups 5 \
    --dns-cloudflare \
    --dns-cloudflare-credentials /cloudflare.ini