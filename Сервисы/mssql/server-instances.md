---
title: "Инстансы и конфигурация MSSQL"
slug: "mssql-instances"
status: "draft"
last_updated: "2026-04-23T00:00:00Z"
updated_by: "AI-Maintainer"
owner: "@DBA Team"
tags: [mssql, instances, configuration, sql-server]
related: ["Сервисы/mssql/databases.md", "Инфраструктура/servers/win-dckio4rlmnm.md"]
ai_notes: "[NEEDS_DATA] Требуется информация об инстансах MSSQL (версии, параметры)"
order: 1
---

# Инстансы и конфигурация MSSQL

## Инстансы на сервере

| Имя | Версия | Порт | Состояние | Описание | Статус |
|-----|--------|------|----------|---------|--------|
| MSSQLSERVER (Default) | [PENDING] | 1433 | [PENDING] | Primary instance | [PENDING] |
| [PENDING] | [PENDING] | [PENDING] | [PENDING] | [PENDING] | [PENDING] |

## Сервер хоста

| Параметр | Значение |
|----------|----------|
| Hostname | win-dckio4rlmnm |
| ОС | Windows Server 2022 / 2025 |
| IP | [PENDING] |
| CPU | [PENDING] cores |
| RAM | [PENDING] GB |

## MSSQL Configuration

### Memory

| Параметр | Значение | Статус |
|----------|----------|--------|
| Min Server Memory | [PENDING] MB | [PENDING] |
| Max Server Memory | [PENDING] MB | [PENDING] |
| Target Memory | [PENDING] MB | [PENDING] |

### Tempdb

| Параметр | Значение |
|----------|----------|
| Данные файлы | [PENDING] |
| Log файлы | [PENDING] |
| File Growth | [PENDING] |

### Networking

| Параметр | Значение |
|----------|----------|
| Named Pipes | [PENDING] (Enabled/Disabled) |
| TCP/IP | Enabled (Port 1433) |
| Shared Memory | [PENDING] |

### Database Mail

| Параметр | Значение |
|----------|----------|
| SMTP Server | [PENDING] |
| From Address | [PENDING] |
| Статус | [PENDING] |

## Service Accounts

| Сервис | Акаунт | Привилегии | Статус |
|--------|--------|-----------|--------|
| SQL Server Engine | [PENDING] | Local System / Domain User | [PENDING] |
| SQL Server Agent | [PENDING] | Local System / Domain User | [PENDING] |

## Версия и патчи

| Параметр | Значение |
|----------|----------|
| SQL Server Version | [PENDING] (2019, 2022, etc) |
| Build Number | [PENDING] |
| Service Pack | [PENDING] |
| Last Patch Date | [PENDING] |

[NEEDS_DATA] — требуется информация об инстансах и их конфигурации
