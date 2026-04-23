# Knowledge Base Validation Rules

These rules ensure data integrity and consistency across all pages.

## 1. Cross-file References

- [ ] Every link in `related: [...]` must point to an existing file
- [ ] Broken links must be marked as `[TODO]` with a note
- [ ] When renaming/moving a page, update all references

## 2. Port and Network Consistency

- [ ] All ports mentioned in service pages must exist in `Инфраструктура/network/firewall-rules.md`
- [ ] Port numbers must be valid (1-65535)
- [ ] CIDR notation must be valid (e.g., `192.168.1.0/24`)
- [ ] No port conflicts on same server (e.g., two services can't use port 1433)
- [ ] All IP addresses must use valid IPv4 format

## 3. Service Dependencies

- [ ] If Service A depends on Service B, Service B must have a page
- [ ] Circular dependencies must be documented (A→B→A)
- [ ] Missing dependencies must be marked `[PENDING]`

## 4. Server Inventory

- [ ] Every mentioned server must have a corresponding page in `Инфраструктура/servers/`
- [ ] Servers must have: hostname, primary IP, OS, contact
- [ ] No duplicate hostnames or primary IPs

## 5. Backup Requirements

- [ ] Every database server must have backup_policy defined
- [ ] Every critical service must reference backup documentation
- [ ] Backup retention must be explicitly stated (e.g., "30 days")

## 6. Monitoring Requirements

- [ ] Every production service must have monitoring configured
- [ ] Critical metrics must have alert thresholds
- [ ] Alert recipients must be documented

## 7. Access Control

- [ ] User accounts must not contain plaintext passwords
- [ ] Use placeholders: `{{SERVICE_ACCOUNT_PASSWORD}}`
- [ ] Refer to secure vault/password manager location

## 8. Frontmatter Validation

- [ ] `title` must be present and non-empty (3-100 chars)
- [ ] `slug` must match regex: `^[a-z0-9]+(-[a-z0-9]+)*$`
- [ ] `status` must be one of: draft, review, published, deprecated
- [ ] `last_updated` must be ISO 8601 format or omitted
- [ ] `related` links must use relative paths
- [ ] Deprecated pages must have deprecation note

## 9. Version and Compatibility

- [ ] 1C version must be in format: `X.Y.Z.BUILD` (e.g., 8.3.25.1234)
- [ ] MSSQL version must be valid: 2016, 2019, 2022
- [ ] OS versions must be documented (e.g., Windows Server 2022 CU5)

## 10. Documentation Completeness

For each service/server, must have:
- [ ] Basic info (name, version, location)
- [ ] Network configuration (IP, ports, firewall rules)
- [ ] Dependencies (what it needs to run)
- [ ] Monitoring (key metrics, alerts)
- [ ] Backups (frequency, retention, last test)
- [ ] Contact (responsible engineer)

---

## Running Validation

When checking a page, run through this checklist:

```bash
# Check for broken references
grep -r "\[TODO\]" Инфраструктура/ Сервисы/

# Check for plaintext passwords
grep -r "password.*=" docs/ --exclude=.kb_config

# Check port uniqueness
grep -r "port:" Сервисы/ | sort | uniq -d
```

---

## Error Categories

| Category | Severity | Auto-fix? | Example |
|----------|----------|-----------|---------|
| Broken link | HIGH | No | Page referenced in `related` doesn't exist |
| Port conflict | HIGH | No | Two services using port 1433 on same server |
| Missing dependency | MEDIUM | No | Service A needs Service B, but B has no page |
| Missing metadata | MEDIUM | Yes | `owner` field not filled in |
| Format error | MEDIUM | Yes | Port number > 65535, invalid CIDR |
| Spelling/clarity | LOW | No | Grammar errors, unclear descriptions |

---

## Reporting Validation Errors

All errors go to `.kb_logs/errors.log`:

```log
[2026-04-22T14:36:00Z] VALIDATION_ERROR | file: Сервисы/1c/cluster.md
  rule: "port_must_be_defined_in_firewall"
  details: "Port 1545 referenced but not found in Инфраструктура/network/firewall-rules.md"
  severity: HIGH
  resolution: "Added TODO marker, requested user confirmation"
  status: pending
---
```
