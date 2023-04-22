# cthullu/pdns_server

This repository contains a [PowerDNS][1] server image based on Alpine Linux.
The goal of this project is to provide a very small container image which contains the
PowerDNS server.

## About the image

This image contains a basic `pdns.conf` file at `/etc/powerdns/` which describes the default
server behaviour. To adapt the configuration to your needs, configuration snippets can be
provided to the `/etc/powerdns/pdns.d` folder.

As the image runs the pdns_server as a non priviledged user (named `pdns`), the default
ports for the server to listen for DNS-queries is changed to `5353`.

## Changes starting with release 4.7.2-b2

Starting from release `4.7.2-b2` the image will no longer switch to the pdns system-user and
execute the PowerDNS server unpriviledged. Instead, the server will be started as root and
the priviledges of PowerDNS are dropped after parsing the configuration and initializing the
server process.

This also effects the exposed ports, which changed from `5353/tcp` and `5353/udp` to
`53/tcp` and `53/udp`.

## Get the image

The latest image can be pulled from quay.io:

    docker pull quay.io/cthullu/pdns_server

## Start the container

The image can be run to display the configuration

    podman run                             \
      --it                                 \
      --name pdns_server                   \
      --publish 53:53/tcp                  \
      --publish 53:53/udp                  \
      --publish 8081:8081/tcp              \
      quay.io/cthullu/pdns_server --config

In order to start the server, at least one backend has to be configured inside a
configuration snippet. The following example shows how to execute the container with
custom configuration snippets:

    podman run                                   \
      --detach                                   \
      --name pdns_server                         \
      --publish 53:53/tcp                        \
      --publish 53:53/udp                        \
      --publish 8081:8081/tcp                    \
      --volume my-config:/etc/powerdns/pdns.d    \
      quay.io/cthullu/pdns_server

[1]: https://www.powerdns.com
