---
title: "Процедура: Обновления и патчинг"
slug: "runbook-patching-updates"
status: "draft"
last_updated: "2026-04-23T00:00:00Z"
updated_by: "AI-Maintainer"
owner: "@DevOps Team"
tags: [runbook, patching, updates, maintenance, windows-update]
related: ["Доступ/users-roles.md"]
ai_notes: "[NEEDS_DATA] Требуется расписание patching для вашей инфраструктуры"
order: 2
---

# Обновления и патчинг (Patching)

## Стратегия patching

| Тип | Частота | Окно обслуживания | Требуемые перезагрузки |
|-----|---------|-------------------|----------------------|
| Security Patches | [PENDING] | [PENDING] | Да, в плановое время |
| OS Updates | [PENDING] | [PENDING] | Да, в плановое время |
| Application Updates | [PENDING] | [PENDING] | Зависит от приложения |
| MSSQL Updates | [PENDING] | [PENDING] | Может быть без перезагрузки |
| 1C Platform Updates | [PENDING] | [PENDING] | Может быть без перезагрузки |

## Фаза 1: Подготовка

### 1.1 Планирование окна обслуживания

- [ ] Выбрать дату и время (обычно выходной день / ночь)
- [ ] Уведомить пользователей заранее ([PENDING] дней)
- [ ] Создать Change Request
- [ ] Получить одобрение от руководства

### 1.2 Создание backup'а

```powershell
# Перед любыми обновлениями - создать fresh backup
BACKUP DATABASE [database_name] TO DISK = '\\backup_server\pre_patch_backup.bak'
```

- [ ] Создать полный system backup (VM snapshot)
- [ ] Создать database backup
- [ ] Убедиться что backup успешен
- [ ] Сохранить backup в безопасном месте

### 1.3 Тестирование обновлений

- [ ] Если возможно - протестировать на test environment
- [ ] Проверить release notes на breaking changes
- [ ] Проверить known issues
- [ ] Подготовить rollback план

## Фаза 2: Windows Server патчинг

### 2.1 Проверка доступных обновлений

```powershell
# Проверить доступные обновления
Get-WindowsUpdate

# Посмотреть детали update'а перед установкой
Get-WindowsUpdate -Details

# Проверить историю обновлений
Get-HotFix | Sort-Object -Property InstalledOn -Descending
```

### 2.2 Установка обновлений

```powershell
# Установить все доступные обновления
Install-WindowsUpdate -AcceptAll -Install

# Или установить конкретные
# Install-WindowsUpdate -Updates KB5033213

# Дождаться завершения
```

### 2.3 Перезагрузка

```powershell
# Перезагрузиться если требуется
Restart-Computer -Force -Delay 60  # 60 секунд на подготовку
```

## Фаза 3: MSSQL обновления

### 3.1 Проверка версии

```sql
-- Проверить текущую версию
SELECT @@VERSION;

-- Проверить build number
SELECT SERVERPROPERTY('ProductVersion') AS ProductVersion;
```

### 3.2 Обновление MSSQL (Cumulative Update)

- [ ] Скачать CU с Microsoft сайта
- [ ] Остановить зависимые приложения (1C, etc)
- [ ] Запустить installer с правами администратора
- [ ] Выбрать опции обновления (обычно "Update" выбран)
- [ ] Дождаться завершения (может быть 10-30 минут)

```sql
-- После обновления - проверить версию
SELECT @@VERSION;

-- Проверить что БД в порядке
DBCC CHECKDB;
```

### 3.3 Перезагрузка SQL Server (если требуется)

```powershell
# Перезагрузить SQL Server service
Restart-Service -Name "MSSQLSERVER" -Force
```

## Фаза 4: 1C обновления

### 4.1 Обновление 1C Platform

- [ ] Скачать новую версию платформы 8.3 / 8.5
- [ ] Остановить 1C Application Server
- [ ] Запустить 1C installer (или распаковать архив)
- [ ] Выбрать "Update"
- [ ] Дождаться завершения

```powershell
# Остановить сервер
Stop-Service -Name "1C:Enterprise*" -Force

# Запустить installer в фоне
& "C:\1C\setup.exe" /S

# Когда завершится - перезагрузить
Start-Service -Name "1C:Enterprise*"
```

### 4.2 Обновление 1C информационных баз

- [ ] Проверить compatibility каждой БД
- [ ] Запустить обновление (может быть автоматическое)
- [ ] Проверить логи обновления
- [ ] Протестировать функции

## Фаза 5:验証 (Verification)

### 5.1 Проверка функциональности

- [ ] Проверить что все сервисы запущены
- [ ] Проверить базовые функции 1C
- [ ] Проверить доступность мониторинга (Zabbix)
- [ ] Проверить логи на ошибки

```powershell
# Проверить статус сервисов
Get-Service | Where-Object {$_.Name -like "*1C*" -or $_.Name -eq "MSSQLSERVER"} | Select Status, Name

# Проверить Event Viewer на ошибки
Get-EventLog -LogName Application -Newest 100 | Where-Object {$_.Type -eq "Error"}
```

### 5.2 Проверка базы данных

```sql
-- Проверить что БД доступны
SELECT name, state_desc FROM sys.databases;

-- Проверить целостность
DBCC CHECKDB;

-- Проверить размер лога (не должен быть огромным)
DBCC SQLPERF(logspace);
```

### 5.3 Smoke-тесты

- [ ] Запустить критические отчёты
- [ ] Проверить интеграции (если есть)
- [ ] Проверить что бизнес-процессы работают
- [ ] Попросить у пользователей feedback

## Фаза 6: Документирование и завершение

### 6.1 Логирование изменений

- [ ] Обновить версии в [Сервисы/mssql/server-instances.md](../../Сервисы/mssql/server-instances.md)
- [ ] Обновить версии в [Сервисы/1c/platform-versions.md](../../Сервисы/1c/platform-versions.md)
- [ ] Записать дату патчинга в .kb_logs/changes.log
- [ ] Закрыть Change Request

### 6.2 Уведомление

- [ ] Отправить уведомление пользователям что обновления завершены
- [ ] Поблагодарить команду
- [ ] Обновить документацию если требуется

## Rollback процедура

Если обновление вызвало проблемы:

### Быстрый rollback (VM snapshot)

```powershell
# Если была VM - вернуться к snapshot перед patching
# Это самый быстрый способ

# В Hyper-V:
Restore-VMSnapshot -VMName "ServerName" -Name "pre_patch" -Confirm:$false

# Машина вернётся к состоянию до обновлений
```

### Ручной rollback (если VM нет)

- [ ] Остановить сервисы
- [ ] Восстановить из backup
- [ ] Перезагрузиться
- [ ] Протестировать функции
- [ ] Создать incident ticket

## Maintenance окно

| День | Время | Ответственный | Статус |
|------|-------|---------------|--------|
| [PENDING] | [PENDING] | [PENDING] | [PENDING] |

[NEEDS_DATA] — требуется расписание patching и maintenance окна
