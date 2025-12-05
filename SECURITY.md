# 🔒 Security Guide

## SSH Hardening

### 1. SSH Key Authentication Only

```bash
# On your local machine, generate SSH key if you haven't
ssh-keygen -t ed25519 -C "your-email@example.com"

# Copy public key to server
ssh-copy-id user@server-ip

# On server, disable password authentication
sudo nano /etc/ssh/sshd_config
```

Update these settings:
```
PasswordAuthentication no
PermitRootLogin no
PubkeyAuthentication yes
```

Restart SSH:
```bash
sudo systemctl restart sshd
```

### 2. Change SSH Port (Optional)

```bash
sudo nano /etc/ssh/sshd_config
```

Change:
```
Port 2222  # Or any port above 1024
```

Update firewall:
```bash
sudo ufw allow 2222/tcp
sudo ufw reload
sudo systemctl restart sshd
```

## Firewall Configuration

### UFW (Uncomplicated Firewall)

```bash
# Install UFW
sudo apt install ufw -y

# Default policies
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Allow essential services
sudo ufw allow OpenSSH
sudo ufw allow 80/tcp    # HTTP
sudo ufw allow 443/tcp   # HTTPS

# Enable firewall
sudo ufw enable

# Check status
sudo ufw status verbose
```

### Common Firewall Rules

```bash
# Allow specific IP only
sudo ufw allow from 123.45.67.89 to any port 22

# Allow port range
sudo ufw allow 3000:3100/tcp

# Delete rule
sudo ufw delete allow 80/tcp

# Reset firewall
sudo ufw reset
```

## Fail2Ban (Intrusion Prevention)

### Installation

```bash
sudo apt install fail2ban -y
```

### Configuration

```bash
# Create local config
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
sudo nano /etc/fail2ban/jail.local
```

Update settings:
```ini
[DEFAULT]
bantime = 1h
findtime = 10m
maxretry = 5
destemail = your-email@example.com
sendername = Fail2Ban
action = %(action_mwl)s

[sshd]
enabled = true
port = ssh
logpath = /var/log/auth.log
maxretry = 3
```

### Manage Fail2Ban

```bash
# Start service
sudo systemctl start fail2ban
sudo systemctl enable fail2ban

# Check status
sudo fail2ban-client status
sudo fail2ban-client status sshd

# Unban IP
sudo fail2ban-client set sshd unbanip 123.45.67.89
```

## System Hardening

### 1. Keep System Updated

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Auto-updates
sudo apt install unattended-upgrades -y
sudo dpkg-reconfigure --priority=low unattended-upgrades
```

### 2. Limit User Privileges

```bash
# Create non-root user
sudo adduser deployuser

# Add to sudo group (only if needed)
sudo usermod -aG sudo deployuser

# Add to docker group
sudo usermod -aG docker deployuser
```

### 3. Disable Unused Services

```bash
# List running services
systemctl list-units --type=service --state=running

# Disable service
sudo systemctl disable service-name
sudo systemctl stop service-name
```

### 4. File Permissions

```bash
# Secure important files
sudo chmod 600 /etc/ssh/sshd_config
sudo chmod 700 ~/.ssh
sudo chmod 600 ~/.ssh/authorized_keys
```

## Docker Security

### 1. Run as Non-Root User

In Dockerfile:
```dockerfile
# Create user
RUN addgroup --gid 1001 appuser && \
    adduser --uid 1001 --gid 1001 --disabled-password appuser

# Switch to user
USER appuser
```

### 2. Limit Container Resources

```yaml
# docker-compose.yml
services:
  app:
    deploy:
      resources:
        limits:
          cpus: '0.5'
          memory: 512M
        reservations:
          cpus: '0.25'
          memory: 256M
```

### 3. Use Read-Only Filesystems

```yaml
services:
  app:
    volumes:
      - ./html:/usr/share/nginx/html:ro  # Read-only
```

### 4. Security Scanning

```bash
# Scan Docker images
docker scan image-name

# Update base images regularly
docker compose pull
docker compose up -d
```

## SSL/TLS Configuration

### Automatic with Caddy

Caddy handles SSL automatically! Just configure your domain:

```caddyfile
yourdomain.com {
    reverse_proxy app:8080
}
```

### Manual with Certbot (if not using Caddy)

```bash
# Install Certbot
sudo apt install certbot python3-certbot-nginx -y

# Get certificate
sudo certbot --nginx -d yourdomain.com -d www.yourdomain.com

# Auto-renewal
sudo certbot renew --dry-run
```

## GitHub Actions Security

### 1. Use Secrets

Never commit sensitive data! Use GitHub Secrets:

- Go to Settings > Secrets > Actions
- Add secrets for:
  - `SSH_PRIVATE_KEY`
  - `SERVER_HOST`
  - `SERVER_USER`
  - Any API keys or passwords

### 2. Limit Permissions

In workflow file:
```yaml
permissions:
  contents: read
  deployments: write
```

### 3. Dedicated Deploy Key

Create a separate SSH key just for GitHub Actions:

```bash
ssh-keygen -t ed25519 -C "github-actions-deploy" -f ~/.ssh/github_deploy
```

Add public key to server, private key to GitHub Secrets.

## Security Checklist

- [ ] SSH key authentication only
- [ ] Password authentication disabled
- [ ] Root login disabled
- [ ] Firewall enabled (UFW)
- [ ] Fail2Ban installed and configured
- [ ] System auto-updates enabled
- [ ] Non-root user for deployments
- [ ] Docker security best practices
- [ ] SSL/TLS certificates (via Caddy)
- [ ] GitHub Secrets configured
- [ ] Regular backups configured
- [ ] Monitoring enabled

## Regular Security Tasks

### Daily
- Check failed login attempts: `sudo tail /var/log/auth.log`
- Review Fail2Ban bans: `sudo fail2ban-client status sshd`

### Weekly
- Update system: `sudo apt update && sudo apt upgrade -y`
- Check disk space: `df -h`
- Review Docker logs: `docker compose logs --tail=100`

### Monthly
- Review firewall rules: `sudo ufw status numbered`
- Check for security updates: `sudo apt list --upgradable`
- Test backup restoration
- Review access logs

## Incident Response

### Compromised Server

1. **Immediately**:
   ```bash
   # Change all passwords
   sudo passwd
   
   # Check for unauthorized users
   who
   w
   
   # Check running processes
   ps aux | grep -v "^root"
   ```

2. **Investigate**:
   ```bash
   # Check auth logs
   sudo grep "Accepted\|Failed" /var/log/auth.log
   
   # Check cron jobs
   crontab -l
   sudo cat /etc/crontab
   
   # Check network connections
   sudo netstat -tulpn
   ```

3. **Cleanup**:
   ```bash
   # Remove unauthorized SSH keys
   nano ~/.ssh/authorized_keys
   
   # Kill suspicious processes
   sudo kill -9 <PID>
   
   # Update all software
   sudo apt update && sudo apt upgrade -y
   ```

4. **Prevent**:
   - Rotate all keys and passwords
   - Review and strengthen firewall rules
   - Enable stricter Fail2Ban settings
   - Consider rebuilding from clean backup

## Resources

- [Ubuntu Security Guide](https://ubuntu.com/security)
- [Docker Security Best Practices](https://docs.docker.com/engine/security/)
- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [CIS Benchmarks](https://www.cisecurity.org/cis-benchmarks)

---

**Security is a process, not a product. Stay vigilant!** 🔒
