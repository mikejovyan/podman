# syntax=docker/dockerfile:1@sha256:4edf897a3ffa55b89f906fc8cc78afdb3f1834cc9c7083565e611a8a7d5fe99e

FROM golang:trixie AS builder

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ARG PACKAGE
# renovate: datasource=github-releases depName=podman-container-tools/podman
ARG PACKAGE_VERSION=6.0.0
ARG TARGETARCH

ENV BUILD_GOAL="" \
    COPYRIGHT="2017-2026 Podman contributors" \
    DEPENDS="conmon, crun | runc, golang-github-containers-common, netavark (>= 2.0.0~), init-system-helpers (>= 1.52)" \
    DESCRIPTION="tool to manage containers and pods" \
    INSTALL_GOAL=install \
    LICENSE=Apache-2.0 \
    RECOMMENDS="catatonit | tini | dumb-init, ca-certificates, dbus-user-session, passt, slirp4netns, uidmap" \
    REQUIREMENTS="libapparmor-dev libassuan-dev libglib2.0-dev libgpg-error-dev libgpgme-dev libseccomp-dev libsystemd-dev" \
    SOURCE=https://github.com/podman-container-tools/podman \
    SUGGESTS="containernetworking-plugins, iptables"

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    export DEBIAN_FRONTEND=noninteractive \
    && rm -f /etc/apt/apt.conf.d/docker-clean \
    && apt-get update \
    && apt-get install --no-install-recommends --yes \
        ca-certificates \
        dpkg-dev \
        make \
    && apt-get install --no-install-recommends --yes \
        ${REQUIREMENTS}

WORKDIR /src

ADD $SOURCE.git#v${PACKAGE_VERSION} .

RUN make $BUILD_GOAL PREFIX=/usr \
    && make $INSTALL_GOAL PREFIX=/usr DESTDIR=/out

COPY build_deb.sh /usr/local/bin/build_deb.sh
RUN build_deb.sh

FROM scratch AS export
COPY --from=builder /out-deb /
