FROM ubuntu:16.04
EXPOSE 123/udp

ENV UDPLOGHOST=
ENV TCPLOGHOST=
# The rsyslog package for alpine has no omrelp support
#ENV RELPLOGHOST=

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -qy rsyslog ntp
RUN mkdir -m 0755 -p /var/spool/rsyslog  && chown -R syslog:syslog /var/spool/rsyslog 

RUN mkdir -p /var/lib/ntp
RUN rm -f /etc/ntp.conf
COPY entrypoint.sh /
COPY rsyslog.conf /etc/rsyslog.conf

# Mounts
# NOTE: Per Dockerfile manual -->
#	"if any build steps change the data within the volume
# 	 after it has been declared, those changes will be discarded."
VOLUME ["/var/spool/rsyslog"]
VOLUME ["/etc/rsyslog"]
VOLUME ["/etc/ntp.conf"]

ENTRYPOINT ["/entrypoint.sh"]
