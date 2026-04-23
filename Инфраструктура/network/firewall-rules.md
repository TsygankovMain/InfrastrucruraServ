---
title: "Firewall правила и сетевая безопасность"
slug: "firewall-rules"
status: "draft"
last_updated: "2026-04-23T00:00:00Z"
updated_by: "AI-Maintainer"
tags: [firewall, security, network-rules, ports]
related: ["Инфраструктура/network/ip-allocation.md", "Доступ/rbac.md"]
ai_notes: "[NEEDS_DATA] Требуется документация firewall правил"
order: 2
---

# Firewall правила

## Входящие правила (Inbound)

### 1C Application Server (PVD-1C)

| Порт | Протокол | Источник | Описание | Статус |
|------|----------|----------|---------|--------|
| 1433 | TCP | VLAN 10 | MSSQL (локальная сеть) | [PENDING] |
| 1541 | TCP | VLAN 10, VPN | 1C Client (TCP) | [PENDING] |
| 1560 | TCP | VLAN 10, VPN | 1C Client (HTTP) | [PENDING] |
| 443 | TCP | Any | HTTPS (Web UI) | [PENDING] |
| 10050 | TCP | VLAN 20 | Zabbix Agent | [PENDING] |
| [PENDING] | [PENDING] | [PENDING] | [PENDING] | [PENDING] |

### MSSQL Server

| Порт | Протокол | Источник | Описание | Статус |
|------|----------|----------|---------|--------|
| 1433 | TCP | VLAN 10 | MSSQL Native (1C) | [PENDING] |
| 445 | TCP | VLAN 30 | SMB (Backup) | [PENDING] |
| 10050 | TCP | VLAN 20 | Zabbix Agent | [PENDING] |
| [PENDING] | [PENDING] | [PENDING] | [PENDING] | [PENDING] |

### Zabbix Server

| Порт | Протокол | Источник | Описание | Статус |
|------|----------|----------|---------|--------|
| 10051 | TCP | VLAN 10, 20, 30 | Zabbix Server (agents) | [PENDING] |
| 80 | TCP | Any | HTTP Web UI | [PENDING] |
| 443 | TCP | Any | HTTPS Web UI | [PENDING] |
| [PENDING] | [PENDING] | [PENDING] | [PENDING] | [PENDING] |

## Исходящие правила (Outbound)

### PVD-1C

| Назначение | Порт | Протокол | Описание | Статус |
|-----------|------|----------|---------|--------|
| Backup Server | 445 | TCP | SMB Backup | [PENDING] |
| Internet | 53, 123 | UDP | DNS, NTP | [PENDING] |
| Internet | 443 | TCP | HTTPS Updates | [PENDING] |
| [PENDING] | [PENDING] | [PENDING] | [PENDING] | [PENDING] |

### MSSQL Server

| Назначение | Порт | Протокол | Описание | Статус |
|-----------|------|----------|---------|--------|
| Backup Server | 445 | TCP | SMB Backup | [PENDING] |
| Internet | 53, 123 | UDP | DNS, NTP | [PENDING] |
| [PENDING] | [PENDING] | [PENDING] | [PENDING] | [PENDING] |

## VPN Access

- **VPN Gateway:** [PENDING]
- **VPN Protocol:** [PENDING] (IPSec / OpenVPN / WireGuard)
- **Разрешённые порты:** [PENDING]
- **Аутентификация:** MFA required

## DDoS Protection

- **Статус:** [PENDING]
- **Провайдер:** [PENDING]
- **Пороги:** [PENDING]

[NEEDS_DATA] — требуется полный список firewall правил для всех сервисов
