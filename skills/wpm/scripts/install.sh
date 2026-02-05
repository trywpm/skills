#!/usr/bin/env bash
set -e

# Check if wpm is already installed
if command -v wpm &> /dev/null; then
    echo "wpm is already installed: $(wpm --version)"
    exit 0
fi

# Determine OS and install
if [[ "$OSTYPE" == "linux-gnu"* ]] || [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Detected Linux/Mac. Installing via curl..."
    curl -fsSL https://wpm.so/install | bash
elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]]; then
    echo "Detected Windows. Installing via PowerShell..."
    powershell -c "irm wpm.so/install.ps1|iex"
else
    echo "Unsupported OS: $OSTYPE"
    exit 1
fi

echo "Installation complete."