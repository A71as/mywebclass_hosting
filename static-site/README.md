# 🌐 Static Site Deployment

Production-ready static website served with Nginx and Docker.

## 📁 Structure

```
static-site/
├── docker-compose.yml    # Docker configuration
├── html/                # Website files
│   └── index.html       # Homepage
└── README.md           # This file
```

## 🚀 Quick Start

### Local Development

```bash
# Navigate to static-site directory
cd static-site

# Start the container
docker compose up -d

# View in browser
open http://localhost
```

### Production Deployment

#### Option 1: Automated (GitHub Actions)

1. Push changes to `main` branch
2. GitHub Actions automatically deploys
3. Visit your site!

#### Option 2: Manual Deployment

```bash
# SSH to server
ssh ahmed@your-server-ip

# Navigate to project
cd ~/mywebclass_hosting/static-site

# Pull latest code
git pull origin main

# Restart container
docker compose down
docker compose up -d
```

## 🛠️ Development

### Edit Website

Edit `html/index.html`:

```bash
# Using nano
nano html/index.html

# Using VS Code (locally)
code html/index.html
```

### Test Changes Locally

```bash
# Start container
docker compose up -d

# View logs
docker compose logs -f

# Stop container
docker compose down
```

### Deploy Changes

```bash
# Commit changes
git add .
git commit -m "Update homepage"
git push origin main

# GitHub Actions deploys automatically!
```

## 🐳 Docker Commands

### Start Container

```bash
docker compose up -d
```

### Stop Container

```bash
docker compose down
```

### View Logs

```bash
# Follow logs
docker compose logs -f

# Last 100 lines
docker compose logs --tail=100
```

### Restart Container

```bash
docker compose restart
```

## 📚 Resources

- [Nginx Documentation](https://nginx.org/en/docs/)
- [Docker Compose Reference](https://docs.docker.com/compose/compose-file/)
- [Main Project README](../README.md)
- [Deployment Guide](../DEPLOYMENT.md)

---

**Need Help?** Check the [main README](../README.md) or [open an issue](https://github.com/A71as/mywebclass_hosting/issues)
