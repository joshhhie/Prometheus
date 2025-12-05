# ObfusQ API Reference

## Base URL
```
http://your-domain.com:3000
```

## Authentication
No authentication required (suitable for internal/private deployment). For public deployment, add your own authentication layer (nginx, JWT, etc).

---

## Endpoints

### POST /api/obfuscate

Obfuscate Luau source code.

#### Request

**Headers:**
```
Content-Type: application/json
```

**Body:**
```json
{
  "code": "print('Hello, World!')",
  "preset": "RobloxMedium"
}
```

**Parameters:**
- `code` (string, required): Luau source code to obfuscate
  - Max length: 10MB
  - Must be valid Luau syntax
  - No encoding required

- `preset` (string, required): Obfuscation preset to use
  - Valid values:
    - `"Minify"` - Code minification only (fastest)
    - `"RobloxLight"` - Light obfuscation (recommended for testing)
    - `"RobloxMedium"` - Medium obfuscation (recommended)
    - `"RobloxStrong"` - Strong obfuscation (slowest, most thorough)

#### Response

**Success (200 OK):**
```json
{
  "obfuscated": "__obfusq_qx7m_1 = function(...) ... end; __obfusq_qx7m_1()"
}
```

**Fields:**
- `obfuscated` (string): The obfuscated Luau code

**Error (400 Bad Request):**
```json
{
  "error": "No script provided"
}
```

**Error (500 Internal Server Error):**
```json
{
  "error": "Obfuscation failed: [reason]"
}
```

#### Examples

**JavaScript/Node.js:**
```javascript
const response = await fetch('http://localhost:3000/api/obfuscate', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    code: 'print("Hello")',
    preset: 'RobloxMedium'
  })
});

const result = await response.json();
console.log(result.obfuscated);
```

**Python:**
```python
import requests
import json

response = requests.post(
  'http://localhost:3000/api/obfuscate',
  json={
    'code': 'print("Hello")',
    'preset': 'RobloxMedium'
  }
)

result = response.json()
print(result['obfuscated'])
```

**cURL:**
```bash
curl -X POST http://localhost:3000/api/obfuscate \
  -H "Content-Type: application/json" \
  -d '{
    "code": "print(\"Hello\")",
    "preset": "RobloxMedium"
  }'
```

**PowerShell:**
```powershell
$body = @{
    code = 'print("Hello")'
    preset = 'RobloxMedium'
} | ConvertTo-Json

Invoke-RestMethod -Uri 'http://localhost:3000/api/obfuscate' `
  -Method Post `
  -Headers @{'Content-Type'='application/json'} `
  -Body $body
```

---

### GET /health

Health check endpoint. Returns service status and version information.

#### Response

**Success (200 OK):**
```json
{
  "status": "ok",
  "version": "1.0.0"
}
```

#### Examples

**JavaScript:**
```javascript
const health = await fetch('http://localhost:3000/health')
  .then(r => r.json());

console.log(health); // {status: 'ok', version: '1.0.0'}
```

**Bash:**
```bash
curl http://localhost:3000/health
```

---

### GET /

Serves the web interface.

#### Response
- Returns HTML content (index.html)
- Access via browser or automated tool

---

## Error Handling

### Common Errors

**400: Bad Request**
```json
{
  "error": "No script provided"
}
```
Cause: The `code` field is empty or missing.

---

**400: Bad Request**
```json
{
  "error": "Invalid preset"
}
```
Cause: The `preset` is not one of the valid options.

---

**500: Internal Server Error**
```json
{
  "error": "Obfuscation failed: [details]"
}
```
Cause: Lua process failed, syntax error, or timeout.

**Common Reasons:**
- Invalid Luau syntax
- Script contains unsupported constructs
- Script is too large (>1MB)
- Obfuscation timeout exceeded (30 seconds)

---

## Rate Limiting

Currently no built-in rate limiting. For production deployment:

```javascript
// Example: Add rate limiting middleware
const rateLimit = require('express-rate-limit');

const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100 // limit each IP to 100 requests per windowMs
});

app.use('/api/', limiter);
```

---

## Performance Considerations

### Script Size Guidelines

| Size | Time | Recommended Preset |
|------|------|-------------------|
| <10 KB | <500ms | Any |
| 10-100 KB | 1-3s | RobloxLight or Medium |
| 100-500 KB | 5-15s | RobloxMedium |
| 500KB-1MB | 15-30s | RobloxLight |
| >1MB | Timeout | Not recommended |

### Optimization Tips

1. **Batch Processing**: Submit multiple small scripts instead of one large script
2. **Preset Selection**: Use RobloxLight for quick obfuscation, RobloxStrong only when needed
3. **Caching**: Cache results for identical scripts
4. **Async**: Always use async/await in concurrent environments

---

## Request/Response Examples

### Example 1: Basic Obfuscation

**Request:**
```bash
POST /api/obfuscate HTTP/1.1
Host: localhost:3000
Content-Type: application/json

{
  "code": "local x = 5\nprint(x)",
  "preset": "RobloxLight"
}
```

**Response:**
```bash
HTTP/1.1 200 OK
Content-Type: application/json

{
  "obfuscated": "local a=5;print(a)"
}
```

---

### Example 2: Invalid Syntax

**Request:**
```bash
POST /api/obfuscate HTTP/1.1
Host: localhost:3000
Content-Type: application/json

{
  "code": "print(invalid syntax]",
  "preset": "RobloxMedium"
}
```

**Response:**
```bash
HTTP/1.1 500 Internal Server Error
Content-Type: application/json

{
  "error": "Obfuscation failed: Syntax error at line 1"
}
```

---

### Example 3: Missing Field

**Request:**
```bash
POST /api/obfuscate HTTP/1.1
Host: localhost:3000
Content-Type: application/json

{
  "preset": "RobloxMedium"
}
```

**Response:**
```bash
HTTP/1.1 400 Bad Request
Content-Type: application/json

{
  "error": "No script provided"
}
```

---

## Integration Examples

### Node.js Module

```javascript
// obfusq-client.js
const fetch = require('node-fetch');

class ObfusQClient {
  constructor(baseUrl = 'http://localhost:3000') {
    this.baseUrl = baseUrl;
  }

  async obfuscate(code, preset = 'RobloxMedium') {
    const response = await fetch(`${this.baseUrl}/api/obfuscate`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ code, preset })
    });

    if (!response.ok) {
      const error = await response.json();
      throw new Error(error.error);
    }

    return response.json();
  }

  async health() {
    const response = await fetch(`${this.baseUrl}/health`);
    return response.json();
  }
}

module.exports = ObfusQClient;
```

**Usage:**
```javascript
const ObfusQClient = require('./obfusq-client');

const client = new ObfusQClient('http://localhost:3000');

(async () => {
  const result = await client.obfuscate('print("Hello")', 'RobloxMedium');
  console.log(result.obfuscated);
})();
```

---

### Python Library

```python
# obfusq_client.py
import requests

class ObfusQClient:
    def __init__(self, base_url='http://localhost:3000'):
        self.base_url = base_url

    def obfuscate(self, code, preset='RobloxMedium'):
        response = requests.post(
            f'{self.base_url}/api/obfuscate',
            json={'code': code, 'preset': preset}
        )
        response.raise_for_status()
        return response.json()

    def health(self):
        response = requests.get(f'{self.base_url}/health')
        response.raise_for_status()
        return response.json()
```

**Usage:**
```python
from obfusq_client import ObfusQClient

client = ObfusQClient('http://localhost:3000')
result = client.obfuscate('print("Hello")', 'RobloxMedium')
print(result['obfuscated'])
```

---

## Webhook/Callback Pattern (Optional)

For async processing with callbacks:

```javascript
// Example implementation
app.post('/api/obfuscate-async', async (req, res) => {
  const { code, preset, callback_url } = req.body;
  
  res.json({ job_id: generateJobId() });
  
  // Process in background
  processObfuscation(code, preset).then(result => {
    // Send callback
    await fetch(callback_url, {
      method: 'POST',
      body: JSON.stringify(result)
    });
  });
});
```

---

## WebSocket Support (Optional)

For real-time updates during obfuscation:

```javascript
const WebSocket = require('ws');

wss.on('connection', (ws) => {
  ws.on('message', async (msg) => {
    const { code, preset } = JSON.parse(msg);
    
    ws.send(JSON.stringify({ status: 'processing' }));
    
    const result = await obfuscate(code, preset);
    
    ws.send(JSON.stringify({ status: 'complete', result }));
  });
});
```

---

## Troubleshooting

### Connection Refused
- Verify server is running: `curl http://localhost:3000/health`
- Check port number (default: 3000)
- Check firewall rules

### Timeout Errors
- Large script exceeded 30-second timeout
- Try splitting into smaller modules
- Use RobloxLight preset for faster processing

### Invalid JSON Response
- Ensure Content-Type is application/json
- Check server logs for errors
- Verify all required fields are provided

---

## Support & Documentation

- **Web UI**: http://localhost:3000
- **Health Check**: http://localhost:3000/health
- **Full Docs**: See readme.md and DEPLOYMENT.md
- **Architecture**: See ARCHITECTURE.md

---

**ObfusQ v1.0.0** API Documentation
