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

## Operational Notes & Troubleshooting

### 1. Rootless Podman & Process Conflicts (Port 5060 "Address in use")
- Issue: Asterisk fails to start with "Address in use" on UDP port 5060, or killing the process ID immediately respawns it under a high UID.
- Cause: Podman runs rootless containers under specific user namespaces. A background container instance running directly in the user session (`podman ps`) will hold port 5060, remaining invisible to system-level `sudo podman ps`.
- Fix: Check running instances without `sudo` using `podman ps`, then run `podman stop <container_name>` and `podman rm <container_name>`.

### 2. Network Isolation & UDP Registration Failures
- Issue: Yealink phone UI shows "Register Failed", and Asterisk's `pjsip set logger on` shows no incoming traffic when clicking Confirm/Save.
- Cause: Standard Podman bridge networks use NAT translation. SIP registration heavily relies on raw UDP socket bindings and header inspection, which often get silently dropped at the host boundary without explicit UDP port maps or host networking.
- Fix: Set `network_mode: host` in `compose.yaml` so Asterisk binds directly to the server's network adapter.

### 3. PJSIP Configuration Credentials
- The live `config/pjsip.conf` file is intentionally excluded from Git tracking (`.gitignore`) to keep SIP authentication secrets local to the host.
- Modify `config/pjsip.conf.example` when adding new structural templates or endpoint parameters to the repo.
