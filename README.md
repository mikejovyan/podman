# podman

Builds podman and its network stack (netavark, aardvark-dns) as real .deb packages for arm64/trixie, published to this repo owner's Forgejo apt package registry.

## Packages

| Image | Description |
|---|---|
| [aardvark-dns](packages/aardvark-dns/) | Container-focused DNS server |
| [netavark](packages/netavark/) | Rust based network stack for containers |
| [podman](packages/podman/) | Tool to manage containers and pods |
