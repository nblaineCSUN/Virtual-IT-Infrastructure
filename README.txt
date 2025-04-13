# Virtual IT Infrastructure Lab

A fully virtualized enterprise-like IT lab built using VirtualBox, pfSense, Windows Server 2022, and Linux systems.

## 🧱 Project Overview

This project simulates a small enterprise network, including:
- Active Directory, DNS, DHCP, and File Server Services
- Linux domain integration with Samba
- pfSense firewall with Logical Segmentation, NAT, and DMZ setup
- Reverse proxy using Nginx on Ubuntu
- Netdata monitoring for visibility across all systems

## 🛠️ Tools & Technologies

- VirtualBox
- Windows Server 2022 (AD, DNS, DHCP, File Server)
- pfSense (DMZ, NAT, Logical Segmentation, Firewall, DNS, DHCP)
- Ubuntu (Nginx)
- Linux Client (Netdata, Samba)
- Netdata Monitoring System

## 🌐 Network Architecture

- LAN Subnet: `192.168.1.0/24`
- DMZ Subnet: `192.168.2.0/24`
- pfSense manages inter-subnet routing, NAT for internet access, and enforces strict firewall rules between LAN and DMZ.

## 📁 Project Components

- [Project Report](documentation/project-report.pdf)
- [IP Schema](documentation/IP-Schema.md)
- [Scope](configs/windows/dhcp_scope.txt)
- [Active Directory Setup](configs/windows/ad_user.txt)
- [pfSense Config](configs/pfSense/interface_configs.txt)
- [Netdata Monitoring Setup](configs/netdata/dashboard.txt)

## 🔒 Security Highlights

- DMZ separation using `intnetdmz`
- pfSense firewall rules per subnet
- Reverse proxy to isolate web exposure

## 🧠 Learnings

- Realistic AD and DHCP configurations
- Planning and implementation of secure network segmentation
- Service monitoring and Linux–Windows interoperability

---

## 📸 Diagrams

[Network Topology](network-diagrams/topology.png)