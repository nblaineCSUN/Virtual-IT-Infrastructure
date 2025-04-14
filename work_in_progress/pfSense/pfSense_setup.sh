#!/bin/bash

# ========== CONFIG ==========
PFSENSE_HOST="192.168.1.1"
USERNAME="admin"
PASSWORD="pfsense"
API_BASE="https://${PFSENSE_HOST}/api/v1"
VERIFY_SSL=false  # Set to true if using valid certs
# ============================

# ========= HELPER ==========
_curl() {
  curl -sk --user "$USERNAME:$PASSWORD" "$@"
}
# ===========================

# ========== 1. INSTALL API (optional, if not already installed) ==========
echo "[+] Checking for pfSense API..."
_curl -X GET "${API_BASE}/system/status" >/dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "[!] API not responding. Installing package..."

  ssh root@${PFSENSE_HOST} <<'EOF'
pkg install -y pfSense-pkg-API
EOF

  echo "[+] API package installed. Reboot pfSense, then rerun the script."
  exit 1
fi

# ========== 2. CONFIGURE INTERFACES ==========
# You should customize these to your network interfaces and VLANs
echo "[+] Configuring Interfaces..."

# Add example: DMZ interface
_curl -X POST "${API_BASE}/interface/assignments" \
  -H "Content-Type: application/json" \
  -d '{"if":"em2","descr":"DMZ"}'

# Set IP for DMZ
_curl -X PUT "${API_BASE}/interface/configure" \
  -H "Content-Type: application/json" \
  -d '{"interface":"opt1","enable":true,"ipaddr":"192.168.2.1","subnet":24,"descr":"DMZ"}'

# ========== 3. CONFIGURE FIREWALL RULES ==========
echo "[+] Adding firewall rules..."

# Allow LAN to DMZ
_curl -X POST "${API_BASE}/firewall/rule" \
  -H "Content-Type: application/json" \
  -d '{
    "interface": "lan",
    "action": "pass",
    "protocol": "any",
    "source": { "network": "lan" },
    "destination": { "network": "dmz" },
    "descr": "Allow LAN to DMZ"
}'

# Allow DMZ to WAN (optional and more restrictive in prod)
_curl -X POST "${API_BASE}/firewall/rule" \
  -H "Content-Type: application/json" \
  -d '{
    "interface": "opt1",
    "action": "pass",
    "protocol": "any",
    "source": { "network": "dmz" },
    "destination": { "any": true },
    "descr": "Allow DMZ to WAN"
}'

# ========== 4. CONFIGURE NAT OUTBOUND ==========
echo "[+] Switching to Manual NAT mode..."

_curl -X PUT "${API_BASE}/nat/outbound/mode" \
  -H "Content-Type: application/json" \
  -d '{"mode":"advanced"}'

# Create a manual rule for DMZ to WAN
_curl -X POST "${API_BASE}/nat/outbound/rule" \
  -H "Content-Type: application/json" \
  -d '{
    "interface":"wan",
    "source":{"network":"192.168.2.0/24"},
    "destination":{"any":true},
    "natport":"any",
    "target":"interface_address",
    "descr":"DMZ to WAN NAT",
    "enabled":true
}'

# ========== 5. APPLY CHANGES ==========
echo "[+] Applying configuration..."
_curl -X POST_
