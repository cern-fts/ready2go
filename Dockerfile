FROM centos:7

# Required repositories
RUN yum install -y epel-release
ADD "http://repository.egi.eu/sw/production/cas/1/current/repo-files/EGI-trustanchors.repo" "/etc/yum.repos.d"

# ROOT CAs
RUN yum install -y lcg-CA

# Server software
RUN yum install -y edg-mkgridmap globus-gridftp-server globus-gridftp-server-progs
RUN yum install -y supervisor cronie

# GridFTP configuration files, and ports
ADD "gridftp.conf" "/etc/gridftp.conf"
EXPOSE 2811 50000-50200

# Grid map file
ADD "edg-mkgridmap.cron" "/etc/cron.d"

# Let's Encrypt
RUN yum install -y certbot
ADD "certbot.cron" "/etc/cron.d/"
ADD "letsencrypt.sh" "/usr/local/bin"
EXPOSE 80

# Supervisord config file
ADD "supervisord.ini" "/etc/supervisord.ini"

# Entry point
CMD ["/usr/bin/supervisord", "--configuration", "/etc/supervisord.ini"]

