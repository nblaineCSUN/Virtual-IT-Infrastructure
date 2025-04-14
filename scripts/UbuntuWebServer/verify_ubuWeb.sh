echo "-----Networking-----"
ip a | grep inet
ip route
cat /etc/netplan/01-netcfg.yaml
echo "-----DNS/Internet-----"
ping -c 3 google.com
dig @192.168.1.10 google.com
echo "-----Hostname-----"
hostname
hostnamectl
echo "-----Nginx-----"
curl localhost
echo "Remote check: From another VM on 192.168.2.0/24, run: curl http://192.168.2.30"
echo "-----UFW-----"
sudo ufw status
echo "-----REBOOT-----"
