---
title: "Service Template"
slug: "template-service"
status: "draft"
description: "Template for documenting services/applications"
---

# Service Configuration Template

> 📝 **This is a template.** Copy and modify for each service.

## 📋 Basic Information

| Property | Value |
|----------|-------|
| **Service Name** | {{SERVICE_NAME}} |
| **Type** | {{SERVICE_TYPE}} |
| **Version** | {{VERSION}} |
| **Status** | {{ACTIVE/DEPRECATED/TESTING}} |
| **Owner/Team** | {{TEAM_OR_CONTACT}} |

## 🖥️ Deployment

### Servers & Instances

| Server | Hostname | Role | Status |
|--------|----------|------|--------|
| {{SERVER_NAME}} | {{FQDN}} | {{PRIMARY/SECONDARY/REPLICA}} | {{ACTIVE}} |

### Cluster/HA Configuration (if applicable)

- **Cluster Type:** {{STANDALONE/ACTIVE-ACTIVE/ACTIVE-PASSIVE}}
- **Load Balancer:** {{LB_NAME_OR_IP}}
- **Failover Policy:** {{AUTOMATIC/MANUAL}}
- **Heartbeat Port:** {{PORT}}

## 🌐 Network Configuration

### Ports & Protocols

| Port | Protocol | Direction | Usage | Encrypted |
|------|----------|-----------|-------|-----------|
| {{PORT}} | {{TCP/UDP/TLS}} | {{INBOUND/OUTBOUND}} | {{PURPOSE}} | {{YES/NO}} |

### Firewall Rules

See: `02_Infrastructure/network/firewall-rules.md` for detailed ACLs

### DNS & Service Discovery

- **Primary DNS Name:** {{DNS_NAME}}
- **Secondary DNS Name:** {{OPTIONAL_DNS}}
- **Service Discovery:** {{CONSUL/ETCD/NONE}}

## 🔗 Dependencies

### Upstream Services (what this service depends on)

| Service | Minimum Version | Purpose | Critical |
|---------|-----------------|---------|----------|
| {{SERVICE_NAME}} | {{MIN_VERSION}} | {{PURPOSE}} | {{YES/NO}} |

### Downstream Services (what depends on this service)

| Service | Dependency Type | Impact if Down |
|---------|-----------------|-----------------|
| {{DEPENDENT_SERVICE}} | {{OPTIONAL/REQUIRED}} | {{IMPACT}} |

## 💾 Data Management

### Database Configuration

- **Database Type:** {{MSSQL/POSTGRESQL/MONGODB/OTHER}}
- **Database Name:** {{DB_NAME}}
- **Server:** {{DB_SERVER_HOSTNAME}}
- **Port:** {{DB_PORT}}
- **Size:** {{APPROXIMATE_GB}}GB

### Data Location & Retention

- **Data Location:** {{SERVER/MOUNT_POINT}}
- **Retention Period:** {{DAYS/MONTHS}}
- **Archival Policy:** {{POLICY_DESCRIPTION}}

## 💾 Backup & Recovery

| Property | Value |
|----------|-------|
| **Backup Method** | {{FULL/INCREMENTAL/SNAPSHOT}} |
| **Tool** | {{VEEAM/SQL_AGENT/SCRIPT}} |
| **Frequency** | {{DAILY/WEEKLY}} |
| **Retention** | {{DAYS}} days |
| **Recovery Time Objective (RTO)** | {{HOURS}} |
| **Recovery Point Objective (RPO)** | {{HOURS}} |
| **Last Successful Backup** | {{DATE_TIME}} |
| **Last Recovery Test** | {{DATE}} |

## 📊 Monitoring & Performance

### Health Checks

| Check | Metric | Threshold | Interval |
|-------|--------|-----------|----------|
| {{CHECK_NAME}} | {{METRIC}} | {{THRESHOLD}} | {{INTERVAL}} |

### Key Metrics

- **Response Time:** Target < {{MS}}ms (warn > {{MS}}ms)
- **Error Rate:** Target < {{PERCENT}}% (warn > {{PERCENT}}%)
- **Availability:** Target {{PERCENT}}% uptime
- **CPU Usage:** Warn if > {{PERCENT}}%
- **Memory Usage:** Warn if > {{PERCENT}}%
- **Disk Usage:** Warn if > {{PERCENT}}%

### Alerts & Notifications

| Alert | Condition | Severity | Recipients |
|-------|-----------|----------|------------|
| {{ALERT_NAME}} | {{CONDITION}} | {{CRITICAL/WARNING}} | {{TEAM/CONTACT}} |

## 🔐 Security & Access

### Authentication

- **Type:** {{LOCAL/LDAP/OAUTH/SAML}}
- **MFA Required:** {{YES/NO}}

### Authorization

| Role | Permissions | Users/Groups |
|------|-------------|--------------|
| {{ROLE_NAME}} | {{PERMISSIONS}} | {{USERS}} |

### Credentials

> ⚠️ **Credentials stored in:** {{VAULT_LOCATION}}  
> Service Account: `{{ACCOUNT_NAME}}`  
> Access via: `{{VAULT_ID}}`

## 🚀 Operations & Procedures

### Startup/Shutdown

```bash
# Start service
{{START_COMMAND}}

# Stop service
{{STOP_COMMAND}}

# Check status
{{STATUS_COMMAND}}
```

### Common Tasks

#### Scaling
- **Horizontal Scaling:** {{METHOD}}
- **Vertical Scaling:** {{METHOD}}

#### Updates & Patching
- **Update Procedure:** {{PROCEDURE_LINK_OR_DESCRIPTION}}
- **Rollback Procedure:** {{PROCEDURE_LINK_OR_DESCRIPTION}}
- **Maintenance Window:** {{DAY}} {{TIME}} UTC

### Troubleshooting

| Issue | Symptoms | Resolution |
|-------|----------|------------|
| {{ISSUE}} | {{SYMPTOMS}} | {{SOLUTION}} |

## 📋 Configuration Files

- Config Location: `{{PATH}}`
- Owner: {{SERVICE_ACCOUNT}}
- Backup: `{{BACKUP_LOCATION}}`

### Important Parameters

```yaml
{{KEY}}: {{VALUE}}
{{KEY}}: {{VALUE}}
```

## 📚 Documentation & References

- **Official Docs:** {{LINK}}
- **Knowledge Base:** {{RELATED_KB_PAGES}}
- **Runbook:** `05_Runbooks/{{SERVICE_NAME}}.md`
- **Incident History:** {{LINK_TO_ISSUES}}

## ✅ Checklist for New Version Deployment

- [ ] Review release notes
- [ ] Test in staging environment
- [ ] Back up current version
- [ ] Plan maintenance window
- [ ] Update dependent services
- [ ] Test failover
- [ ] Update documentation
- [ ] Notify stakeholders

---

**Last Updated:** {{DATE}}  
**Updated By:** {{UPDATER}}  
**Next Review:** {{DATE}}  
**Status:** {{DRAFT/REVIEW/PUBLISHED}}
