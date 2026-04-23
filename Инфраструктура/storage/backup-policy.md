---
title: "Политика резервного копирования"
slug: "backup-policy"
status: "draft"
last_updated: "2026-04-23T00:00:00Z"
updated_by: "AI-Maintainer"
owner: "@DBA Team"
tags: [backup, disaster-recovery, rto-rpo]
related: ["Инфраструктура/storage/disaster-recovery.md"]
ai_notes: "[NEEDS_DATA] Требуется информация о backup-ах и расписании"
order: 1
---

# Политика резервного копирования

## Стратегия резервного копирования

| Компонент | Тип Backup | Расписание | Место хранения | Удержание | Статус |
|-----------|-----------|-----------|-----------------|-----------|--------|
| MSSQL Databases | Full | [PENDING] | [PENDING] | [PENDING] | [PENDING] |
| MSSQL Databases | Incremental | [PENDING] | [PENDING] | [PENDING] | [PENDING] |
| MSSQL Databases | Transaction Log | [PENDING] | [PENDING] | [PENDING] | [PENDING] |
| 1C Application Data | File-level | [PENDING] | [PENDING] | [PENDING] | [PENDING] |
| System Configuration | Full | [PENDING] | [PENDING] | [PENDING] | [PENDING] |

## RTO / RPO Требования

| Сервис | RTO (Recovery Time) | RPO (Recovery Point) | Приоритет |
|--------|------------------|-------------------|-----------|
| MSSQL Production | [PENDING] | [PENDING] | Critical |
| 1C Enterprise | [PENDING] | [PENDING] | High |
| Configuration | [PENDING] | [PENDING] | Medium |

## Backup Инструменты

| Инструмент | Назначение | Версия | Статус |
|-----------|-----------|--------|--------|
| Veeam Backup & Replication | [PENDING] | [PENDING] | [PENDING] |
| MSSQL Agent | [PENDING] | [PENDING] | [PENDING] |
| Windows Backup | [PENDING] | [PENDING] | [PENDING] |

## Места хранения

| Название | Тип | Размер | Доступ | Статус |
|----------|-----|--------|--------|--------|
| Local NAS | NAS | [PENDING] TB | SMB 445 | [PENDING] |
| Cloud Storage | S3/Azure | [PENDING] TB | Encrypted | [PENDING] |
| Offsite Tape | Tape Archive | [PENDING] TB | Physical | [PENDING] |

## Процедура проверки (Backup Verification)

- **Частота:** [PENDING] (еженедельно / ежемесячно)
- **Метод:** [PENDING] (test restore / integrity check)
- **Ответственный:** [PENDING]

## Восстановление (Restore Procedure)

1. [PENDING] Идентификация точки восстановления
2. [PENDING] Подготовка целевого хранилища
3. [PENDING] Запуск процесса восстановления
4. [PENDING] Верификация данных
5. [PENDING] Переключение на восстановленную систему

[NEEDS_DATA] — требуется информация о backup расписании и хранилищах
