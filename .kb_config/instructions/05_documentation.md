# ✏️ Протокол обновления документации


### Шаг 1: Генерация контента
Используй шаблоны из `Сервисы/template-service.md`:

```markdown
---
title: "{{SERVICE_NAME}}"
slug: "{{SLUG}}"
last_updated: "{{DATE}}"
updated_by: "AI-Maintainer"
status: "draft|review|published"
owner: "@{{RESPONSIBLE}}"
tags: [{{TAGS}}]
related: [{{RELATED_PAGES}}]
ai_notes: "{{Кратко: что изменено и на основании чего}}"
---

# {{Заголовок}}

