// ObfusQ - Express.js Backend Server for Roblox Luau Obfuscation
// Integrates with Lua obfuscator core via Node-Lua bridge

const express = require('express');
const path = require('path');
const bodyParser = require('body-parser');
const { execFile } = require('child_process');
const fs = require('fs');
const os = require('os');
const crypto = require('crypto');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(express.static(path.join(__dirname, 'public')));
app.use(bodyParser.json({ limit: '10mb' }));
app.use(bodyParser.urlencoded({ limit: '10mb', extended: true }));

// Obfuscation API endpoint
app.post('/api/obfuscate', async (req, res) => {
    try {
        const { code, preset } = req.body;

        if (!code) {
            return res.status(400).json({ error: 'No script provided' });
        }

        if (!preset || !['Minify', 'RobloxLight', 'RobloxMedium', 'RobloxStrong'].includes(preset)) {
            return res.status(400).json({ error: 'Invalid preset' });
        }

        // Create temporary files for input/output
        const tempDir = os.tmpdir();
        const inputId = crypto.randomBytes(8).toString('hex');
        const inputFile = path.join(tempDir, `obfusq_input_${inputId}.lua`);
        const outputFile = path.join(tempDir, `obfusq_output_${inputId}.lua`);

        try {
            // Write input script to temporary file
            fs.writeFileSync(inputFile, code, 'utf8');

            // Execute obfuscation via CLI
            const cliPath = path.join(__dirname, 'src', 'cli.lua');
            const result = await executeObfuscation(inputFile, outputFile, preset, cliPath);

            if (result.error) {
                return res.status(500).json({ error: result.error });
            }

            // Read obfuscated output
            const obfuscated = fs.readFileSync(outputFile, 'utf8');

            res.json({ obfuscated });

        } finally {
            // Clean up temporary files
            if (fs.existsSync(inputFile)) fs.unlinkSync(inputFile);
            if (fs.existsSync(outputFile)) fs.unlinkSync(outputFile);
        }

    } catch (error) {
        console.error('Obfuscation error:', error);
        res.status(500).json({ error: 'Obfuscation failed: ' + error.message });
    }
});

// Execute obfuscation
function executeObfuscation(inputFile, outputFile, preset, cliPath) {
    return new Promise((resolve) => {
        const luaPath = process.env.LUA_PATH || 'lua';
        const args = [cliPath, '--preset', preset, '--out', outputFile, inputFile];

        const timeout = setTimeout(() => {
            resolve({ error: 'Obfuscation timeout' });
        }, 30000); // 30 second timeout

        execFile(luaPath, args, { maxBuffer: 10 * 1024 * 1024 }, (error, stdout, stderr) => {
            clearTimeout(timeout);

            if (error) {
                resolve({ error: stderr || error.message });
            } else if (!fs.existsSync(outputFile)) {
                resolve({ error: 'Output file not created' });
            } else {
                resolve({ success: true });
            }
        });
    });
}

// Health check
app.get('/health', (req, res) => {
    res.json({ status: 'ok', version: '1.0.0' });
});

// Serve index
app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

// Start server
app.listen(PORT, () => {
    console.log(`✓ ObfusQ server running on http://localhost:${PORT}`);
    console.log(`✓ API endpoint: http://localhost:${PORT}/api/obfuscate`);
    console.log(`✓ Health check: http://localhost:${PORT}/health`);
});

// Graceful shutdown
process.on('SIGTERM', () => {
    console.log('SIGTERM received, shutting down gracefully');
    process.exit(0);
});

process.on('SIGINT', () => {
    console.log('SIGINT received, shutting down gracefully');
    process.exit(0);
});
