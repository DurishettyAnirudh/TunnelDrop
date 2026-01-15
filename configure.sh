echo "======= FileBrowser Configuration ======="
echo "Configuring filebrowser..."
cd ~/filebrowser
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