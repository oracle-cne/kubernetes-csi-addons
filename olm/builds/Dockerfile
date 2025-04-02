FROM container-registry.oracle.com/os/oraclelinux:9 AS builder

#COPY /etc/yum.repos.d/* /etc/yum.repos.d/
COPY *.repo /etc/yum.repos.d/

RUN dnf update -y && \
    dnf config-manager --enable ol9_codeready_builder && \
    dnf -y install git make golang>=1.23 protobuf-compiler && \
    dnf clean all && rm -rf /var/cache/dnf

# Copy the contents of the repository
COPY . /workspace/go/src/github.com/csi-addons/kubernetes-csi-addons

ENV GOPATH=/workspace/go CGO_ENABLED=0
WORKDIR /workspace/go/src/github.com/csi-addons/kubernetes-csi-addons

# Build the sidecar and csi-addons tool for admin usage and testing
RUN make build

FROM container-registry.oracle.com/os/oraclelinux:9-slim

# COPY LICENSE NOTICE THIRD_PARTY_LICENSES.txt olm/SECURITY.md /usr/share/licenses/
COPY --from=builder /workspace/go/src/github.com/csi-addons/kubernetes-csi-addons/LICENSE \
     /workspace/go/src/github.com/csi-addons/kubernetes-csi-addons/olm/SECURITY.md \
     /workspace/go/src/github.com/csi-addons/kubernetes-csi-addons/ATTRIBUTION-HELPER-DEPS \
     /workspace/go/src/github.com/csi-addons/kubernetes-csi-addons/THIRD_PARTY_LICENSES.txt /usr/share/licenses/

RUN microdnf update -y && \
    microdnf clean all && \
    rm -rf /var/cache/yum/* && \
    test -d /LICENSES || ln -s /usr/share/licenses /LICENSES

WORKDIR /
COPY --from=builder /workspace/go/src/github.com/csi-addons/kubernetes-csi-addons/bin/csi-addons-sidecar /usr/sbin/
COPY --from=builder /workspace/go/src/github.com/csi-addons/kubernetes-csi-addons/bin/csi-addons /usr/bin/

ENTRYPOINT ["/usr/sbin/csi-addons-sidecar"]
