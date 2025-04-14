#!/bin/bash

# ========== CONFIG ==========
STATIC_IP="192.168.2.30"
GATEWAY="192.168.2.1"
DNS_SERVER="192.168.1.1"  # Your WindowsDC01 if it's your DNS
INTERFACE="enp0s3"         # Change this to match your Ubuntu NIC name
HOSTNAME="ubuntuweb"
# ============================

echo "[+] Updating system..."
apt update && apt upgrade -y

echo "[+] Installing required packages..."
apt install -y nginx curl ufw software-properties-common apt-transport-https ca-certificates gnupg lsb-release net-tools

echo "[+] Setting hostname..."
hostnamectl set-hostname "$HOSTNAME"

echo "[+] Setting static IP address..."
sudo bash -c "cat > /etc/netplan/01-netcfg.yaml" <<EOF
network:
  version: 2
  renderer: networkd
  ethernets:
    ${INTERFACE}:
      addresses:
        - ${STATIC_IP}/24
      gateway4: ${GATEWAY}
      nameservers:
        addresses: [${DNS_SERVER}, 8.8.8.8]
EOF

echo "[+] Applying Netplan configuration..."
netplan apply

echo "[+] Enabling and starting Nginx..."
systemctl enable nginx
systemctl start nginx

echo "[+] Installing Netdata (monitoring)..."
bash <(curl -Ss https://my-netdata.io/kickstart.sh) --dont-wait

echo "[+] Configuring UFW firewall..."
ufw allow ssh
ufw allow http
ufw allow https
ufw enable

echo "[+] Cleaning up..."
apt autoremove -y

echo "[+] Setup complete!"
echo "Reboot the system to finalize changes, especially hostname and networking."
