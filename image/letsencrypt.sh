#!/bin/bash
set -ex

# Create/renew
/usr/bin/certbot certonly --non-interactive --renew-by-default ${TESTCERT} --standalone \
    --post-hook="chmod 0400 /etc/letsencrypt/live/${DOMAIN}/privkey.pem" \
    -m "${EMAIL}" --agree-tos \
    -d "${DOMAIN}" \
    --preferred-challenges http-01

if [[ ! -f "/etc/grid-security/hostcert.pem" ]]; then
    ln -s "/etc/letsencrypt/live/${DOMAIN}/fullchain.pem" "/etc/grid-security/hostcert.pem"
    ln -s "/etc/letsencrypt/live/${DOMAIN}/privkey.pem" "/etc/grid-security/hostkey.pem"
fi

# When running against Let's Encrypt staging environment,
# add the fake root CA
if [[ -n "${TESTCERT}" ]] && [[ ! -f "/etc/grid-security/certificates/fakelerootx1.pem" ]]; then
    curl "https://letsencrypt.org/certs/fakelerootx1.pem" > "/etc/grid-security/certificates/fakelerootx1.pem"
    fakehash=$(openssl x509 -hash -noout -in "/etc/grid-security/certificates/fakelerootx1.pem")
    ln -s "/etc/grid-security/certificates/fakelerootx1.pem" "/etc/grid-security/certificates/${fakehash}.0"
fi

