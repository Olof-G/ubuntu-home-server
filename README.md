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

## Structure

```bash
opt/
└── docker/
    ├── nextcloud/
    ├── minecraft/
    └── monitoring/
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