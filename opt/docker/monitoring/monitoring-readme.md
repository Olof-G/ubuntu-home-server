## Notes relevant to the monitoring stack

### Ports
| Host port | Container port | Service    | Purpose |
|-----------|----------------|------------|---------|
|   9090    |      9090      | Prometheus | Web UI / query API |
|   3000    |      3000      | Grafana    | Web dashboard |

Only Prometheus and Grafana are published to the host. node-exporter (9100) and cAdvisor (8080) are reachable only inside the docker compose network, where Prometheus scrapes them by service name (`node-exporter:9100`, `cadvisor:8080`). cAdvisor's internal 8080 therefore doesn't conflict with Nextcloud on the host.