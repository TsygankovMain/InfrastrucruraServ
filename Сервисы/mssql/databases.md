---
title: "MSSQL базы данных"
slug: "mssql-databases"
status: "draft"
last_updated: "2026-04-23T00:00:00Z"
updated_by: "AI-Maintainer"
owner: "@DBA Team"
tags: [mssql, databases, data]
related: ["Сервисы/mssql/server-instances.md", "Сервисы/mssql/ha-replication.md"]
ai_notes: "[NEEDS_DATA] Требуется список баз данных и их назначение"
order: 2
---

# MSSQL базы данных

## Основные БД 1C Enterprise

| Имя БД | Назначение | Размер | Владелец | Статус |
|--------|-----------|--------|----------|--------|
| [PENDING] | 1C Business Data | [PENDING] | [PENDING] | [PENDING] |
| [PENDING] | 1C Config | [PENDING] | [PENDING] | [PENDING] |
| [PENDING] | 1C Accounting | [PENDING] | [PENDING] | [PENDING] |

## Системные БД

| Имя БД | Назначение | Размер |
|--------|-----------|--------|
| master | System DB | [PENDING] |
| model | Template DB | [PENDING] |
| msdb | SQL Agent Jobs | [PENDING] |
| tempdb | Temporary Objects | [PENDING] |

## Параметры БД

### [PENDING] — 1C Main DB

| Параметр | Значение |
|----------|----------|
| Owner | [PENDING] |
| Compatibility Level | [PENDING] (SQL 2016/2019/2022) |
| Recovery Model | [PENDING] (Full / Simple / Bulk-Logged) |
| Collation | [PENDING] |
| Status | [PENDING] (Online/Suspect) |

### Файлы БД

| Файл | Путь | Размер | Тип |
|------|------|--------|-----|
| [PENDING].mdf | [PENDING] | [PENDING] | Data |
| [PENDING].ldf | [PENDING] | [PENDING] | Log |
| [PENDING].ndf | [PENDING] | [PENDING] | Data (Secondary) |

## Индексы и Fragmentation

| БД | Индексы | Фрагментация | Maintenance | Статус |
|----|---------|-------------|------------|--------|
| [PENDING] | [PENDING] | [PENDING] % | [PENDING] | [PENDING] |

## Backup Schedule

| БД | Full Backup | Differential | Log Backup | Статус |
|----|-------------|--------------|-----------|--------|
| [PENDING] | [PENDING] | [PENDING] | [PENDING] | [PENDING] |

## Database Users

| БД | Логин | Роль | Статус |
|----|-------|------|--------|
| [PENDING] | sa | db_owner | [PENDING] |
| [PENDING] | [PENDING] | [PENDING] | [PENDING] |

[NEEDS_DATA] — требуется список всех БД и их конфигурация
