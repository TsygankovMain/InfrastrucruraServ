---
title: "Высокоуровневая архитектура инфраструктуры"
slug: "architecture-overview"
status: "published"
last_updated: "2026-04-23T00:00:00Z"
updated_by: "AI-Maintainer"
tags: [architecture, overview, infrastructure, diagram]
related: ["Обзор/network-map.md", "Обзор/data-flow.md", "Инфраструктура/servers/pvd-1c.md"]
---

# 🏗️ Архитектура инфраструктуры

## Компоненты системы

```
┌─────────────────────────────────────────────┐
│           Пользователи / Клиенты             │
└────────────────┬────────────────────────────┘
                 │
         ┌───────┴───────┐
         │               │
    ┌────▼────┐    ┌────▼────┐
    │  Web UI  │    │  Desktop │
    └────┬────┘    └────┬────┘
         │              │
    ┌────┴──────────────┴───────┐
    │   Application Layer        │
    │  (1C Enterprise Servers)   │
    └────┬──────────────────────┘
         │
    ┌────▼──────────────────────┐
    │   Data Layer              │
    │  (MSSQL + Storage)        │
    └────┬──────────────────────┘
         │
    ┌────▼──────────────────────┐
    │   Monitoring / Backup     │
    │  (Zabbix + Veeam)         │
    └───────────────────────────┘
```

## Основные слои

### 1. Application Layer — 1C Enterprise
- **Сервер:** PVD-1C (Supermicro SSG-6019P-ACR12L01-NC24B)
- **ОС:** Windows Server 2025 Standard
- **CPU:** 2x Intel Xeon Gold 6132 (28 cores)
- **RAM:** 130 GB DDR4 ECC LRDIMM
- **Роль:** Central application server for 1C Enterprise

### 2. Data Layer — MSSQL + Storage
- **Сервер:** MSSQL Primary (win-dckio4rlmnm.md)
- **СУБД:** Microsoft SQL Server 2019+
- **Хранилище:** HDD (6TB), SSD (1.92TB x2, 240GB, 480GB)
- **Резервные копии:** [PENDING] Veeam / Backup & Replication

### 3. Monitoring & Observability
- **Система мониторинга:** Zabbix Server
- **Метрики:** CPU, RAM, Disk, Network, Application-level
- **Логирование:** [PENDING]

### 4. Network & Access
- **Сетевой интерфейс:** Dual Gigabit LAN
- **Доступ:** VPN + MFA (требуется)
- **Firewall:** [PENDING] Hardware firewall / Windows Firewall rules

## Высокоуровневые процессы

### Бизнес-процесс
1. Пользователь подключается через Web UI / Desktop client
2. Запрос маршрутизируется на 1C Application Server
3. Сервер обрабатывает логику приложения
4. Данные сохраняются в MSSQL Database
5. Результат возвращается клиенту

### Мониторинг
- Zabbix Agent собирает метрики с PVD-1C
- Метрики отправляются на Zabbix Server
- Алерты генерируются при превышении порогов

### Резервное копирование
- [PENDING] Расписание backup'ов (ежедневно / еженедельно)
- [PENDING] Хранилище backup'ов
- [PENDING] RTO / RPO требования

[NEEDS_VERIFICATION] — архитектура требует уточнения и согласования
