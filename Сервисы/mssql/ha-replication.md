---
title: "MSSQL High Availability и репликация"
slug: "mssql-ha-replication"
status: "draft"
last_updated: "2026-04-23T00:00:00Z"
updated_by: "AI-Maintainer"
owner: "@DBA Team"
tags: [mssql, ha, replication, failover, disaster-recovery]
related: ["Сервисы/mssql/server-instances.md", "Инфраструктура/storage/backup-policy.md"]
ai_notes: "[NEEDS_DEFINITION] Требуется информация о HA стратегии"
order: 3
---

# MSSQL High Availability

## Текущая конфигурация HA

| Компонент | Тип | Статус |
|-----------|-----|--------|
| Always On Availability Groups | [PENDING] | [PENDING] |
| Database Mirroring | [PENDING] | [PENDING] |
| Transactional Replication | [PENDING] | [PENDING] |
| Log Shipping | [PENDING] | [PENDING] |

## Always On Availability Groups (если используется)

| AG Name | Primary | Secondary | Sync Mode | Statuses |
|---------|---------|-----------|-----------|----------|
| [PENDING] | [PENDING] | [PENDING] | [PENDING] | [PENDING] |

## Database Mirroring (если используется)

| БД | Principal | Mirror | Failover | Статус |
|----|-----------|--------|----------|--------|
| [PENDING] | [PENDING] | [PENDING] | [PENDING] | [PENDING] |

## Failover Cluster (если используется)

| Параметр | Значение |
|----------|----------|
| Cluster Name | [PENDING] |
| Nodes | [PENDING] |
| Failover Time | [PENDING] seconds |
| Statuses | [PENDING] |

## Replication Configuration

### Publishers

| Publisher | БД | Type | Статус |
|-----------|----|----|--------|
| [PENDING] | [PENDING] | [PENDING] | [PENDING] |

### Subscribers

| Subscriber | Publication | Type | Статус |
|-----------|-------------|------|--------|
| [PENDING] | [PENDING] | [PENDING] | [PENDING] |

## Log Shipping (если используется)

| Primary | Secondary | Backup Share | Статус |
|---------|-----------|--------------|--------|
| [PENDING] | [PENDING] | [PENDING] | [PENDING] |

## Monitoring & Alerts

| Метрика | Порог | Триггер |
|---------|-------|---------|
| Replication Latency | [PENDING] secs | [PENDING] |
| Failover Time | [PENDING] secs | [PENDING] |
| Transaction Log Size | [PENDING] MB | [PENDING] |

[NEEDS_DEFINITION] — требуется определить HA стратегию (All-On / Mirroring / Replication)
