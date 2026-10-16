# Homelab server

Personal Ubuntu Server homelab used to develop practical experience
with Linux administration, Docker, networking, monitoring, and automation.

## Hardware & OS

- CPU: i3-8100T 3.1GHz
- RAM: 16GB DDR4
- Ubuntu 26.04.1 LTS

## Services

- Nextcloud
- Minecraft
- Prometheus
- Node Exporter
- cAdvisor
- Grafana
- AdGuard
- Wireguard

## Structure

```bash
opt/
└── docker/
    ├── adguard/
    ├── monitoring/
    ├── minecraft/
    └── nextcloud/

etc/
└── wireguard/
```

## Monitoring

```bash
Ubuntu host
    │
    ├── Node Exporter
    │
    └── Docker containers
          │
          └── cAdvisor
                │
                ▼
           Prometheus
                │
                ▼
             Grafana
```