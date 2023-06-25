#!/usr/bin/env bash

VERSION=4.7.4-b2

podman build \
--force-rm \
--no-cache \
--platform linux/amd64 \
--quiet \
--rm \
--tag quay.io/cthullu/bind9:${VERSION} \
--file Dockerfile .
