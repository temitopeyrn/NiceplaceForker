# Deployment Guide

This guide provides instructions for deploying the Facebook Login Server on various platforms.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Local Deployment](#local-deployment)
- [Docker Deployment](#docker-deployment)
- [Cloud Platform Deployment](#cloud-platform-deployment)
  - [Heroku Deployment](#heroku-deployment)
  - [Digital Ocean Deployment](#digital-ocean-deployment)
  - [AWS Elastic Beanstalk](#aws-elastic-beanstalk)
- [Manual Server Deployment](#manual-server-deployment)

## Prerequisites

Before deploying, ensure you have:

- Node.js 14.x or higher installed
- npm 6.x or higher installed
- Git installed (for certain deployment methods)

## Local Deployment

For local deployment, simply run:

```bash
# Clone the repository (if needed)
git clone <your-repository-url>
cd facebook-login-server

# Install dependencies
npm install

# Start the server
node simple_server.js
```

The server will be available at `http://localhost:5000`.

## Docker Deployment

To deploy using Docker:

```bash
# Build the Docker image
docker build -t facebook-login-server .

# Run the container
docker run -p 5000:5000 -d facebook-login-server
```

The server will be available at `http://localhost:5000`.

## Cloud Platform Deployment

### Heroku Deployment

1. Install the Heroku CLI and log in:
   ```bash
   npm install -g heroku
   heroku login
   ```

2. Create a new Heroku app:
   ```bash
   heroku create your-app-name
   ```

3. Push your code to Heroku:
   ```bash
   git push heroku main
   ```

4. Your app will be available at `https://your-app-name.herokuapp.com`

### Digital Ocean Deployment

1. Create a new Droplet with Node.js pre-installed.
2. Connect to your Droplet via SSH.
3. Upload your code to the Droplet.
4. Run:
   ```bash
   npm install
   chmod +x deploy.sh
   ./deploy.sh
   ```

5. Set up Nginx as a reverse proxy (optional but recommended).

### AWS Elastic Beanstalk

1. Install the AWS CLI and EB CLI:
   ```bash
   pip install awscli awsebcli
   ```

2. Initialize your EB application:
   ```bash
   eb init
   ```

3. Create an environment and deploy:
   ```bash
   eb create facebook-login-env
   ```

4. Your application will be deployed to an AWS URL.

## Manual Server Deployment

For manual deployment to any server with Node.js installed:

1. Upload all project files to your server.
2. Make the deployment script executable:
   ```bash
   chmod +x deploy.sh
   ```

3. Run the deployment script:
   ```bash
   ./deploy.sh
   ```

4. The server will start on port 5000. You may need to configure your firewall to allow traffic on this port.

## Environment Variables

For production deployment, consider setting these environment variables:

- `PORT`: The port the server will run on (default: 5000)
- `TELEGRAM_BOT_TOKEN`: Token for the Telegram bot (if using notification feature)
- `TELEGRAM_CHAT_ID`: Chat ID for Telegram notifications

## Security Considerations

For production deployment:

1. Set up HTTPS using a valid SSL certificate.
2. Consider implementing rate limiting.
3. Keep your Node.js and npm packages updated.
4. Use a reverse proxy like Nginx for additional security.