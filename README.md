# 🚀 MyWebClass Hosting Platform

Production-ready web hosting platform with Docker, automatic HTTPS, and CI/CD automation.

## 🎯 What's Included

```
Production Server
├── Multi-layer Security (SSH, Firewall)
├── Docker Platform (Engine + Compose)
├── Caddy Reverse Proxy (Automatic HTTPS)
├── Static Site Deployment
└── CI/CD Pipeline (GitHub Actions)
```

## 📋 Features

- ✅ **Automated Deployment** - GitHub Actions CI/CD
- ✅ **HTTPS** - Automatic SSL with Caddy
- ✅ **Docker** - Containerized applications
- ✅ **Security** - SSH key authentication
- ✅ **Production-Ready** - Real-world best practices

## 🚀 Quick Start

### Prerequisites

- VPS server (Ubuntu 24.04 recommended)
- Domain name (optional but recommended)
- SSH access to your server
- Git installed locally

### 1. Clone Repository

```bash
git clone https://github.com/A71as/mywebclass_hosting.git
cd mywebclass_hosting
```

### 2. Deploy Static Site

The static site is located in `static-site/` directory:

```bash
cd static-site
docker compose up -d
```

Visit http://your-server-ip to see your site!

### 3. Set Up CI/CD

GitHub Actions automatically deploys on push to `main` branch.

**Required Secrets** (Settings > Secrets > Actions):
- `SSH_PRIVATE_KEY` - Your SSH private key
- `SERVER_HOST` - Your server IP address
- `SERVER_USER` - Your server username

### 4. Update Content

Edit `static-site/html/index.html` and push:

```bash
git add .
git commit -m "Update content"
git push origin main
```

GitHub Actions will automatically deploy! 🎉

## 📁 Project Structure

```
mywebclass_hosting/
├── .github/
│   └── workflows/
│       ├── deploy-static.yml    # Auto-deploy static site
│       └── test.yml             # Test workflow
├── static-site/
│   ├── html/
│   │   └── index.html          # Your website
│   ├── docker-compose.yml      # Docker configuration
│   └── README.md               # Static site docs
└── README.md                   # This file
```

## 🛠️ Technologies

- **Ubuntu 24.04 LTS** - Linux server
- **Docker & Docker Compose** - Containerization
- **Caddy v2** - Reverse proxy with auto HTTPS
- **GitHub Actions** - CI/CD automation
- **Nginx** - Web server (in container)

## 🔒 Security Features

- SSH key-only authentication
- Automated firewall configuration
- GitHub Secrets for sensitive data
- HTTPS-only (when domain configured)
- Minimal attack surface

## 📖 Documentation

### Static Site Deployment

See [`static-site/README.md`](static-site/README.md) for detailed instructions on:
- Local development
- Docker deployment
- Custom domain setup
- Troubleshooting

### GitHub Actions

Workflows are in `.github/workflows/`:
- `test.yml` - Runs on every push to test the build
- `deploy-static.yml` - Deploys to server when static-site files change

### Server Setup

1. **Initial Server Configuration**
   ```bash
   # Update system
   sudo apt update && sudo apt upgrade -y
   
   # Install Docker
   curl -fsSL https://get.docker.com -o get-docker.sh
   sudo sh get-docker.sh
   sudo usermod -aG docker $USER
   ```

2. **Clone Repository on Server**
   ```bash
   cd ~
   git clone https://github.com/A71as/mywebclass_hosting.git
   cd mywebclass_hosting
   ```

3. **Configure Firewall (Optional)**
   ```bash
   sudo ufw allow OpenSSH
   sudo ufw allow 80/tcp
   sudo ufw allow 443/tcp
   sudo ufw enable
   ```

## 🎓 Learning Resources

This project is based on the comprehensive course at:
https://github.com/kaw393939/mywebclass_hosting

Course topics include:
- Linux system administration
- Docker containerization
- Reverse proxy configuration
- SSL/TLS certificates
- CI/CD automation
- Security hardening
- Production best practices

## 🐛 Troubleshooting

### Deployment Fails

1. Check GitHub Actions logs in the "Actions" tab
2. Verify SSH key is correct in GitHub Secrets
3. Ensure server is accessible: `ssh user@server-ip`
4. Check server logs: `docker compose logs`

### Site Not Loading

1. Check if container is running: `docker ps`
2. Check nginx logs: `docker compose logs nginx`
3. Verify firewall allows port 80: `sudo ufw status`
4. Test locally: `curl http://localhost`

### GitHub Actions Can't Connect

1. Verify `SSH_PRIVATE_KEY` secret is set correctly
2. Ensure public key is in `~/.ssh/authorized_keys` on server
3. Test SSH connection manually
4. Check `SERVER_HOST` and `SERVER_USER` secrets

## 📝 Common Tasks

### Update Website Content

```bash
# Edit files locally
vim static-site/html/index.html

# Commit and push
git add .
git commit -m "Update homepage"
git push origin main

# GitHub Actions deploys automatically!
```

### Manual Deployment

If you need to deploy manually:

```bash
ssh user@server-ip
cd ~/mywebclass_hosting
git pull origin main
cd static-site
docker compose up -d --build
```

### View Logs

```bash
# On server
cd ~/mywebclass_hosting/static-site
docker compose logs -f
```

### Restart Services

```bash
# On server
cd ~/mywebclass_hosting/static-site
docker compose restart
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature-name`
3. Commit changes: `git commit -m 'Add feature'`
4. Push to branch: `git push origin feature-name`
5. Submit a Pull Request

## 📜 License

MIT License - Free for educational and commercial use.

## 🎯 Next Steps

- [ ] Add custom domain
- [ ] Configure SSL with Let's Encrypt
- [ ] Set up monitoring
- [ ] Add database (PostgreSQL)
- [ ] Deploy backend application
- [ ] Implement backup strategy

## 💡 Tips

- **Always test locally first** with `docker compose up`
- **Check logs frequently** when troubleshooting
- **Keep secrets secure** - never commit them to git
- **Use SSH keys** - more secure than passwords
- **Monitor deployments** - watch GitHub Actions runs
- **Keep Docker updated** - `docker system prune` regularly

## 📞 Support

- **Issues**: https://github.com/A71as/mywebclass_hosting/issues
- **Course**: https://github.com/kaw393939/mywebclass_hosting
- **Documentation**: See docs in course repository

---

**Built for Production** | **Automated with CI/CD** | **Secure by Default**

⭐ Star this repo if it helps you!
