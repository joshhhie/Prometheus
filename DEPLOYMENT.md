# ObfusQ - Roblox Luau Obfuscator

## Quick Start with Coolify

### Prerequisites
- Coolify VPS or Docker-compatible environment
- Docker and Docker Compose installed (Coolify handles this)

### Deployment Steps

#### Option 1: Using Coolify Dashboard
1. Go to your Coolify dashboard
2. Click **Add Service** → **Docker Compose**
3. Paste the contents of `docker-compose.yml`
4. Set environment variable: `PORT=3000`
5. Deploy

#### Option 2: Manual Docker Deployment
```bash
# Clone or pull the repository
git clone <your-repo> obfusq
cd obfusq

# Build and run with Docker Compose
docker-compose up -d

# Access the application
# Open http://your-vps-ip:3000 in your browser
```

#### Option 3: Direct Docker Build
```bash
# Build the image
docker build -t obfusq:latest .

# Run the container
docker run -d \
  --name obfusq \
  -p 3000:3000 \
  -e NODE_ENV=production \
  obfusq:latest
```

### Configuration

#### Environment Variables
- `PORT` - Server port (default: 3000)
- `NODE_ENV` - Set to `production` for production use

#### Presets Available
- **Minify** - Code minification only
- **RobloxLight** - Light obfuscation (fast)
- **RobloxMedium** - Medium obfuscation (balanced)
- **RobloxStrong** - Strong obfuscation (thorough)

### Features

✓ Full Roblox Luau compatibility  
✓ Web-based interface - paste and obfuscate  
✓ Multiple obfuscation levels  
✓ String encryption  
✓ Variable name mangling  
✓ Control flow transformation  
✓ Constant array replacement  

### API Endpoints

#### POST /api/obfuscate
Obfuscate Luau code

**Request:**
```json
{
  "code": "-- Your Luau script here\nprint('Hello')",
  "preset": "RobloxMedium"
}
```

**Response:**
```json
{
  "obfuscated": "-- Obfuscated code..."
}
```

#### GET /health
Health check endpoint

**Response:**
```json
{
  "status": "ok",
  "version": "1.0.0"
}
```

### Troubleshooting

#### Container won't start
```bash
# Check logs
docker logs obfusq

# Verify Lua is installed
docker exec obfusq lua -v
```

#### Port already in use
```bash
# Change port in docker-compose.yml or environment
PORT=8080 docker-compose up -d
```

#### Obfuscation timeout
- Increase timeout in server.js if needed (currently 30 seconds)
- Break large scripts into smaller files

### Performance Tips

1. For large scripts (>100KB), consider splitting into modules
2. Use RobloxLight or RobloxMedium for fast iteration
3. Use RobloxStrong only when needed for final release
4. Cache results for identical scripts

### Security Notes

- The service runs as non-root user for security
- Temporary files are automatically cleaned up
- No script content is logged
- Set appropriate firewall rules on your VPS
- Consider using a reverse proxy (nginx) with authentication

### Updating

```bash
# Pull latest changes
git pull origin main

# Rebuild and restart
docker-compose down
docker-compose up -d --build
```

### Support

For issues or feature requests, check the project repository.

---

**ObfusQ v1.0.0** - Roblox Luau Obfuscator  
*Protect your Roblox scripts from reverse engineering*
