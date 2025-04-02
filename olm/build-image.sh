#!/usr/bin/env bash

set -x

CONTAINER_CLI="${CONTAINER_CLI:-podman}"

name="csiaddons-k8s-sidecar"
version="0.9.1"
registry="container-registry.oracle.com/olcne"
docker_tag=${registry}/${name}:v${version}

"${CONTAINER_CLI}" build --pull \
    --build-arg https_proxy=${https_proxy} \
    -t ${docker_tag} -f ./olm/builds/Dockerfile .
