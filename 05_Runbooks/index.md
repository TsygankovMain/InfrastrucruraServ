---
title: "Операционные процедуры"
slug: "runbooks-index"
status: "published"
last_updated: "2026-04-23T00:00:00Z"
updated_by: "AI-Maintainer"
tags: [runbooks, operations, procedures, automation]
related: ["05_Runbooks/deploy-new-server.md", "05_Runbooks/disaster-recovery.md"]
---

# 📖 Операционные процедуры

Пошаговые инструкции (runbooks) для типовых операций и аварийных ситуаций.

## 📋 Содержание

- [Развёртывание нового сервера](deploy-new-server.md) — процедура установки и конфигурации
- [Аварийное восстановление (DR)](disaster-recovery.md) — восстановление из резервных копий
- [Обновления и патчинг](patching-updates.md) — применение патчей и обновлений
- [Масштабирование](scaling.md) — добавление ресурсов и масштабирование

### 🔧 Вспомогательные скрипты

Смотрите папку [`scripts/`](scripts/) для автоматизированных скриптов сбора конфигурации:
- `collect-1c-config.ps1` — сбор конфигурации 1C
- `collect-1c-databases-sql.sql` — сбор информации о БД 1C
- `collect-mssql-config.ps1` — сбор конфигурации MSSQL

---

*Процедуры требуют уточнения для вашей инфраструктуры. [NEEDS_VERIFICATION] Требуется валидация всех шагов.*
