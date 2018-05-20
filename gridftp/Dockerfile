FROM centos:7

# Required repositories
RUN yum install -y epel-release
ADD "http://repository.egi.eu/sw/production/cas/1/current/repo-files/EGI-trustanchors.repo" "/etc/yum.repos.d"

# ROOT CAs
RUN yum install -y ca-policy-egi-core

# Server software
RUN yum install -y edg-mkgridmap globus-gridftp-server globus-gridftp-server-progs
RUN yum install -y supervisor cronie

# GridFTP ports
EXPOSE 2811 50000-50200

# Grid mapfile
ADD "image/edg-mkgridmap.cron" "/etc/cron.d"

# Supervisord config file
ADD "image/supervisord.ini" "/etc/supervisord.ini"

# Entry point
CMD ["/usr/bin/supervisord", "--configuration", "/etc/supervisord.ini"]

