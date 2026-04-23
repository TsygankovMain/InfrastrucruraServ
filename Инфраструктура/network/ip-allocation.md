---
title: "IP распределение и VLAN конфигурация"
slug: "ip-allocation"
status: "draft"
last_updated: "2026-04-23T00:00:00Z"
updated_by: "AI-Maintainer"
tags: [network, ip, vlan, subnets]
related: ["Инфраструктура/network/firewall-rules.md", "Обзор/network-map.md"]
ai_notes: "[NEEDS_DATA] Требуется актуальная информация об IP адресах и VLAN'ах"
---

# IP распределение

## VLAN архитектура

| VLAN ID | Название | Subnet | Шлюз | Назначение | Статус |
|---------|----------|--------|------|-----------|--------|
| 10 | Production | 192.168.10.0/24 | 192.168.10.1 | 1C Enterprise, MSSQL | [PENDING] |
| 20 | Management | 192.168.20.0/24 | 192.168.20.1 | Мониторинг, администрирование | [PENDING] |
| 30 | Backup | 192.168.30.0/24 | 192.168.30.1 | Резервное копирование | [PENDING] |
| [PENDING] | DMZ | [PENDING] | [PENDING] | [PENDING] | [PENDING] |

## IP Адреса серверов

### VLAN 10 — Production

| Хост | IP Адрес | MAC | Назначение | Статус |
|------|----------|-----|-----------|--------|
| PVD-1C | [PENDING] | [PENDING] | 1C Enterprise + MSSQL | [NEEDS_VERIFICATION] |
| [PENDING] | [PENDING] | [PENDING] | [PENDING] | [PENDING] |

### VLAN 20 — Management

| Хост | IP Адрес | MAC | Назначение | Статус |
|------|----------|-----|-----------|--------|
| Zabbix-Server | [PENDING] | [PENDING] | Система мониторинга | [NEEDS_VERIFICATION] |
| [PENDING] | [PENDING] | [PENDING] | [PENDING] | [PENDING] |

### VLAN 30 — Backup

| Хост | IP Адрес | MAC | Назначение | Статус |
|------|----------|-----|-----------|--------|
| Backup-Storage | [PENDING] | [PENDING] | Хранилище резервных копий | [PENDING] |
| [PENDING] | [PENDING] | [PENDING] | [PENDING] | [PENDING] |

## DNS конфигурация

| Параметр | Значение |
|----------|----------|
| DNS Domain | [PENDING] |
| Primary DNS | [PENDING] |
| Secondary DNS | [PENDING] |

## DHCP (если используется)

| Диапазон | Начало | Конец | VLAN | Статус |
|----------|--------|-------|------|--------|
| [PENDING] | [PENDING] | [PENDING] | [PENDING] | [PENDING] |

[NEEDS_DATA] — требуется полный список IP адресов и конфиги DHCP/DNS
