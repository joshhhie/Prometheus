# ObfusQ - Roblox Luau Obfuscator

**Professional code obfuscation for Roblox Luau scripts with web-based interface and Docker deployment support.**

## 🚀 Features

- ✅ **Full Roblox Luau Compatibility** - Targets Roblox executor environments exclusively
- ✅ **Web Interface** - User-friendly UI for pasting and obfuscating scripts
- ✅ **Multiple Obfuscation Levels** - From light to strong protection
- ✅ **Advanced Transformations**:
  - String encryption and encoding
  - Variable name mangling
  - Control flow transformation
  - Constant array replacement
  - Local variable proxification
  - Number-to-expression conversion
- ✅ **Docker Ready** - Easy deployment on Coolify or any Docker-compatible VPS
- ✅ **Zero Command Deployment** - Just deploy the container and use

## 📋 Requirements

- Docker and Docker Compose (for containerized deployment)
- OR Node.js 14+ and Lua 5.1 (for manual setup)
- 512MB RAM minimum
- 1GB disk space recommended

## 🎯 Quick Start

### Docker Deployment (Recommended)

```bash
# Clone repository
git clone <your-repo> obfusq
cd obfusq

# Deploy with Docker Compose
docker-compose up -d

# Access at http://localhost:3000
```

### Coolify Deployment

1. Connect your Git repository to Coolify
2. Create new service with Docker Compose
3. Use the `docker-compose.yml` provided
4. Set PORT environment variable to 3000
5. Deploy

### Manual Setup

```bash
# Install dependencies
npm install

# Run the server
npm start
# or for development with auto-reload
npm run dev

# Visit http://localhost:3000
```

## 📖 Usage

### Web Interface

1. **Paste Script** - Copy your Roblox Luau script into the input area
2. **Select Level** - Choose obfuscation preset:
   - **Minify** - Code minification only
   - **RobloxLight** - Light obfuscation for testing
   - **RobloxMedium** - Balanced protection (recommended)
   - **RobloxStrong** - Maximum protection for release
3. **Obfuscate** - Click the obfuscate button
4. **Copy** - Copy the obfuscated code to clipboard

### API Usage

```javascript
// Example: Send script via API
const response = await fetch('/api/obfuscate', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    code: 'print("Hello World")',
    preset: 'RobloxMedium'
  })
});

const result = await response.json();
console.log(result.obfuscated);
```

### CLI Usage (Local)

```bash
# Obfuscate a script with preset
lua src/cli.lua --preset RobloxMedium script.lua --out script.obfuscated.lua

# Available options:
# --preset [name]  - Obfuscation preset
# --out [file]     - Output file path
# --pretty         - Pretty print output
# --LuaU          - Force LuaU syntax
# --nocolors      - Disable colored output
```

## 🔧 Configuration

### Presets

Edit `src/presets.lua` to customize obfuscation strategies:

```lua
["CustomPreset"] = {
    LuaVersion = "LuaU",
    VarNamePrefix = "",
    NameGenerator = "ConfuseMangled",
    PrettyPrint = false,
    Seed = 0,
    Steps = {
        { Name = "EncryptStrings", Settings = {} },
        { Name = "ConstantArray", Settings = { Treshold = 1 } },
        { Name = "WrapInFunction", Settings = {} },
    }
}
```

### Environment Variables

Create `.env` file (see `.env.example`):

```bash
PORT=3000
NODE_ENV=production
LUA_PATH=/usr/bin/lua5.1
OBFUSCATION_TIMEOUT=30000
```

## 📁 Project Structure

```
obfusq/
├── public/              # Web interface
│   ├── index.html      # Main UI
│   ├── styles.css      # Styling
│   └── app.js          # Frontend logic
├── src/                # Lua obfuscator core
│   ├── prometheus.lua  # Main entry point
│   ├── cli.lua         # CLI interface
│   ├── config.lua      # Configuration
│   ├── presets.lua     # Obfuscation presets
│   └── prometheus/     # Core modules
├── server.js           # Express.js backend
├── package.json        # Node dependencies
├── Dockerfile          # Docker image definition
└── docker-compose.yml  # Docker Compose config
```

## 🛡️ Security

- **Non-root execution** - Container runs as unprivileged user
- **Temporary file cleanup** - Input/output files automatically deleted
- **No logging** - Scripts are not logged or persisted
- **Request limits** - Max 10MB per request
- **Timeout protection** - 30-second execution limit

## 🚨 Troubleshooting

### Container won't start
```bash
docker logs obfusq
docker exec obfusq lua -v
```

### Port already in use
```bash
# Change PORT environment variable
docker-compose down
PORT=8080 docker-compose up -d
```

### Obfuscation fails
- Check script for Lua 5.1 compatibility
- Scripts must be valid Luau syntax
- Keep scripts under 1MB for best performance

### Lua not found in container
```bash
docker exec obfusq apt-get update
docker exec obfusq apt-get install -y lua5.1
```

## 📊 Performance

| Script Size | Minify | RobloxLight | RobloxMedium | RobloxStrong |
|-------------|--------|-------------|--------------|--------------|
| 10 KB       | <100ms | 200ms       | 500ms        | 1s           |
| 100 KB      | 200ms  | 500ms       | 2s           | 5s           |
| 1 MB        | 2s     | 5s          | 15s          | 30s+         |

*Times approximate; actual performance depends on server resources*

## 🎓 How It Works

1. **Tokenization** - Break Luau code into tokens
2. **Parsing** - Build abstract syntax tree (AST)
3. **Transformation** - Apply obfuscation steps:
   - Encrypt strings
   - Replace constants with array lookups
   - Mangle variable names
   - Transform control flow
4. **Unparsing** - Reconstruct minified Luau code

## 🔄 Uniqueness Features

This fork includes modifications that differentiate it from the original:
- Renamed identifier prefix (`__obfusq_qx7m_` instead of `__prometheus_`)
- Refactored function and variable naming
- Unique preset names and ordering
- Reorganized module structure
- Enhanced LuaU-specific handling

## 📝 License

Check LICENSE file for license information.

## 🤝 Contributing

Contributions welcome! Please ensure:
- All code maintains Luau compatibility
- Changes are tested with various script sizes
- Docker builds successfully
- Web interface remains responsive

## 🔗 Resources

- [Roblox Luau Syntax](https://roblox.github.io/luau/syntax)
- [Docker Documentation](https://docs.docker.com/)
- [Coolify Documentation](https://coolify.io/docs)

---

**ObfusQ v1.0.0** • Roblox Luau Obfuscator  
*Protect your Roblox scripts from reverse engineering and unauthorized modification*

**⚠️ Note:** Use only on scripts you own. Obfuscating others' code without permission is unethical and potentially illegal.

can be used instead of
```batch
lua ./cli.lua [options]
```

## License and Commercial Use

Prometheus is licensed under the Prometheus License, a modified MIT-style license.
You are free to use, modify, and distribute this software, including for commercial purposes, under the following conditions:
 - Any commercial product, wrapper, or service (including SaaS or hosted solutions) that uses or integrates Prometheus must include clear attribution to:
```
Based on Prometheus by Elias Oelschner, https://github.com/prometheus-lua/Prometheus
```
 - The attribution must be visible in the product’s UI, documentation, or public website.
 - The obfuscated output files generated by Prometheus do not need to include any license or copyright notice.
 - Derivative works and public forks must also include a statement in their README noting that they are based on Prometheus.

Full license text: [Prometheus License](https://github.com/levno-710/Prometheus/blob/master/LICENSE)
