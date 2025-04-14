
Complete Setup Wizard (System > Setup Wizard)

Ensure up to date (System > Update)

If unable to find packages: In pfSense shell run: "certctl rehash" then "pkg-static install -fy pkg pfSense-repo pfSense-upgrade"

Pass command with: ssh admin@<pfSense IP> 'pfSsh.php < config_script.txt' from LinuxClient or whichever machine you want to use to pass.  
							    
Enable SSH or upload this script to a Linux host with network access to 192.168.1.1 or whatever your pfSense IP is.

Run: pfSense_setup.sh

Check pfSense UI — interfaces, rules, NAT should all reflect the changes with ./verify_LinCli.sh