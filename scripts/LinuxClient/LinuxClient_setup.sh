#!/bin/bash

# ========== CONFIG ==========
STATIC_IP="192.168.1.50"
GATEWAY="192.168.1.1"
DNS_SERVER="192.168.1.1"  # WindowsDC01 or pfSense, depending on what you choose
INTERFACE="enp0s3"         # Make sure this matches your NIC (`ip a`)
HOSTNAME="linuxclient"
# ============================

echo "[+] Updating system..."
sudo apt update && sudo apt upgrade -y

echo "[+] Installing essential packages..."
sudo apt install -y netdata-core netdata curl ufw net-tools smbclient cifs-utils nfs-common htop vim gnupg lsb-release software-properties-common avahi-daemon openssh-client openssh-server

echo "[+] Setting hostname..."
sudo hostnamectl set-hostname "$HOSTNAME"

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

# Permissions fix
sudo chmod 644 /etc/netplan/01-netcfg.yaml
sudo chown root:root /etc/netplan/01-netcfg.yaml

echo "[+] Applying Netplan configuration..."
sudo netplan apply --debug

echo "[+] Installing Netdata..."
bash <(curl -Ss https://my-netdata.io/kickstart.sh) --dont-wait

echo "[+] Configuring UFW firewall..."
sudo ufw allow ssh
sudo ufw allow 19999/tcp
sudo ufw enable

echo "[✔] Setup complete!"
echo "Access Netdata at: http://${STATIC_IP}:19999"

