import os
import re
import shutil

os.makedirs(".kb_config/instructions", exist_ok=True)

with open("KB_MAINTAINER.md", "r", encoding="utf-8") as f:
    content = f.read()

# Split by "## "
parts = re.split(r'\n## ', content)

intro = parts[0]
sections = parts[1:]

files_map = [
    ("01_principles.md", "🎯 Твоя роль и принципы работы"),
    ("02_structure.md", "📁 Обязательная структура репозитория"),
    ("03_workflow.md", "🔄 Рабочий цикл: как ты обрабатываешь ввод пользователя"),
    ("04_questions.md", "❓ Протокол уточняющих вопросов"),
    ("05_documentation.md", "✏️ Протокол обновления документации"),
    ("06_logging.md", "📜 Формат логов"),
    ("07_ontology.md", "🧠 Онтология и семантика"),
    ("08_security.md", "🛡️ Правила безопасности и целостности"),
    ("09_first_run.md", "🚀 Первый запуск: чек-лист для тебя"),
    ("10_troubleshooting.md", "🆘 Если что-то пошло не так")
]

# Write index.md
index_content = """---
title: "Навигация по инструкциям AI"
---

# 🤖 Инструкции для AI-администратора базы знаний

Этот раздел содержит внутренние инструкции и правила ведения базы знаний, скрытые от читателей портала Gramax.

## Навигация

"""

for filename, title in files_map:
    index_content += f"- [{title}]({filename})\n"

index_content += "- [Опросник для пользователя](../QUESTIONNAIRE.md)\n"

with open(".kb_config/instructions/index.md", "w", encoding="utf-8") as f:
    f.write(index_content)

# Process sections
for i, section in enumerate(sections):
    lines = section.split('\n')
    title = lines[0].strip()
    body = '\n'.join(lines[1:])
    
    # find filename
    filename = f"part_{i}.md"
    for fname, ftitle in files_map:
        if ftitle in title or title.startswith(ftitle) or ftitle.startswith(title[:10]):
            filename = fname
            break
            
    with open(f".kb_config/instructions/{filename}", "w", encoding="utf-8") as f:
        f.write(f"# {title}\n\n{body}\n")

print("Created instructions in .kb_config/instructions/")

# Move QUESTIONNAIRE.md
if os.path.exists("QUESTIONNAIRE.md"):
    shutil.move("QUESTIONNAIRE.md", ".kb_config/QUESTIONNAIRE.md")
    print("Moved QUESTIONNAIRE.md to .kb_config/")

# Remove original KB_MAINTAINER.md
if os.path.exists("KB_MAINTAINER.md"):
    os.remove("KB_MAINTAINER.md")
    print("Removed KB_MAINTAINER.md")

