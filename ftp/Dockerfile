FROM centos:7

# Server software
RUN yum install -y vsftpd

# FTP ports
EXPOSE 2811 50000-50200

# Configuration
ADD "vsftpd.conf" "/etc/vsftpd/vsftpd.conf"

# Entry point
CMD ["/usr/sbin/vsftpd", "/etc/vsftpd/vsftpd.conf"]

