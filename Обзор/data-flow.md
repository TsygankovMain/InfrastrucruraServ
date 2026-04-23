---
title: "Потоки данных между компонентами"
slug: "data-flow"
status: "draft"
last_updated: "2026-04-23T00:00:00Z"
updated_by: "AI-Maintainer"
tags: [data-flow, architecture, communication]
related: ["Обзор/architecture.md", "Обзор/network-map.md"]
ai_notes: "[NEEDS_VERIFICATION] Требуется документация всех потоков данных"
order: 3
---

# 📊 Потоки данных

## Основные потоки

### 1️⃣ Client → 1C Application Server

**Направление:** Входящий  
**Протокол:** HTTP/HTTPS, 1C Protocol  
**Порты:** [PENDING] (стандартно 1541, 1560, 443)  
**Частота:** Real-time (как необходимо)  
**Объём:** [PENDING] GB/день

```
User/Client
    ↓
 Network
    ↓
 Firewall (Allow ports)
    ↓
 1C Application Server (PVD-1C)
```

### 2️⃣ 1C Server → MSSQL Database

**Направление:** Внутренний (Local)  
**Протокол:** SQL Server RPC, TDS  
**Порты:** 1433 (default)  
**Частота:** Непрерывно (transactions)  
**Объём:** [PENDING] GB/день

```
1C Application Server
    ↓
 Named Pipes / TCP/IP
    ↓
 MSSQL Server
    ↓
 Database Storage
```

### 3️⃣ MSSQL → Backup Storage

**Направление:** Исходящий  
**Протокол:** [PENDING] (Veeam / S3 / SMB)  
**Порты:** [PENDING]  
**Частота:** [PENDING] (ежедневно / еженедельно)  
**Объём:** [PENDING] GB/backup

```
MSSQL Server
    ↓
 Backup Agent (Veeam)
    ↓
 Storage / Cloud
```

### 4️⃣ All Servers → Zabbix Monitoring

**Направление:** Входящий (к Zabbix)  
**Протокол:** Zabbix Agent Protocol  
**Порты:** 10050 (Agent) / 10051 (Server)  
**Частота:** Каждые 60 сек (по умолчанию)  
**Объём:** [PENDING] KB/мин

```
Servers (Zabbix Agents)
    ↓
 Collect Metrics
    ↓
 Send to Zabbix Server
    ↓
 Store in Zabbix DB
    ↓
 Display in Web UI
```

## Критичные потоки данных

- **Database Replication:** [PENDING] (если есть failover)
- **Log Forwarding:** [PENDING]
- **Alert Notifications:** [PENDING]

[NEEDS_VERIFICATION] — требуется актуальный анализ потоков
