---
title: "Пользователи и роли в инфраструктуре"
slug: "users-roles"
status: "draft"
last_updated: "2026-04-23T00:00:00Z"
updated_by: "AI-Maintainer"
owner: "@DevOps Team"
tags: [users, roles, authentication, ad]
related: ["Доступ/rbac.md", "Доступ/permissions-matrix.md"]
ai_notes: "[NEEDS_DATA] Требуется заполнить данные о пользователях и их ролях. Ожидание уточнения от администратора."
---

# Пользователи и роли

## Active Directory (AD) интеграция

| Параметр | Значение |
|----------|----------|
| AD Domain | PVD-1C |
| LDAP Server | [PENDING] |
| Sync Schedule | [PENDING] |

## Основные группы пользователей

### 🔴 Administrators
- **Описание:** Полный доступ ко всей инфраструктуре
- **Члены:** [NEEDS_DATA]
- **Ответственный:** [PENDING]

### 🟠 DevOps Team
- **Описание:** Управление серверами, сервисами, резервные копии
- **Члены:** [NEEDS_DATA]
- **Ответственный:** [PENDING]

### 🟡 1C Operators
- **Описание:** Оперативное управление 1C Enterprise (запуск, остановка, мониторинг)
- **Члены:** [NEEDS_DATA]
- **Ответственный:** [PENDING]

### 🟢 DBAs (Database Administrators)
- **Описание:** Управление MSSQL серверами, базами данных, резервными копиями
- **Члены:** [NEEDS_DATA]
- **Ответственный:** [PENDING]

### 🔵 Monitoring & Support
- **Описание:** Мониторинг систем, доступ к логам и метрикам
- **Члены:** [NEEDS_DATA]
- **Ответственный:** [PENDING]

## Процесс onboarding

1. Создание учётной записи в AD
2. Добавление в соответствующую группу
3. Предоставление доступа на серверы (SSH keys / RDP)
4. Инструктаж по политикам безопасности
5. Логирование в audit logs

[NEEDS_VERIFICATION] — данные требуют проверки и уточнения
