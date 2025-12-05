# 🎯 Getting Started

Welcome to your production hosting platform! This guide will get you up and running quickly.

## ⚡ Quick Path

Choose your experience level:

### 🟢 Beginner (Never used Docker/Linux before)

**Goal**: Get a website live fast

1. Read [Chapter 1: Introduction](https://github.com/kaw393939/mywebclass_hosting/blob/master/docs/01-introduction.md)
2. Set up server (DigitalOcean, $6/month)
3. Follow [DEPLOYMENT.md](DEPLOYMENT.md) - Initial Server Setup section
4. Deploy static site:
   ```bash
   cd ~/mywebclass_hosting/static-site
   docker compose up -d
   ```
5. Visit `http://your-server-ip` 🎉

**Next**: Learn about [security](SECURITY.md) and [CI/CD](.github/workflows/)

### 🟡 Intermediate (Some Docker/Linux experience)

**Goal**: Production-ready deployment with HTTPS

1. Complete "Initial Server Setup" from [DEPLOYMENT.md](DEPLOYMENT.md)
2. Configure domain DNS
3. Update [Caddyfile](Caddyfile) with your domain
4. Deploy full infrastructure:
   ```bash
   cd ~/mywebclass_hosting
   docker network create web
   docker compose up -d
   cd static-site
   docker compose up -d
   ```
5. Set up GitHub Actions CI/CD
6. Visit `https://yourdomain.com` 🚀

**Next**: Explore [operations scripts](scripts/) and monitoring

### 🔴 Advanced (DevOps/SRE focus)

**Goal**: Complete production platform

1. Review architecture in [README.md](README.md)
2. Implement all security measures from [SECURITY.md](SECURITY.md)
3. Set up full infrastructure with monitoring
4. Configure automated backups
5. Implement blue-green deployment
6. Add database and backend applications

**Next**: Contribute improvements, add monitoring dashboards

## 📚 Documentation Index

- **[README.md](README.md)** - Project overview and features
- **[DEPLOYMENT.md](DEPLOYMENT.md)** - Complete deployment guide
- **[SECURITY.md](SECURITY.md)** - Security hardening guide
- **[static-site/README.md](static-site/README.md)** - Static site specifics

## 🗺️ Project Structure

```
mywebclass_hosting/
├── .github/workflows/        # CI/CD automation
│   ├── deploy-static.yml    # Auto-deploy on push
│   └── test.yml             # Test workflow
├── scripts/                 # Operational scripts
│   ├── backup.sh           # Backup script
│   ├── deploy.sh           # Manual deployment
│   └── health-check.sh     # Server health check
├── static-site/            # Your website
│   ├── html/
│   │   └── index.html
│   ├── docker-compose.yml
│   └── README.md
├── Caddyfile              # Reverse proxy config
├── docker-compose.yml     # Infrastructure setup
├── DEPLOYMENT.md          # Deployment guide
├── SECURITY.md            # Security guide
└── README.md              # This file
```

## ✅ Pre-Deployment Checklist

### Server Setup
- [ ] Server created (Ubuntu 24.04 LTS recommended)
- [ ] SSH access configured
- [ ] Non-root user created
- [ ] Docker installed
- [ ] Firewall configured (UFW)

### Repository Setup
- [ ] Repository cloned on server
- [ ] GitHub Secrets configured
- [ ] SSH keys set up for GitHub Actions

### Optional but Recommended
- [ ] Domain purchased and configured
- [ ] Fail2Ban installed
- [ ] Automated backups configured
- [ ] Monitoring set up

## 🚀 Deployment Methods

### Method 1: Automated (Recommended)

**Best for**: Continuous deployment, team projects

1. Set up GitHub Secrets
2. Push to `main` branch
3. GitHub Actions deploys automatically

```bash
git add .
git commit -m "Update site"
git push origin main
```

### Method 2: Manual

**Best for**: Learning, troubleshooting

```bash
ssh user@server-ip
cd ~/mywebclass_hosting/static-site
git pull origin main
docker compose down && docker compose up -d
```

### Method 3: Deployment Script

**Best for**: Quick manual deploys

```bash
ssh user@server-ip
cd ~/mywebclass_hosting
bash scripts/deploy.sh
```

## 🔍 Verification Steps

After deployment, verify everything works:

### 1. Check Containers

```bash
docker ps
```

Expected output: Running containers for your services

### 2. Test Website

```bash
curl http://localhost
```

Or visit in browser: `http://your-server-ip`

### 3. Check Logs

```bash
docker compose logs -f
```

Look for errors or warnings

### 4. Verify SSL (if domain configured)

Visit `https://yourdomain.com` - should show green padlock

## 🐛 Troubleshooting Quick Reference

### Container won't start
```bash
docker compose logs
docker compose down
docker compose up -d
```

### Website not accessible
```bash
sudo ufw status          # Check firewall
docker ps                # Check containers
curl http://localhost    # Test locally
```

### GitHub Actions failing
1. Check Actions tab on GitHub
2. Verify secrets are set correctly
3. Test SSH connection manually

### Need more help?
- Check detailed [DEPLOYMENT.md](DEPLOYMENT.md)
- Review [SECURITY.md](SECURITY.md)
- See static-site [README](static-site/README.md)
- Original course: [mywebclass_hosting](https://github.com/kaw393939/mywebclass_hosting)

## 📖 Learning Resources

### Official Documentation
- [Main Course Repository](https://github.com/kaw393939/mywebclass_hosting)
- [Docker Documentation](https://docs.docker.com/)
- [Caddy Documentation](https://caddyserver.com/docs/)
- [GitHub Actions](https://docs.github.com/en/actions)

### Course Chapters (Recommended Reading)
1. [Introduction](https://github.com/kaw393939/mywebclass_hosting/blob/master/docs/01-introduction.md)
2. [Linux Commands](https://github.com/kaw393939/mywebclass_hosting/blob/master/docs/02-linux-commands.md)
3. [Docker Concepts](https://github.com/kaw393939/mywebclass_hosting/blob/master/docs/12-docker-concepts.md)
4. [CI/CD with GitHub Actions](https://github.com/kaw393939/mywebclass_hosting/blob/master/docs/21-cicd-github-actions.md)

## 🎯 Next Steps

After getting your site live:

### Immediate
1. ✅ Test the deployment
2. ✅ Verify GitHub Actions work
3. ✅ Make a change and watch auto-deploy

### This Week
1. [ ] Read security documentation
2. [ ] Set up automated backups
3. [ ] Configure custom domain
4. [ ] Enable HTTPS with Caddy

### This Month
1. [ ] Add monitoring
2. [ ] Deploy a backend application
3. [ ] Set up database
4. [ ] Implement comprehensive security

## 💡 Pro Tips

- **Test locally first**: Always use `docker compose up` locally before pushing
- **Watch the logs**: `docker compose logs -f` is your best friend
- **Small changes**: Make small, incremental changes - easier to debug
- **Backup regularly**: Use the backup script weekly
- **Monitor resources**: Run health-check script daily
- **Keep updated**: `docker compose pull` and `apt update` weekly

## 🤝 Contributing

Found an issue or want to improve something?

1. Fork the repository
2. Make your changes
3. Test thoroughly
4. Submit a Pull Request

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/A71as/mywebclass_hosting/issues)
- **Main Course**: [mywebclass_hosting](https://github.com/kaw393939/mywebclass_hosting)
- **Discussions**: Use GitHub Discussions for questions

## 🎓 Course Credits

This project is based on the comprehensive course:
**[Production Web Hosting: From Zero to Deployment](https://github.com/kaw393939/mywebclass_hosting)**

Created by Professor Keith Williams for CS Education.

---

**Ready to start?** Pick your path above and begin! 🚀

**Questions?** Check [DEPLOYMENT.md](DEPLOYMENT.md) or [open an issue](https://github.com/A71as/mywebclass_hosting/issues)

⭐ **Star this repo** if it helps you learn!
