#!/bin/sh

set -e

# Check for existing node_modules
if [ ! -d "node_modules" ]; then
    echo "Installing dependencies..."
    npm i
else
    echo "Dependencies already installed."
fi

# Start the development server with any CMD arguments
echo "Starting the development server..."

if npm run dev -- "$@"; then
    echo "Development server started successfully."
else
    echo "Failed to start the development server. Please check for errors."
    exit 1  # Exit with a non-zero status to indicate failure
fi