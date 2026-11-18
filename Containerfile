ARG BASE_IMAGE
FROM $BASE_IMAGE AS builder

RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get install --no-install-recommends --yes \
        ca-certificates \
        dpkg-dev \
        make

ARG PACKAGE
ARG PACKAGE_VERSION
ARG TARGETARCH

ARG BUILD_GOAL
ARG COPYRIGHT
ARG DEPENDS
ARG DESCRIPTION
ARG INSTALL_GOAL
ARG LICENSE
ARG RECOMMENDS
ARG REQUIREMENTS
ARG SOURCE
ARG SUGGESTS

ENV BUILD_GOAL=${BUILD_GOAL} \
    COPYRIGHT="${COPYRIGHT}" \
    DEPENDS="${DEPENDS}" \
    DESCRIPTION="${DESCRIPTION}" \
    INSTALL_GOAL=${INSTALL_GOAL} \
    LICENSE=${LICENSE} \
    RECOMMENDS="${RECOMMENDS}" \
    REQUIREMENTS="${REQUIREMENTS}" \
    SOURCE=${SOURCE} \
    SUGGESTS="${SUGGESTS}"

RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get install --no-install-recommends --yes \
        ${REQUIREMENTS}

WORKDIR /src

ADD $SOURCE/archive/refs/tags/v${PACKAGE_VERSION}.tar.gz /tmp/src.tar.gz

RUN tar xzf /tmp/src.tar.gz -C /src --strip-components=1 \
    && rm /tmp/src.tar.gz

RUN make $BUILD_GOAL PREFIX=/usr \
    && make $INSTALL_GOAL PREFIX=/usr DESTDIR=/out

RUN --mount=type=bind,source=build_deb.sh,target=/build_deb.sh \
    bash /build_deb.sh

FROM scratch AS export
COPY --from=builder /out-deb /
