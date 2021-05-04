FROM alpine:latest

ENV VPN_FILE=/surfshark/nl-ams.prod.surfshark.com_udp.ovpn
# The CIDR mask of the local IP addresses (e.g. 192.168.1.0/24, 10.1.1.0/24) which will be acessing the proxy. This is so the response to a request>
ENV PRIVATE_NET=10.61.46.0/24

# Install openvpn, privoxy, supervisor (run more than one service in Docker), and utilities
RUN apk add curl unzip openvpn privoxy dumb-init supervisor && mkdir /privoxy

# Setup supervisor and remove default config
RUN mkdir -p /var/log/supervisor && mkdir -p /etc/supervisor/conf.d && rm /etc/supervisord.conf
COPY supervisord.conf /etc/supervisor

# Fetch SurfShark openvpn config files
WORKDIR /
RUN mkdir /surfshark && cd /surfshark && \
    curl -s https://my.surfshark.com/vpn/api/v1/server/configurations > configurations.zip && \
    unzip configurations.zip > /dev/null && rm configurations.zip

# Copy scripts and privoxy config into image
WORKDIR /
RUN mkdir /scripts
COPY /scripts/* /scripts/
RUN chmod +x /scripts/*
COPY /privoxy/* /etc/privoxy/
COPY /privoxy/* /config/privoxy/

EXPOSE 8118

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["/usr/bin/supervisord"]
