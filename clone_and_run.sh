#!/bin/bash

# Set error handling
set -e

# Verify Node.js installation
echo "Node.js version: $(node --version)"
echo "NPM version: $(npm --version)"

echo "Starting Facebook Login Page server..."

# Check for express dependency
if ! npm list express > /dev/null 2>&1; then
  echo "Installing required dependencies..."
  npm install express
fi

# Run the simple server directly
echo "Starting server on port 5000..."
node simple_server.js
