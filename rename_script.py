import os
import re

# Map of old paths to new paths
moves = {
    "Обзор/index.md": "Обзор.md",
    "Инфраструктура/network/index.md": "Инфраструктура/network.md",
    "Инфраструктура/storage/index.md": "Инфраструктура/storage.md",
    "Сервисы/1c/index.md": "Сервисы/1c.md",
    "Сервисы/mssql/index.md": "Сервисы/mssql.md",
    "Доступ/index.md": "Доступ.md",
    "Ранбуки/index.md": "Ранбуки.md"
}

# Execute moves
for old, new in moves.items():
    if os.path.exists(old):
        print(f"Moving {old} to {new}")
        os.rename(old, new)
    else:
        print(f"File {old} does not exist.")

# Create missing index files
creations = {
    "Инфраструктура.md": "---\ntitle: \"Инфраструктура\"\norder: 2\n---\n\n# Инфраструктура\n\nРаздел содержит информацию о физических и виртуальных серверах, сетях и хранилищах.\n",
    "Инфраструктура/servers.md": "---\ntitle: \"Серверы\"\norder: 1\n---\n\n# Серверы\n\nРаздел содержит реестр серверов инфраструктуры.\n",
    "Сервисы.md": "---\ntitle: \"Сервисы\"\norder: 3\n---\n\n# Сервисы\n\nРаздел содержит документацию по развернутым сервисам и платформам.\n",
    "Сервисы/monitoring.md": "---\ntitle: \"Мониторинг\"\norder: 3\n---\n\n# Мониторинг\n\nДокументация по системам мониторинга (Zabbix и др.).\n"
}

for filepath, content in creations.items():
    if not os.path.exists(filepath):
        print(f"Creating {filepath}")
        os.makedirs(os.path.dirname(filepath) or '.', exist_ok=True)
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content)

# Update markdown links across all .md files
def update_links(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    
    old_content = content
    # Replace links to index.md with parent.md
    # E.g. [Link](Обзор/index.md) -> [Link](Обзор.md)
    # E.g. [Link](../Обзор/index.md) -> [Link](../Обзор.md)
    content = re.sub(r'(?<=[\(\[])([\.a-zA-Z0-9_/-]+?)/index\.md(?=[\)\]#])', r'\1.md', content)
    
    if content != old_content:
        print(f"Updated links in {filepath}")
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content)

for root, _, files in os.walk("."):
    if ".git" in root or ".kb" in root:
        continue
    for file in files:
        if file.endswith(".md"):
            update_links(os.path.join(root, file))

