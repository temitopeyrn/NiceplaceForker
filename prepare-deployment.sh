#!/bin/bash

# Script to prepare the project for deployment

echo "==============================================="
echo "Facebook Login Server - Deployment Preparation"
echo "==============================================="

# Create a deployment directory
DEPLOY_DIR="deployment-package"
mkdir -p $DEPLOY_DIR

# Copy necessary files to the deployment directory
echo "Copying files to $DEPLOY_DIR..."
cp index.html $DEPLOY_DIR/
cp simple_server.js $DEPLOY_DIR/
cp Dockerfile $DEPLOY_DIR/
cp docker-compose.yml $DEPLOY_DIR/
cp .dockerignore $DEPLOY_DIR/
cp Procfile $DEPLOY_DIR/
cp .env.example $DEPLOY_DIR/
cp deploy.sh $DEPLOY_DIR/
cp README.md $DEPLOY_DIR/
cp DEPLOYMENT.md $DEPLOY_DIR/
cp vercel.json $DEPLOY_DIR/
cp netlify.toml $DEPLOY_DIR/
cp .gitignore $DEPLOY_DIR/

# Use the deployment package.json
echo "Setting up package.json for deployment..."
cp package.json.deploy $DEPLOY_DIR/package.json

echo "==============================================="
echo "Deployment package created in: $DEPLOY_DIR"
echo "You can now zip this directory and deploy it to your chosen platform"
echo "See DEPLOYMENT.md for deployment instructions"
echo "==============================================="