---
title: "Инструкция и скрипты для автоматизации сбора данных"
slug: "automation-data-collection"
status: "published"
last_updated: "2026-04-23T00:00:00Z"
updated_by: "AI-Maintainer"
tags: [automation, powershell, data-collection, scripting]
---

# 🤖 Автоматизация сбора данных инфраструктуры

Используйте эти PowerShell скрипты для автоматизированного сбора технических данных и заполнения Knowledge Base.

---

## 📋 Обзор доступных скриптов

| Скрипт | Назначение | Выход |
|--------|-----------|-------|
| `Collect-SystemInfo.ps1` | Информация о ПК (CPU, RAM, ОС, Диск) | JSON / CSV |
| `Collect-NetworkConfig.ps1` | Сетевая конфигурация (IP, DNS, Firewall) | JSON / CSV |
| `Collect-MSSQLConfig.ps1` | MSSQL конфигурация (версия, БД, параметры) | JSON / CSV |
| `Collect-1CConfig.ps1` | 1C Enterprise конфигурация | JSON / CSV |
| `Collect-AllData.ps1` | Комбинированный скрипт (все выше) | HTML Report + JSON |

---

## 🛠️ СКРИПТ 1: Системная информация

**Файл:** `Collect-SystemInfo.ps1`

```powershell
<#
.SYNOPSIS
    Собирает информацию о системе (CPU, RAM, Диск, ОС, Network)

.DESCRIPTION
    Этот скрипт собирает детальную информацию о сервере и экспортирует в JSON

.PARAMETER OutputPath
    Путь для сохранения результата (по умолчанию C:\Reports\)

.PARAMETER Format
    Формат вывода: JSON или CSV (по умолчанию JSON)

.EXAMPLE
    .\Collect-SystemInfo.ps1 -OutputPath "C:\Reports" -Format JSON
#>

param(
    [string]$OutputPath = "C:\Reports",
    [ValidateSet("JSON", "CSV")]
    [string]$Format = "JSON"
)

# Создать папку если не существует
if (-not (Test-Path $OutputPath)) {
    New-Item -ItemType Directory -Path $OutputPath -Force | Out-Null
}

Write-Host "🔍 Сбор системной информации..." -ForegroundColor Cyan

# ===== ОСНОВНАЯ ИНФОРМАЦИЯ =====
$SystemInfo = @{
    Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    ComputerName = $env:COMPUTERNAME
    Domain = $env:USERDOMAIN
    UserName = $env:USERNAME
}

# ===== ОС =====
$OS = Get-CimInstance -ClassName Win32_OperatingSystem
$OSInfo = @{
    OSName = $OS.Caption
    OSVersion = $OS.Version
    BuildNumber = $OS.BuildNumber
    ServicePackMajorVersion = $OS.ServicePackMajorVersion
    InstallDate = $OS.InstallDate
    LastBootUpTime = $OS.LastBootUpTime
}

# ===== CPU =====
$CPU = Get-CimInstance -ClassName Win32_Processor
$CPUInfo = @{
    Manufacturer = $CPU.Manufacturer
    Name = $CPU.Name
    NumberOfCores = $CPU.NumberOfCores
    NumberOfLogicalProcessors = $CPU.NumberOfLogicalProcessors
    MaxClockSpeed = "$($CPU.MaxClockSpeed) MHz"
}

# ===== ПАМЯТЬ =====
$Memory = Get-CimInstance -ClassName Win32_ComputerSystem
$RAM = Get-CimInstance -ClassName Win32_PhysicalMemory
$MemoryInfo = @{
    TotalPhysicalMemory_GB = [math]::Round($Memory.TotalPhysicalMemory / 1GB, 2)
    InstalledRAM_GB = [math]::Round(($RAM | Measure-Object -Property Capacity -Sum).Sum / 1GB, 2)
    AvailableMemory_MB = [math]::Round((Get-Counter -Counter "\Memory\Available MBytes" | Select-Object -ExpandProperty CounterSamples).CookedValue, 2)
}

# ===== ДИСКИ =====
$Disks = Get-Volume | Where-Object {$_.DriveLetter}
$DiskInfo = @()
foreach ($Disk in $Disks) {
    $DiskInfo += @{
        DriveLetter = $Disk.DriveLetter
        FriendlyName = $Disk.FriendlyName
        SizeGB = [math]::Round($Disk.Size / 1GB, 2)
        FreeSpaceGB = [math]::Round($Disk.SizeRemaining / 1GB, 2)
        UsagePercent = [math]::Round(100 - (($Disk.SizeRemaining / $Disk.Size) * 100), 2)
        FileSystem = $Disk.FileSystem
    }
}

# ===== СЕТЬ =====
$NetworkAdapters = Get-NetAdapter | Where-Object {$_.Status -eq "Up"}
$NetworkInfo = @()
foreach ($Adapter in $NetworkAdapters) {
    $IPConfig = Get-NetIPConfiguration -InterfaceAlias $Adapter.Name
    $NetworkInfo += @{
        InterfaceName = $Adapter.Name
        Description = $Adapter.InterfaceDescription
        Status = $Adapter.Status
        IPv4Address = ($IPConfig.IPv4Address.IPAddress | Select-Object -First 1)
        IPv4Gateway = ($IPConfig.IPv4DefaultGateway.NextHop | Select-Object -First 1)
        IPv6Address = ($IPConfig.IPv6Address.IPAddress | Select-Object -First 1)
        DNSServers = (Get-DnsClientServerAddress -InterfaceAlias $Adapter.Name).ServerAddresses -join ", "
        MacAddress = $Adapter.MacAddress
    }
}

# ===== SERVICE PACKS И ОБНОВЛЕНИЯ =====
$Hotfixes = Get-HotFix | Sort-Object -Property InstalledOn -Descending | Select-Object -First 10
$UpdateInfo = @{
    InstalledHotfixes = @()
}
foreach ($HF in $Hotfixes) {
    $UpdateInfo.InstalledHotfixes += @{
        KB = $HF.HotFixID
        Description = $HF.Description
        InstalledDate = $HF.InstalledOn
    }
}

# ===== СЛУЖБА WINDOWS =====
$Services = @("MSSQLSERVER", "1C:Enterprise*", "Zabbix Agent", "WinRM", "RDP") | 
    ForEach-Object { Get-Service -Name $_ -ErrorAction SilentlyContinue }
$ServiceInfo = @()
foreach ($Service in $Services) {
    if ($Service) {
        $ServiceInfo += @{
            Name = $Service.Name
            DisplayName = $Service.DisplayName
            Status = $Service.Status
            StartType = $Service.StartType
        }
    }
}

# ===== СОБРАТЬ ВСЁ В ОДИН ОБЪЕКТ =====
$Report = @{
    System = $SystemInfo
    OS = $OSInfo
    CPU = $CPUInfo
    Memory = $MemoryInfo
    Disks = $DiskInfo
    Network = $NetworkInfo
    Updates = $UpdateInfo
    Services = $ServiceInfo
}

# ===== СОХРАНИТЬ РЕЗУЛЬТАТ =====
$Timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$OutputFile = Join-Path $OutputPath "SystemInfo_$Timestamp.$($Format.ToLower())"

switch ($Format) {
    "JSON" {
        $Report | ConvertTo-Json -Depth 10 | Out-File -FilePath $OutputFile -Encoding UTF8
        Write-Host "✅ JSON отчёт сохранён: $OutputFile" -ForegroundColor Green
    }
    "CSV" {
        # Для CSV создаём несколько файлов для разных секций
        $Report.Disks | Export-Csv -Path "$($OutputFile -replace '.csv', '_Disks.csv')" -NoTypeInformation -Encoding UTF8
        $Report.Network | Export-Csv -Path "$($OutputFile -replace '.csv', '_Network.csv')" -NoTypeInformation -Encoding UTF8
        $Report.Services | Export-Csv -Path "$($OutputFile -replace '.csv', '_Services.csv')" -NoTypeInformation -Encoding UTF8
        Write-Host "✅ CSV отчёты сохранены в $OutputPath" -ForegroundColor Green
    }
}

Write-Host "`n📊 Сводка:`n" -ForegroundColor Yellow
Write-Host "  Компьютер: $($SystemInfo.ComputerName)" 
Write-Host "  ОС: $($OSInfo.OSName) Build $($OSInfo.BuildNumber)"
Write-Host "  CPU: $($CPUInfo.Name) ($($CPUInfo.NumberOfCores) cores)"
Write-Host "  RAM: $($MemoryInfo.TotalPhysicalMemory_GB) GB"
Write-Host "  Диски: $($DiskInfo.Count) (Всего: $([math]::Round(($DiskInfo | Measure-Object -Property SizeGB -Sum).Sum, 2)) GB)"
Write-Host "  Сетевые интерфейсы: $($NetworkInfo.Count)"
Write-Host "  Служб запущено: $($ServiceInfo.Count)"
