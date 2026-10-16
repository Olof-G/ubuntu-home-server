## Notes relevant to wireguard setup

WireGuard runs on the host (not in Docker) and is managed with `wg-quick@wg0`.
The real config lives in `/etc/wireguard/` and is not synced by the playbook, since it contains a private key.
Only `wg0.conf.example` (placeholders) is committed.

## Design
- Split tunnel, server-only: remote devices reach the server at its tunnel address `10.8.0.1`, everything else goes out normally.
- No IP forwarding or NAT needed.
- Tunnel subnet: `10.8.0.0/24`

| Device | Tunnel IP |
|--------|-----------|
| server | 10.8.0.1  |
| laptop | 10.8.0.2  |
| phone  | 10.8.0.3  |

## Ports
| Port      |          Where         |  Purpose  |
|-----------|------------------------|-----------|
| 51820 udp | router forward + ufw   | WireGuard |

Router: forward UDP 51820 to the server's LAN IP (give the server a DHCP reservation so this doesn't break).
Note: Could enable DDNS on the router and use that name as the clients' `Endpoint` instead of the public IP.

### Server setup
```bash
sudo apt update && sudo apt install wireguard
sudo -i
cd /etc/wireguard
(umask 077; wg genkey | tee server.key | wg pubkey > server.pub)
exit
sudo cp wg0.conf.example /etc/wireguard/wg0.conf    # then fill in the placeholders
sudo chmod 600 /etc/wireguard/wg0.conf
sudo systemctl enable --now wg-quick@wg0
```

### Adding a peer
1. Generate device key pair (e.g. *Add empty tunnel* in Wireguard app on Windows).
2. Client config:
```ini
[Interface]
PrivateKey = <device-private-key>
Address = 10.8.0.X/24
DNS = 10.8.0.1  # Makes peer use server's AdGuard while Wireguard tunnel is active

[Peer]
PublicKey = <server-public-key>
Endpoint = <ddns-name-or-public-ip>:51820
AllowedIPs = 10.8.0.0/24
PersistentKeepalive = 25
```
3. Add a `[Peer]` block with the device's public key and `AllowedIPs = 10.8.0.X/32` to the server's `wg0.conf`.
4. Restart the interface:
```bash
sudo systemctl restart wg-quick@wg0
```

### Nextcloud trusted domain
Nextcloud refuses requests from addresses not on its *trusted_domains* list. List the entries first, then add the tunnel address at the next unused index (X) (reusing an index overwrites that entry):
```bash
docker exec -u www-data nextcloud php occ config:system:get trusted_domains
docker exec -u www-data nextcloud php occ config:system:set trusted_domains X --value=10.8.0.1
```
