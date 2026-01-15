#!/data/data/com.termux/files/usr/bin/bash

echo "======= Starting Services ======="

# Stop any previous instances
pkill filebrowser >/dev/null 2>&1
pkill cloudflared >/dev/null 2>&1

# Start FileBrowser
cd ~/filebrowser || exit 1
echo "FileBrowser is starting..."
chmod +x ./filebrowser
./filebrowser >/dev/null 2>&1 &
sleep 2
echo "FileBrowser is running..."

# Start Cloudflared
echo "Starting Cloudflared tunnel..."
cloudflared tunnel --url http://localhost:8080 > tunnel.log 2>&1 &

# Wait until the tunnel URL appears
URL=""
for i in {1..20}; do
  URL=$(grep -o 'https://[-a-zA-Z0-9]*\.trycloudflare\.com' tunnel.log | head -n 1)
  if [ -n "$URL" ]; then
    break
  fi
  sleep 1
done

# Check result
if [ -z "$URL" ]; then
  echo "Failed to retrieve Cloudflared URL."
  echo "Check tunnel.log for details."
  exit 1
fi

# Print the URL
echo "================================"
echo "Tunnel URL:"
echo "$URL"
echo "================================"
echo "Server setup complete."

ENDPOINT_FILE="$HOME/filebrowser/endpoint.conf"

# 1. Ensure endpoint file exists
if [ ! -f "$ENDPOINT_FILE" ]; then
    echo "Endpoint file not found: $ENDPOINT_FILE"
    echo "Please configure it first."
    exit 1
fi
 
DEST_ENDPOINT=$(cat "$ENDPOINT_FILE")

if [ -z "$DEST_ENDPOINT" ]; then
    echo "Endpoint file is empty."
    exit 1
fi


echo "Destination endpoint: $DEST_ENDPOINT"
echo "Sending tunnel URL to saved endpoint..."
ENVIRONMENT="$HOME/filebrowser/.env"


# 1. Ensure endpoint file exists
if [ ! -f "$ENVIRONMENT" ]; then
    echo ".env file not found: $ENDPOIENVIRONMENT"
    echo "Please configure it first."
    exit 1
fi


API_KEY=$(cat "$ENVIRONMENT")


curl -X POST "$DEST_ENDPOINT/update" \
     -H "Content-Type: application/json" \
     -H "x-api-key: $API_KEY" \
     -d "{\"url\": \"$URL\"}"



echo "Done."