# ============================================================================
# 1C Enterprise Configuration Collector
# Собирает информацию о конфигурации 1C платформ 8.3 и 8.5
# Предназначен для автоматического пополнения Knowledge Base
# ============================================================================

param(
    [string]$OutputFormat = "JSON",  # JSON или CSV
    [string]$OutputPath = "C:\Zabbix\1c-config.json"
)

$ErrorActionPreference = "Stop"

# ============================================================================
# ФУНКЦИИ
# ============================================================================

function Get-1CInstallations {
    $1cVersions = @()
    $installPaths = @(
        "C:\Program Files\1cv8",
        "C:\Program Files (x86)\1cv8",
        "D:\1cv8",
        "E:\1cv8"
    )

    foreach ($path in $installPaths) {
        if (Test-Path $path) {
            $versionFolders = Get-ChildItem -Path $path -Directory -ErrorAction SilentlyContinue

            foreach ($folder in $versionFolders) {
                $binPath = Join-Path $folder.FullName "bin"
                $exePath = Join-Path $binPath "1cv8.exe"

                if (Test-Path $exePath) {
                    $fileVersion = (Get-Item $exePath).VersionInfo.ProductVersion

                    $1cVersions += @{
                        Version = $folder.Name
                        FullPath = $folder.FullName
                        BinPath = $binPath
                        ExecutablePath = $exePath
                        FileVersion = $fileVersion
                    }
                }
            }
        }
    }

    return $1cVersions
}

function Get-1CRegistry {
    $regInfo = @{}
    $regPath = "HKLM:\Software\1C"

    if (Test-Path $regPath) {
        try {
            $regInfo | Add-Member -NotePropertyName "RegistryFound" -NotePropertyValue $true
            $defaultPath = (Get-ItemProperty -Path $regPath -ErrorAction SilentlyContinue)."Path"
            if ($defaultPath) {
                $regInfo | Add-Member -NotePropertyName "DefaultInstallPath" -NotePropertyValue $defaultPath
            }
        }
        catch {
            $regInfo | Add-Member -NotePropertyName "RegistryError" -NotePropertyValue $_.Exception.Message
        }
    }

    return $regInfo
}

function Get-1CClusterConfiguration {
    $clusterConfig = @{
        IsConfigured = $false
        ClusterServers = @()
        WorkServers = @()
    }

    $racPath = "C:\Program Files\1cv8\common\1cestart.exe"
    if (-not (Test-Path $racPath)) {
        $racPath = "C:\Program Files (x86)\1cv8\common\1cestart.exe"
    }

    if (Test-Path $racPath) {
        $clusterConfig.IsConfigured = $true
        $clusterConfig.RACPath = $racPath

        try {
            $output = & $racPath cluster list localhost 2>&1

            if ($output) {
                $clusterConfig.ClusterOutput = $output | ConvertTo-Json
            }
        }
        catch {
            $clusterConfig.RACCommandError = $_.Exception.Message
        }
    }

    return $clusterConfig
}

function Get-1CServices {
    $services = @()
    try {
        $1cServices = Get-Service -ErrorAction SilentlyContinue | Where-Object { $_.Name -like "*1cv8*" -or $_.DisplayName -like "*1C*" }
        
        foreach ($service in $1cServices) {
            $services += @{
                ServiceName = $service.Name
                DisplayName = $service.DisplayName
                Status = $service.Status.ToString()
                StartType = $service.StartType.ToString()
                ProcessID = if ($service.Status -eq "Running") { 
                    try {
                        (Get-CimInstance Win32_Service -Filter "Name='$($service.Name)'" -ErrorAction SilentlyContinue).ProcessId
                    }
                    catch { $null }
                } else { $null }
            }
        }
    }
    catch {
        # Если ошибка, возвращаем пустой массив
    }

    return @($services)  # Всегда возвращает массив (может быть пуст)
}

function Get-1CProcessMetrics {
    $metrics = @{
        RunningInstances = @()
    }

    $processes = Get-Process -Name "1cv8" -ErrorAction SilentlyContinue

    foreach ($proc in $processes) {
        try {
            $metrics.RunningInstances += @{
                ProcessID = $proc.Id
                WorkingSetMB = [math]::Round($proc.WorkingSet / 1MB, 2)
                CPU = [math]::Round($proc.CPU, 2)
                ThreadCount = $proc.Threads.Count
                StartTime = $proc.StartTime.ToString("yyyy-MM-dd HH:mm:ss")
            }
        }
        catch {
            # Пропускаем процесс если он завершился во время сбора
            continue
        }
    }

    return $metrics
}

function Get-1CNetworkPorts {
    $typicalPorts = @{
        "1540" = "Platform 1: 1C RAS (cluster server)"
        "1541" = "Platform 1: 1C RAS communication"
        "1560" = "Platform 1: 1C Application server"
        "1561" = "Platform 1: 1C backup server"
        "1640" = "Platform 2: 1C RAS (cluster server)"
        "1641" = "Platform 2: 1C RAS communication"
        "1642" = "Platform 2: 1C Application server"
        "1643" = "Platform 2: 1C backup server"
    }

    # Проверяем какие порты слушают (обе платформы)
    $typicalPortsArray = @(1540, 1541, 1560, 1561, 1640, 1641, 1642, 1643)
    $activePorts = @()
    try {
        $activePorts = Get-NetTCPConnection -State Listen -ErrorAction SilentlyContinue | 
            Where-Object { $_.LocalPort -in $typicalPortsArray } |
            Select-Object -Property LocalPort, OwningProcess -Unique |
            Sort-Object LocalPort |
            ForEach-Object { "Port $($_.LocalPort) - PID: $($_.OwningProcess)" }
    }
    catch {
        $activePorts = @()
    }

    # Возвращаем структурированный объект
    $ports = @{
        ExpectedPorts = $typicalPorts
        ActivePorts = if ($activePorts) { ($activePorts -join "`n") } else { "No active ports found" }
    }

    return $ports
}

function Get-1CDatabaseConnections {
    $dbConnections = @{
        SQLServerConnections = @()
    }

    $regPath = "HKLM:\Software\1C\1CEnterprise"

    if (Test-Path $regPath) {
        try {
            $subKeys = Get-ChildItem -Path $regPath -ErrorAction SilentlyContinue

            foreach ($key in $subKeys) {
                $connectString = (Get-ItemProperty -Path $key.PSPath -ErrorAction SilentlyContinue).ConnectionString

                if ($connectString) {
                    $dbConnections.SQLServerConnections += @{
                        RegistryPath = $key.Name
                        ConnectionString = $connectString
                    }
                }
            }
        }
        catch {
            $dbConnections.RegistryError = $_.Exception.Message
        }
    }

    return $dbConnections
}

# ============================================================================
# MAIN
# ============================================================================

Write-Host "🔍 Сбор конфигурации 1C Enterprise..." -ForegroundColor Cyan

$collectionData = @{
    CollectionTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Hostname = $env:COMPUTERNAME
    Installations = @(Get-1CInstallations)
    RegistryInfo = Get-1CRegistry
    ClusterConfiguration = Get-1CClusterConfiguration
    Services = @(Get-1CServices)
    ProcessMetrics = Get-1CProcessMetrics
    NetworkPorts = Get-1CNetworkPorts
    DatabaseConnections = Get-1CDatabaseConnections
}

# ============================================================================
# ВЫВОД РЕЗУЛЬТАТОВ
# ============================================================================

if ($OutputFormat -eq "JSON") {
    $jsonOutput = $collectionData | ConvertTo-Json -Depth 5
    
    # Создаём директорию если её нет
    $OutputDir = Split-Path -Path $OutputPath -Parent
    if (-not (Test-Path $OutputDir)) {
        New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null
    }
    
    $jsonOutput | Out-File -FilePath $OutputPath -Encoding UTF8 -Force
    Write-Host "✅ Данные сохранены в: $OutputPath" -ForegroundColor Green
    Write-Host "`n" + $jsonOutput
}
elseif ($OutputFormat -eq "CSV") {
    Write-Host "⚠️  CSV формат пока не поддерживается, используйте JSON" -ForegroundColor Yellow
}

# ============================================================================
# РЕЗЮМЕ
# ============================================================================

Write-Host "`n" + ("=" * 70) -ForegroundColor Cyan
Write-Host "📊 СВОДКА СБОРА ДАННЫХ 1C CONFIGURATION" -ForegroundColor Cyan
Write-Host "=" * 70 -ForegroundColor Cyan

Write-Host ("Версии установлены: {0}" -f $collectionData.Installations.Count)
Write-Host ("Сервисы найдены: {0}" -f $collectionData.Services.Count)
Write-Host ("Процессы 1cv8 работают: {0}" -f $collectionData.ProcessMetrics.RunningInstances.Count)
Write-Host ("Кластер настроен: {0}" -f $collectionData.ClusterConfiguration.IsConfigured)

Write-Host "`n💾 JSON экспортирован в: $OutputPath" -ForegroundColor Green
