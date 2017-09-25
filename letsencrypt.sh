#!/bin/bash
set -ex

/usr/bin/certbot certonly --non-interactive --renew-by-default ${TESTCERT} --standalone -m "${EMAIL}" --agree-tos -d "${DOMAIN}" --preferred-challenges http-01

if [[ ! -f "/etc/grid-security/hostcert.pem" ]]; then
    ln -s "/etc/letsencrypt/live/${DOMAIN}/fullchain.pem" "/etc/grid-security/hostcert.pem"
    ln -s "/etc/letsencrypt/live/${DOMAIN}/privkey.pem" "/etc/grid-security/hostkey.pem"
fi

