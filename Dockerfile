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
VOLUME "/etc/edg-mkgridmap.conf" "/etc/localgridmap.conf"

# Host cert and key
VOLUME "/etc/grid-security/hostcert.pem" "/etc/grid-security/hostkey.pem"

# Supervisord config file
ADD "supervisord.ini" "/etc/supervisord.ini"

# Entry point
CMD ["/usr/bin/supervisord", "--configuration", "/etc/supervisord.ini"]

