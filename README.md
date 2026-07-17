# Homelab Public Configs

Sanitized Docker Compose configurations from my self-hosted homelab running on Proxmox VE.

## Stack

- **Hypervisor:** Proxmox VE
- **NAS:** TrueNAS SCALE
- **Docker Host:** Ubuntu VM managed via Portainer
- **Reverse Proxy:** Nginx Proxy Manager
- **DNS:** AdGuard Home
- **Remote Access:** Cloudflare Tunnel + Tailscale

## Services

| Service | Image | Notes |
|---------|-------|-------|
| Vaultwarden | vaultwarden/server:latest | Self-hosted Bitwarden |
| Nginx Proxy Manager | jc21/nginx-proxy-manager:latest | Reverse proxy + SSL |
| Cloudflared | cloudflare/cloudflared:latest | Cloudflare tunnel |
| Portainer | portainer/portainer-ce:latest | Docker management UI |

## Usage

All sensitive values (passwords, tokens, domains, IPs) have been replaced with placeholders. Search for `YOUR_` and `yourdomain.com` to find values you need to replace.

## Notes

- Tailscale subnet router runs on the Docker host for remote LAN access
- AdGuard Home runs as a Proxmox LXC with a secondary instance on Docker for redundancy
- All external traffic routes through Cloudflare Tunnel to Nginx Proxy Manager

## Documentation

- [Backup Strategy](docs/backup-strategy.md) -- 3-2-1 approach and lessons learned
- [Monitoring Stack](docs/monitoring.md) -- Prometheus/Grafana setup notes and gotchas
