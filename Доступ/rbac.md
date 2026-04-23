---
title: "RBAC политика (Role-Based Access Control)"
slug: "rbac-policy"
status: "draft"
last_updated: "2026-04-23T00:00:00Z"
updated_by: "AI-Maintainer"
owner: "@Security Team"
tags: [rbac, security, access-control, policy]
related: ["Доступ/permissions-matrix.md", "Доступ/users-roles.md"]
ai_notes: "[NEEDS_DEFINITION] Требуется уточнить RBAC модель для организации"
---

# RBAC политика

## Ролевая модель

### Компоненты RBAC

```
User → Role(s) → Permission(s) → Resource(s)
```

### Определённые роли

#### 1. Administrator (Admin)
- **Описание:** Полный доступ ко всем ресурсам
- **Ресурсы:** Все серверы, все сервисы, все операции
- **Ограничения:** Действия логируются

#### 2. Infrastructure Engineer (Infra)
- **Описание:** Управление инфраструктурой и развёртыванием
- **Ресурсы:** Серверы, сетевые конфиги, хранилища
- **Ограничения:** Без доступа к данным приложений

#### 3. Database Administrator (DBA)
- **Описание:** Полное управление MSSQL
- **Ресурсы:** MSSQL инстансы, базы данных, backup/restore
- **Ограничения:** Без физического доступа к серверам

#### 4. Application Operator (AppOps)
- **Описание:** Оперативное управление 1C Enterprise
- **Ресурсы:** 1C серверы, запуск/остановка, мониторинг
- **Ограничения:** Без изменения конфиги, без доступа к MSSQL

#### 5. Viewer (Read-Only)
- **Описание:** Только просмотр состояния
- **Ресурсы:** Все, но только Read-Only
- **Ограничения:** Без изменений, без доступа к чувствительным данным

## Принципы разграничения

1. **Principle of Least Privilege** — минимум необходимых разрешений
2. **Separation of Duties** — разделение обязанностей
3. **Need to Know** — доступ только к необходимому
4. **Audit Trail** — все действия логируются

[NEEDS_VERIFICATION] — политика требует согласования с Security Team
