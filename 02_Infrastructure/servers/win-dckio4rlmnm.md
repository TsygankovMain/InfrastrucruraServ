---
title: "WIN-DCKIO4RLMNM: MSSQL 2019 Database Server"
slug: "win-dckio4rlmnm-sql-server"
status: "published"
last_updated: "2026-04-22T13:00:00Z"
updated_by: "AI-Maintainer"
owner: "Mainsoft Tsyganov ES"
tags: [mssql-2019, database-server, production, windows-server-2016, xeon-e5]
related: ["02_Infrastructure/servers/pvd-1c.md", "03_Services/mssql/server-2019.md"]
ai_notes: "Created from AIDA64 system report. Hosts MSSQL Server 2019 for 1C Enterprise applications (8.3 and 8.5). Disk allocation strategy [PENDING]."
---

# WIN-DCKIO4RLMNM: MSSQL 2019 Database Server

**Production SQL Server hosting databases for 1C Enterprise 8.3 and 8.5 platforms.**

---

## 📋 Основная информация

| Свойство | Значение |
|----------|----------|
| **Hostname** | WIN-DCKIO4RLMNM |
| **Primary IP** | 192.168.87.240 |
| **MAC Address** | 10-C3-7B-47-DC-3A |
| **Operating System** | Microsoft Windows Server 2016 Standard (10.0.14393.447) |
| **Environment** | Production |
| **Status** | Active |
| **Responsible Contact** | Mainsoft Tsyganov ES |

---

## 💻 Hardware & Specifications

### CPU
- **Processor Type:** 2x Intel Xeon E5-2650 v2 (Ivy Bridge-EP)
- **Cores/Threads:** 8 cores per CPU × 2 = **16 cores total**
- **Base Frequency:** 2.60 GHz
- **Turbo:** Up to 3.5 GHz
- **Multiplier:** 26x (2600 MHz)

### Memory
- **Total RAM:** 131 GB (131,021 MB)
- **Type:** Registered ECC DDR3 SDRAM
- **Modules Installed:**
  - DIMM-A1: Samsung M386B4G70DM0-YK04 (32 GB DDR3-1600 ECC)
  - DIMM-B1: Samsung M386B4G70DM0-YK04 (32 GB DDR3-1600 ECC)
  - DIMM-C1: Samsung M386B4G70DM0-YK04 (32 GB DDR3-1600 ECC)
  - DIMM-D1: SK Hynix HMT84GL7AMR4A-PB (32 GB DDR3-1600 ECC)
  - Additional slots: [PENDING]
- **Speed:** DDR3-1600 (11-11-11-28 @ 800 MHz native)

### Motherboard & Chipset
- **Manufacturer:** ASUS
- **Model:** Z9PA-D8 Series
- **Chipset:** Intel Patsburg C602 + Intel Ivy Bridge-EP
- **Features:** 3× PCI-E x8, 2× PCI-E x16, 1× PIKE, 8× DDR3 DIMM, Dual Gigabit LAN
- **BIOS Version:** 5403 (01/07/2014)
- **BIOS System Version:** 4.6

### System
- **DMI Manufacturer:** ASUSTeK COMPUTER INC.
- **DMI System Model:** Z9PA-D8 Series
- **System Serial Number:** 1405265368 0024
- **System UUID:** A0B6886E-CB5BDD911-846710C3-7B47DC3A

---

## 💾 Storage Configuration

### Physical Drives

| Drive | Model | Capacity | Type | Purpose |
|-------|-------|----------|------|---------|
| **Virtual-Floppy** | AMI Virtual Floppy0 USB | - | Virtual | BIOS/IPMI |
| **Virtual-HDISK0** | AMI Virtual HDISK0 USB | - | Virtual | [PENDING] |
| **SSD-1** | Intel SSDSC2KG019T8 | 1.92 TB | SATA-III SSD | [PENDING] |
| **SSD-2** | Intel SSDSC2KG240G8 | 240 GB | SATA-III SSD | [PENDING] |
| **SSD-3** | Intel SSDSC2KG960G8 | 960 GB | SATA-III SSD | [PENDING] |
| **Virtual-CDROM0** | AMI Virtual CDROM0 USB | - | Virtual | BIOS/IPMI |

**Physical Storage:** ~3.1 TB (excluding virtual devices)

### Logical Volumes

| Drive | Filesystem | Total Size | Free Space | Purpose |
|-------|-----------|-----------|-----------|---------|
| **C:** | NTFS | 223.1 GB | 126.5 GB | [PENDING] |
| **D:** | NTFS | 894.1 GB | 893.9 GB | [PENDING] |
| **H:** | NTFS | 894.2 GB | 894.0 GB | [PENDING] |
| **Total** | - | 2,011.4 GB | 1,914.4 GB | - |

**SMART Status:** ✅ OK

---

## 🌐 Network Configuration

### Network Adapters

| Adapter | Model | Speed | IP Address | MAC Address |
|---------|-------|-------|-----------|------------|
| **NIC-1** | Intel 82574L Gigabit Network Connection | 1 Gbps | 192.168.87.240 | 10-C3-7B-47-DC-3A |
| **NIC-2** | Intel 82574L Gigabit Network Connection | 1 Gbps | [PENDING] | [PENDING] |

### DNS Configuration
- **NetBIOS Name:** WIN-DCKIO4RLMNM
- **DNS Hostname:** WIN-DCKIO4RLMNM
- **DNS Domain:** [Not joined to domain]
- **FQDN:** WIN-DCKIO4RLMNM

---

## 🔧 Database Services

### MSSQL Server 2019

| Property | Value |
|----------|-------|
| **Edition** | [PENDING - Standard/Enterprise/etc] |
| **Version** | SQL Server 2019 |
| **Instance Name** | [PENDING - default or named instance?] |
| **Database Port** | 1433 (TCP, likely) |
| **Status** | [PENDING - verify running] |

### Supported Databases
- **1C Enterprise 8.3 Database:** [PENDING - name/size]
- **1C Enterprise 8.5 Database:** [PENDING - name/size]
- **System Databases:** master, msdb, tempdb, model

### Key Dependencies
- **1C Application Servers:** PVD-1C (192.168.87.242)
  - Connections via TCP/1433
  - High-volume read/write during business hours
- **Backup Target:** [PENDING]
- **Replication/Mirroring:** [PENDING - configured?]

---

## 📊 Monitoring & Performance

### Key Metrics to Monitor

| Metric | Threshold (Warn) | Threshold (Critical) |
|--------|-----------------|----------------------|
| **CPU Usage** | > 75% | > 90% |
| **Memory Usage** | > 85% | > 95% |
| **Disk C: Usage** | > 80% | > 95% |
| **Disk D: Usage** | > 80% | > 95% |
| **Disk H: Usage** | > 80% | > 95% |
| **SQL Server Memory** | > 85% of allocated | > 95% of allocated |
| **Database Transaction Log** | > 80% full | > 95% full |
| **Network Bandwidth** | > 80% | > 95% |

### Current Health Status
- **CPU:** [PENDING]
- **Memory:** 131 GB total, low utilization expected (893.9 GB free on D:)
- **Disk C:** 126.5 GB free (56.7% available)
- **Disk D/H:** 893.9 GB / 894.0 GB free (99.98% available) — indicates fresh allocation
- **Network:** Dual 1 Gbps adapters, capacity available

---

## 💾 Backup & Recovery

| Property | Value |
|----------|-------|
| **Backup Strategy** | [PENDING] |
| **Backup Frequency** | [PENDING - daily/hourly transaction logs?] |
| **Backup Tool** | [PENDING - native MSSQL or third-party?] |
| **Backup Location** | [PENDING - local/network/cloud?] |
| **Retention Period** | [PENDING] days/weeks |
| **Recovery Model** | [PENDING - Simple/Full/Bulk-logged] |
| **RTO Target** | [PENDING] hours |
| **RPO Target** | [PENDING] minutes |
| **Last Successful Backup** | [PENDING] |
| **Last Recovery Test** | [PENDING] |

---

## 🔐 Security & Access

### Database Logins
- **Administrator Account:** ROOT (local)
- **Service Account:** {{MSSQL_SERVICE_ACCOUNT}}
- **Password Location:** Stored in {{VAULT_LOCATION}}

### SQL Server Logins
[PENDING - List service accounts, 1C database users, administrative logins]

### Network Access Control
[PENDING - Document firewall rules for TCP/1433]

---

## 🛠️ Maintenance & Operations

### SQL Server Services

**Start SQL Server:**
```powershell
Start-Service "MSSQLSERVER"  # or named instance
```

**Stop SQL Server:**
```powershell
Stop-Service "MSSQLSERVER"
```

**Restart SQL Server:**
```powershell
Restart-Service "MSSQLSERVER"
```

**Check Service Status:**
```powershell
Get-Service "MSSQLSERVER"
```

### Common Tasks

#### Database Backup
```sql
-- Full database backup
BACKUP DATABASE [1C_Database] 
TO DISK = 'E:\Backups\1C_Database_YYYYMMDD.bak'
WITH FORMAT, INIT, COMPRESSION;

-- Transaction log backup
BACKUP LOG [1C_Database]
TO DISK = 'E:\Backups\1C_Database_Log_YYYYMMDD.trn'
WITH FORMAT, INIT, COMPRESSION;
```

#### Check Database Health
```sql
DBCC CHECKDB([1C_Database]) WITH NO_INFOMSGS;
```

#### View Transaction Log Space
```sql
DBCC SQLPERF(LOGSPACE);
```

### Update/Patching Schedule
- **Windows Server Patching:** [PENDING day/time UTC]
- **MSSQL Cumulative Updates:** [PENDING - frequency and schedule]
- **Driver Updates:** [PENDING]
- **Maintenance Window:** [PENDING - ensure backup is complete before patching]

---

## 🔗 Related Resources

### Configuration
- **MSSQL Config File:** `C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\` (typical)
- **SQL Server Error Log:** `C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\LOG\`
- **Database Files:** [PENDING - actual data directory]

### Documentation
- [MSSQL Server 2019 Service Guide](../03_Services/mssql/server-2019.md)
- [1C Enterprise Application Server (PVD-1C)](pvd-1c.md)
- [Network Firewall Rules](../02_Infrastructure/network/firewall-rules.md)
- [Backup Policy](../02_Infrastructure/storage/backup-policy.md)

### Runbooks
- [MSSQL Database Recovery Procedures](../../05_Runbooks/mssql-recovery.md)
- [Transaction Log Growth Management](../../05_Runbooks/txn-log-management.md)
- [MSSQL Failover Procedures](../../05_Runbooks/mssql-failover.md)

---

## 📝 Notes

- **Older Hardware:** Xeon E5-2650 v2 (2013-era) — still reliable but consider upgrade timeline
- **Windows Server 2016:** Extended support until January 2027 — plan upgrade to 2019/2022
- **Storage Configuration:** D: and H: volumes have excessive free space (893+ GB each), indicating fresh allocation — define usage strategy
- **Memory:** 131 GB DDR3 is substantial for MSSQL 2019, monitor actual database size
- **Networking:** 1 Gigabit adapters are adequate for 1C workload but monitor bandwidth during peak hours
- **Virtual Devices:** AMI virtual floppy/CDROM/HDISK indicate IPMI/BMC access capability — ensure secured

---

**Status:** 🟢 Published  
**Last Verified:** 2026-04-22  
**Next Review:** [PENDING - schedule periodic reviews]
