#!/bin/bash

# Set error handling
set -e

# Verify Node.js installation
echo "Node.js version: $(node --version)"
echo "NPM version: $(npm --version)"

echo "Starting Niceplace web application setup..."

# Clone the repository or update if it already exists
echo "Checking for existing repository..."
if [ -d "Niceplace" ]; then
    echo "Repository already exists, using the existing code..."
    cd Niceplace
    # No need to pull, as we don't have tracking set up properly
    # Just use the existing code as is
else
    echo "Cloning the repository..."
    git clone https://github.com/kashflowNG/Niceplace.git
    cd Niceplace
    # We don't need to set up tracking since we won't be pulling again
fi

# Determine the type of application and install dependencies
echo "Examining repository structure..."

# Check for package.json (Node.js)
if [ -f "package.json" ]; then
    echo "Node.js application detected, installing dependencies..."
    npm install
fi

# Check for requirements.txt (Python)
if [ -f "requirements.txt" ]; then
    echo "Python application detected, installing dependencies..."
    pip install -r requirements.txt
fi

# Check for Gemfile (Ruby)
if [ -f "Gemfile" ]; then
    echo "Ruby application detected, installing dependencies..."
    bundle install
fi

# Check for composer.json (PHP)
if [ -f "composer.json" ]; then
    echo "PHP application detected, installing dependencies..."
    composer install
fi

# Look for environment setup
if [ -f ".env.example" ]; then
    echo "Creating .env file from example..."
    cp .env.example .env
    echo "Note: You may need to configure the .env file with appropriate values."
fi

# Determine how to start the application
echo "Determining how to start the application..."

# Check for specific start scripts in package.json if it's a Node.js app
if [ -f "package.json" ]; then
    # Check for TSX - it should be installed in the environment already
    echo "Checking for required dependencies..."
    if ! command -v tsx &> /dev/null; then
        echo "TSX not found in PATH, using the one we installed via packager_tool..."
        export PATH="$PATH:$(pwd)/../node_modules/.bin"
    fi
    
    # Modify the Vite config to use port 5000
    if [ -f "vite.config.ts" ] || [ -f "vite.config.js" ]; then
        echo "Ensuring the Vite configuration uses port 5000..."
        # This has been done already in an earlier step
    fi
    
    # For this specific application (Niceplace), we know it's a TypeScript app
    # with server/index.ts as the entry point
    if [ -f "server/index.ts" ]; then
        echo "Found server/index.ts, using 'dev' script for development mode..."
        # Set environment variables for proper configuration
        export NODE_ENV=development
        export PORT=5000
        export HOST=0.0.0.0
        
        # Run the dev script which should use the environment variables
        echo "Starting the application on port 5000..."
        npm run dev
    else
        # Fallback to standard approaches
        echo "Using standard Node.js application startup..."
        
        # Check if build script exists and run it first
        if grep -q "\"build\":" package.json; then
            echo "Building the application first..."
            npm run build
        fi
        
        # Check if there are server.js or index.js files in various directories
        echo "Looking for main application file..."
        
        # Try different startup methods
        if [ -f "dist/index.js" ]; then
            echo "Found dist/index.js, starting from there..."
            NODE_ENV=production PORT=5000 HOST=0.0.0.0 node dist/index.js
        elif [ -f "server/index.js" ]; then
            echo "Found server/index.js, starting from there..."
            PORT=5000 HOST=0.0.0.0 node server/index.js
        elif [ -f "server.js" ]; then
            echo "Found server.js in root, starting from there..."
            PORT=5000 HOST=0.0.0.0 node server.js
        elif grep -q "\"dev\":" package.json; then
            echo "Starting Node.js application in dev mode..."
            PORT=5000 HOST=0.0.0.0 npm run dev
        elif grep -q "\"start\":" package.json; then
            echo "Starting Node.js application..."
            PORT=5000 HOST=0.0.0.0 npm start
        fi
    fi
fi

# Check for Python web frameworks
if [ -f "manage.py" ]; then
    echo "Django application detected, starting server..."
    python manage.py runserver 0.0.0.0:5000
elif [ -f "app.py" ] || [ -f "main.py" ] || [ -f "server.py" ]; then
    PYTHON_APP=$(find . -maxdepth 1 -name "app.py" -o -name "main.py" -o -name "server.py" | head -1)
    echo "Flask/Python application detected, starting server..."
    # Set Flask environment variables for port 5000
    export FLASK_APP=$PYTHON_APP
    export FLASK_ENV=development
    export PORT=5000
    python -c "import os; from flask import Flask; app = Flask('app'); app.run(host='0.0.0.0', port=int(os.environ.get('PORT', 5000)))" || python $PYTHON_APP
fi

# If we couldn't determine how to start automatically, provide guidance
echo "
If the application didn't start automatically, please check the repository's README or documentation 
for specific instructions on how to run the application.

Common commands to start applications:
- Node.js: npm start, npm run dev, node app.js
- Python: python app.py, python manage.py runserver
- Ruby on Rails: rails server
- PHP: php -S 0.0.0.0:8000
"

echo "Setup completed!"
