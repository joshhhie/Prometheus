// ObfusQ Web Interface JavaScript

document.addEventListener('DOMContentLoaded', function() {
    const scriptInput = document.getElementById('scriptInput');
    const scriptOutput = document.getElementById('scriptOutput');
    const obfuscateBtn = document.getElementById('obfuscateBtn');
    const copyBtn = document.getElementById('copyBtn');
    const presetSelect = document.getElementById('presetSelect');
    const errorContainer = document.getElementById('errorContainer');
    const successMessage = document.getElementById('successMessage');

    obfuscateBtn.addEventListener('click', obfuscateScript);
    copyBtn.addEventListener('click', copyToClipboard);

    function hideMessages() {
        errorContainer.style.display = 'none';
        successMessage.style.display = 'none';
    }

    async function obfuscateScript() {
        const code = scriptInput.value.trim();
        
        if (!code) {
            showError('Please paste a script to obfuscate');
            return;
        }

        obfuscateBtn.disabled = true;
        const btnText = obfuscateBtn.querySelector('.btn-text');
        const btnSpinner = obfuscateBtn.querySelector('.btn-spinner');
        btnText.style.display = 'none';
        btnSpinner.style.display = 'inline-block';

        hideMessages();

        try {
            const response = await fetch('/api/obfuscate', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    code: code,
                    preset: presetSelect.value
                })
            });

            const result = await response.json();

            if (!response.ok) {
                showError(result.error || 'Obfuscation failed');
                return;
            }

            scriptOutput.value = result.obfuscated;
            copyBtn.style.display = 'block';
            showSuccess('Script obfuscated successfully!');

        } catch (error) {
            showError('Network error: ' + error.message);
        } finally {
            obfuscateBtn.disabled = false;
            btnText.style.display = 'inline';
            btnSpinner.style.display = 'none';
        }
    }

    function copyToClipboard() {
        scriptOutput.select();
        document.execCommand('copy');
        
        const originalText = copyBtn.textContent;
        copyBtn.textContent = '✅ Copied!';
        setTimeout(() => {
            copyBtn.textContent = originalText;
        }, 2000);
    }

    function showError(message) {
        errorContainer.textContent = '❌ ' + message;
        errorContainer.style.display = 'block';
    }

    function showSuccess(message) {
        successMessage.textContent = '✅ ' + message;
        successMessage.style.display = 'block';
    }
});
