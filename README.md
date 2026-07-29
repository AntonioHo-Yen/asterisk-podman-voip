# Lightweight Asterisk SIP Server on Podman

A minimal, rootless Podman deployment running Asterisk 22 on Alpine Linux. Designed for low-overhead local VoIP routing across isolated network VLANs.

## Architecture & Design Choices

* **Engine:** Pure Asterisk engine running inside a minimal Alpine Linux container (~50MB).
* **Networking (`network_mode: host`):** Bypasses `slirp4netns` translation overhead to bind directly to host interfaces for dynamic RTP audio streams (`10000-20000/udp`) and SIP signaling (`5060/udp`).
* **Isolation:** Built to handle SIP registrations crossing stateful firewall boundaries (e.g., dedicated Voice VLAN to Server Subnet).

## Directory Structure

```text
.
├── Containerfile
├── compose.yaml
├── config/
│   ├── extensions.conf
│   └── pjsip.conf.example
├── .gitignore
└── README.md
