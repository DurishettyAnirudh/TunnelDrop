echo "======= Updating Mirrors ======="
pkg update && pkg upgrade -y -y -y -y


echo "Setting up storage...."
echo "Please grant permission for storage..."
termux-setup-storage
mkdir ~/storage/TunnelDrop
mkdir ~/storage/TunnelDrop/files
echo "Storage Setup is done..."


echo "======= Installing Dependencies =========="
echo "Installing wget and tar..."
pkg install wget tar -y


echo "Installing Cloudflared..."
pkg install cloudflared
echo "Cloudflared is installed..."


echo "Installing Filebrowser..."
mkdir filebrowser
cd filebrowser
curl -LO https://github.com/filebrowser/filebrowser/releases/latest/download/linux-arm64-filebrowser.tar.gz
tar -xvzf linux-arm64-filebrowser.tar.gz
chmod +x filebrowser
echo "Filebrowser is installed..."


echo "======= FileBrowser Configuration ======="
echo "Configuring filebrowser..."
cd ~/TunnelDrop/filebrowser
./filebrowser config init
./filebrowser config set --root ~/storage/TunnelDrop/filesbrowser
./filebrowser config set --address 127.0.0.1
read -p "Enter a Username: " username
read -sp "Set a Password (Minimum 12 Characters): " password
./filebrowser users add $username $password --perm.admin 
echo "Finished Configuring FileBrowser..."

echo "Configuring remote location..."
echo "Note: If you don't have the remote application setup for redirection to this service, you can enter 'n' below."

read -p "Enter Remote URL: " endpoint

echo "$endpoint" > "endpoint.conf"
echo "Endpoint saved to 'endpoint.conf'."


read -p "Enter API Key: " API_KEY
echo "$API_KEY" > ".env"