---
title: "Матрица разрешений по ролям и сервисам"
slug: "permissions-matrix"
status: "draft"
last_updated: "2026-04-23T00:00:00Z"
updated_by: "AI-Maintainer"
owner: "@Security Team"
tags: [permissions, matrix, rbac, access-control]
related: ["Доступ/rbac.md", "Доступ/users-roles.md"]
ai_notes: "[NEEDS_VERIFICATION] Матрица требует уточнения текущих разрешений"
order: 3
---

# Матрица разрешений

Таблица разрешений по ролям и ресурсам.

## Легенда

- ✅ = Полный доступ (Read + Write + Execute)
- 📖 = Только чтение (Read-Only)
- 🔒 = Нет доступа
- 🔑 = Доступ с подтверждением (MFA / Approval)

## Матрица доступа

| Ресурс | Admin | DBA | Infra | AppOps | Viewer | Service Account |
|--------|-------|-----|-------|--------|--------|-----------------|
| **MSSQL Servers** | ✅ | ✅ | 📖 | 🔒 | 📖 | 🔑 (Limited) |
| **MSSQL Databases** | ✅ | ✅ | 🔒 | 🔒 | 📖 | 🔑 (Limited) |
| **1C Enterprise** | ✅ | 🔒 | 📖 | ✅ | 📖 | 🔑 (Limited) |
| **1C Databases** | ✅ | 📖 | 🔒 | 📖 | 📖 | 🔒 |
| **Network Config** | ✅ | 🔒 | ✅ | 🔒 | 🔒 | 🔒 |
| **Servers (Physical)** | ✅ | 🔒 | ✅ | 🔒 | 🔒 | 🔒 |
| **Backup/Restore** | ✅ | ✅ | 📖 | 📖 | 🔒 | 🔑 (Limited) |
| **Monitoring (Zabbix)** | ✅ | 📖 | 📖 | 📖 | 📖 | 📖 |
| **Audit Logs** | ✅ | 📖 | 📖 | 🔒 | 🔒 | 🔒 |
| **User Management** | ✅ | 🔒 | 🔒 | 🔒 | 🔒 | 🔒 |

## Примечания

- Все доступы через VPN + MFA (где требуется)
- SSH Key-based auth для серверов (нет паролей)
- RDP с двухфакторной аутентификацией
- Все действия логируются и подлежат аудиту

[NEEDS_VERIFICATION] — требуется актуальная информация о разрешениях
