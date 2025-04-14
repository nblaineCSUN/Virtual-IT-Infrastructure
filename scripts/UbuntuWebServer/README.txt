You must update INTERFACE to match your actual NIC name (use ip a or ifconfig to check).

It sets 192.168.2.30/24, gateway 192.168.2.1, and DNS to your AD/DNS server at 192.168.1.10.

Netdata will be accessible at http://192.168.2.30:19999

Nginx is installed and enabled (can host your reverse proxy or static/dynamic web content).

UFW allows only SSH, HTTP, and HTTPS. You can tweak as needed.