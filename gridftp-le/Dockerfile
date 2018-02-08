FROM centos:7

# Required repositories
RUN yum install -y epel-release
ADD "http://repository.egi.eu/sw/production/cas/1/current/repo-files/EGI-trustanchors.repo" "/etc/yum.repos.d"
ADD "http://fts-repo.web.cern.ch/fts-repo/fts3-continuous-el7.repo" "/etc/yum.repos.d"

# EGI Trust anchors
RUN yum install -y ca-policy-egi-core

# letsencrypt CA
RUN yum install -y ca_letsencrypt

# Server software
RUN yum install -y edg-mkgridmap globus-gridftp-server globus-gridftp-server-progs
RUN yum install -y supervisor cronie

# GridFTP ports
EXPOSE 2811 50000-50200

# Grid mapfile
ADD "image/edg-mkgridmap.cron" "/etc/cron.d"

# Optional explicit user mapping
ARG LOCALGRIDMAP
RUN echo $LOCALGRIDMAP >> /etc/localgridmap.conf

# Set GLOBUS_HOSTNAME to DOMAIN
ARG DOMAIN
ENV GLOBUS_HOSTNAME $DOMAIN

# Add user accounts
ARG CONTAINERUSERS
RUN for u in $CONTAINERUSERS; do if [ $u ]; then adduser -m -c '' $u; fi; done

# Let's Encrypt
ARG EMAIL
RUN if [[ -z ${EMAIL} ]]; then echo "Warning: EMAIL not set - required for obtaining a letsencrypt certificate"; else echo "Using $EMAIL to obtain host certificate."; fi
RUN yum install -y certbot
ADD "image/certbot.cron" "/etc/cron.d/"
ADD "image/letsencrypt.sh" "/usr/local/bin"
EXPOSE 80

# Supervisord config file
ADD "image/supervisord.ini" "/etc/supervisord.ini"

# Entry point
CMD ["/usr/bin/supervisord", "--configuration", "/etc/supervisord.ini"]

