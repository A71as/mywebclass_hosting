# 📝 Deployment Guide

Complete guide for deploying your application to production.

## Prerequisites

- [ ] Ubuntu 24.04 LTS server (VPS)
- [ ] Domain name (optional but recommended)
- [ ] SSH access to server
- [ ] Git installed on server
- [ ] Docker and Docker Compose installed

## Initial Server Setup

### 1. Create Server User

```bash
# SSH into server as root
ssh root@your-server-ip

# Create deployment user
adduser ahmed
usermod -aG sudo ahmed
usermod -aG docker ahmed

# Switch to new user
su - ahmed
```

### 2. Configure SSH Keys

```bash
# On your LOCAL machine
ssh-copy-id ahmed@your-server-ip

# Test connection
ssh ahmed@your-server-ip
```

### 3. Install Docker

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Add user to docker group
sudo usermod -aG docker $USER

# Logout and login for changes to take effect
exit
ssh ahmed@your-server-ip

# Verify Docker
docker --version
docker compose version
```

### 4. Configure Firewall

```bash
# Install and configure UFW
sudo apt install ufw -y
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow OpenSSH
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw enable

# Verify
sudo ufw status
```

### 5. Clone Repository

```bash
# Clone your repository
cd ~
git clone https://github.com/A71as/mywebclass_hosting.git
cd mywebclass_hosting
```

## Deployment Options

### Option 1: Docker Compose (Recommended)

#### Static Site Only

```bash
cd ~/mywebclass_hosting/static-site
docker compose up -d
```

#### Full Infrastructure (Caddy + Static Site)

```bash
cd ~/mywebclass_hosting

# Create network first
docker network create web

# Start infrastructure
docker compose up -d

# Start static site
cd static-site
docker compose up -d
```

### Option 2: Manual Deployment

```bash
# Copy files to web root
sudo mkdir -p /var/www/mywebsite
sudo cp -r static-site/html/* /var/www/mywebsite/
sudo chown -R www-data:www-data /var/www/mywebsite
sudo chmod -R 755 /var/www/mywebsite

# Install and configure Nginx
sudo apt install nginx -y
sudo systemctl enable nginx
sudo systemctl start nginx
```

## Domain Configuration

### 1. Point Domain to Server

In your domain registrar, create an A record:

```
Type: A
Name: @
Value: your-server-ip
TTL: 3600
```

For www subdomain:

```
Type: A
Name: www
Value: your-server-ip
TTL: 3600
```

### 2. Update Caddyfile

```bash
cd ~/mywebclass_hosting
nano Caddyfile
```

Update domain:

```caddyfile
yourdomain.com www.yourdomain.com {
    reverse_proxy static-site:80
}
```

### 3. Restart Caddy

```bash
docker compose restart caddy
```

Caddy will automatically obtain SSL certificates!

## CI/CD Setup (GitHub Actions)

### 1. Add GitHub Secrets

Go to: `https://github.com/A71as/mywebclass_hosting/settings/secrets/actions`

Add these secrets:

- **SSH_PRIVATE_KEY**: Your SSH private key
- **SERVER_HOST**: `your-server-ip`
- **SERVER_USER**: `ahmed`

### 2. Push to Trigger Deployment

```bash
# Make changes locally
git add .
git commit -m "Deploy changes"
git push origin main

# GitHub Actions will automatically deploy!
```

### 3. Monitor Deployment

- Go to GitHub repository
- Click "Actions" tab
- Watch your workflow run

## Verification

### Check Services

```bash
# List running containers
docker ps

# Check logs
docker compose logs -f

# Check Caddy
docker compose logs caddy

# Check static site
docker compose logs -f static-site
```

### Test Website

```bash
# From server
curl http://localhost

# From anywhere
curl http://your-server-ip
curl https://yourdomain.com  # If domain configured
```

### Check SSL

```bash
# Test SSL certificate
echo | openssl s_client -servername yourdomain.com -connect yourdomain.com:443 2>/dev/null | openssl x509 -noout -dates
```

## Troubleshooting

### Containers Not Starting

```bash
# Check container status
docker ps -a

# View logs
docker compose logs

# Restart containers
docker compose down
docker compose up -d
```

### Website Not Accessible

```bash
# Check firewall
sudo ufw status

# Check if port is open
sudo netstat -tulpn | grep :80
sudo netstat -tulpn | grep :443

# Test locally
curl http://localhost
```

### SSL Issues

```bash
# Check Caddy logs
docker compose logs caddy | grep -i "error\|certificate"

# Verify domain points to server
dig yourdomain.com +short

# Restart Caddy
docker compose restart caddy
```

### GitHub Actions Can't Connect

```bash
# On server, check authorized_keys
cat ~/.ssh/authorized_keys

# Test SSH from local machine
ssh -i ~/.ssh/id_ed25519 ahmed@your-server-ip

# Check GitHub Actions logs for error details
```

## Maintenance

### Update Application

```bash
# Pull latest code
cd ~/mywebclass_hosting
git pull origin main

# Restart services
docker compose down
docker compose up -d
```

### Update Docker Images

```bash
cd ~/mywebclass_hosting
docker compose pull
docker compose up -d
```

### View Logs

```bash
# All services
docker compose logs -f

# Specific service
docker compose logs -f static-site

# Last 100 lines
docker compose logs --tail=100
```

### Restart Services

```bash
# Restart all
docker compose restart

# Restart specific service
docker compose restart static-site
```

### Clean Up

```bash
# Remove stopped containers
docker container prune -f

# Remove unused images
docker image prune -f

# Remove unused volumes
docker volume prune -f

# Remove everything unused
docker system prune -af
```

## Backup

### Manual Backup

```bash
# Run backup script
cd ~/mywebclass_hosting
bash scripts/backup.sh
```

### Automated Backups

```bash
# Add to crontab
crontab -e

# Add this line (daily at 2 AM)
0 2 * * * /home/ahmed/mywebclass_hosting/scripts/backup.sh
```

## Rollback

### To Previous Version

```bash
cd ~/mywebclass_hosting

# View commit history
git log --oneline

# Rollback to specific commit
git checkout <commit-hash>

# Restart services
docker compose down
docker compose up -d

# To return to latest
git checkout main
```

### Restore from Backup

```bash
# List backups
ls -lh ~/backups/

# Extract backup
cd ~
tar -xzf backups/backup_YYYYMMDD_HHMMSS.tar.gz

# Restart services
cd mywebclass_hosting
docker compose down
docker compose up -d
```

## Monitoring

### Health Checks

```bash
# Run health check script
cd ~/mywebclass_hosting
bash scripts/health-check.sh
```

### Resource Usage

```bash
# CPU and memory
docker stats

# Disk usage
df -h

# Container resource usage
docker stats --no-stream
```

### Logs

```bash
# Follow all logs
docker compose logs -f

# Search logs
docker compose logs | grep "error"

# Export logs
docker compose logs > deployment.log
```

## Security

### Regular Updates

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Update Docker images
docker compose pull
docker compose up -d
```

### Check Failed Logins

```bash
sudo tail -f /var/log/auth.log
```

### Review Firewall

```bash
sudo ufw status verbose
```

## Next Steps

After successful deployment:

1. ✅ Monitor logs for errors
2. ✅ Set up automated backups
3. ✅ Configure monitoring/alerting
4. ✅ Test disaster recovery
5. ✅ Document any customizations
6. ✅ Share with team

## Resources

- [Docker Documentation](https://docs.docker.com/)
- [Caddy Documentation](https://caddyserver.com/docs/)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Ubuntu Server Guide](https://ubuntu.com/server/docs)

---

**Questions?** Open an issue on GitHub or check the troubleshooting section.
