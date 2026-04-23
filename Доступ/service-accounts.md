---
title: "Сервис-акаунты для автоматизации"
slug: "service-accounts"
status: "draft"
last_updated: "2026-04-23T00:00:00Z"
updated_by: "AI-Maintainer"
owner: "@DevOps Team"
tags: [service-accounts, automation, security]
related: ["Доступ/rbac.md", "Доступ/users-roles.md"]
ai_notes: "[NEEDS_DATA] Требуется список сервис-акаунтов и их назначение"
order: 4
---

# Сервис-акаунты

Автоматизированные учётные записи для приложений и скриптов.

## Таблица сервис-акаунтов

| Название | Назначение | Сервис | Привилегии | Статус |
|----------|-----------|--------|-----------|--------|
| `svc_1c_backup` | Резервное копирование 1C | 1C Enterprise | Read-Only (базы 1C) | [PENDING] |
| `svc_mssql_backup` | Резервное копирование MSSQL | MSSQL | Backup Operator | [PENDING] |
| `svc_zabbix_monitor` | Мониторинг систем | Zabbix | Read-Only (metrics) | [PENDING] |
| `svc_sync_ad` | Синхронизация Active Directory | AD Sync | Limited (user sync) | [PENDING] |

## Управление паролями

- **Хранилище:** [PENDING] (Password Manager / Vault)
- **Ротация паролей:** [PENDING] (ежемесячно / квартально)
- **Audit логирование:** Все действия логируются в MSSQL audit logs

## Best Practices

- Минимум привилегий (Principle of Least Privilege)
- Отсутствие доступа к консолям/RDP
- API-only или restricted shell
- Регулярная ревизия и удаление неиспользуемых акаунтов

[NEEDS_DATA] — требуется полный список сервис-акаунтов вашей инфраструктуры
