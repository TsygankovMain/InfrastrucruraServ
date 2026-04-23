---
title: "Процедура: Аварийное восстановление (Disaster Recovery)"
slug: "runbook-disaster-recovery"
status: "draft"
last_updated: "2026-04-23T00:00:00Z"
updated_by: "AI-Maintainer"
owner: "@DBA Team"
tags: [runbook, disaster-recovery, backup, restore, rto-rpo]
related: ["Инфраструктура/storage/backup-policy.md", "Инфраструктура/storage/san-config.md"]
ai_notes: "[NEEDS_VERIFICATION] DR процедура требует уточнения RTO/RPO требований"
order: 4
---

# Аварийное восстановление (Disaster Recovery)

## Классификация сценариев

| Сценарий | Серьёзность | RTO | RPO | Процедура |
|----------|------------|-----|-----|-----------|
| Потеря файла / Случайное удаление | Low | [PENDING] | [PENDING] | File-level restore |
| Повреждение БД | Medium | [PENDING] | [PENDING] | DB restore from backup |
| Отказ одного сервера | High | [PENDING] | [PENDING] | Server rebuild + data restore |
| Потеря всего datacenter | Critical | [PENDING] | [PENDING] | Full site failover |

## Предусловия

- ✅ Резервные копии актуальны (последний backup менее [PENDING] часов назад)
- ✅ Резервные копии хранятся в безопасном месте
- ✅ Процедура восстановления протестирована [PENDING] (ежемесячно / квартально)
- ✅ Команда обучена процедуре

## Фаза 1: Оценка ситуации

### 1.1 Определить масштаб проблемы

- [ ] Определить какие сервисы недоступны
- [ ] Определить причину сбоя (hardware / software / network)
- [ ] Определить, повреждены ли данные
- [ ] Определить точку восстановления (когда последний good backup)

### 1.2 Активировать DR план

- [ ] Проинформировать руководство
- [ ] Созвать team на экстренное совещание
- [ ] Активировать план восстановления
- [ ] Назначить координатора восстановления
- [ ] Начать логирование действий

## Фаза 2: Восстановление MSSQL БД

### 2.1 Оценка повреждения

```sql
-- Проверить целостность БД
DBCC CHECKDB (database_name, REPAIR_REBUILD);

-- Если REPAIR_REBUILD не помогает, переходим к restore
```

### 2.2 Восстановление из Full Backup

```sql
-- Прерыва все подключения
USE master;
ALTER DATABASE [database_name] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;

-- Восстановить БД из backup
RESTORE DATABASE [database_name] FROM DISK = '\\backup_server\backup\database_name.bak'
WITH REPLACE, NORECOVERY;

-- Восстановить transaction logs (если есть)
RESTORE LOG [database_name] FROM DISK = '\\backup_server\backup\database_name.trn'
WITH RECOVERY;

-- Вернуть в multi-user режим
ALTER DATABASE [database_name] SET MULTI_USER;

-- Проверить доступность
SELECT * FROM sys.databases WHERE name = 'database_name';
```

### 2.3 Синхронизация данных

- [ ] Проверить консистентность данных
- [ ] Проверить все таблицы (SELECT COUNT для key tables)
- [ ] Проверить последние transactions
- [ ] Сравнить checksum с production snapshot (если есть)

### 2.4 Проверить связность с 1C

- [ ] Перезагрузить 1C Application Server
- [ ] Проверить подключение к MSSQL
- [ ] Проверить логирование в журнале событий 1C
- [ ] Протестировать основные функции 1C

## Фаза 3: Восстановление 1C Enterprise

### 3.1 Восстановление информационной базы

```powershell
# Остановить 1C Application Server
Stop-Service "1C:Enterprise*"

# Восстановить файлы БД из backup
# (если file-based storage)
Copy-Item "\\backup_server\1c_backup\*" -Destination "C:\1C\InfoBase\" -Recurse -Force

# Или восстановить MSSQL БД (см. выше)

# Перезагрузить 1C Application Server
Start-Service "1C:Enterprise*"
```

### 3.2 Проверить 1C функции

- [ ] Подключиться через 1C Client (Desktop)
- [ ] Подключиться через 1C Web Client
- [ ] Проверить ключевые бизнес-процессы
- [ ] Проверить отчёты
- [ ] Проверить справочники и документы

## Фаза 4: Восстановление системного сервера

### 4.1 Если нужна полная переустановка

- [ ] Следовать процедуре [Развёртывание нового сервера](deploy-new-server.md)
- [ ] Восстановить конфигурацию из [Инфраструктура/servers/](../../Инфраструктура/servers/)
- [ ] Восстановить backup'ы (см. выше)

### 4.2 Если нужна замена диска

```powershell
# Отключить сервер
Stop-Computer -Force

# Заменить диск в hardware
# Загрузиться с USB восстановления / Виртуального диска

# Восстановить OS из backup (если есть full image backup)
# или переустановить OS + приложения
```

## Фаза 5: Постоянное восстановление

### 5.1 Проверка функциональности

- [ ] Запустить smoke-тесты
- [ ] Проверить все critical функции
- [ ] Проверить интеграции (если есть)
- [ ] Проверить мониторинг (alerts, logs)

### 5.2 Возвращение к норме

- [ ] Перевести systems на normal режим
- [ ] Убедиться, что backup'ы возобновились
- [ ] Документировать что произошло
- [ ] Провести postmortem встречу

### 5.3 Предотвращение в будущем

- [ ] Определить root cause сбоя
- [ ] Внедрить улучшения
- [ ] Обновить процедуры
- [ ] Провести training для team

## Контакты для экстренной помощи

| Роль | Контакт | Телефон | Email |
|------|---------|---------|-------|
| DBA Lead | [PENDING] | [PENDING] | [PENDING] |
| DevOps Lead | [PENDING] | [PENDING] | [PENDING] |
| 1C Administrator | [PENDING] | [PENDING] | [PENDING] |
| Infrastructure Manager | [PENDING] | [PENDING] | [PENDING] |

## Тестирование DR

- **Последний тест:** [PENDING]
- **Следующий тест запланирован:** [PENDING]
- **Результаты:** [PENDING]

[NEEDS_VERIFICATION] — DR план требует уточнения для вашей инфраструктуры
