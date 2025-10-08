#!/bin/bash

set -e

echo "🔍 Checking font subsetting dependencies..."
echo ""

# Check Python
if command -v python3 &> /dev/null; then
    PYTHON_CMD="python3"
    echo "✅ Python found: python3"
elif command -v python &> /dev/null; then
    PYTHON_CMD="python"
    echo "✅ Python found: python"
else
    echo "❌ Python is not installed!"
    echo "   Please install Python 3 from https://www.python.org/downloads/"
    exit 1
fi

# Check pip
if command -v pip3 &> /dev/null; then
    PIP_CMD="pip3"
    echo "✅ pip found: pip3"
elif command -v pip &> /dev/null; then
    PIP_CMD="pip"
    echo "✅ pip found: pip"
else
    echo "❌ pip is not installed!"
    echo "   Please install pip or reinstall Python with pip included."
    exit 1
fi

# Check if pyftsubset (fonttools) is installed
if command -v pyftsubset &> /dev/null; then
    echo "✅ fonttools already installed"
else
    echo "📦 Installing fonttools..."
    $PIP_CMD install fonttools brotli zopfli
    echo "✅ fonttools installed successfully"
fi

echo ""
echo "✨ All dependencies ready!"
echo ""
