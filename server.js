const express = require('express');
const bodyParser = require('body-parser');
const { exec } = require('child_process');
const fs = require('fs');
const path = require('path');
const { v4: uuidv4 } = require('uuid');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(bodyParser.text({ limit: '50mb' })); // Allow large payloads
app.use(express.static('public'));

// Routes
app.post('/obfuscate', (req, res) => {
    const luaCode = req.body;

    if (!luaCode) {
        return res.status(400).send('No Lua code provided');
    }

    const id = uuidv4();
    const inputPath = path.join(__dirname, `temp_${id}.lua`);
    const outputPath = path.join(__dirname, `temp_${id}_out.lua`);

    // Write input file
    fs.writeFileSync(inputPath, luaCode);

    // Command to run Prometheus
    // Assuming lua is available in the environment (will be in Docker)
    const command = `lua prometheus/cli.lua --config roblox_config.lua --out "${outputPath}" "${inputPath}"`;

    exec(command, (error, stdout, stderr) => {
        // Build response object
        const response = {
            success: true,
            output: '',
            logs: stdout,
            error: null
        };

        if (error) {
            console.error(`Error executing obfuscator: ${error}`);
            response.success = false;
            response.error = stderr || error.message;
        } else {
            // Read output file
            if (fs.existsSync(outputPath)) {
                response.output = fs.readFileSync(outputPath, 'utf8');
                // Cleanup output file
                fs.unlinkSync(outputPath);
            } else {
                response.success = false;
                response.error = "Obfuscation failed to produce output file.";
            }
        }

        // Cleanup input file
        if (fs.existsSync(inputPath)) {
            fs.unlinkSync(inputPath);
        }

        if (response.success) {
            res.send(response.output);
        } else {
            res.status(500).send(response.error);
        }
    });
});

app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});
