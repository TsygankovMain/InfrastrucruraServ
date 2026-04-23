---
title: "SAN конфигурация и хранилище"
slug: "san-config"
status: "draft"
last_updated: "2026-04-23T00:00:00Z"
updated_by: "AI-Maintainer"
owner: "@Storage Team"
tags: [san, storage, disk-arrays, lun]
related: ["Инфраструктура/storage/backup-policy.md"]
ai_notes: "[NEEDS_DATA] Требуется информация о SAN и дисковых массивах"
---

# SAN конфигурация

## Текущее хранилище (PVD-1C)

Согласно AIDA64 отчёту:

| Диск | Тип | Ёмкость | Скорость | Статус |
|------|-----|---------|----------|--------|
| HGST HUS726T6TALE6L4 | HDD SATA | 6 TB | 7200 RPM | [PENDING] |
| INTEL SSDSC2KG019T8 | SSD SATA | 1.92 TB | NVMe | [PENDING] |
| INTEL SSDSC2KG019T8 | SSD SATA | 1.92 TB | NVMe | [PENDING] |
| INTEL SSDSC2KG240G8 | SSD SATA | 240 GB | SATA-III | [PENDING] |
| INTEL SSDSC2KG480G8 | SSD SATA | 480 GB | SATA-III | [PENDING] |

**Всего:** 10.62 TB

## Размещение хранилища

### OS & Application Tier
- **Диск:** SSD 480 GB
- **Используется для:** Windows Server 2025 + 1C Enterprise
- **Требуемое место:** [PENDING]

### Database Tier
- **Диск:** SSD 1.92 TB x2 (RAID 1 или RAID 10)
- **Используется для:** MSSQL Data files
- **Требуемое место:** [PENDING]

### Transaction Log Tier
- **Диск:** SSD 240 GB
- **Используется для:** MSSQL Transaction logs
- **Требуемое место:** [PENDING]

### Backup Tier
- **Диск:** HDD 6 TB
- **Используется для:** Локальные резервные копии
- **Требуемое место:** [PENDING]

## RAID Configuration

| Уровень | Тип | Диски | Объём | Отказоустойчивость | Статус |
|---------|-----|-------|-------|-------------------|--------|
| RAID 0 | Striping | [PENDING] | [PENDING] | Нет | [PENDING] |
| RAID 1 | Mirroring | [PENDING] | [PENDING] | 1 диск | [PENDING] |
| RAID 5 | Striping + Parity | [PENDING] | [PENDING] | 1 диск | [PENDING] |
| RAID 10 | 1+0 | [PENDING] | [PENDING] | 2 диска | [PENDING] |

## LUN Mapping

| LUN | Размер | Назначение | Сервер | Статус |
|-----|--------|-----------|--------|--------|
| [PENDING] | [PENDING] | [PENDING] | [PENDING] | [PENDING] |

## Мониторинг хранилища

- **S.M.A.R.T. статус:** OK (согласно AIDA64)
- **Утилизация диска:** [PENDING]
- **Скорость I/O:** [PENDING]
- **Алерты:** [PENDING]

[NEEDS_DATA] — требуется информация о RAID конфиге и расположении данных
