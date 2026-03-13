# 自动化工作流

这是一个自动化工作流示例，包含定时任务和事件触发。

## 项目概述

- **难度**: ⭐⭐⭐ 高级
- **功能**: 定时和数据处理自动化
- **特性**: 定时执行、条件触发、错误通知

## 项目结构

```
automation-workflow/
├── agents/
│   ├── scheduler/
│   ├── fetcher/
│   ├── processor/
│   └── notifier/
├── skills/
│   ├── scheduler/
│   ├── data-fetch/
│   ├── data-process/
│   └── notification/
├── workflows/
│   ├── daily-report.yaml
│   ├── data-sync.yaml
│   └── backup.yaml
├── cron/
│   └── jobs.yaml
└── README.md
```

## 核心功能

### 1. 定时任务

```yaml
# cron/jobs.yaml
jobs:
  - name: daily-report
    schedule: "0 9 * * *"  # 每天早上9点
    workflow: daily-report
    
  - name: hourly-sync
    schedule: "0 * * * *"  # 每小时
    workflow: data-sync
    
  - name: weekly-backup
    schedule: "0 2 * * 0"  # 每周日凌晨2点
    workflow: backup
```

### 2. 工作流定义

#### 每日报告工作流

```yaml
# workflows/daily-report.yaml
name: daily-report
version: 1.0

agents:
  - fetcher
  - processor
  - notifier

steps:
  - name: fetch-data
    agent: fetcher
    input:
      source: database
      query: daily-stats
    output:
      data: ${result.data}
      
  - name: process-data
    agent: processor
    input:
      data: ${steps.fetch-data.data}
      operations:
        - aggregate
        - calculate-trends
    output:
      report: ${result.report}
      
  - name: send-notification
    agent: notifier
    input:
      report: ${steps.process-data.report}
      recipients:
        - team@example.com
      subject: 每日报告
```

#### 数据同步工作流

```yaml
# workflows/data-sync.yaml
name: data-sync
version: 1.0

triggers:
  - schedule: "0 * * * *"
  - webhook: /api/sync

steps:
  - name: fetch-source
    agent: fetcher
    input:
      source: api-external
      
  - name: fetch-target
    agent: fetcher
    input:
      source: database
      
  - name: compare
    agent: processor
    input:
      source: ${steps.fetch-source.data}
      target: ${steps.fetch-target.data}
      
  - name: sync
    agent: processor
    condition: ${steps.compare.result.has-diff}
    input:
      changes: ${steps.compare.result.changes}
```

#### 备份工作流

```yaml
# workflows/backup.yaml
name: backup
version: 1.0

steps:
  - name: backup-files
    agent: fetcher
    input:
      source: /data
      destination: /backup/${date}
      
  - name: backup-database
    agent: fetcher
    input:
      type: database
      destination: /backup/db-${date}
      
  - name: verify-backup
    agent: processor
    input:
      backups:
        - ${steps.backup-files.result}
        - ${steps.backup-database.result}
        
  - name: cleanup-old
    agent: processor
    condition: ${steps.verify-backup.result.success}
    input:
      retention-days: 30
```

## 代理配置

### 调度代理

```yaml
# agents/scheduler/agent.yaml
name: scheduler
description: 任务调度代理

skills:
  - scheduler

config:
  max-concurrent-jobs: 5
  timezone: Asia/Shanghai
  
hooks:
  before-execute:
    - log: "Starting job ${job.name}"
  after-execute:
    - log: "Completed job ${job.name}"
    - metric: record_job_duration
```

### 数据获取代理

```yaml
# agents/fetcher/agent.yaml
name: fetcher
description: 数据获取代理

skills:
  - data-fetch

sources:
  - type: database
    config:
      connection: ${DB_CONNECTION}
  - type: api
    config:
      base-url: ${API_BASE_URL}
  - type: filesystem
    config:
      base-path: /data
```

### 数据处理代理

```yaml
# agents/processor/agent.yaml
name: processor
description: 数据处理代理

skills:
  - data-process

operations:
  - aggregate
  - filter
  - transform
  - validate
  - calculate
```

### 通知代理

```yaml
# agents/notifier/agent.yaml
name: notifier
description: 通知代理

channels:
  - email
  - webhook
  - slack
  
config:
  email:
    smtp: ${SMTP_SERVER}
  slack:
    webhook: ${SLACK_WEBHOOK}
```

## 实现代码

### 调度技能

```yaml
# skills/scheduler/SKILL.md
name: scheduler
description: 任务调度

triggers:
  - cron
  - webhook
  - event
```

```powershell
# skills/scheduler/scripts/schedule.ps1
param(
    [string]$JobName,
    [string]$Schedule,
    [hashtable]$Workflow
)

# 解析 cron 表达式
$cron = Parse-Cron $Schedule

# 调度任务
$job = @{
    name = $JobName
    schedule = $cron
    workflow = $Workflow
    enabled = $true
}

Add-ScheduledJob -Job $job

@{
    success = $true
    job = $job
} | ConvertTo-Json
```

### 数据获取技能

```yaml
# skills/data-fetch/SKILL.md
name: data-fetch
description: 从各种来源获取数据
```

```powershell
# skills/data-fetch/scripts/fetch.ps1
param(
    [string]$Source,
    [hashtable]$Config
)

$result = switch ($Source) {
    "database" {
        # 数据库查询
        Query-Database -Config $Config
    }
    "api" {
        # API 请求
        Invoke-RestMethod -Uri $Config.url -Method Get
    }
    "filesystem" {
        # 文件读取
        Get-Content -Path $Config.path -Raw
    }
}

@{
    data = $result
    source = $Source
    timestamp = Get-Date -Format "o"
} | ConvertTo-Json
```

### 数据处理技能

```yaml
# skills/data-process/SKILL.md
name: data-process
description: 数据处理和分析
```

```powershell
# skills/data-process/scripts/process.ps1
param(
    [array]$Data,
    [string[]]$Operations
)

$processed = $Data

foreach ($op in $Operations) {
    $processed = switch ($op) {
        "aggregate" { $processed | Group-Object | ForEach-Object { $_.Count } }
        "filter" { $processed | Where-Object { $_.active -eq $true } }
        "calculate-trends" { Calculate-Trends -Data $processed }
    }
}

@{
    result = $processed
    operations = $Operations
} | ConvertTo-Json
```

### 通知技能

```yaml
# skills/notification/SKILL.md
name: notification
description: 发送通知
```

```powershell
# skills/notification/scripts/notify.ps1
param(
    [string]$Channel,
    [string]$Message,
    [string[]]$Recipients
)

switch ($Channel) {
    "email" {
        Send-MailMessage -To $Recipients -Body $Message
    }
    "slack" {
        Invoke-RestMethod -Uri $Webhook -Method Post -Body @{ text = $Message }
    }
}

@{
    success = $true
    channel = $Channel
    recipients = $Recipients.Count
} | ConvertTo-Json
```

## 监控和告警

### 监控配置

```yaml
# monitoring.yaml
monitoring:
  metrics:
    - job-execution-time
    - job-success-rate
    - data-processed-count
    - notification-delivery-rate
    
  alerts:
    - condition: job-failure-rate > 0.1
      severity: high
      channels:
        - email
        - slack
        
    - condition: execution-time > 300
      severity: medium
      channels:
        - slack
```

### 日志配置

```yaml
logging:
  level: info
  
  outputs:
    - type: file
      path: /logs/automation
      
    - type: cloudwatch
      log-group: automation-workflow
      
  retention: 30 days
```

## 部署

### Docker Compose

```yaml
version: '3.8'
services:
  openclaw:
    image: openclaw:latest
    volumes:
      - ./agents:/app/agents
      - ./skills:/app/skills
      - ./workflows:/app/workflows
    environment:
      - DB_CONNECTION=...
      - API_BASE_URL=...
      
  scheduler:
    image: openclaw-scheduler:latest
    depends_on:
      - openclaw
```

## 扩展建议

1. **添加更多触发器**
   - 文件变化
   - 消息队列
   - 自定义事件

2. **添加工作流版本控制**
   - 回滚能力
   - 灰度发布

3. **添加更多数据源**
   - S3
   - Google Sheets
   - FTP

## 相关文档

- [简单聊天机器人](../simple-chatbot/)
- [代码审查系统](../code-review-system/)
- [技能开发](../../02-skills/)
