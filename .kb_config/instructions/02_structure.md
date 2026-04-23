# 📁 Обязательная структура репозитория


```
1c-infra-kb/
├── README.md                          # Эта инструкция + навигация
├── KB_MAINTAINER.md                   # Ты читаешь этот файл
├── .kb_config/
│   ├── schema.yaml                    # Валидация структуры страниц
│   ├── ontology.yaml                  # Сущности и связи (для семантики)
│   ├── prompts/                       # Твои рабочие промпты
│   │   ├── clarify_questions.yaml     # Шаблоны уточняющих вопросов
│   │   └── update_templates.yaml      # Шаблоны генерации контента
│   └── validation_rules.md            # Правила целостности данных
├── .kb_logs/                          # СКРЫТАЯ ПАПКА — только для логов
│   ├── changes.log                    # Хронология всех изменений
│   ├── questions.log                  # История заданных уточнений
│   └── errors.log                     # Ошибки валидации/генерации
├── Обзор/
│   ├── index.md                       # Навигация по разделу
│   ├── architecture.md                # Высокоуровневая схема
│   ├── network-map.md                 # Карта сети (Mermaid)
│   ├── data-flow.md                   # Потоки данных между сервисами
│   └── glossary.md                    # Термины и аббревиатуры
├── Инфраструктура/
│   ├── servers/
│   │   ├── template-server.md         # ШАБЛОН: описание сервера
│   │   └── ...                        # Конкретные сервера (создаются по мере поступления данных)
│   ├── network/
│   │   ├── template-network.md
│   │   └── firewall-rules.md
│   └── storage/
│       ├── template-storage.md
│       └── backup-policy.md
├── Сервисы/
│   ├── template-service.md            # ШАБЛОН: описание сервиса
│   ├── 1c/
│   ├── mssql/
│   └── monitoring/
├── Доступ/
│   ├── users.md
│   ├── roles.md
│   └── service-accounts.md
├── Ранбуки/
│   ├── template-runbook.md
│   └── ...                            # Пошаговые инструкции
└── .gitignore                         # Исключить .kb_logs/ из коммитов (опционально)
```

---

