---
title: "Шаблон: Документация сервера"
slug: "template-server"
status: "draft"
description: "Template for documenting individual servers"
order: 99
---

# Шаблон: Документация сервера

> 📝 **This is a template.** Copy and modify for each new server.

## 📋 Basic Information

| Property | Value |
|----------|-------|
| **Server Name** | {{HOSTNAME}} |
| **FQDN** | {{FQDN}} |
| **Primary IP** | {{IP_PRIMARY}} |
| **Secondary IP** | {{IP_SECONDARY_OR_NONE}} |
| **Location** | {{DATACENTER_OR_LOCATION}} |
| **Contact** | {{RESPONSIBLE_ENGINEER}} |

## 💻 Hardware & OS

| Property | Value |
|----------|-------|
| **Operating System** | {{OS_NAME_VERSION}} |
| **CPU Cores** | {{CPU_COUNT}} |
| **Memory (RAM)** | {{RAM_GB}}GB |
| **Storage** | {{DISK_SIZE_GB}}GB {{DISK_TYPE}} |
| **Created/Deployed** | {{DATE}} |

## 🔧 Services Running

List all services hosted on this server:

| Service | Version | Port(s) | Status |
|---------|---------|---------|--------|
| {{SERVICE_NAME}} | {{VERSION}} | {{PORTS}} | {{ACTIVE/INACTIVE}} |

**Dependencies:**
- This server depends on: {{LIST_DEPENDENT_SERVICES}}
- {{RELATED_SERVERS}} depend on this server

## 🌐 Network Configuration

### IP Configuration
```
Interface: {{INTERFACE_NAME}}
  Primary IP: {{IP_PRIMARY}}/{{CIDR}}
  Gateway: {{GATEWAY_IP}}
  DNS Servers: {{DNS_PRIMARY}}, {{DNS_SECONDARY}}
```

### Firewall Rules
> See: `Инфраструктура/network/firewall-rules.md` for detailed rules

| Port | Protocol | Direction | From/To | Purpose |
|------|----------|-----------|---------|---------|
| {{PORT}} | {{TCP/UDP}} | {{INBOUND/OUTBOUND}} | {{SOURCE/DEST}} | {{PURPOSE}} |

## 💾 Backup Configuration

| Property | Value |
|----------|-------|
| **Backup Method** | {{FULL/INCREMENTAL/DIFFERENTIAL/SNAPSHOT}} |
| **Tool/Agent** | {{VEEAM/SQL_AGENT/SCRIPT/OTHER}} |
| **Frequency** | {{DAILY/WEEKLY/ON_DEMAND}} |
| **Time of Backup** | {{HH:MM UTC}} |
| **Retention Period** | {{DAYS}} days |
| **Storage Location** | {{LOCAL/NAS/CLOUD}} |
| **Last Successful Backup** | {{DATE_TIME}} |
| **Last Recovery Test** | {{DATE}} |

## 📊 Monitoring & Alerts

### Key Metrics
- CPU Usage: Alert if > {{THRESHOLD}}%
- Memory Usage: Alert if > {{THRESHOLD}}%
- Disk Usage: Alert if > {{THRESHOLD}}%
- {{CUSTOM_METRIC}}: Alert if {{CONDITION}}

### Alert Recipients
- Primary: {{PRIMARY_CONTACT}} ({{EMAIL}})
- Secondary: {{SECONDARY_CONTACT}} ({{EMAIL}})
- Escalation: {{ESCALATION_TEAM}}

## 🔑 Access & Credentials

| Account | Type | Purpose | Access Level |
|---------|------|---------|--------------|
| {{ACCOUNT_NAME}} | {{SERVICE/ADMIN}} | {{PURPOSE}} | {{ROLE}} |

> ⚠️ **Credentials stored in:** {{VAULT_LOCATION}}  
> Use: `{{CREDENTIAL_ID}}` to retrieve from secure storage

## 🛠️ Maintenance Windows

- **Regular Updates:** {{DAY}} {{TIME}} UTC
- **Patching Cycle:** {{FREQUENCY}}
- **Last Update:** {{DATE}}

## 📝 Additional Notes

{{ANY_SPECIFIC_NOTES}}

---

**Last Updated:** {{LAST_UPDATE_DATE}}  
**Updated By:** {{UPDATER_NAME}}  
**Status:** {{DRAFT/REVIEW/PUBLISHED}}
