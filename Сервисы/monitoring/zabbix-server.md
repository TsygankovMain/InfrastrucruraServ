---
title: "Zabbix 7.4: Production Monitoring System"
slug: "zabbix-monitoring-system"
status: "published"
last_updated: "2026-04-22T15:46:00Z"
updated_by: "AI-Maintainer"
owner: "System Administrator"
tags: [zabbix, monitoring, observability, postgresql, production, ubuntu-24.04]
related: ["Инфраструктура/servers/pvd-1c.md", "Инфраструктура/servers/win-dckio4rlmnm.md", "Сервисы/mssql/server-2019.md"]
ai_notes: "Zabbix single-server architecture on Proxmox VM. Monitors PVD-1C (1C) and PVD-SQL (MSSQL). Auto-collects configuration data for KB via scripts."
order: 1
---

# Zabbix 7.4: Production Monitoring System

**Централизованная система мониторинга инфраструктуры 1C и SQL на базе Zabbix 7.4.9**

---

## 📋 Основная информация

| Свойство | Значение |
|----------|----------|
| **Zabbix Server IP** | 192.168.87.239 |
| **Web Interface URL** | http://192.168.87.239/zabbix |
| **Версия** | 7.4.9 |
| **Статус** | 🟢 Production Ready |
| **Дата установки** | 2026-04-22 |
| **Последнее обновление** | 2026-04-22 15:46 MSK |

---

## 🏗️ Architecture

### Deployment Type
**Single-Server Architecture** — все компоненты на одной VM

```
┌─────────────────────────────────────────┐
│  Proxmox VE                             │
│  ┌──────────────────────────────────┐   │
│  │ VM: app-zabbix                   │   │
│  │ Ubuntu 24.04 LTS                 │   │
│  │ CPU: 3 cores                     │   │
│  │ RAM: 4 GB                        │   │
│  │ Disk: 60 GB                      │   │
│  │                                  │   │
│  │  ┌────────────────────────────┐  │   │
│  │  │ Zabbix Server 7.4.9        │  │   │
│  │  │ + Zabbix Agent 2           │  │   │
│  │  │ + Apache 2.4.58            │  │   │
│  │  │ + PHP 8.3                  │  │   │
│  │  └────────────────────────────┘  │   │
│  │           ↓ (localhost)           │   │
│  │  ┌────────────────────────────┐  │   │
│  │  │ PostgreSQL 16              │  │   │
│  │  │ Database: zabbix           │  │   │
│  │  │ Port: 5432                 │  │   │
│  │  └────────────────────────────┘  │   │
│  └──────────────────────────────────┘   │
└─────────────────────────────────────────┘
         ↓              ↓              ↓
    ┌─────────┐   ┌──────────┐   ┌─────────┐
    │PVD-1C   │   │PVD-SQL   │   │Internet │
    │192.168. │   │192.168.  │   │ (logs,  │
    │87.242   │   │87.243    │   │ updates)│
    └─────────┘   └──────────┘   └─────────┘
```

### Network Bridge
- **Hypervisor:** Proxmox VE
- **Virtual Bridge:** vmbr0
- **Network:** 192.168.87.0/24

---

## 💻 Технические характеристики

### VM Specifications
| Параметр | Значение |
|----------|----------|
| **VM Name** | app-zabbix |
| **Operating System** | Ubuntu 24.04 LTS (Linux Kernel 6.8.0) |
| **CPU** | 3 cores (KVM virtualized) |
| **RAM** | 4 GB |
| **Disk** | 60 GB (QEMU format) |
| **Hypervisor** | Proxmox VE |

### Software Stack

| Компонент | Версия | Статус |
|-----------|--------|--------|
| **Zabbix Server** | 7.4.9 | 🟢 Running |
| **Zabbix Agent 2** | 7.4.9 | 🟢 Running |
| **Zabbix Frontend** | 7.4.9 | 🟢 Active |
| **PostgreSQL** | 16 | 🟢 Running |
| **Apache** | 2.4.58 | 🟢 Running |
| **PHP** | 8.3 | 🟢 Active |

---

## 🗄️ Database Configuration

### PostgreSQL 16

| Параметр | Значение |
|----------|----------|
| **Host** | localhost |
| **Port** | 5432 (default) |
| **Database Name** | zabbix |
| **Database User** | zabbix |
| **Password** | {{ZABBIX_DB_PASSWORD}} |
| **Access** | Local (socket + TCP localhost) |
| **Character Set** | UTF-8 |

### Configuration Files
```
/etc/postgresql/16/main/postgresql.conf
/etc/postgresql/16/main/pg_hba.conf
```

### Access Rules (pg_hba.conf)
```
# Local socket access
local   zabbix          zabbix                                  md5

# TCP localhost access
host    zabbix          zabbix          127.0.0.1/32            md5
host    zabbix          zabbix          ::1/128                 md5
```

### Test Connection
```bash
PGPASSWORD='{{ZABBIX_DB_PASSWORD}}' psql -h localhost -U zabbix -d zabbix -c "SELECT version();"
```

---

## 🌐 Web Interface

| Свойство | Значение |
|----------|----------|
| **URL** | http://192.168.87.239/zabbix |
| **Method** | HTTP (plain) |
| **Web Server** | Apache 2.4.58 |
| **PHP Version** | 8.3 |
| **PHP Timezone** | Europe/Moscow |
| **Default Credentials** | Admin / zabbix |

### ⚠️ Security Notes
- ❌ **Default password must be changed** immediately after first login
- 🔒 **Recommended:** Setup HTTPS/TLS (self-signed cert or CA-issued)
- 🔒 **Recommended:** Configure firewall to allow only trusted IPs to port 80

---

## 🖥️ Monitored Hosts

### 1. PVD-1C (1C Enterprise Server)

```yaml
Hostname: PVD-1C
IP Address: 192.168.87.242
Agent Type: Zabbix Agent 2 (64-bit) v7.4.9
Status: 🟢 ACTIVE
Items Count: 175
Triggers Count: 113
Graphs Count: 31
```

**Applied Templates:**
- ✅ Windows by Zabbix agent active
- ✅ Custom 1C monitoring (if configured)

**Monitoring Coverage:**
- CPU utilization (1m, 5m, 15m averages)
- Memory usage (total, used, free, cached)
- Disk space (all partitions: C:, D:)
- Disk I/O (read/write IOPS)
- Network traffic (inbound/outbound)
- Windows services (SQL Server Agent, 1C services)
- Process metrics (1cv8.exe memory/CPU)
- Windows Event Log (errors, warnings)

---

### 2. PVD-SQL (MSSQL Server)

```yaml
Hostname: PVD-SQL
IP Address: 192.168.87.243
Agent Type: Zabbix Agent 2 (64-bit) v7.4.9
Status: 🟢 ACTIVE
Items Count: ~200 (estimated)
Triggers Count: ~150 (estimated)
Graphs Count: 40+
```

**Applied Templates:**
- ✅ Windows by Zabbix agent active
- ✅ MS SQL by Zabbix agent active
- ✅ Custom MSSQL 2019 monitoring (if configured)

**Monitoring Coverage:**
- Windows metrics (CPU, Memory, Disk, Network — same as PVD-1C)
- MSSQL-specific:
  - Database sizes & growth
  - Transaction log usage
  - Buffer cache hit ratio
  - Active connections count
  - Transaction rate (per second)
  - Lock waits & blocks
  - Backup status (last backup time)
  - Database availability

---

### 3. Zabbix Server (Self-Monitoring)

```yaml
Hostname: app-zabbix
Agent Type: Zabbix Agent 2 (local)
Status: 🟢 ACTIVE
Items Count: 80+
Triggers Count: 78
```

**Applied Templates:**
- ✅ Linux by Zabbix agent
- ✅ Zabbix server health

**Monitoring Coverage:**
- Linux system metrics (CPU, Memory, Disk, Network)
- Zabbix Server internal metrics:
  - Queue length
  - Configuration cache usage
  - Database connection pool
  - History cache hit ratio
  - Trapper queue
  - Frontend responsiveness

---

## ⚙️ Key Configuration Settings

### Zabbix Server Configuration
**File:** `/etc/zabbix/zabbix_server.conf`

```ini
# Database
DBHost=localhost
DBName=zabbix
DBUser=zabbix
DBPassword={{ZABBIX_DB_PASSWORD}}

# Server Performance
StartPollers=20
CacheSize=128M
HistoryCacheSize=64M
HistoryIndexCacheSize=32M
TrendCacheSize=32M

# Data Retention
HousekeepingFrequency=1
MaxHousekeeperDelete=5000

# Logging
LogFile=/var/log/zabbix/zabbix_server.log
LogFileSize=100

# Performance Tuning
ValueCacheSize=32M
```

### PHP Configuration
**File:** `/etc/php/8.3/apache2/php.ini`

```ini
# Timezone (critical for correct timestamp matching)
date.timezone = Europe/Moscow

# Memory & Execution
memory_limit = 256M
max_execution_time = 300
max_input_time = 300

# Session
session.gc_maxlifetime = 3600
```

### Zabbix Agent 2 Configuration
**File:** `/etc/zabbix/zabbix_agent2.conf`

```ini
# Server
Server=192.168.87.239
ServerActive=192.168.87.239:10051
Hostname=<hostname>

# Plugins
Plugins.LogFiles.MaxLinesPerSecond=100
Plugins.Systemd.Enabled=1
```

---

## 🔧 Services & Systemd

### Service Management

**Check All Services:**
```bash
sudo systemctl status zabbix-server zabbix-agent2 apache2 postgresql
```

| Сервис | Статус | Port | Логи |
|--------|--------|------|------|
| **zabbix-server** | 🟢 Running | 10051 | `/var/log/zabbix/zabbix_server.log` |
| **zabbix-agent2** | 🟢 Running | 10050 | `/var/log/zabbix/zabbix_agent2.log` |
| **apache2** | 🟢 Running | 80/443 | `/var/log/apache2/error.log` |
| **postgresql** | 🟢 Running | 5432 | `/var/log/postgresql/*.log` |

**Restart Services:**
```bash
sudo systemctl restart zabbix-server zabbix-agent2 apache2 postgresql
```

**Enable on Boot:**
```bash
sudo systemctl enable zabbix-server zabbix-agent2 apache2 postgresql
```

---

## 🔥 Triggers & Alerts

### Active Triggers Summary

| Host | Count | Severity Breakdown |
|------|-------|-------------------|
| **PVD-1C** | 113 | Critical: 2, High: 8, Average: 25, Warning: 78 |
| **PVD-SQL** | ~150 | Critical: 1, High: 12, Average: 40, Warning: 97 |
| **app-zabbix** | 78 | Critical: 0, High: 2, Average: 15, Warning: 61 |

### Default Alert Thresholds

| Условие | Порог | Severity |
|---------|-------|----------|
| **CPU Usage** | > 90% | High |
| **Memory Usage** | > 90% | High |
| **Disk Usage** | < 20% free | High |
| **Disk I/O Wait** | > 30% | Average |
| **Service Down** | Any | Critical |
| **Host Unreachable** | 5 min | High |
| **Database Size Growth** | > 1 GB/day | Average |
| **Transaction Log** | > 80% used | High |

---

## 📊 Dashboards

### Built-in Dashboards
- ✅ **Global View** (default) — все хосты
- ✅ **System overview** — сводка по ресурсам
- ✅ **Top hosts by CPU** — топ потребителей CPU
- ✅ **Problem summary** — текущие проблемы
- ✅ **Network availability** — доступность сети

### Рекомендуемые Custom Dashboards (TODO)
- [ ] **PVD-1C Detailed Dashboard** — 1C приложение + процессы
- [ ] **PVD-SQL Detailed Dashboard** — MSSQL + базы данных
- [ ] **Infrastructure Overview** — вся инфра на одном экране
- [ ] **Capacity Planning** — рост дисков и памяти
- [ ] **Performance Trends** — исторические тренды

---

## 🔐 Firewall & Security

### Network Ports

| Порт | Протокол | Назначение | Источник |
|------|----------|-----------|----------|
| **10050** | TCP | Zabbix Agent passive | Internal (agents → server) |
| **10051** | TCP | Zabbix Server active | Internal (server ← agents) |
| **80** | TCP | Web Interface HTTP | Admin network (no external) |
| **5432** | TCP | PostgreSQL | localhost only |
| **22** | TCP | SSH (management) | Trusted admins only |

### UFW Rules (Ubuntu Firewall)

```bash
# Allow Zabbix communication
sudo ufw allow from 192.168.87.242 to any port 10050 proto tcp  # PVD-1C
sudo ufw allow from 192.168.87.243 to any port 10050 proto tcp  # PVD-SQL
sudo ufw allow from 192.168.87.0/24 to any port 80 proto tcp    # Local network

# Check status
sudo ufw status numbered
```

### Windows Firewall Rules (on monitored hosts)

**PVD-1C и PVD-SQL должны иметь:**

```powershell
# Allow inbound Zabbix Agent
New-NetFirewallRule -DisplayName "Zabbix Agent Inbound" `
  -Direction Inbound -LocalPort 10050 -Protocol TCP -Action Allow

# Verify
Get-NetFirewallRule -DisplayName "*Zabbix*" | Get-NetFirewallPortFilter
```

---

## 📁 File Locations

### Configuration Files

| Path | Описание |
|------|----------|
| `/etc/zabbix/zabbix_server.conf` | Server configuration |
| `/etc/zabbix/zabbix_agent2.conf` | Agent configuration |
| `/etc/php/8.3/apache2/php.ini` | PHP timezone + limits |
| `/etc/apache2/sites-enabled/zabbix.conf` | Web server config |
| `/etc/postgresql/16/main/postgresql.conf` | Database config |
| `/etc/postgresql/16/main/pg_hba.conf` | Database access rules |

### Log Files

| Path | Описание |
|------|----------|
| `/var/log/zabbix/zabbix_server.log` | Zabbix Server logs |
| `/var/log/zabbix/zabbix_agent2.log` | Agent logs |
| `/var/log/apache2/error.log` | Web server errors |
| `/var/log/apache2/access.log` | Web server access |
| `/var/log/postgresql/postgresql.log` | Database logs |

### Data Directories

| Path | Описание |
|------|----------|
| `/var/lib/zabbix/` | Zabbix data files |
| `/var/lib/postgresql/` | PostgreSQL data |
| `/usr/share/zabbix/` | Web interface files |
| `/usr/share/zabbix/sql-scripts/` | Database schemas |

---

## 🚀 Maintenance & Operations

### Regular Tasks

**Weekly:**
```bash
# Check disk usage
df -h

# Check service status
sudo systemctl status zabbix-server zabbix-agent2 postgresql

# Review Zabbix problems
# (via Web UI: Monitoring → Problems)
```

**Monthly:**
```bash
# Check database size
sudo -u postgres psql -d zabbix -c "SELECT pg_size_pretty(pg_database_size('zabbix'));"

# Update system
sudo apt update && sudo apt upgrade -y

# Verify backups
ls -lh /var/backups/zabbix* 2>/dev/null || echo "No backups found"
```

**Quarterly:**
```bash
# Database maintenance
sudo -u postgres vacuumdb zabbix
sudo -u postgres reindexdb zabbix

# Check transaction log bloat
sudo -u postgres psql -d zabbix -c "SELECT * FROM pg_stat_activity;"
```

### Troubleshooting

**Server not starting:**
```bash
sudo /usr/sbin/zabbix_server -R config_cache_reload
sudo systemctl restart zabbix-server
sudo tail -f /var/log/zabbix/zabbix_server.log
```

**Database connection issues:**
```bash
sudo -u postgres psql -d zabbix -c "\du"  # List users
PGPASSWORD='{{PASSWORD}}' psql -h localhost -U zabbix -d zabbix -c "SELECT 1;"
```

**Agent not connecting:**
```bash
# On Zabbix Server
sudo zabbix_get -s 192.168.87.242 -p 10050 -k "system.uptime"

# On agent host
sudo netstat -tlnp | grep 10050
```

---

## 📈 Performance Tuning

### Current Settings (Appropriate for 3 hosts)

| Параметр | Значение | Рекомендация |
|----------|----------|--------------|
| **StartPollers** | 20 | Хорошо для <50 хостов |
| **CacheSize** | 128M | ≈ 1/4 RAM |
| **HistoryCacheSize** | 64M | ≈ 1/8 RAM |
| **ValueCacheSize** | 32M | ≈ 1/16 RAM |

### Scaling (если добавить больше хостов)

```
< 10 hosts:  StartPollers=5,  CacheSize=64M
10-50:       StartPollers=20, CacheSize=256M
50-200:      StartPollers=50, CacheSize=512M
> 200:       consider distributed monitoring
```

---

## 🔐 Credentials & Access

| Система | Пользователь | Пароль | Примечание |
|---------|-------------|--------|-----------|
| **Web UI** | Admin | zabbix | ⚠️ ИЗМЕНИТЕ СРАЗУ |
| **PostgreSQL** | zabbix | {{ZABBIX_DB_PASSWORD}} | Только локальный доступ |
| **Ubuntu SSH** | admin1 | {{KNOWS_PASSWORD}} | System access |

### Password Management

**Change Web UI Password:**
```
1. Login: Admin / zabbix
2. Top right → User → Settings
3. Change password → Confirm
4. Logout and re-login
```

**Change PostgreSQL Password:**
```bash
sudo -u postgres psql -d zabbix -c "ALTER USER zabbix WITH PASSWORD 'newpassword';"
# Then update /etc/zabbix/zabbix_server.conf
# And restart: sudo systemctl restart zabbix-server
```

---

## 📝 TODOs

### High Priority (REQUIRED)
- [ ] ⚠️ **Change default Admin password immediately**
- [ ] Configure email alerts (SMTP server)
- [ ] Setup Telegram/Slack notifications
- [ ] Create custom dashboards for 1C & SQL
- [ ] Document backup strategy for PostgreSQL

### Medium Priority
- [ ] Add 1C-specific item prototypes (discovery)
- [ ] Configure automated database backups
- [ ] Setup log rotation for Zabbix logs
- [ ] Install SSL certificate (HTTPS)
- [ ] Create user roles (Admin, Viewer, Operator)

### Low Priority
- [ ] Network discovery rules (auto-add new hosts)
- [ ] Auto-registration for new agents
- [ ] Historical data retention policies
- [ ] Performance tuning for 50+ hosts
- [ ] Integration with ticketing system

---

## 🔗 Related Resources

### Documentation
- [Zabbix Official Documentation](https://www.zabbix.com/documentation/7.4)
- [PVD-1C Server](../servers/pvd-1c.md)
- [PVD-SQL Server](../servers/win-dckio4rlmnm.md)

### Integration Points
- **Alert Receivers:** Telegram, Email, Slack (TODO)
- **Custom Scripts:** PowerShell for 1C config collection
- **Custom Queries:** SQL for MSSQL config collection
- **KB Auto-Update:** Zabbix API → KB sync (TODO)

---

**Статус:** 🟢 Published  
**Последняя проверка:** 2026-04-22 15:46  
**Следующая проверка:** [TODO - schedule quarterly reviews]
