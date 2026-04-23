---
title: "1C Application Servers и кластеры"
slug: "1c-app-servers"
status: "draft"
last_updated: "2026-04-23T00:00:00Z"
updated_by: "AI-Maintainer"
owner: "@1C Admin Team"
tags: [1c, app-servers, cluster, load-balancing]
related: ["03_Services/1c/platform-versions.md", "02_Infrastructure/servers/pvd-1c.md"]
ai_notes: "[NEEDS_DATA] Требуется информация о серверах приложений 1C"
---

# 1C Application Servers

## Кластер серверов приложений

| Сервер | IP | Порт | Роль | Статус |
|--------|----|----|------|--------|
| PVD-1C | [PENDING] | [PENDING] | Primary App Server | [PENDING] |
| [PENDING] | [PENDING] | [PENDING] | Secondary / Backup | [PENDING] |

## Главный сервер (Master Server)

| Параметр | Значение |
|----------|----------|
| Hostname | PVD-1C |
| IP | [PENDING] |
| Port (HTTP) | [PENDING] (default 1540) |
| Port (TCP) | [PENDING] (default 1541) |
| Status | [PENDING] |

## Конфигурация сервера

### Memory & Threads

| Параметр | Значение |
|----------|----------|
| Max Memory Usage | [PENDING] MB |
| Worker Processes | [PENDING] |
| Max Connections | [PENDING] |

### Logging

| Параметр | Значение |
|----------|----------|
| Log Level | [PENDING] (Debug / Info / Error) |
| Log Path | [PENDING] |
| Log Rotation | [PENDING] (Daily / Size-based) |
| Retention Days | [PENDING] |

### Database Connection

| Параметр | Значение |
|----------|----------|
| MSSQL Server | [PENDING] |
| Port | 1433 |
| Database User | [PENDING] |
| Connection Pool Size | [PENDING] |

## Информационные базы (InfoBases)

| Имя | Описание | БД | Пользователи | Статус |
|-----|---------|----|----|---------|
| [PENDING] | Main Business App | [PENDING] | [PENDING] | [PENDING] |
| [PENDING] | Accounting System | [PENDING] | [PENDING] | [PENDING] |
| [PENDING] | HR Management | [PENDING] | [PENDING] | [PENDING] |

## Пользовательские сеансы

| Параметр | Значение |
|----------|----------|
| Max Session Duration | [PENDING] minutes |
| Idle Timeout | [PENDING] minutes |
| Max Concurrent Sessions | [PENDING] |
| Max Stored Sessions | [PENDING] |

## RAS (Repository Administration Server)

| Параметр | Значение |
|----------|----------|
| RAS Server | [PENDING] |
| RAS Port | [PENDING] (default 1545) |
| Repository Type | File-based / MSSQL | [PENDING] |
| Repository Path | [PENDING] |

[NEEDS_DATA] — требуется информация о серверах приложений и информационных базах
