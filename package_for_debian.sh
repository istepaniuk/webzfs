#!/bin/bash

set -eu

docker rm webzfs-tmp || true

docker build -t webzfs-builder --file debian/Dockerfile .
docker create --name webzfs-tmp webzfs-builder
docker cp webzfs-tmp:/webzfs_0.65.0_amd64.deb .
docker rm webzfs-tmp
