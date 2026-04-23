---
title: "Процедура: Развёртывание нового сервера"
slug: "runbook-deploy-server"
status: "draft"
last_updated: "2026-04-23T00:00:00Z"
updated_by: "AI-Maintainer"
owner: "@DevOps Team"
tags: [runbook, deployment, server-setup, provisioning]
related: ["Инфраструктура/servers/template-server.md", "Доступ/users-roles.md"]
ai_notes: "[NEEDS_VERIFICATION] Процедура требует проверки для вашей инфраструктуры"
---

# Развёртывание нового сервера

## Предусловия

- ✅ Одобрение от руководства (Change Request)
- ✅ IP адрес выделен и зарегистрирован в DNS
- ✅ Доступ к гиперvisор / физическому хостинг-центру
- ✅ Образ ОС готов (ISO / Template VM)
- ✅ Планы резервного копирования определены

## Фаза 1: Подготовка

### 1.1 Сбор требований

- [ ] Определить назначение сервера (1C, MSSQL, Monitoring и т.д.)
- [ ] Определить требуемые ресурсы (CPU, RAM, Storage)
- [ ] Выбрать ОС (Windows Server 2022 / 2025)
- [ ] Определить VLAN (Production / Management / Backup)
- [ ] Составить документацию на сервер (см. шаблон)

### 1.2 Подготовка инфраструктуры

- [ ] Выделить IP адрес из пула VLAN
- [ ] Зарегистрировать в DNS (Forward + Reverse)
- [ ] Создать запись в IP allocation файле: [Инфраструктура/network/ip-allocation.md](../../Инфраструктура/network/ip-allocation.md)
- [ ] Добавить firewall правила (см. шаблон)
- [ ] Настроить резервное копирование (RTO/RPO)

## Фаза 2: Установка ОС

### 2.1 Развёртывание VM / Физический сервер

**Для Virtualized:**
- [ ] Клонировать шаблон VM из образа
- [ ] Настроить сетевые интерфейсы (IP, Gateway, DNS)
- [ ] Подключить диски нужного объёма
- [ ] Включить VM

**Для Physical:**
- [ ] Подключить к сетевому оборудованию
- [ ] Установить BIOS параметры
- [ ] Загрузиться с ISO / PXE
- [ ] Следовать мастеру установки Windows Server

### 2.2 Базовая конфигурация ОС

```powershell
# Установить имя компьютера
Rename-Computer -NewName "HOSTNAME" -Restart

# Настроить IP адрес (если не DHCP)
New-NetIPAddress -IPAddress 192.168.x.x -PrefixLength 24 -DefaultGateway 192.168.x.1

# Добавить DNS
Set-DnsClientServerAddress -InterfaceAlias Ethernet -ServerAddresses 8.8.8.8, 8.8.4.4

# Включить Windows Updates
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name NoAutoUpdate -Value 0

# Выполнить обновления
Install-WindowsUpdate -AcceptAll -Install
```

### 2.3 Базовая безопасность

- [ ] Отключить RDP на стандартном порту 3389 (изменить на другой)
- [ ] Включить Windows Firewall
- [ ] Установить antivirus (если требуется)
- [ ] Включить Windows Defender (минимум)
- [ ] Установить последние патчи

## Фаза 3: Установка сервисов

### 3.1 Для сервера 1C Enterprise

```powershell
# Установить .NET Framework 4.8+
# Установить Visual C++ Redistributable
# Скачать и установить 1C Enterprise Server

# Установить ODBC драйверы для MSSQL
# Настроить подключение к MSSQL серверу
```

- [ ] Установить 1C Enterprise Server (версия [PENDING])
- [ ] Настроить подключение к MSSQL БД
- [ ] Создать информационные базы
- [ ] Установить лицензии
- [ ] Протестировать подключение клиентов

### 3.2 Для MSSQL сервера

```powershell
# Установить SQL Server 2022 (или требуемую версию)
# Выбрать параметры:
# - Instance Name: MSSQLSERVER
# - Authentication: Mixed Mode
# - Service Accounts: Domain User
# - Data directories: отдельные диски

# Установить Management Studio
# Установить SQL Server Agent
```

- [ ] Установить MSSQL (версия [PENDING])
- [ ] Настроить экземпляр
- [ ] Создать БД (или восстановить из backup)
- [ ] Настроить backup jobs
- [ ] Протестировать подключение

### 3.3 Для сервера мониторинга

- [ ] Установить Zabbix Agent
- [ ] Настроить подключение к Zabbix Server
- [ ] Добавить хост в Zabbix UI
- [ ] Проверить метрики

## Фаза 4: Постустановка

### 4.1 Проверка и тестирование

- [ ] Проверить сетевую связность (ping, tracert)
- [ ] Проверить разрешение DNS
- [ ] Проверить доступ к сервисам
- [ ] Проверить логирование (Event Viewer / Application logs)
- [ ] Запустить первый backup
- [ ] Проверить восстановление из backup

### 4.2 Документирование

- [ ] Создать/обновить документацию на сервер
- [ ] Указать IP, DNS, VLAN, назначение
- [ ] Добавить в [Инфраструктура/servers/](../../Инфраструктура/servers/)
- [ ] Обновить диаграмму архитектуры
- [ ] Добавить в monitoring dashboard

### 4.3 Передача в production

- [ ] Согласовать с team leads
- [ ] Обновить README и навигацию
- [ ] Провести handoff-встречу
- [ ] Установить monitoring alerts
- [ ] Начать регулярный backup

## Troubleshooting

### Сервер не загружается
- Проверить BIOS/firmware
- Проверить параметры загрузки
- Проверить хранилище (диск не повреждён)

### Нет сетевой связности
- Проверить физическое подключение кабеля
- Проверить конфиг IP адреса
- Проверить маршруты (route print)
- Проверить firewall правила

### Сервис не запускается
- Проверить логи ошибок (Event Viewer)
- Проверить service account привилегии
- Проверить зависимости (другие сервисы)
- Запустить диагностику

[NEEDS_VERIFICATION] — процедура требует проверки для вашей инфраструктуры
