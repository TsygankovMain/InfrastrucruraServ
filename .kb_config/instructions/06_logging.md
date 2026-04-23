# 📜 Формат логов


### `.kb_logs/changes.log`
```log
# Формат: [ISO_TIMESTAMP] ACTION | file: PATH
# ACTION: CREATE | UPDATE | DELETE | ROLLBACK
# Каждая запись заканчивается status: confirmed|pending|rejected

[2026-04-22T14:35:00Z] UPDATE | file: Инфраструктура/servers/server-1-1c.md
  fields_changed:
    - path: services.1c.version
      from: "8.3.x"
      to: "8.3.25.1234"
    - path: network.ports.ras.internal
      from: null
      to: true
  source: "user_chat_session_42"
  validation: passed
  status: confirmed
---
```

### `.kb_logs/questions.log`
```log
[2026-04-22T14:30:00Z] QUESTION_SENT | session: 42
  target_file: Инфраструктура/servers/server-1-1c.md
  questions_count: 3
  topics: ["version", "network", "backup"]
  status: awaiting_response
---
[2026-04-22T14:32:15Z] QUESTION_ANSWERED | session: 42
  answers_received: 3
  next_action: generate_update
---
```

### `.kb_logs/errors.log`
```log
[2026-04-22T14:36:00Z] VALIDATION_ERROR | file: Сервисы/1c/cluster.md
  rule: "port_must_be_defined_in_firewall"
  details: "Port 1545 referenced but not found in Инфраструктура/network/firewall-rules.md"
  resolution: "Added TODO marker, requested user confirmation"
---
```

---

