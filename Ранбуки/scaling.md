---
title: "Процедура: Масштабирование и добавление ресурсов"
slug: "runbook-scaling"
status: "draft"
last_updated: "2026-04-23T00:00:00Z"
updated_by: "AI-Maintainer"
owner: "@Infrastructure Team"
tags: [runbook, scaling, capacity-planning, performance]
related: ["Инфраструктура/servers/template-server.md"]
ai_notes: "[NEEDS_DATA] Требуется определить пороги масштабирования (CPU, RAM, Disk %)"
---

# Масштабирование и добавление ресурсов

## Мониторинг производительности

### Пороги для escalation

| Ресурс | Жёлтый уровень | Красный уровень | Действие |
|--------|----------------|-----------------|---------|
| CPU Utilization | [PENDING] % | [PENDING] % | Добавить CPU cores / Оптимизировать queries |
| RAM Utilization | [PENDING] % | [PENDING] % | Добавить RAM / Оптимизировать памяти |
| Disk Space | [PENDING] % | [PENDING] % | Добавить диск / Очистить старые данные |
| Database Size | [PENDING] GB | [PENDING] GB | Архивировать данные / Добавить хранилище |
| Connection Pool | [PENDING] % | [PENDING] % | Увеличить pool size / Добавить сервер |

### Мониторинг в Zabbix

- [ ] Проверить dashboard в Zabbix для текущих метрик
- [ ] Определить тренд использования ресурсов
- [ ] Спланировать масштабирование на [PENDING] дней / месяцев вперёд

## Фаза 1: Планирование масштабирования

### 1.1 Анализ текущей нагрузки

```sql
-- MSSQL: Проверить размер БД
SELECT 
    DB_NAME(database_id) AS DatabaseName,
    CAST(SUM(size) * 8.0 / 1024 / 1024 AS DECIMAL(10, 2)) AS SizeGB
FROM sys.master_files
GROUP BY database_id;

-- MSSQL: Проверить нагрузку на CPU
SELECT 
    object_name,
    counter_name,
    cntr_value
FROM sys.dm_os_performance_counters
WHERE object_name LIKE '%Processor%';

-- MSSQL: Проверить активные соединения
SELECT COUNT(*) FROM sys.dm_exec_sessions;
```

```powershell
# Windows: Проверить использование памяти
Get-Counter -Counter "\Memory\Available MBytes"

# Windows: Проверить использование CPU
Get-Counter -Counter "\Processor(_Total)\% Processor Time" -SampleInterval 1 -MaxSamples 10

# Windows: Проверить использование диска
Get-Volume | Select DriveLetter, Size, SizeRemaining
```

### 1.2 Определить потребности

- [ ] Определить требуемый рост ресурсов (10% / 50% / 100%)
- [ ] Определить timeline (срочно / в течение месяца)
- [ ] Получить одобрение бюджета
- [ ] Создать Change Request

## Фаза 2: Добавление CPU/RAM (для VM)

### 2.1 Добавить CPU cores

```powershell
# Hyper-V: Добавить CPU cores
Set-VMProcessor -VMName "ServerName" -Count 8  # Увеличить до 8 cores

# После добавления - можно без перезагрузки
```

### 2.2 Добавить RAM

```powershell
# Hyper-V: Добавить памяти
Set-VMMemory -VMName "ServerName" -StartupBytes 128GB -MaximumBytes 256GB

# Может потребоваться перезагрузка для полного эффекта
Restart-Computer -ComputerName "ServerName" -Force
```

### 2.3 Проверить добавление ресурсов

```powershell
# На самом сервере - проверить что видит ОС
Get-ComputerInfo | Select SystemProcessorCount, @{Name="TotalPhysicalMemory(GB)"; Expression={$_.OsPhysicalMemorySize/1GB}}
```

## Фаза 3: Добавление хранилища (Disk)

### 3.1 Для MSSQL Data files

- [ ] Выделить новый диск / LUN на SAN
- [ ] Подключить диск к серверу (может потребоваться перезагрузка)
- [ ] Инициализировать диск и создать partition
- [ ] Отформатировать в NTFS

```powershell
# Инициализировать новый диск
Get-Disk | Where-Object {$_.PartitionStyle -eq 'RAW'} | Initialize-Disk -PartitionStyle MBR -PassThru

# Создать partition и volume
New-Partition -DiskNumber 1 -UseMaximumSize -AssignDriveLetter |
Format-Volume -FileSystem NTFS -NewFileSystemLabel "SQLData"
```

### 3.2 Переместить MSSQL data files

```sql
-- Добавить новый filegroup
ALTER DATABASE [database_name] ADD FILEGROUP [NewFileGroup];

-- Добавить новый файл на новый диск
ALTER DATABASE [database_name] 
ADD FILE (NAME = [NewDataFile], FILENAME = 'E:\SQLData\newfile.mdf', SIZE = 100MB)
TO FILEGROUP [NewFileGroup];

-- Распределять новые данные на новый filegroup (если требуется)
-- CREATE TABLE new_table (...) ON [NewFileGroup];
```

### 3.3 Для хранилища backup'ов

- [ ] Выделить новое хранилище (NAS / облако)
- [ ] Подключить как network drive
- [ ] Обновить backup jobs на новое хранилище
- [ ] Запустить пробный backup

## Фаза 4: Масштабирование приложений

### 4.1 Добавление 1C Application Server (если используется кластер)

- [ ] Развернуть новый сервер (см. [deploy-new-server.md](deploy-new-server.md))
- [ ] Установить 1C Enterprise Server
- [ ] Добавить в RAS кластер
- [ ] Настроить load balancer (если есть)
- [ ] Протестировать распределение сеансов

```powershell
# Добавить новый сервер в кластер через RAS
# Обычно через GUI интерфейса 1C Enterprise

# Проверить что сервер видит БД
# и может запускать приложения
```

### 4.2 Добавление MSSQL Replica (для HA)

```sql
-- Создать второй сервер как replica
-- Процедура зависит от стратегии (Always On / Mirroring / Replication)

-- Пример для Always On:
-- 1. Создать backup на primary
-- 2. Восстановить на secondary (NORECOVERY)
-- 3. Создать endpoint'ы
-- 4. Создать availability group
```

## Фаза 5: Проверка и оптимизация

### 5.1 После масштабирования

- [ ] Проверить что новые ресурсы видны в ОС
- [ ] Проверить что сервисы используют новые ресурсы
- [ ] Проверить performance улучшился ли
- [ ] Обновить документацию о ресурсах

### 5.2 Мониторинг после изменений

- [ ] Проверить Zabbix метрики на новые значения
- [ ] Проверить application performance
- [ ] Проверить backup'ы работают ли
- [ ] Провести smoke-тесты

## Capacity Planning

| Дата | Текущие ресурсы | Прогноз нагрузки | Рекомендация | Статус |
|------|----------------|-----------------|--------------|--------|
| 2026-04-23 | CPU: [PENDING], RAM: [PENDING], Disk: [PENDING] | [PENDING] | [PENDING] | [PENDING] |
| 2026-07-23 | [PENDING] | [PENDING] | [PENDING] | [PENDING] |

[NEEDS_DATA] — требуется baseline метрик и пороги масштабирования
