# 🤖 Автоматический сбор конфигурации для Knowledge Base

Эти скрипты позволяют **автоматически собирать информацию** из 1C и SQL Server для пополнения базы знаний.

---

## 📋 Доступные скрипты

### 1. **collect-1c-config.ps1** — 1C Enterprise конфигурация
**Что собирает:**
- Установленные версии платформ (8.3, 8.5)
- Версия файла исполняемого модуля
- Статус сервисов 1C
- Метрики процесса 1cv8.exe (память, CPU)
- Сетевые порты (RAS, кластер)
- Информацию о кластере (если настроен)
- Подключения к БД (из реестра)

**Где запускать:** На сервере **PVD-1C** (192.168.87.242)

**Результат:** JSON файл с полной конфигурацией

---

### 2. **collect-mssql-config.ps1** — MSSQL Server конфигурация
**Что собирает:**
- Версию SQL Server и издание
- Список всех БД с размерами
- Статус резервных копий
- Конфигурационные параметры
- Список логинов (только имена)
- Активные подключения
- Фрагментацию индексов
- Использование памяти

**Где запускать:** На сервере **PVD-SQL** (192.168.87.243)

**Результат:** JSON файл с полной конфигурацией SQL

---

### 3. **collect-1c-databases-sql.sql** — SQL запросы для 1C БД
**Что собирает:**
- Список всех БД 1C (размеры, дата создания)
- Размер данных и логов
- История резервных копий
- Текущие подключения
- Конфигурация БД (Recovery Model, совместимость)
- Фрагментацию индексов
- Блокировки и ожидания

**Где запускать:** На сервере **PVD-SQL** через SQL Server Management Studio или sqlcmd

**Результат:** Табличные данные для экспорта в JSON

---

## 🚀 Как использовать

### Вариант 1: Ручной сбор (один раз)

#### Шаг 1: Собрать конфигурацию 1C

На сервере **PVD-1C** запустите PowerShell (от администратора):

```powershell
# Перейти в папку со скриптами
cd "C:\Path\To\Scripts"

# Запустить скрипт сбора
.\collect-1c-config.ps1 -OutputPath "C:\Zabbix\1c-config.json"

# Результат сохранится в файл
```

**Если ошибка выполнения скриптов:**
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
# Потом повторить запуск скрипта
```

#### Шаг 2: Собрать конфигурацию MSSQL

На сервере **PVD-SQL** запустите PowerShell (от администратора):

```powershell
# Убедитесь, что установлен SqlServer модуль
Import-Module SqlServer

# Запустить скрипт сбора
.\collect-mssql-config.ps1 -SQLServerInstance "localhost" -OutputPath "C:\Zabbix\mssql-config.json"
```

**Если ошибка про SqlServer модуль:**
```powershell
# Установить модуль
Install-Module SqlServer -Force
Import-Module SqlServer
```

#### Шаг 3: Запустить SQL запросы для БД 1C

Откройте **SQL Server Management Studio** на PVD-SQL:

1. Откройте `collect-1c-databases-sql.sql`
2. Запустите каждый запрос (они помечены номерами)
3. Скопируйте результаты в JSON формат

---

### Вариант 2: Автоматический сбор через Zabbix

#### Настройка Zabbix Agent для автоматического сбора

**На PVD-1C:**

1. Скопируйте `collect-1c-config.ps1` в папку Zabbix Agent:
```bash
Copy-Item collect-1c-config.ps1 "C:\Program Files\Zabbix Agent 2\scripts\"
```

2. Добавьте в `zabbix_agent2.conf`:
```ini
UserParameter=1c.config.collect,powershell.exe -ExecutionPolicy RemoteSigned -File "C:\Program Files\Zabbix Agent 2\scripts\collect-1c-config.ps1" -OutputPath "C:\Zabbix\1c-config.json"
```

3. Перезагрузите агент:
```powershell
Restart-Service "Zabbix Agent 2"
```

4. Тестируйте с сервера Zabbix:
```bash
zabbix_get -s 192.168.87.242 -p 10050 -k "1c.config.collect"
```

**Аналогично на PVD-SQL с `collect-mssql-config.ps1`**

#### Настройка Zabbix для запуска скриптов по расписанию

Создайте Action в Zabbix UI:

1. **Configuration → Actions → Event source: Internal**
2. **New action:**
   - Name: "Daily 1C Config Collection"
   - Trigger: "Zabbix server startup" или CRON-based
   - Operations:
     ```
     Command (on Zabbix server):
     /usr/local/sbin/zabbix_server_scripts/run-1c-collection.sh
     ```

3. Создайте bash скрипт `/usr/local/sbin/zabbix_server_scripts/run-1c-collection.sh`:
```bash
#!/bin/bash

# Собрать 1C конфигурацию с PVD-1C
ssh admin@192.168.87.242 "powershell.exe -ExecutionPolicy RemoteSigned -File C:\\Scripts\\collect-1c-config.ps1"

# Собрать MSSQL конфигурацию с PVD-SQL
ssh admin@192.168.87.243 "powershell.exe -ExecutionPolicy RemoteSigned -File C:\\Scripts\\collect-mssql-config.ps1"

# Скопировать файлы на Zabbix сервер
scp admin@192.168.87.242:C:\\Zabbix\\1c-config.json /opt/zabbix/kb-imports/
scp admin@192.168.87.243:C:\\Zabbix\\mssql-config.json /opt/zabbix/kb-imports/

echo "✅ Config collection completed at $(date)" >> /var/log/zabbix/kb-collection.log
```

---

### Вариант 3: Интеграция с Knowledge Base

#### Экспорт JSON в КБ

После сбора данных (JSON файлы):

1. **Откройте JSON файл:**
```bash
cat /path/to/1c-config.json | jq .
```

2. **Скопируйте результаты в соответствующие разделы КБ:**
   - `03_Services/1c/platform-8.3.md` — информация о платформе 8.3
   - `03_Services/1c/platform-8.5.md` — информация о платформе 8.5
   - `03_Services/mssql/server-2019.md` — информация о SQL Server 2019

3. **Обновите поля [PENDING] на реальные значения**

---

## 📊 Примеры результатов

### 1C Config Output (фрагмент JSON):
```json
{
  "CollectionTime": "2026-04-22 13:07:00",
  "Hostname": "PVD-1C",
  "Installations": [
    {
      "Version": "8.3",
      "FullPath": "C:\\Program Files\\1cv8\\8.3",
      "FileVersion": "8.3.25.1234"
    },
    {
      "Version": "8.5",
      "FullPath": "C:\\Program Files\\1cv8\\8.5",
      "FileVersion": "8.5.18.567"
    }
  ],
  "Services": [
    {
      "ServiceName": "1cv8",
      "DisplayName": "1C:Enterprise",
      "Status": "Running"
    }
  ]
}
```

### MSSQL Config Output (фрагмент JSON):
```json
{
  "CollectionTime": "2026-04-22 13:00:00",
  "SQLServerInstance": "localhost",
  "Version": {
    "ProductVersion": "15.0.4001.0",
    "Edition": "Standard"
  },
  "Databases": [
    {
      "Name": "1C_83_Base",
      "RecoveryModel": "Full",
      "SizeGB": "45.67"
    }
  ]
}
```

---

## ⚠️ Важные замечания

### Безопасность
- ❌ **Не коммитьте JSON файлы с паролями в Git!**
- ✅ **Пароли должны быть заменены на {{PLACEHOLDER}}**
- 🔒 **Ограничьте доступ к скриптам на серверах**

### Требования
- **PowerShell 5.0+** на Windows серверах
- **SqlServer модуль** для PowerShell (для MSSQL скрипта)
- **Права администратора** для запуска скриптов
- **Доступ к SQL Server** (Windows auth или SQL auth)

### Производительность
- Скрипты работают **не более 5 минут**
- Не требуют много ресурсов
- Безопасны для запуска в рабочее время

---

## 🔄 Рекомендуемое расписание

| Скрипт | Частота | Время |
|--------|---------|-------|
| collect-1c-config.ps1 | 1 раз в неделю | 22:00 MSK (воскресенье) |
| collect-mssql-config.ps1 | 1 раз в неделю | 22:05 MSK (воскресенье) |
| SQL queries (ручно) | По необходимости | - |

---

## 🆘 Troubleshooting

### "Execution policy prevents running scripts"
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
```

### "Cannot find SQL Server module"
```powershell
Install-Module SqlServer -Repository PSGallery -Force
```

### "Cannot connect to database"
- Проверьте, что SQL Server запущен
- Проверьте firewall правила (порт 1433)
- Проверьте credentials (Windows auth vs SQL auth)

### "JSON export is empty"
- Убедитесь, что скрипт выполнился без ошибок
- Проверьте, что у пользователя есть права на чтение БД
- Посмотрите лог: `$error[0] | Format-List -Force`

---

## 📚 Ссылки

- [Knowledge Base Index](../../README.md)
- [PVD-1C Server](../../02_Infrastructure/servers/pvd-1c.md)
- [PVD-SQL Server](../../02_Infrastructure/servers/win-dckio4rlmnm.md)
- [Zabbix Monitoring](../../03_Services/monitoring/zabbix-server.md)

---

**Версия:** 1.0  
**Дата создания:** 2026-04-22  
**Готов к использованию:** ✅ Yes
