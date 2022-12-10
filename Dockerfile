# Set base base image for following commands
FROM alpine:3.17.0

# Set environment variables
ENV LC_ALL C.UTF-8

# Update all packages
# Install pdns server, tools and various backends
RUN apk -U --no-cache upgrade                           \
    && apk add --no-cache                               \
        pdns                                            \
        pdns-tools                                      \
        pdns-backend-bind                               \
        pdns-backend-geoip                              \
        pdns-backend-ldap                               \
        pdns-backend-lua2                               \
        pdns-backend-mariadb                            \
        pdns-backend-mysql                              \
        pdns-backend-odbc                               \
        pdns-backend-pgsql                              \
        pdns-backend-pipe                               \
        pdns-backend-remote                             \
        pdns-backend-sqlite3                            \
    && rm -rf /var/cache/apk/*

# Copy the minimal configuration
COPY conf.d/pdns.conf /etc/powerdns/pdns.conf

# Create config folder and adapt permissions
RUN mkdir -p /etc/powerdns/pdns.d                       \
    && chown -R pdns:pdns /etc/powerdns                 \
    && chmod 0755 /etc/powerdns /etc/powerdns/pdns.d    \
    && chmod 0600 /etc/powerdns/pdns.conf

# Create mount points with the specified names and mark them as holding external provided volumes
VOLUME [ "/etc/powerdns/pdns.d" ]

# Switch to dedicated pdns user
USER pdns

# Documentation purpose: Ports the container listens on
EXPOSE 5353/tcp 5353/udp 8081/tcp

# Specify a entrypoint. CMD parsed will be apended
ENTRYPOINT [ "/usr/sbin/pdns_server", "--config-dir=/etc/powerdns" ]
