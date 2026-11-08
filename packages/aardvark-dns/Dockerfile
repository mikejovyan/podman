# syntax=docker/dockerfile:1@sha256:4edf897a3ffa55b89f906fc8cc78afdb3f1834cc9c7083565e611a8a7d5fe99e

FROM rust:slim-trixie AS builder

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ARG PACKAGE
# renovate: datasource=github-releases depName=containers/aardvark-dns
ARG PACKAGE_VERSION=2.0.0
ARG TARGETARCH

ENV BUILD_GOAL=build \
    COPYRIGHT="2021-2026 Aardvark-dns contributors" \
    DEPENDS="netavark (>= 2.0.0)" \
    DESCRIPTION="Container-focused DNS server" \
    INSTALL_GOAL=install \
    LICENSE=Apache-2.0 \
    RECOMMENDS="" \
    REQUIREMENTS="" \
    SOURCE=https://github.com/containers/aardvark-dns \
    SUGGESTS=""

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
