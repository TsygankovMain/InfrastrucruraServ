-- ============================================================================
-- SQL QUERIES: Сбор информации о 1C базах данных в MSSQL
-- Выполняется на сервере PVD-SQL (192.168.87.243)
-- Результаты экспортируются в JSON для загрузки в Knowledge Base
-- ============================================================================

-- ============================================================================
-- 1. СПИСОК ВСЕх БАЗ ДАННЫХ 1C
-- ============================================================================

-- Получить все БД с суммарной статистикой
SELECT
    d.name AS DatabaseName,
    d.database_id AS DatabaseID,
    d.recovery_model_desc AS RecoveryModel,
    d.state_desc AS DatabaseState,
    CAST(CAST(SUM(mf.size) * 8.0 / 1024 / 1024 AS DECIMAL(10,2)) AS NVARCHAR(20)) AS SizeGB,
    d.create_date AS CreatedDate,
    DATEDIFF(DAY, d.create_date, GETDATE()) AS AgeDays,
    CASE
        WHEN d.state_desc = 'ONLINE' THEN 'Active'
        ELSE d.state_desc
    END AS Status
FROM
    sys.databases d
LEFT JOIN
    sys.master_files mf ON d.database_id = mf.database_id
WHERE
    d.name NOT IN ('master', 'model', 'msdb', 'tempdb')  -- Исключаем системные БД
GROUP BY
    d.name, d.database_id, d.recovery_model_desc, d.state_desc, d.create_date
ORDER BY
    d.name;

-- ============================================================================
-- 2. РАЗМЕР ДАННЫХ И LOG ФАЙЛОВ
-- ============================================================================

-- Получить размер каждого файла БД (для проверки где лежат диски)
SELECT
    d.name AS DatabaseName,
    mf.type_desc AS FileType,  -- ROWS (data) or LOG (transaction log)
    mf.name AS LogicalFileName,
    mf.physical_name AS PhysicalPath,
    CAST(CAST(mf.size * 8.0 / 1024 / 1024 AS DECIMAL(10,2)) AS NVARCHAR(20)) AS FileSizeGB,
    CAST(CAST(FILEPROPERTY(d.name + '.' + mf.name, 'SpaceUsed') * 8.0 / 1024 / 1024 AS DECIMAL(10,2)) AS NVARCHAR(20)) AS UsedSpaceGB
FROM
    sys.databases d
INNER JOIN
    sys.master_files mf ON d.database_id = mf.database_id
WHERE
    d.name NOT IN ('master', 'model', 'msdb', 'tempdb')
ORDER BY
    d.name, mf.type_desc;

-- ============================================================================
-- 3. СТАТИСТИКА ПО ТАБЛИЦАМ (для оценки размера БД)
-- ============================================================================

-- Запустить для каждой 1C БД:
-- USE [имя_базы_1c];

SELECT
    SCHEMA_NAME(t.schema_id) AS SchemaName,
    t.name AS TableName,
    COUNT(i.name) AS IndexCount,
    CAST(CAST(SUM(ps.reserved_page_count) * 8.0 / 1024 AS DECIMAL(10,2)) AS NVARCHAR(20)) AS ReservedSpaceMB,
    CAST(CAST(SUM(ps.used_page_count) * 8.0 / 1024 AS DECIMAL(10,2)) AS NVARCHAR(20)) AS UsedSpaceMB,
    COUNT(*) AS RowCount  -- Примечание: это даст приблизительное значение
FROM
    sys.tables t
LEFT JOIN
    sys.indexes i ON t.object_id = i.object_id
LEFT JOIN
    sys.dm_db_partition_stats ps ON i.object_id = ps.object_id AND i.index_id = ps.index_id
GROUP BY
    SCHEMA_NAME(t.schema_id), t.name
ORDER BY
    UsedSpaceMB DESC;

-- ============================================================================
-- 4. РЕЗЕРВНЫЕ КОПИИ (когда последний раз делались)
-- ============================================================================

SELECT
    bs.database_name AS DatabaseName,
    bs.type AS BackupType,  -- D=Full, I=Differential, L=Log
    CASE bs.type
        WHEN 'D' THEN 'Full Backup'
        WHEN 'I' THEN 'Differential'
        WHEN 'L' THEN 'Transaction Log'
        ELSE 'Other'
    END AS BackupTypeDescription,
    bs.backup_finish_date AS BackupFinishDate,
    DATEDIFF(DAY, bs.backup_finish_date, GETDATE()) AS DaysSinceBackup,
    CAST(CAST(bs.backup_size / 1024 / 1024 / 1024 AS DECIMAL(10,2)) AS NVARCHAR(20)) AS BackupSizeGB,
    bs.backup_start_date AS BackupStartDate,
    DATEDIFF(MINUTE, bs.backup_start_date, bs.backup_finish_date) AS BackupDurationMinutes
FROM
    msdb.dbo.backupset bs
WHERE
    bs.database_name NOT IN ('master', 'model', 'msdb')
ORDER BY
    bs.database_name, bs.backup_finish_date DESC;

-- ============================================================================
-- 5. ТЕКУЩИЕ ПОДКЛЮЧЕНИЯ К БАЗАМ
-- ============================================================================

SELECT
    DB_NAME(es.database_id) AS DatabaseName,
    es.session_id AS SessionID,
    es.login_name AS LoginName,
    es.host_name AS HostName,
    es.program_name AS ApplicationName,
    es.status AS SessionStatus,
    GETDATE() - CONVERT(DATETIME, CONVERT(VARCHAR(20), es.login_time, 121)) AS ConnectionDurationHours
FROM
    sys.dm_exec_sessions es
WHERE
    DB_NAME(es.database_id) NOT IN ('master', 'model', 'msdb', 'tempdb')
    AND es.database_id > 4
ORDER BY
    DB_NAME(es.database_id), es.login_name;

-- ============================================================================
-- 6. КОНФИГУРАЦИЯ БД (Recovery Model, Compatibility)
-- ============================================================================

SELECT
    d.name AS DatabaseName,
    d.recovery_model_desc AS RecoveryModel,
    d.compatibility_level AS CompatibilityLevel,
    CASE d.compatibility_level
        WHEN 100 THEN 'SQL Server 2008'
        WHEN 110 THEN 'SQL Server 2012'
        WHEN 120 THEN 'SQL Server 2014'
        WHEN 130 THEN 'SQL Server 2016'
        WHEN 140 THEN 'SQL Server 2017'
        WHEN 150 THEN 'SQL Server 2019'
        WHEN 160 THEN 'SQL Server 2022'
        ELSE 'Unknown'
    END AS CompatibleWithVersion,
    d.is_auto_shrink_on AS AutoShrink,
    d.is_auto_update_stats_on AS AutoUpdateStats,
    d.is_broker_enabled AS BrokerEnabled,
    d.create_date AS DatabaseCreatedDate
FROM
    sys.databases d
WHERE
    d.name NOT IN ('master', 'model', 'msdb', 'tempdb')
ORDER BY
    d.name;

-- ============================================================================
-- 7. ФРАГМЕНТАЦИЯ ИНДЕКСОВ (для каждой БД)
-- ============================================================================

-- Запустить для каждой 1C БД отдельно:
-- USE [имя_базы_1c];

SELECT TOP 20
    OBJECT_NAME(ips.object_id) AS TableName,
    i.name AS IndexName,
    ips.index_type_desc AS IndexType,
    CAST(ips.avg_fragmentation_in_percent AS DECIMAL(5,2)) AS FragmentationPercent,
    ips.page_count AS PageCount,
    CASE
        WHEN ips.avg_fragmentation_in_percent < 10 THEN 'OK'
        WHEN ips.avg_fragmentation_in_percent < 30 THEN 'Reorganize'
        ELSE 'Rebuild'
    END AS RecommendedAction
FROM
    sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'LIMITED') ips
INNER JOIN
    sys.indexes i ON ips.object_id = i.object_id AND ips.index_id = i.index_id
WHERE
    ips.avg_fragmentation_in_percent > 10
    AND ips.page_count > 1000
ORDER BY
    ips.avg_fragmentation_in_percent DESC;

-- ============================================================================
-- 8. БЛОКИРОВКИ И ОЖИДАНИЯ (если есть проблемы)
-- ============================================================================

SELECT
    DB_NAME(es.database_id) AS DatabaseName,
    es.session_id AS SessionID,
    es.login_name AS LoginName,
    es.status AS SessionStatus,
    er.wait_duration_ms AS WaitDurationMS,
    er.wait_type AS WaitType,
    er.command AS Command,
    SUBSTRING(st.text, er.statement_start_offset/2 + 1,
        (CASE WHEN er.statement_end_offset = -1
            THEN LEN(CONVERT(NVARCHAR(MAX), st.text))
            ELSE er.statement_end_offset/2
        END - er.statement_start_offset/2)) AS ExecutingQuery
FROM
    sys.dm_exec_sessions es
LEFT JOIN
    sys.dm_exec_requests er ON es.session_id = er.session_id
LEFT JOIN
    sys.dm_exec_sql_text(er.sql_handle) st ON 1=1
WHERE
    es.database_id > 4
    AND er.wait_duration_ms > 0
ORDER BY
    er.wait_duration_ms DESC;

-- ============================================================================
-- 9. MAINTENANCE JOBS (SQL Agent)
-- ============================================================================

SELECT
    j.name AS JobName,
    j.enabled AS IsEnabled,
    j.create_date AS CreatedDate,
    s.schedule_uid,
    s.name AS ScheduleName,
    sched.active_start_date AS ScheduleStartDate,
    sched.freq_type AS FrequencyType,
    CASE sched.freq_type
        WHEN 1 THEN 'Once'
        WHEN 4 THEN 'Daily'
        WHEN 8 THEN 'Weekly'
        WHEN 16 THEN 'Monthly'
        WHEN 32 THEN 'Monthly (relative)'
        WHEN 64 THEN 'When SQL Server starts'
        WHEN 128 THEN 'When idle'
        ELSE 'Unknown'
    END AS FrequencyDescription
FROM
    msdb.dbo.sysjobs j
LEFT JOIN
    msdb.dbo.sysjobschedules jsch ON j.job_id = jsch.job_id
LEFT JOIN
    msdb.dbo.sysschedules sched ON jsch.schedule_id = sched.schedule_id
WHERE
    j.name LIKE '%backup%'
    OR j.name LIKE '%maintenance%'
    OR j.name LIKE '%1C%'
ORDER BY
    j.name;

-- ============================================================================
-- 10. ПРИМЕЧАНИЯ ДЛЯ ЭКСПОРТА В JSON (BASH/PowerShell)
-- ============================================================================

/*
ЭКСПОРТ В JSON СРЕДСТВАМИ SQLCMD:

sqlcmd -S PVD-SQL -U sa -P {{PASSWORD}} -d master -o output.json -h -1 -W -Q "
SELECT
    (SELECT * FROM (
        SELECT name, database_id FROM sys.databases WHERE name NOT IN ('master','model','msdb','tempdb')
    ) databases FOR JSON PATH) AS databases
"

Или через PowerShell:
$connectionString = "Server=PVD-SQL;Database=master;Integrated Security=true;"
$connection = New-Object System.Data.SqlClient.SqlConnection($connectionString)
$connection.Open()

$command = $connection.CreateCommand()
$command.CommandText = "SELECT name, database_id FROM sys.databases FOR JSON PATH"

$result = $command.ExecuteScalar()
$result | ConvertFrom-Json | ConvertTo-Json -Depth 10 | Out-File databases.json -Encoding UTF8

*/
