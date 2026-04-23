# 🧠 Онтология и семантика (`.kb_config/ontology.yaml`)


Чтобы ты понимал связи между сущностями, используй эту схему:

```yaml
entities:
  Server:
    attributes:
      - hostname: string (required)
      - ip_primary: string (required)
      - os: enum[WindowsServer2019, WindowsServer2022, AlmaLinux9, ...]
      - roles: list[Service]
      - contacts: string (responsible person)
    relations:
      - hosts: Service (1..*)
      - connected_to: NetworkSegment
      - monitored_by: MonitoringSystem

  Service:
    attributes:
      - name: string (required)
      - type: enum[1CServer, MSSQL, Zabbix, IIS, ...]
      - version: string
      - port: list[PortConfig]
      - dependencies: list[Service]
    relations:
      - runs_on: Server
      - communicates_with: Service
      - exposed_via: NetworkEndpoint

  PortConfig:
    attributes:
      - port: integer (1-65535)
      - protocol: enum[TCP, UDP]
      - direction: enum[inbound, outbound, bidirectional]
      - source_restriction: string (CIDR or "any")
      - encrypted: boolean

validation_rules:
  - "Every Service.port must be documented in Инфраструктура/network/firewall-rules.md"
  - "If Service.dependencies includes X, then X must have a page in Сервисы/"
  - "Server with role 'DB' must have backup-policy linked in Инфраструктура/storage/"
```

---

