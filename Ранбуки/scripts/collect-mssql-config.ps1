# ============================================================================
# MSSQL Server Configuration Collector
# Собирает конфигурацию и статистику MS SQL Server 2019
# Предназначен для автоматического пополнения Knowledge Base
# ============================================================================

param(
    [string]$SQLServerInstance = "localhost",  # или "HOSTNAME\INSTANCENAME"
    [string]$OutputFormat = "JSON",
    [string]$OutputPath = "C:\Zabbix\mssql-config.json"
)

$ErrorActionPreference = "Continue"

# ============================================================================
# ФУНКЦИИ
# ============================================================================

function Get-SQLServerVersion {
    <#
    .SYNOPSIS
        Получает версию SQL Server
    #>

    $query = @"
SELECT
    @@VERSION as Version,
    SERVERPROPERTY('ProductVersion') as ProductVersion,
    SERVERPROPERTY('Edition') as Edition,
    SERVERPROPERTY('EngineEdition') as EngineEdition
"@

    try {
        $result = Invoke-Sqlcmd -ServerInstance $SQLServerInstance -Query $query -ErrorAction Stop
        return @{
            Version = $result.Version
            ProductVersion = $result.ProductVersion
            Edition = $result.Edition
            EngineEdition = $result.EngineEdition
        }
    }
    catch {
        return @{ Error = $_.Exception.Message }
    }
}

function Get-SQLDatabases {
    <#
    .SYNOPSIS
        Получает список БД с их размерами и параметрами
    #>

    $query = @"
SELECT
    d.name as DatabaseName,
    d.database_id as DatabaseID,
    d.recovery_model_desc as RecoveryModel,
    d.state_desc as State,
    CAST(CAST(SUM(CASE WHEN type = 0 THEN size END) OVER (PARTITION BY database_id) * 8.0 / 1024 / 1024 AS DECIMAL(10,2)) AS NVARCHAR(20)) as SizeGB,
    d.create_date as CreatedDate,
    CAST(DATEDIFF(day, d.create_date, GETDATE()) as INT) as AgeDays
FROM
    sys.master_files mf
INNER JOIN
    sys.databases d ON mf.database_id = d.database_id
GROUP BY
    d.name, d.database_id, d.recovery_model_desc, d.state_desc, d.create_date
ORDER BY
    d.name
"@

    try {
        $result = Invoke-Sqlcmd -ServerInstance $SQLServerInstance -Query $query -ErrorAction Stop

        return @{
            DatabaseCount = $result.Count
            Databases = $result | ForEach-Object {
                @{
                    Name = $_.DatabaseName
                    ID = $_.DatabaseID
                    RecoveryModel = $_.RecoveryModel
                    State = $_.State
                    SizeGB = $_.SizeGB
                    CreatedDate = $_.CreatedDate.ToString("yyyy-MM-dd")
                    AgeDays = $_.AgeDays
                }
            }
        }
    }
    catch {
        return @{ Error = $_.Exception.Message }
    }
}

function Get-SQLBackupStatus {
    <#
    .SYNOPSIS
        Получает статус и время последних бэкапов
    #>

    $query = @"
SELECT
    ISNULL(d.name, bs.database_name) as DatabaseName,
    CONVERT(CHAR(10), MAX(bs.backup_finish_date), 101) as LastBackupDate,
    DATEDIFF(day, MAX(bs.backup_finish_date), GETDATE()) as DaysSinceBackup,
    MAX(CASE WHEN type = 'D' THEN backup_finish_date END) as LastFullBackup,
    MAX(CASE WHEN type = 'I' THEN backup_finish_date END) as LastDiffBackup,
    MAX(CASE WHEN type = 'L' THEN backup_finish_date END) as LastLogBackup
FROM
    msdb.dbo.backupset bs
LEFT JOIN
    sys.databases d ON bs.database_name = d.name
GROUP BY
    ISNULL(d.name, bs.database_name)
ORDER BY
    DatabaseName
"@

    try {
        $result = Invoke-Sqlcmd -ServerInstance $SQLServerInstance -Query $query -ErrorAction Stop

        return @{
            BackupStatus = $result | ForEach-Object {
                @{
                    Database = $_.DatabaseName
                    LastBackupDate = $_.LastBackupDate
                    DaysSinceBackup = $_.DaysSinceBackup
                    LastFullBackup = $_.LastFullBackup
                    LastDiffBackup = $_.LastDiffBackup
                    LastLogBackup = $_.LastLogBackupDate
                }
            }
        }
    }
    catch {
        return @{ Error = $_.Exception.Message }
    }
}

function Get-SQLServerConfiguration {
    <#
    .SYNOPSIS
        Получает конфигурационные параметры SQL Server
    #>

    $query = @"
SELECT
    name,
    value_in_use as CurrentValue,
    value as ConfiguredValue,
    description
FROM
    sys.configurations
WHERE
    name IN (
        'max server memory (MB)',
        'min server memory (MB)',
        'max degree of parallelism',
        'cost threshold for parallelism',
        'backup compression default',
        'recovery interval (minutes)',
        'default fill factor (%)'
    )
ORDER BY
    name
"@

    try {
        $result = Invoke-Sqlcmd -ServerInstance $SQLServerInstance -Query $query -ErrorAction Stop

        return @{
            Configuration = $result | ForEach-Object {
                @{
                    Name = $_.name
                    CurrentValue = $_.CurrentValue
                    ConfiguredValue = $_.ConfiguredValue
                    Description = $_.description
                }
            }
        }
    }
    catch {
        return @{ Error = $_.Exception.Message }
    }
}

function Get-SQLLogins {
    <#
    .SYNOPSIS
        Получает список SQL Server логинов (только имена, без паролей!)
    #>

    $query = @"
SELECT
    name as LoginName,
    type_desc as LoginType,
    create_date as CreatedDate,
    CASE WHEN is_disabled = 1 THEN 'Disabled' ELSE 'Enabled' END as Status
FROM
    sys.server_principals
WHERE
    type IN ('S', 'U', 'G')  -- SQL login, Windows user, Windows group
ORDER BY
    name
"@

    try {
        $result = Invoke-Sqlcmd -ServerInstance $SQLServerInstance -Query $query -ErrorAction Stop

        return @{
            Logins = $result | ForEach-Object {
                @{
                    Name = $_.LoginName
                    Type = $_.LoginType
                    CreatedDate = $_.CreatedDate.ToString("yyyy-MM-dd")
                    Status = $_.Status
                }
            }
        }
    }
    catch {
        return @{ Error = $_.Exception.Message }
    }
}

function Get-SQLConnectionCount {
    <#
    .SYNOPSIS
        Получает количество активных подключений
    #>

    $query = @"
SELECT
    db_name(database_id) as DatabaseName,
    COUNT(*) as ConnectionCount,
    COUNT(DISTINCT login_name) as UniqueLogins
FROM
    sys.dm_exec_sessions
WHERE
    database_id > 4  -- Exclude system databases
GROUP BY
    database_id
ORDER BY
    DatabaseName
"@

    try {
        $result = Invoke-Sqlcmd -ServerInstance $SQLServerInstance -Query $query -ErrorAction Stop

        return @{
            Connections = $result | ForEach-Object {
                @{
                    Database = $_.DatabaseName
                    TotalConnections = $_.ConnectionCount
                    UniqueLogins = $_.UniqueLogins
                }
            }
        }
    }
    catch {
        return @{ Error = $_.Exception.Message }
    }
}

function Get-SQLIndexFragmentation {
    <#
    .SYNOPSIS
        Получает статистику фрагментации индексов
    #>

    $query = @"
SELECT
    db_name(ips.database_id) as DatabaseName,
    OBJECT_NAME(ips.object_id, ips.database_id) as TableName,
    i.name as IndexName,
    CAST(ips.avg_fragmentation_in_percent AS DECIMAL(5,2)) as FragmentationPercent
FROM
    sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'LIMITED') ips
INNER JOIN
    sys.indexes i ON ips.object_id = i.object_id AND ips.index_id = i.index_id
WHERE
    ips.avg_fragmentation_in_percent > 10
    AND ips.page_count > 1000
ORDER BY
    ips.avg_fragmentation_in_percent DESC
"@

    try {
        $result = Invoke-Sqlcmd -ServerInstance $SQLServerInstance -Query $query -ErrorAction Stop

        $highFragmentation = @($result | Where-Object { $_.FragmentationPercent -gt 30 })

        return @{
            TotalFragmentedIndexes = $result.Count
            HighlyFragmented = $highFragmentation.Count
            TopFragmentedIndexes = $result | Select-Object -First 10 | ForEach-Object {
                @{
                    Database = $_.DatabaseName
                    Table = $_.TableName
                    Index = $_.IndexName
                    Fragmentation = [decimal]$_.FragmentationPercent
                }
            }
        }
    }
    catch {
        return @{ Error = $_.Exception.Message }
    }
}

function Get-SQLMemoryUsage {
    <#
    .SYNOPSIS
        Получает использование памяти SQL Server
    #>

    $query = @"
SELECT
    SUM(CAST(bpool_commit_target * 8.0 / 1024 / 1024 AS DECIMAL(10,2))) as Target_Memory_MB,
    SUM(CAST(bpool_committed * 8.0 / 1024 / 1024 AS DECIMAL(10,2))) as Committed_Memory_MB,
    SUM(CAST(bpool_visible * 8.0 / 1024 / 1024 AS DECIMAL(10,2))) as Visible_Memory_MB
FROM
    sys.dm_os_memory_pools
WHERE
    pool_id = 1
"@

    try {
        $result = Invoke-Sqlcmd -ServerInstance $SQLServerInstance -Query $query -ErrorAction Stop

        return @{
            TargetMemoryMB = [decimal]$result.Target_Memory_MB
            CommittedMemoryMB = [decimal]$result.Committed_Memory_MB
            VisibleMemoryMB = [decimal]$result.Visible_Memory_MB
        }
    }
    catch {
        return @{ Error = $_.Exception.Message }
    }
}

# ============================================================================
# MAIN
# ============================================================================

Write-Host "🔍 Сбор конфигурации MSSQL Server..." -ForegroundColor Cyan
Write-Host "   Сервер: $SQLServerInstance`n" -ForegroundColor Gray

$collectionData = @{
    CollectionTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Hostname = $env:COMPUTERNAME
    SQLServerInstance = $SQLServerInstance

    Version = Get-SQLServerVersion
    Databases = Get-SQLDatabases
    BackupStatus = Get-SQLBackupStatus
    Configuration = Get-SQLServerConfiguration
    Logins = Get-SQLLogins
    Connections = Get-SQLConnectionCount
    IndexFragmentation = Get-SQLIndexFragmentation
    MemoryUsage = Get-SQLMemoryUsage
}

# ============================================================================
# ВЫВОД РЕЗУЛЬТАТОВ
# ============================================================================

if ($OutputFormat -eq "JSON") {
    $jsonOutput = $collectionData | ConvertTo-Json -Depth 5

    # Сохраняем в файл
    $jsonOutput | Out-File -FilePath $OutputPath -Encoding UTF8 -Force
    Write-Host "✅ Данные сохранены в: $OutputPath`n" -ForegroundColor Green

    # Выводим в консоль (укороченная версия)
    Write-Host $jsonOutput | Select-Object -First 50
}

# ============================================================================
# РЕЗЮМЕ
# ============================================================================

Write-Host "`n" + ("=" * 70) -ForegroundColor Cyan
Write-Host "📊 СВОДКА КОНФИГУРАЦИИ MSSQL SERVER" -ForegroundColor Cyan
Write-Host "=" * 70 -ForegroundColor Cyan

if ($collectionData.Version.Error) {
    Write-Host "❌ ОШИБКА: Не удалось подключиться к SQL Server" -ForegroundColor Red
    Write-Host $collectionData.Version.Error -ForegroundColor Red
} else {
    Write-Host ("Версия: {0}" -f $collectionData.Version.ProductVersion)
    Write-Host ("Издание: {0}" -f $collectionData.Version.Edition)
    Write-Host ("Баз данных: {0}" -f $collectionData.Databases.DatabaseCount)

    if ($collectionData.IndexFragmentation.HighlyFragmented) {
        Write-Host ("⚠️  Критически фрагментировано индексов: {0}" -f $collectionData.IndexFragmentation.HighlyFragmented) -ForegroundColor Yellow
    }
}

Write-Host "`n💾 JSON экспортирован в: $OutputPath" -ForegroundColor Green

# ============================================================================
# ПРИМЕЧАНИЯ ДЛЯ ИМПОРТА В KNOWLEDGE BASE
# ============================================================================

Write-Host "`n📋 ПРИМЕЧАНИЕ ДЛЯ ИМПОРТА В KNOWLEDGE BASE:" -ForegroundColor Cyan
Write-Host "  1. Откройте полученный JSON файл" -ForegroundColor Gray
Write-Host "  2. Вставьте информацию в соответствующие поля КБ" -ForegroundColor Gray
Write-Host "  3. Проверьте конфигурацию вручную для полноты" -ForegroundColor Gray
