# 工作流编排

本目录包含工作流编排的实现和最佳实践。

## 概述

工作流编排定义和管理多代理任务的执行顺序和条件。

## 工作流定义

### 基本结构

```yaml
name: my-workflow
version: 1.0.0

# 工作流元数据
metadata:
  description: 示例工作流
  author: openclaw-team

# 定义代理
agents:
  - id: fetcher
    type: data-fetcher
  - id: processor
    type: data-processor
  - id: reporter
    type: report-generator

# 定义步骤
steps:
  - name: fetch-data
    agent: fetcher
    input:
      source: database
    output:
      data: ${result.data}
      
  - name: process-data
    agent: processor
    input:
      data: ${steps.fetch-data.data}
    output:
      processed: ${result.processed}
      
  - name: generate-report
    agent: reporter
    input:
      data: ${steps.process-data.processed}
```

## 步骤类型

### 1. 顺序步骤

```yaml
steps:
  - name: step-1
    agent: agent-a
  - name: step-2
    agent: agent-b
    depends_on: step-1
```

### 2. 并行步骤

```yaml
steps:
  - name: parallel-a
    agent: agent-a
    run_with: [parallel-b, parallel-c]
    
  - name: parallel-b
    agent: agent-b
    
  - name: parallel-c
    agent: agent-c
```

### 3. 条件步骤

```yaml
steps:
  - name: decide
    agent: decision-agent
    output:
      action: ${result.action}
      
  - name: action-a
    agent: agent-a
    condition: ${steps.decide.action} == "A"
    
  - name: action-b
    agent: agent-b
    condition: ${steps.decide.action} == "B"
```

### 4. 循环步骤

```yaml
steps:
  - name: process-items
    agent: processor
    loop:
      over: ${input.items}
      as: item
      until: ${result.complete}
      max-iterations: 10
```

## 错误处理

### 重试策略

```yaml
error_handling:
  retry:
    enabled: true
    max-attempts: 3
    strategy: exponential-backoff
    initial-delay: 1s
    max-delay: 60s
    
  on-retry:
    - log: "Retrying step ${step.name}"
    - notify: alert-channel
```

### 降级处理

```yaml
error_handling:
  fallback:
    enabled: true
    
    steps:
      - name: primary-fallback
        agent: fallback-agent-a
      - name: secondary-fallback
        agent: fallback-agent-b
        
  on-failure:
    - log: "Workflow failed"
    - notify: admin
    - cleanup: true
```

### 超时处理

```yaml
steps:
  - name: long-running-task
    agent: processor
    timeout: 300s  # 5分钟
    
    on-timeout:
      - cancel: true
      - notify: timeout-channel
```

## 数据传递

### 变量引用

```yaml
steps:
  - name: step-1
    agent: agent-a
    output:
      result-a: ${result.data}
      
  - name: step-2
    agent: agent-b
    input:
      from-step-1: ${steps.step-1.result-a}
```

### 数据转换

```yaml
transforms:
  - input: ${steps.step-1.raw-data}
    output: transformed
    script: |
      return {
        cleaned: input.clean(),
        validated: input.validate()
      }
```

## 事件和触发

### 工作流事件

```yaml
events:
  on-start:
    - log: "Workflow started"
    
  on-step-complete:
    - log: "Step ${step.name} completed"
    - metric: record_step_duration
    
  on-complete:
    - log: "Workflow completed"
    - notify: success-channel
    
  on-failure:
    - log: "Workflow failed: ${error}"
    - notify: failure-channel
```

### 外部触发

```yaml
triggers:
  - type: schedule
    cron: "0 9 * * *"  # 每天9点
    
  - type: webhook
    path: /api/trigger
    methods: [POST]
    
  - type: event
    source: external-system
    event: data-updated
```

## 监控和日志

### 状态追踪

```yaml
monitoring:
  track-state: true
  state-store: redis
  
  checkpoints:
    - after: every-step
    - on-error: always
```

### 指标收集

```yaml
metrics:
  - step_duration
  - step_success_rate
  - workflow_duration
  - retry_count
  
  export:
    - type: prometheus
      endpoint: /metrics
    - type: cloudwatch
      namespace: OpenClaw
```

## 高级特性

### 子工作流

```yaml
steps:
  - name: subworkflow
    workflow: sub-workflow-name
    input:
      data: ${input.data}
    output:
      result: ${result}
```

### 并发控制

```yaml
concurrency:
  max-parallel: 5
  
  resources:
    - name: database-connection
      max: 10
      
    - name: api-rate-limit
      max: 100
```

### 版本控制

```yaml
versioning:
  enabled: true
  
  strategies:
    - type: rollback
      auto: false
    - type: canary
      traffic: 10%
```

## 最佳实践

1. **步骤精简**: 每个步骤只做一件事
2. **清晰依赖**: 明确定义步骤间的依赖关系
3. **错误处理**: 为每个步骤定义错误处理策略
4. **日志记录**: 记录足够的日志便于调试
5. **超时设置**: 设置合理的超时时间
6. **可观测性**: 集成监控和告警

## 相关文档

- [代理协作](../agent-coordination/)
- [通信模式](../communication-patterns/)
