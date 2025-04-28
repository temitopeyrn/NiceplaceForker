#!/bin/bash

# Simple deployment script for manual server deployment

# Exit on any error
set -e

echo "==============================================="
echo "Simple Facebook Login Server Deployment Script"
echo "==============================================="

# Check if we have node installed
if ! command -v node &> /dev/null; then
    echo "Error: Node.js is not installed. Please install Node.js to continue."
    exit 1
fi

# Ensure npm dependencies are installed
echo "Installing dependencies..."
npm install --production

# Set execute permissions for the startup script
echo "Setting permissions for startup script..."
chmod +x clone_and_run.sh

# Check if PM2 is installed (for process management)
if ! command -v pm2 &> /dev/null; then
    echo "PM2 process manager not found. Installing globally..."
    npm install -g pm2
fi

# Start the application with PM2
echo "Starting application with PM2..."
pm2 start simple_server.js --name "facebook-login-server"

echo "================================================="
echo "Deployment complete!"
echo "Your application should now be running on port 5000."
echo "To check status: pm2 status"
echo "To view logs: pm2 logs facebook-login-server"
echo "To stop: pm2 stop facebook-login-server"
echo "================================================="