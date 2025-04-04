#!/usr/bin/env bash

set -x

CONTAINER_CLI="${CONTAINER_CLI:-podman}"

name="csiaddons-k8s-sidecar"
version="0.12.0"
registry="container-registry.oracle.com/olcne"
docker_tag=${registry}/${name}:v${version}

dnf repolist

"${CONTAINER_CLI}" build --pull \
    --build-arg https_proxy=${https_proxy} \
    --volume /etc/yum.repos.d:/etc/yum.repos.d \
    --tag ${docker_tag} -f ./olm/builds/Dockerfile .
