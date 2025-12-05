# ObfusQ System Architecture

## 🏗️ Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                     USER/CLIENT BROWSER                      │
│                  (Web Interface at :3000)                    │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  index.html → Paste Script → Select Level → Submit  │   │
│  │  ↓                                                   │   │
│  │  Obfuscation Result ← Copy to Clipboard             │   │
│  └─────────────────────────────────────────────────────┘   │
└────────────────┬──────────────────────────────────────────────┘
                 │
                 │ JSON POST /api/obfuscate
                 │ {code, preset}
                 ▼
┌─────────────────────────────────────────────────────────────┐
│              EXPRESS.JS BACKEND (Node.js)                    │
│            server.js - Runs on Port 3000                     │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  POST /api/obfuscate                                │   │
│  │  • Validate input code                              │   │
│  │  • Validate preset name                             │   │
│  │  • Create temporary files                           │   │
│  │  • Invoke Lua CLI via execFile                      │   │
│  │  • Read obfuscated output                           │   │
│  │  • Clean up temporary files                         │   │
│  │  • Return JSON response                             │   │
│  └─────────────────────────────────────────────────────┘   │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  GET /health                                        │   │
│  │  • Returns service status & version                 │   │
│  └─────────────────────────────────────────────────────┘   │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  GET / (static files)                               │   │
│  │  • Serves public/index.html                         │   │
│  │  • Serves public/styles.css                         │   │
│  │  • Serves public/app.js                             │   │
│  └─────────────────────────────────────────────────────┘   │
└────────────────┬──────────────────────────────────────────────┘
                 │
    execFile('lua', [...cli.lua args...])
                 │
                 ▼
┌─────────────────────────────────────────────────────────────┐
│              LUA OBFUSCATION CORE                            │
│          src/cli.lua (runs as subprocess)                    │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  1. Parse command line arguments                    │   │
│  │     --preset [RobloxLight|Medium|Strong]            │   │
│  │     --out [output_file.lua]                         │   │
│  │     [input_file.lua]                                │   │
│  │                                                     │   │
│  │  2. Load configuration                              │   │
│  │     • Read src/config.lua (LuaU defaults)          │   │
│  │     • Read src/presets.lua (available presets)     │   │
│  │                                                     │   │
│  │  3. Invoke Processing Pipeline                      │   │
│  │     • Load source code                              │   │
│  │     • Parse to AST (Abstract Syntax Tree)           │   │
│  │     • Apply transformation steps in sequence:       │   │
│  │       - EncryptStrings                              │   │
│  │       - ConstantArray                               │   │
│  │       - ProxifyLocals                               │   │
│  │       - NumbersToExpressions                        │   │
│  │       - WrapInFunction                              │   │
│  │     • Unparse AST back to Luau                      │   │
│  │                                                     │   │
│  │  4. Write obfuscated output                         │   │
│  │     • Write to temporary output file                │   │
│  │     • Return success                                │   │
│  └─────────────────────────────────────────────────────┘   │
└────────────────┬──────────────────────────────────────────────┘
                 │
         ┌───────┴──────────────────────────┐
         │ src/prometheus/* modules:        │
         ├──────────────────────────────────┤
         │ • tokenizer.lua - Lexical analysis
         │ • parser.lua - Syntax analysis    │
         │ • ast.lua - AST definitions       │
         │ • unparser.lua - Code generation  │
         │ • steps/ - Transformation steps   │
         │ • namegenerators/ - Name mangling │
         │ • util.lua - Utilities            │
         └───────────────────────────────────┘
```

## 📦 Component Details

### Frontend Layer
- **index.html**: Main UI template
- **styles.css**: Professional gradient UI
- **app.js**: Client-side logic
- **Communication**: JSON POST requests

### Backend Layer (Node.js)
- **server.js**: Express.js server
- **Responsibilities**:
  - HTTP server management
  - Request validation
  - File I/O coordination
  - Lua process invocation
  - Error handling

### Core Obfuscation Layer (Lua 5.1)
- **cli.lua**: Command-line entry point
- **prometheus.lua**: Core module loader
- **config.lua**: Global configuration
- **presets.lua**: Obfuscation presets
- **prometheus/**: Core obfuscation modules

## 🔄 Request Flow

```
1. USER ACTION
   ├─ Pastes Luau script in web interface
   ├─ Selects obfuscation preset (RobloxMedium)
   └─ Clicks "Obfuscate Script"

2. FRONTEND (app.js)
   ├─ Collects form data
   ├─ Validates input (non-empty)
   ├─ Shows loading spinner
   └─ Sends JSON POST to /api/obfuscate

3. BACKEND (server.js)
   ├─ Receives POST request
   ├─ Validates code + preset
   ├─ Creates temp files: obfusq_input_[random].lua
   ├─ Writes script to input file
   ├─ Executes: lua src/cli.lua --preset RobloxMedium input.lua --out output.lua
   ├─ Waits for Lua process (max 30 seconds)
   ├─ Reads output file
   ├─ Deletes temp files
   └─ Sends JSON response with obfuscated code

4. LUA CORE
   ├─ Loads configuration (LuaU enabled)
   ├─ Loads preset (RobloxMedium)
   ├─ Tokenizes script
   ├─ Parses to AST
   ├─ Applies transformation steps:
   │  ├─ EncryptStrings → strings → array lookups
   │  ├─ ConstantArray → constants → function calls
   │  ├─ ProxifyLocals → local vars → proxied access
   │  ├─ NumbersToExpressions → numbers → expressions
   │  └─ WrapInFunction → wraps in IIFE
   ├─ Unpars AST to Luau
   └─ Writes output file

5. FRONTEND DISPLAY
   ├─ Hides loading spinner
   ├─ Displays obfuscated code
   ├─ Shows "Copied!" button
   └─ Displays success message

6. USER OUTPUT
   └─ Copies obfuscated Luau to clipboard
```

## 🐳 Docker Deployment

```
┌──────────────────────────────────────┐
│      COOLIFY VPS / Docker Host       │
│  ┌────────────────────────────────┐  │
│  │    Docker Container            │  │
│  │  ┌──────────────────────────┐  │  │
│  │  │  Ubuntu 22.04 (slim)     │  │  │
│  │  │  ├─ Node.js 18           │  │  │
│  │  │  ├─ Lua 5.1              │  │  │
│  │  │  ├─ npm dependencies     │  │  │
│  │  │  └─ ObfusQ files         │  │  │
│  │  └──────────────────────────┘  │  │
│  │  ┌──────────────────────────┐  │  │
│  │  │  Port Mapping            │  │  │
│  │  │  Container:3000 → Host:3000 │  │
│  │  └──────────────────────────┘  │  │
│  │  ┌──────────────────────────┐  │  │
│  │  │  Health Check            │  │  │
│  │  │  curl /health every 30s  │  │  │
│  │  └──────────────────────────┘  │  │
│  │  ┌──────────────────────────┐  │  │
│  │  │  Non-root User           │  │  │
│  │  │  appuser (UID: 1000)     │  │  │
│  │  └──────────────────────────┘  │  │
│  └────────────────────────────────┘  │
└──────────────────────────────────────┘
```

## 🛡️ Security Architecture

```
┌─────────────────────────────────────┐
│       Security Layers               │
├─────────────────────────────────────┤
│  1. Input Validation                │
│     • Max 10MB request size          │
│     • Preset whitelist check         │
│     • Code emptiness check           │
├─────────────────────────────────────┤
│  2. Process Isolation               │
│     • Lua runs in separate process   │
│     • Timeout protection (30s)       │
│     • Separate temp file per request │
├─────────────────────────────────────┤
│  3. File Security                   │
│     • Temp files use random names    │
│     • Auto cleanup after use         │
│     • No persistence of scripts      │
├─────────────────────────────────────┤
│  4. Container Security              │
│     • Non-root user execution        │
│     • Read-only filesystem possible  │
│     • Network isolation              │
│     • Resource limits enforced       │
├─────────────────────────────────────┤
│  5. Error Handling                  │
│     • No stack trace exposure        │
│     • Generic error messages         │
│     • Proper exception catching      │
└─────────────────────────────────────┘
```

## 📊 Data Flow

```
User Script (Luau)
    ↓ tokenization
Tokens []
    ↓ parsing
AST (Abstract Syntax Tree)
    ↓ transformation steps
Modified AST
    ├─ Strings encrypted
    ├─ Constants replaced
    ├─ Variables mangled
    ├─ Numbers transformed
    └─ Wrapped in function
    ↓ unparsing
Obfuscated Script (Luau)
    ↓
Output to User
```

## ⚙️ Performance Characteristics

```
Request Processing Timeline:
├─ 0-10ms: HTTP request parsing
├─ 10-20ms: Validation & temp file creation
├─ 20-50ms: Lua process startup
├─ 50-5000ms: Obfuscation (depends on preset & size)
├─ 5000-5010ms: File reading & cleanup
└─ 5010-5050ms: Response JSON encoding

Typical Times:
├─ Small script (10KB): 200-500ms total
├─ Medium script (100KB): 1-3 seconds total
└─ Large script (1MB): 10-30 seconds total
```

---

This architecture ensures:
✅ Scalability - Stateless design
✅ Reliability - Error handling at each layer
✅ Security - Multiple security checkpoints
✅ Maintainability - Clear separation of concerns
✅ Extensibility - Easy to add new presets/steps
