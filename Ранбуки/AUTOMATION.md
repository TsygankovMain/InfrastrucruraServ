---
order: 5
---


```powershell

# ===== СКРИПТ 2: Сетевая конфигурация =====

<#
.SYNOPSIS
    Собирает информацию о сетевой конфигурации (IP, DNS, Firewall, VLAN)

.DESCRIPTION
    Скрипт собирает детальную сетевую информацию и маршруты

.PARAMETER OutputPath
    Путь для сохранения результата (по умолчанию C:\Reports\)

.EXAMPLE
    .\Collect-NetworkConfig.ps1 -OutputPath "C:\Reports"
#>

param(
    [string]$OutputPath = "C:\Reports"
)

if (-not (Test-Path $OutputPath)) {
    New-Item -ItemType Directory -Path $OutputPath -Force | Out-Null
}

Write-Host "🌐 Сбор сетевой конфигурации..." -ForegroundColor Cyan

# ===== IP АДРЕСА =====
$IPConfigs = Get-NetIPConfiguration
$NetworkConfig = @{
    Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Interfaces = @()
    Routes = @()
    DNS = @()
}

foreach ($Config in $IPConfigs) {
    if ($Config.IPv4Address) {
        $NetworkConfig.Interfaces += @{
            InterfaceAlias = $Config.InterfaceAlias
            IPv4Address = $Config.IPv4Address.IPAddress[0]
            IPv4Prefix = $Config.IPv4Address.PrefixLength[0]
            IPv4Gateway = $Config.IPv4DefaultGateway.NextHop
            IPv6Address = $Config.IPv6Address.IPAddress[0]
            DHCP = $Config.NetAdapter.NdisPhysicalMedium
        }
    }
}

# ===== МАРШРУТЫ =====
$Routes = Get-NetRoute -AddressFamily IPv4 | Where-Object {$_.DestinationPrefix -notlike "255.255.255.255*"}
foreach ($Route in $Routes) {
    $NetworkConfig.Routes += @{
        Destination = $Route.DestinationPrefix
        NextHop = $Route.NextHop
        InterfaceAlias = $Route.InterfaceAlias
        Metric = $Route.RouteMetric
    }
}

# ===== DNS =====
$DNSServers = Get-DnsClientServerAddress -AddressFamily IPv4
foreach ($DNS in $DNSServers) {
    if ($DNS.ServerAddresses) {
        $NetworkConfig.DNS += @{
            InterfaceAlias = $DNS.InterfaceAlias
            Servers = $DNS.ServerAddresses -join ", "
        }
    }
}

# ===== PING ТЕСТЫ К ВАЖНЫМ ХОСТАМ =====
$NetworkConfig.PingTests = @{}
$PingHosts = @("8.8.8.8", "1.1.1.1", $env:LOGONSERVER)
foreach ($Host in $PingHosts) {
    try {
        $PingResult = Test-Connection -ComputerName $Host -Count 1 -ErrorAction Stop
        $NetworkConfig.PingTests[$Host] = @{
            Status = "Success"
            ResponseTime = "$($PingResult.ResponseTime) ms"
        }
    } catch {
        $NetworkConfig.PingTests[$Host] = @{
            Status = "Failed"
            Error = $_.Exception.Message
        }
    }
}

# ===== СОХРАНИТЬ =====
$Timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$OutputFile = Join-Path $OutputPath "NetworkConfig_$Timestamp.json"
$NetworkConfig | ConvertTo-Json -Depth 10 | Out-File -FilePath $OutputFile -Encoding UTF8

Write-Host "✅ Сетевой отчёт сохранён: $OutputFile" -ForegroundColor Green
Write-Host "`n📊 Найдено сетевых интерфейсов: $($NetworkConfig.Interfaces.Count)" -ForegroundColor Yellow
Write-Host "📊 Маршрутов: $($NetworkConfig.Routes.Count)" -ForegroundColor Yellow
```

### 🖧 СКРИПТ 3: MSSQL конфигурация

**Файл:** `Collect-MSSQLConfig.ps1`

```powershell

<#
.SYNOPSIS
    Собирает конфигурацию MSSQL (версия, БД, параметры, пользователи)

.DESCRIPTION
    Подключается к MSSQL серверу и собирает детальную информацию

.PARAMETER ServerInstance
    Имя сервера\инстанс (пример: localhost\MSSQLSERVER)

.PARAMETER OutputPath
    Путь для сохранения (по умолчанию C:\Reports\)

.EXAMPLE
    .\Collect-MSSQLConfig.ps1 -ServerInstance "localhost" -OutputPath "C:\Reports"
#>

param(
    [string]$ServerInstance = "localhost",
    [string]$OutputPath = "C:\Reports"
)

if (-not (Test-Path $OutputPath)) {
    New-Item -ItemType Directory -Path $OutputPath -Force | Out-Null
}

Write-Host "🗄️  Сбор MSSQL конфигурации..." -ForegroundColor Cyan

# Убедитесь что SqlServer модуль установлен
if (-not (Get-Module -Name SqlServer -ListAvailable)) {
    Write-Host "⚠️  SqlServer модуль не установлен. Установка..." -ForegroundColor Yellow
    Install-Module -Name SqlServer -Force -AllowClobber
}

Import-Module SqlServer

$MSSQLInfo = @{
    Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    ServerInstance = $ServerInstance
    Version = ""
    Databases = @()
    Logins = @()
    ServerProperties = @()
    BackupJobs = @()
}

try {
    # ===== ВЕРСИЯ И BUILD =====
    $VersionQuery = @"
SELECT 
    @@VERSION AS Version,
    SERVERPROPERTY('ProductVersion') AS ProductVersion,
    SERVERPROPERTY('ProductLevel') AS ProductLevel,
    SERVERPROPERTY('Edition') AS Edition
"@
    $VersionInfo = Invoke-Sqlcmd -ServerInstance $ServerInstance -Query $VersionQuery
    $MSSQLInfo.Version = $VersionInfo.Version

    # ===== БАЗЫ ДАННЫХ =====
    $DBQuery = @"
SELECT 
    name AS DatabaseName,
    state_desc AS Status,
    recovery_model_desc AS RecoveryModel,
    CAST(SUM(size) * 8.0 / 1024 AS DECIMAL(10,2)) AS SizeGB
FROM sys.master_files
GROUP BY name, state_desc, recovery_model_desc
"@
    $Databases = Invoke-Sqlcmd -ServerInstance $ServerInstance -Query $DBQuery
    foreach ($DB in $Databases) {
        $MSSQLInfo.Databases += @{
            Name = $DB.DatabaseName
            Status = $DB.Status
            RecoveryModel = $DB.RecoveryModel
            SizeGB = $DB.SizeGB
        }
    }

    # ===== ЛОГИНЫ И ПОЛЬЗОВАТЕЛИ =====
    $LoginQuery = @"
SELECT 
    name AS LoginName,
    type_desc AS LoginType,
    create_date AS CreateDate
FROM sys.server_principals
WHERE type IN ('S', 'U')
"@
    $Logins = Invoke-Sqlcmd -ServerInstance $ServerInstance -Query $LoginQuery
    foreach ($Login in $Logins) {
        $MSSQLInfo.Logins += @{
            Name = $Login.LoginName
            Type = $Login.LoginType
            Created = $Login.CreateDate
        }
    }

    # ===== ПАРАМЕТРЫ СЕРВЕРА =====
    $ConfigQuery = @"
SELECT 
    name AS ParameterName,
    value AS ParameterValue,
    value_in_use AS CurrentValue
FROM sys.configurations
WHERE name IN ('max server memory (MB)', 'min server memory (MB)', 'max degree of parallelism')
"@
    $Config = Invoke-Sqlcmd -ServerInstance $ServerInstance -Query $ConfigQuery
    foreach ($Param in $Config) {
        $MSSQLInfo.ServerProperties += @{
            Name = $Param.ParameterName
            Value = $Param.ParameterValue
            CurrentValue = $Param.CurrentValue
        }
    }

    # ===== ПОСЛЕДНИЕ BACKUP'И =====
    $BackupQuery = @"
SELECT TOP 10
    database_name AS DatabaseName,
    type AS BackupType,
    backup_start_date AS StartDate,
    backup_finish_date AS FinishDate
FROM msdb.dbo.backupset
ORDER BY backup_finish_date DESC
"@
    $Backups = Invoke-Sqlcmd -ServerInstance $ServerInstance -Query $BackupQuery
    foreach ($Backup in $Backups) {
        $MSSQLInfo.BackupJobs += @{
            Database = $Backup.DatabaseName
            Type = $Backup.BackupType
            Started = $Backup.StartDate
            Finished = $Backup.FinishDate
        }
    }

    Write-Host "✅ Успешно собрана информация с $ServerInstance" -ForegroundColor Green

} catch {
    Write-Host "❌ Ошибка подключения: $($_.Exception.Message)" -ForegroundColor Red
    return
}

# ===== СОХРАНИТЬ =====
$Timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$OutputFile = Join-Path $OutputPath "MSSQLConfig_$Timestamp.json"
$MSSQLInfo | ConvertTo-Json -Depth 10 | Out-File -FilePath $OutputFile -Encoding UTF8

Write-Host "`n✅ MSSQL отчёт сохранён: $OutputFile" -ForegroundColor Green
Write-Host "`n📊 Сводка:`n" -ForegroundColor Yellow
Write-Host "  Версия: $($MSSQLInfo.Version)" 
Write-Host "  БД найдено: $($MSSQLInfo.Databases.Count)"
Write-Host "  Логинов: $($MSSQLInfo.Logins.Count)"
Write-Host "  Параметров сервера: $($MSSQLInfo.ServerProperties.Count)"
Write-Host "  Последних backup'ов: $($MSSQLInfo.BackupJobs.Count)"
```

---

## 🏢 СКРИПТ 4: 1C конфигурация

**Файл:** `Collect-1CConfig.ps1`

```powershell

<#
.SYNOPSIS
    Собирает информацию о 1C Enterprise (версии, серверы, БД)

.DESCRIPTION
    Для работы требуется наличие 1C установленной на сервере

.PARAMETER RASPort
    Порт RAS сервера (по умолчанию 1545)

.PARAMETER OutputPath
    Путь для сохранения

.EXAMPLE
    .\Collect-1CConfig.ps1 -RASPort 1545 -OutputPath "C:\Reports"
#>

param(
    [int]$RASPort = 1545,
    [string]$OutputPath = "C:\Reports"
)

if (-not (Test-Path $OutputPath)) {
    New-Item -ItemType Directory -Path $OutputPath -Force | Out-Null
}

Write-Host "🏢 Сбор 1C конфигурации..." -ForegroundColor Cyan

$1CInfo = @{
    Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Platform = @()
    Servers = @()
    Infobases = @()
    Services = @()
}

# ===== ПРОВЕРИТЬ УСТАНОВЛЕННЫЕ ВЕРСИИ 1C =====
$1CVersions = @("8.3", "8.5")
foreach ($Version in $1CVersions) {
    $RegPath = "HKLM:\Software\1C\1CEnterprise\$Version"
    if (Test-Path $RegPath) {
        $PlatformPath = (Get-ItemProperty -Path $RegPath).ProgramPath
        if (Test-Path $PlatformPath) {
            $1CInfo.Platform += @{
                Version = $Version
                InstallPath = $PlatformPath
                IsInstalled = $true
            }
        }
    }
}

# ===== ПРОВЕРИТЬ СЕРВИСЫ 1C =====
$Services = Get-Service -Name "*1C*" -ErrorAction SilentlyContinue
foreach ($Service in $Services) {
    $1CInfo.Services += @{
        Name = $Service.Name
        DisplayName = $Service.DisplayName
        Status = $Service.Status
        StartType = $Service.StartType
    }
}

# ===== ПОПЫТКА ПОДКЛЮЧИТЬСЯ К RAS (если доступно) =====
$RASAvailable = Test-NetConnection -ComputerName "localhost" -Port $RASPort -WarningAction SilentlyContinue
if ($RASAvailable.TcpTestSucceeded) {
    Write-Host "✅ RAS сервер доступен на порту $RASPort" -ForegroundColor Green
    $1CInfo.RASAvailable = $true
    $1CInfo.RASPort = $RASPort
} else {
    Write-Host "⚠️  RAS сервер недоступен на порту $RASPort" -ForegroundColor Yellow
    $1CInfo.RASAvailable = $false
}

# ===== ПРОВЕРИТЬ 1C ЛОГИ =====
$1CLogPath = "C:\ProgramData\1C\1CEnterprise"
if (Test-Path $1CLogPath) {
    $LogFiles = Get-ChildItem -Path $1CLogPath -Filter "*.log" -Recurse -ErrorAction SilentlyContinue | 
                Sort-Object -Property LastWriteTime -Descending | 
                Select-Object -First 5
    $1CInfo.RecentLogs = @()
    foreach ($Log in $LogFiles) {
        $1CInfo.RecentLogs += @{
            Name = $Log.Name
            LastModified = $Log.LastWriteTime
            SizeKB = [math]::Round($Log.Length / 1KB, 2)
        }
    }
}

# ===== СОХРАНИТЬ =====
$Timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$OutputFile = Join-Path $OutputPath "1CConfig_$Timestamp.json"
$1CInfo | ConvertTo-Json -Depth 10 | Out-File -FilePath $OutputFile -Encoding UTF8

Write-Host "`n✅ 1C отчёт сохранён: $OutputFile" -ForegroundColor Green
Write-Host "`n📊 Сводка:`n" -ForegroundColor Yellow
Write-Host "  Версии платформы: $($1CInfo.Platform.Count)"
Write-Host "  Сервисов 1C: $($1CInfo.Services.Count)"
Write-Host "  RAS доступен: $($1CInfo.RASAvailable)"
Write-Host "  Последних логов: $($1CInfo.RecentLogs.Count)"
```

---

## 🔗 СКРИПТ 5: Комбинированный сбор данных

**Файл:** `Collect-AllData.ps1`

```powershell

<#
.SYNOPSIS
    Комбинированный скрипт для сбора ВСЕ данных

.DESCRIPTION
    Запускает все скрипты сбора данных и создаёт HTML отчёт

.PARAMETER OutputPath
    Путь для сохранения отчётов

.EXAMPLE
    .\Collect-AllData.ps1 -OutputPath "C:\Reports"
#>

param(
    [string]$OutputPath = "C:\Reports"
)

if (-not (Test-Path $OutputPath)) {
    New-Item -ItemType Directory -Path $OutputPath -Force | Out-Null
}

Write-Host "
╔════════════════════════════════════════════════════════════╗
║       🤖 Комбинированный сбор данных инфраструктуры       ║
╚════════════════════════════════════════════════════════════╝
" -ForegroundColor Cyan

$ScriptsPath = Split-Path -Parent $MyInvocation.MyCommand.Path

$StartTime = Get-Date

# Запустить все скрипты
Write-Host "`n[1/4] Сбор системной информации..." -ForegroundColor Yellow
& "$ScriptsPath\Collect-SystemInfo.ps1" -OutputPath $OutputPath -Format JSON

Write-Host "`n[2/4] Сбор сетевой конфигурации..." -ForegroundColor Yellow
& "$ScriptsPath\Collect-NetworkConfig.ps1" -OutputPath $OutputPath

Write-Host "`n[3/4] Сбор MSSQL конфигурации..." -ForegroundColor Yellow
& "$ScriptsPath\Collect-MSSQLConfig.ps1" -ServerInstance "localhost" -OutputPath $OutputPath

Write-Host "`n[4/4] Сбор 1C конфигурации..." -ForegroundColor Yellow
& "$ScriptsPath\Collect-1CConfig.ps1" -OutputPath $OutputPath

# ===== СОЗДАТЬ HTML ОТЧЁТ =====
Write-Host "`n🔧 Создание HTML отчёта..." -ForegroundColor Cyan

$HTMLReport = @"
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Отчёт об инфраструктуре</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f5f5f5; }
        .container { max-width: 1200px; margin: 0 auto; padding: 20px; }
        h1 { color: #333; border-bottom: 3px solid #007bff; padding-bottom: 10px; }
        .section { background: white; margin: 20px 0; padding: 20px; border-radius: 5px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        table { width: 100%; border-collapse: collapse; }
        th { background: #007bff; color: white; padding: 10px; text-align: left; }
        td { padding: 8px; border-bottom: 1px solid #ddd; }
        tr:hover { background: #f9f9f9; }
        .status-ok { color: green; font-weight: bold; }
        .status-warning { color: orange; font-weight: bold; }
        .status-error { color: red; font-weight: bold; }
        .timestamp { font-size: 0.9em; color: #666; }
    </style>
</head>
<body>
    <div class="container">
        <h1>📊 Отчёт об инфраструктуре</h1>
        <p class="timestamp">Создано: $(Get-Date -Format "dd.MM.yyyy HH:mm:ss")</p>
        
        <div class="section">
            <h2>📁 Сгенерированные отчёты</h2>
            <ul>
                <li>✅ Системная информация - SystemInfo_*.json</li>
                <li>✅ Сетевая конфигурация - NetworkConfig_*.json</li>
                <li>✅ MSSQL конфигурация - MSSQLConfig_*.json</li>
                <li>✅ 1C конфигурация - 1CConfig_*.json</li>
            </ul>
            <p><strong>Локация:</strong> $OutputPath</p>
        </div>
        
        <div class="section">
            <h2>📖 Следующие шаги</h2>
            <ol>
                <li>Просмотрите JSON файлы в редакторе</li>
                <li>Заполните недостающие значения [PENDING] в QUESTIONNAIRE.md</li>
                <li>Обновите соответствующие документы в Knowledge Base</li>
                <li>Запустите этот скрипт снова для верификации</li>
            </ol>
        </div>
    </div>
</body>
</html>
"@

$Timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$HTMLFile = Join-Path $OutputPath "Report_$Timestamp.html"
$HTMLReport | Out-File -FilePath $HTMLFile -Encoding UTF8

$EndTime = Get-Date
$Duration = ($EndTime - $StartTime).TotalSeconds

Write-Host "`n
╔════════════════════════════════════════════════════════════╗
║                  ✅ СБОР ЗАВЕРШЁН                          ║
╚════════════════════════════════════════════════════════════╝
" -ForegroundColor Green

Write-Host "`n📂 Отчёты сохранены в: $OutputPath" -ForegroundColor Yellow
Write-Host "`n📊 HTML отчёт: $HTMLFile" -ForegroundColor Cyan
Write-Host "`n⏱️  Время выполнения: $([math]::Round($Duration, 2)) сек" -ForegroundColor Yellow

Write-Host "`n💡 Совет: Откройте HTML отчёт в браузере для удобного просмотра!" -ForegroundColor Magenta
```

---

## 📖 ИНСТРУКЦИЯ ПО ИСПОЛЬЗОВАНИЮ

### Шаг 1: Подготовка

```powershell
# Открыть PowerShell с правами администратора
# Перейти в папку скриптов
cd "C:\path\to\Ранбуки\scripts"

# Разрешить выполнение скриптов
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
```

### Шаг 2: Создать папку для отчётов

```powershell
mkdir C:\Reports
```

### Шаг 3: Запустить сбор данных

**Вариант A: Сбор ВСЁ одной командой**
```powershell
.\Collect-AllData.ps1 -OutputPath "C:\Reports"
```

**Вариант B: Сбор по отдельным скриптам**
```powershell
# Системная информация
.\Collect-SystemInfo.ps1 -OutputPath "C:\Reports" -Format JSON

# Сетевая конфигурация
.\Collect-NetworkConfig.ps1 -OutputPath "C:\Reports"

# MSSQL (замените на ваш сервер\инстанс)
.\Collect-MSSQLConfig.ps1 -ServerInstance "YOUR_SERVER\MSSQLSERVER" -OutputPath "C:\Reports"

# 1C Enterprise
.\Collect-1CConfig.ps1 -OutputPath "C:\Reports"
```

### Шаг 4: Просмотр результатов

```powershell
# Открыть HTML отчёт
Start-Process "C:\Reports\Report_*.html"

# Или просмотреть JSON в редакторе
code C:\Reports\*.json
```

### Шаг 5: Заполнение Knowledge Base

1. Откройте `QUESTIONNAIRE.md`
2. Используйте собранные данные для заполнения полей
3. Обновите соответствующие документы в Knowledge Base

---

## 🔧 Troubleshooting

### "SqlServer модуль не установлен"
```powershell
Install-Module -Name SqlServer -Force -AllowClobber
```

### "Отказано в доступе"
```powershell
# Запустить PowerShell как администратор
# Или изменить Policy:
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### "Не могу подключиться к MSSQL"
```powershell
# Проверить что MSSQL запущен
Get-Service -Name MSSQLSERVER | Where-Object Status -eq 'Running'

# Проверить conexión по TCP
Test-NetConnection -ComputerName localhost -Port 1433
```

---

## 📊 Формат результатов

Все скрипты генерируют **JSON** файлы, которые можно:

1. **Просмотреть в текстовом редакторе** (VS Code, Notepad++)
2. **Импортировать в PowerShell:**
```powershell
$Data = Get-Content "C:\Reports\SystemInfo_*.json" | ConvertFrom-Json
$Data.Memory.TotalPhysicalMemory_GB  # Просмотр свойств
```

3. **Конвертировать в CSV:**
```powershell
$Data | ConvertTo-Csv | Out-File "export.csv"
```

---

## 📝 Примеры интеграции

### Пример 1: Заполнение IP адреса из скрипта

После запуска `Collect-NetworkConfig.ps1` найдите в JSON файле:
```json
"IPv4Address": "192.168.10.5"
```

И вставьте в документ `Инфраструктура/network/ip-allocation.md`.

### Пример 2: Автоматическое обновление документа

```powershell
$Data = Get-Content "C:\Reports\MSSQLConfig_*.json" | ConvertFrom-Json
$Version = $Data.Version

# Обновить файл документа
(Get-Content "Инфраструктура/servers/pvd-1c.md") -replace "SQL Server.*", "SQL Server: $Version" | 
    Set-Content "Инфраструктура/servers/pvd-1c.md"
```

---

**Готово!** Используйте эти скрипты регулярно для актуализации Knowledge Base! 🎉
