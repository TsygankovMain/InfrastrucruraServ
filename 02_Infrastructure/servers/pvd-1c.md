---
title: "PVD-1C: 1C Enterprise Application Server"
slug: "pvd-1c-1c-server"
status: "published"
last_updated: "2026-04-22T13:07:00Z"
updated_by: "AI-Maintainer"
owner: "Mainsoft Tsyganov ES"
tags: [1c-enterprise, application-server, production, windows-server-2025, xeon-gold]
related: ["02_Infrastructure/servers/win-dckio4rlmnm.md", "03_Services/1c/platform-8.3.md", "03_Services/1c/platform-8.5.md"]
ai_notes: "Created from AIDA64 system report. Two 1C Platform versions (8.3 and 8.5) running on this server. Disk allocation strategy [PENDING]."
---

# PVD-1C: 1C Enterprise Application Server

**Production-grade server hosting 1C Enterprise 8.3 and 8.5 platform versions.**

---

## 📋 Основная информация

| Свойство | Значение |
|----------|----------|
| **Hostname** | PVD-1C |
| **Primary IP** | 192.168.87.242 |
| **MAC Address** | AC-1F-6B-59-95-1D |
| **Operating System** | Microsoft Windows Server 2025 Standard (10.0.26100.32522) |
| **Environment** | Production |
| **Status** | Active |
| **Responsible Contact** | Mainsoft Tsyganov ES |

---

## 💻 Hardware & Specifications

### CPU
- **Processor Type:** 2x Intel Xeon Gold 6132 (Skylake-SP)
- **Cores/Threads:** 14 cores per CPU × 2 = **28 cores total**
- **Base Frequency:** 2.60 GHz
- **Turbo:** Up to 3.7 GHz
- **Multiplier:** 33x (3300 MHz)

### Memory
- **Total RAM:** 130 GB (130,730 MB)
- **Type:** LRDIMM ECC DDR4 SDRAM
- **Configuration:** 12x DIMM slots on motherboard
- **Bandwidth:** High-bandwidth for virtualization-ready architecture

### Motherboard & Chipset
- **Manufacturer:** Supermicro
- **Model:** X11DDW-NT
- **Chipset:** Intel Lewisburg C622 + Intel Skylake-SP
- **Features:** 2× PCI-E x16, 1× PCI-E x32, 1× M.2, 1× U.2, Dual Gigabit LAN
- **DMI Version:** 1.11

### BIOS
- **Type:** AMI BIOS
- **Version:** 5.14
- **Release Date:** 07/11/2023
- **Capabilities:** Flash BIOS, Shadow BIOS, Selectable Boot, EDD, BBS

---

## 💾 Storage Configuration

### Physical Drives

| Drive | Model | Capacity | Type | Speed | Purpose |
|-------|-------|----------|------|-------|---------|
| **HDD-1** | HGST HUS726T6TALE6L4 | 6 TB | SATA-III HDD | 7200 RPM | [PENDING] |
| **SSD-1** | Intel SSDSC2KG019T8 | 1.92 TB | SATA-III SSD | - | [PENDING] |
| **SSD-2** | Intel SSDSC2KG019T8 | 1.92 TB | SATA-III SSD | - | [PENDING] |
| **SSD-3** | Intel SSDSC2KG240G8 | 240 GB | SATA-III SSD | - | [PENDING] |
| **SSD-4** | Intel SSDSC2KG480G8 | 480 GB | SATA-III SSD | - | [PENDING] |

**Total Storage:** 10.6 TB raw capacity

### Logical Volumes

| Drive | Filesystem | Total Size | Free Space | Purpose |
|-------|-----------|-----------|-----------|---------|
| **C:** | NTFS | 222.6 GB | 63.4 GB | [PENDING] |
| **D:** | NTFS | 447.1 GB | 422.8 GB | [PENDING] |
| **Total** | - | 669.7 GB | 486.1 GB | - |

**SMART Status:** ✅ OK

---

## 🌐 Network Configuration

### Network Adapters

| Adapter | Model | Speed | IP Address | MAC Address |
|---------|-------|-------|-----------|------------|
| **NIC-1** | Intel Ethernet Connection X722 for 10GBASE-T | 10 Gbps | 192.168.87.242 | AC-1F-6B-59-95-1D |
| **NIC-2** | Intel Ethernet Connection X722 for 10GBASE-T | 10 Gbps | - | [NEEDS_VERIFICATION] |

### DNS Configuration
- **NetBIOS Name:** PVD-1C
- **DNS Hostname:** PvD-1c
- **DNS Domain:** [Not joined to domain]
- **FQDN:** PvD-1c

---

## 🔧 Services & Applications

### 1C Enterprise Platforms

| Platform | Version | Status | Port(s) | Purpose |
|----------|---------|--------|---------|---------|
| **1C Enterprise** | 8.3 | Active | [PENDING] | Production Business Logic |
| **1C Enterprise** | 8.5 | Active | [PENDING] | Production Business Logic |

### Key Dependencies
- **Database Server:** WIN-DCKIO4RLMNM (192.168.87.240)
  - MSSQL 2019 instance
  - Connection: TCP/1433 (likely)
- **Monitoring:** [PENDING]
- **Backup Target:** [PENDING]

---

## 📊 Monitoring & Performance

### Key Metrics to Monitor

| Metric | Threshold (Warn) | Threshold (Critical) |
|--------|-----------------|----------------------|
| **CPU Usage** | > 75% | > 90% |
| **Memory Usage** | > 85% | > 95% |
| **Disk C: Usage** | > 80% | > 95% |
| **Disk D: Usage** | > 80% | > 95% |
| **Network Bandwidth** | > 80% | > 95% |

### Current Health Status
- **CPU:** [PENDING]
- **Memory:** Estimated 80%+ available
- **Disk:** C: has 63.4 GB free (28.5% available)
- **Network:** Dual 10 Gbps adapters, capacity available

---

## 💾 Backup & Recovery

| Property | Value |
|----------|-------|
| **Backup Strategy** | [PENDING] |
| **Backup Frequency** | [PENDING] |
| **Backup Tool** | [PENDING] |
| **Backup Location** | [PENDING] |
| **Retention Period** | [PENDING] days |
| **RTO Target** | [PENDING] hours |
| **RPO Target** | [PENDING] hours |
| **Last Successful Backup** | [PENDING] |
| **Last Recovery Test** | [PENDING] |

---

## 🔐 Security & Access

### Local Accounts
- **Administrator Account:** root
- **Admin Status:** Local administrator on PVD-1C
- **Password:** Stored in {{VAULT_LOCATION}}

### User Accounts
[PENDING - Enumerate users with administrative or service account access]

### Firewall Rules
[PENDING - Document inbound/outbound rules for 1C ports]

---

## 🛠️ Maintenance & Operations

### Startup/Shutdown Procedures

**Start 1C Services:**
```powershell
# [PENDING - Add specific commands for starting 1C 8.3 and 8.5 platforms]
Start-Service "1C:Enterprise*"
```

**Stop 1C Services:**
```powershell
# [PENDING - Add specific commands]
Stop-Service "1C:Enterprise*"
```

**Check Service Status:**
```powershell
Get-Service | Where-Object {$_.Name -like "*1C*"}
```

### Update/Patching Schedule
- **Windows Updates:** [PENDING]
- **1C Platform Updates:** [PENDING]
- **Driver Updates:** [PENDING]
- **Maintenance Window:** [PENDING day/time UTC]

### Known Issues & Workarounds
[PENDING - Document any known issues with this server]

---

## 🔗 Related Resources

### Configuration Files
- 1C 8.3 Configuration: `[PENDING - file path]`
- 1C 8.5 Configuration: `[PENDING - file path]`
- Log Location: `[PENDING - path]`

### Documentation
- [1C Platform 8.3 Service Guide](../03_Services/1c/platform-8.3.md)
- [1C Platform 8.5 Service Guide](../03_Services/1c/platform-8.5.md)
- [MSSQL Server (WIN-DCKIO4RLMNM)](win-dckio4rlmnm.md)
- [Network Firewall Rules](../02_Infrastructure/network/firewall-rules.md)

### Runbooks
- [Deploying 1C Update](../../05_Runbooks/deploy-1c-update.md)
- [Emergency Database Recovery](../../05_Runbooks/emergency-recovery.md)
- [Scaling 1C Application Server](../../05_Runbooks/scale-1c-server.md)

---

## 📝 Notes

- Server is production-grade with enterprise-class hardware (Xeon Gold, ECC memory)
- Dual 10 Gigabit Ethernet provides redundancy and high throughput
- Storage capacity is robust (10.6 TB), but allocation strategy requires definition
- Disk C: has adequate free space (63.4 GB), but monitor growth
- 1C versions 8.3 and 8.5 coexist on same server — ensure proper isolation

---

**Status:** 🟢 Published  
**Last Verified:** 2026-04-22  
**Next Review:** [PENDING - schedule periodic reviews]
