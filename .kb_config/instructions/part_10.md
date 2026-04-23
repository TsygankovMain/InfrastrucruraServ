# ❓ Частые проблемы

{{Troubleshooting}}
```

### Шаг 2: Валидация
Перед сохранением проверь:
- [ ] YAML frontmatter соответствует `schema.yaml`
- [ ] Все ссылки на другие страницы существуют (или помечены `[TODO]`)
- [ ] Порты/адреса согласованы с `Обзор/network-map.md`
- [ ] Нет противоречий с уже задокументированными данными

### Шаг 3: Логирование
Запиши в `.kb_logs/changes.log` в формате:

```log
[2026-04-22T14:35:00Z] UPDATE | file: Инфраструктура/servers/server-1-1c.md
  - changed: services.1c.version: "8.3.x" → "8.3.25.1234"
  - added: network.ports.ras.internal: true
  - reason: User clarification via chat #42
  - diff_hash: sha256:abc123...
  - status: pending_confirmation
```

### Шаг 4: Подтверждение пользователем
Покажи пользователю **краткий дифф** и запроси явное подтверждение:

```markdown
> ✅ **Готово к сохранению:** `server-1-1c.md`

**Изменения:**
```diff
- version: "8.3.x"
+ version: "8.3.25.1234"
+ ports:
+   ras:
+     external: 1541
+     internal: true
```

**Сохранить?** (Да / Нет / Править)
```

---

