---
title: "Карта сети и топология"
slug: "network-map"
status: "draft"
last_updated: "2026-04-23T00:00:00Z"
updated_by: "AI-Maintainer"
tags: [network, topology, diagram, ip-allocation]
related: ["01_Overview/data-flow.md", "02_Infrastructure/network/ip-allocation.md"]
ai_notes: "[NEEDS_DATA] Требуется актуальная сетевая топология и IP адреса"
---

# 🗺️ Карта сети

## Физическая топология

```
┌──────────────────────────────────────────────┐
│          Internet / External Network         │
└──────────────────┬───────────────────────────┘
                   │ (Firewall)
            ┌──────▼──────┐
            │  Firewall    │
            │  (Hardware)  │
            └──────┬───────┘
                   │
        ┌──────────┴─────────────┐
        │                        │
   ┌────▼─────┐          ┌─────▼────┐
   │ VLAN 10  │          │ VLAN 20  │
   │Production│          │Management│
   │(1C, MSSQL)          │         │
   └────┬─────┘          └─────┬────┘
        │                      │
   ┌────▼────────┐      ┌─────▼────┐
   │  PVD-1C     │      │ Zabbix   │
   │ (1C + MSSQL)│      │ Server   │
   └─────────────┘      └──────────┘
```

## VLAN Распределение

| VLAN | Название | IP Range | Назначение | Статус |
|------|----------|----------|-----------|--------|
| 10 | Production | 192.168.10.0/24 | 1C, MSSQL, App servers | Active |
| 20 | Management | 192.168.20.0/24 | Monitoring, Administration | Active |
| [PENDING] | DMZ | 192.168.100.0/24 | [PENDING] | [PENDING] |

## IP Адреса (текущие)

| Хост | IP | VLAN | Назначение | Статус |
|------|----|----|-----------|--------|
| PVD-1C | 192.168.1.? | 10 | 1C Enterprise + MSSQL | [NEEDS_VERIFICATION] |
| Zabbix-Server | 192.168.?.? | 20 | Monitoring | [NEEDS_VERIFICATION] |
| [PENDING] | [PENDING] | [PENDING] | [PENDING] | [PENDING] |

## Firewall Правила

[PENDING] — Требуется документация firewall правил (входящие/исходящие порты)

[NEEDS_DATA] — требуется полная сетевая топология и IP адреса
