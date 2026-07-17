# Monitoring Stack

Overview of the Prometheus + Grafana setup (see `configs/docker/monitoring.yml` for the compose file).

## Components

- **Prometheus** -- metrics collection and storage, 30-day retention, 15s scrape interval.
- **Grafana** -- dashboards. Using community dashboards for Node Exporter, cAdvisor, and the hypervisor as a starting point rather than building from scratch.
- **cAdvisor** -- per-container resource metrics.
- **node-exporter** -- deployed on every host in the stack (hypervisor, backup server, NAS, Docker host) for system-level metrics.
- **Custom exporters** -- a DNS-server exporter (query stats), a hypervisor-API exporter (VM/container metrics), and a bridge exporter for translating the NAS's native metrics format into something Prometheus can scrape.

## Notes / gotchas

- If your NAS OS has a read-only root filesystem, you can't just drop an exporter binary in `/usr/local/bin`. Put it on a writable dataset/mount instead, and point the systemd unit there. Watch for the unit file getting wiped on NAS OS updates -- worth a note-to-self to re-create it if metrics go stale after an update.
- Every new exporter port needs a firewall rule opened on whichever host is running it -- easy to forget and end up with a target Prometheus can't reach.
- API tokens for hypervisor-integration exporters should be scoped to the minimum permission needed (read-only monitoring role) and stored in a password manager, not in the compose file -- hence the `YOUR_*` placeholders in this repo.
- Small containers with limited disk (e.g. a DNS server LXC) can silently fill up from unrelated growth (in this case, a query log with no retention bound), which can break unrelated things like an app's built-in auto-updater. Worth keeping an eye on disk usage across small/thin-provisioned containers generally, not just the ones you'd expect to grow.
