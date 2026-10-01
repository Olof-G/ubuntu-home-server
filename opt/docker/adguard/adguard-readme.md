## Notes relevant to adguard setup

### Port 53
Port 53 is required for the DNS server but a potential issue is that port 53 is already in use by systemd-resolved. Check this [thread](https://github.com/AdguardTeam/AdGuardHome/issues/4283) for a solution.
NOTE: Configuring this before setting up adguard causes docker to fail when trying to fetch the image.