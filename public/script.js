document.addEventListener('DOMContentLoaded', () => {
    const inputScript = document.getElementById('inputScript');
    const outputScript = document.getElementById('outputScript');
    const obfuscateBtn = document.getElementById('obfuscateBtn');
    const copyBtn = document.getElementById('copyBtn');
    const loader = document.getElementById('loader');
    const btnText = document.querySelector('.btn-text');

    obfuscateBtn.addEventListener('click', async () => {
        const scriptContent = inputScript.value;

        if (!scriptContent.trim()) {
            alert('Please enter a script to obfuscate.');
            return;
        }

        // UI Loading State
        setLoading(true);
        outputScript.value = '';

        try {
            const response = await fetch('/obfuscate', {
                method: 'POST',
                headers: {
                    'Content-Type': 'text/plain'
                },
                body: scriptContent
            });

            if (!response.ok) {
                const errorText = await response.text();
                throw new Error(errorText || 'Obfuscation failed');
            }

            const data = await response.text();
            outputScript.value = data;
        } catch (error) {
            console.error('Error:', error);
            outputScript.value = `-- Error during obfuscation:\n${error.message}`;
        } finally {
            setLoading(false);
        }
    });

    copyBtn.addEventListener('click', () => {
        if (!outputScript.value) return;

        outputScript.select();
        document.execCommand('copy'); // Fallback for older browsers
        navigator.clipboard.writeText(outputScript.value).then(() => {
            const originalText = copyBtn.innerHTML;
            copyBtn.innerHTML = '<i class="fa-solid fa-check"></i> Copied!';
            setTimeout(() => {
                copyBtn.innerHTML = originalText;
            }, 2000);
        });
    });

    function setLoading(isLoading) {
        if (isLoading) {
            obfuscateBtn.disabled = true;
            loader.style.display = 'inline-block';
            btnText.style.display = 'none';
            obfuscateBtn.style.opacity = '0.8';
            obfuscateBtn.style.cursor = 'wait';
        } else {
            obfuscateBtn.disabled = false;
            loader.style.display = 'none';
            btnText.style.display = 'inline';
            obfuscateBtn.style.opacity = '1';
            obfuscateBtn.style.cursor = 'pointer';
        }
    }
});
