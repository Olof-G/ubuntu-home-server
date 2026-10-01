## Notes relevant to adguard setup

## Ports
| Host port  | Container port | Purpose |
|------------|----------------|---------|
| 53 tcp/udp |       53       | DNS |
|    8081    |       80       | Web dashboard |
|    3001    |      3000      | First-run setup wizard (only needed during setup) |

The standard host ports are 8080 and 3000 for th web dashboard and setup wizard respectively. However, due to nextcloud using port 8080 and grafana using port 3000, adguard's host ports were changed to 8081 and 3001.

### Port 53
Port 53 is required for the DNS server but on Ubuntu port 53 is already used by systemd-resolved. Check this [thread](https://github.com/AdguardTeam/AdGuardHome/issues/4283) for the solution.

### Router settings
The router is configured to hand out a specific DNS server via DHCP instead of choosing one automatically. The server's IP is used as the primary DNS Server.

### Verifying adguard
```bash
nslookup doubleclick.net <server-ip>   # blocked: returns 0.0.0.0
nslookup example.com <server-ip>       # resolves normally
```