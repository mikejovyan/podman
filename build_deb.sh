#!/bin/env bash
set -euo pipefail

# prepare package metadata
version_clean="${VERSION}-1"
pkg_doc="/out/usr/share/doc/$PACKAGE"
debian_dir="/out/DEBIAN"

mkdir -p "$debian_dir" "$pkg_doc" /out-deb
mkdir -p /tmp/debian && touch /tmp/debian/control
mapfile -t executables < <(find /out -type f -executable)
shlibs=$(cd /tmp && dpkg-shlibdeps -O "${executables[@]}" | sed 's/shlibs:Depends=//')
final_depends="${DEPENDS:+$DEPENDS, }$shlibs"

# create control file
cat <<EOF >"$debian_dir/control"
Package: $PACKAGE
Version: $version_clean
Architecture: $TARGETARCH
Depends: $final_depends
Recommends: ${RECOMMENDS:-}
Suggests: ${SUGGESTS:-}
Homepage: $SOURCE
Description: $DESCRIPTION
EOF

# create copyright file
cat <<EOF >"$pkg_doc/copyright"
Format: https://www.debian.org/doc/packaging-manuals/copyright-format/1.0/
Source: $SOURCE

Files: *
Copyright: $COPYRIGHT
License: $LICENSE
 The full text of the $LICENSE license is distributed in
 /usr/share/common-licenses/$LICENSE on Debian systems.
EOF

# build package
dpkg --build /out "/out-deb/${PACKAGE}_${version_clean}_${TARGETARCH}.deb"
