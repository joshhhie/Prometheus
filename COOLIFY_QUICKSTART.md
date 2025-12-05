# ObfusQ - Coolify Quick Start Guide

## ⚡ 5-Minute Setup

### Step 1: Connect Repository to Coolify
1. Log in to your Coolify dashboard
2. Click **Add** → **New Application**
3. Select **Docker Compose**
4. Connect your Git repository (the one with this code)
5. Select **master** branch

### Step 2: Configure Service
1. Name: `obfusq`
2. Public URL: `your-domain.com` (optional but recommended)
3. Port: `3000`

### Step 3: Set Environment Variables
In the **Environment** section, add:
```
PORT=3000
NODE_ENV=production
LUA_PATH=/usr/bin/lua5.1
```

### Step 4: Deploy
1. Click **Deploy**
2. Wait for build completion (~2 minutes)
3. Check logs for "✓ ObfusQ server running"

### Step 5: Access
Open: `http://your-vps-ip:3000` or `https://your-domain.com`

---

## 🎯 Using ObfusQ

### Via Web Interface
1. Paste your Roblox Luau script
2. Choose obfuscation level
3. Click "Obfuscate Script"
4. Copy the result

### Via API
```bash
curl -X POST http://your-domain.com/api/obfuscate \
  -H "Content-Type: application/json" \
  -d '{
    "code": "print(\"Hello\")",
    "preset": "RobloxMedium"
  }'
```

### Via CLI (for local development)
```bash
lua src/cli.lua --preset RobloxMedium your_script.lua
```

---

## 🔧 Troubleshooting

### Service won't start
```
Check Coolify logs. Common issues:
- Port 3000 already in use → change PORT env var
- Lua not installed → container will install it
- Node dependencies missing → rebuild container
```

### Obfuscation fails
- Script is too large (>1MB)
- Invalid Lua/Luau syntax
- Special characters in script

### Performance slow
- Use RobloxLight for testing
- Split large scripts into modules
- Increase server resources in Coolify

---

## 📊 Presets Explained

| Preset | Speed | Protection | Best For |
|--------|-------|-----------|----------|
| **Minify** | ⚡⚡⚡ | ⭐ | Compression only |
| **RobloxLight** | ⚡⚡ | ⭐⭐⭐ | Quick testing |
| **RobloxMedium** | ⚡ | ⭐⭐⭐⭐ | Most use cases |
| **RobloxStrong** | 🐢 | ⭐⭐⭐⭐⭐ | Final release |

---

## ✅ Verification

After deployment:
1. Visit health check: `http://your-domain.com/health`
2. Should return: `{"status":"ok","version":"1.0.0"}`

---

## 🆘 Support

**Health Check Endpoint**: `http://your-domain.com/health`

**API Documentation**: Visit `http://your-domain.com` for web UI

**Error Logs**: Check Coolify's service logs in dashboard

---

## 🚀 Production Tips

1. **Enable HTTPS**: Use Coolify's SSL certificate
2. **Add Domain**: Point custom domain to Coolify service
3. **Monitor**: Enable Coolify's monitoring/alerts
4. **Backup**: Enable volume backups for logs
5. **Scale**: Increase container resource limits if needed

---

**ObfusQ v1.0.0** - Ready to protect your Roblox scripts! 🛡️
