# 高级技能开发

本目录包含 OpenClaw 高级技能的开发指南。

## 目录内容

- [README.md](./README.md) - 高级技能概述
- [conditional-triggers/](conditional-triggers/) - 条件触发
- [tool-permissions/](tool-permissions/) - 工具权限控制
- [context-passing/](context-passing/) - 上下文传递

## 高级特性

### 1. 条件触发

技能可以根据复杂条件触发。

```yaml
触发条件:
  - 条件: 用户提到 {topic}
    额外: mood == "happy"
  - 条件: 用户请求 {action}
    额外: priority >= 5
```

#### 示例：天气查询技能

```yaml
# weather-skill/SKILL.md
name: weather-query
description: 查询天气信息

激活条件: |
  用户提到 "天气" 或 "weather"
  且 城市参数 存在

参数:
  - name: city
    type: string
    required: true
    description: 城市名称
  - name: format
    type: string
    default: "detail"
    description: 输出格式 (detail/simple)
```

### 2. 工具权限控制

精细控制技能可以使用的工具。

```yaml
tools:
  allowed:
    - read
    - write
  denied:
    - exec
  limits:
    exec:
      max-duration: 30
      allowed-commands:
        - git
        - npm
        - node
```

#### 示例：安全文件读取

```yaml
# safe-read/SKILL.md
name: safe-file-read
description: 安全读取文件

tools:
  allowed:
    - read
  denied: []
  limits:
    read:
      max-size: 1MB
      allowed-paths:
        - ${workspace}/**
        - ${home}/docs/**
      denied-paths:
        - ${workspace}/.openclaw/**
        - **/.env
```

### 3. 上下文传递

技能可以访问和传递上下文信息。

```yaml
context:
  # 可用的上下文变量
  available:
    - session.history      # 会话历史
    - user.preferences    # 用户偏好
    - project.config      # 项目配置
    - agent.capabilities  # 代理能力
  
  # 需要传递到下一步的数据
  output:
    - result.data         # 执行结果
    - result.metadata     # 元数据
```

#### 示例：数据分析技能

```yaml
# data-analysis/SKILL.md
name: data-analysis
description: 数据分析技能

context:
  available:
    - input.data          # 输入数据
    input:
      type: json
      schema:
        fields: array
        format: table
  
  output:
    - analysis.summary    # 分析摘要
    - analysis.charts   # 图表数据

处理流程:
  1. 验证输入数据
  2. 执行分析
  3. 生成报告
```

### 4. 链式执行

技能可以串联执行。

```yaml
chaining:
  # 前置技能
  requires:
    - data-validation
  
  # 执行后触发
  triggers-on-complete:
    - report-generator
    - notification-sender
  
  # 失败时触发
  triggers-on-failure:
    - error-handler
    - admin-alert
```

### 5. 异步执行

长时间运行的任务可以使用异步模式。

```yaml
async:
  enabled: true
  timeout: 300  # 5分钟
  
  # 进度报告
  progress:
    enabled: true
    interval: 10  # 每10%报告一次
  
  # 取消支持
  cancellable: true
```

#### 示例：批量处理技能

```yaml
# batch-process/SKILL.md
name: batch-process
description: 批量处理文件

async:
  enabled: true
  timeout: 600

parameters:
  - name: files
    type: array
    required: true
  - name: operation
    type: string
    enum: [compress, encrypt, copy]

progress:
  format: "已处理 {completed}/{total} 个文件"
  
result:
  successful: array
  failed: array
  summary: object
```

## 高级模式

### 状态机

技能可以建模为状态机。

```yaml
stateMachine:
  initial: idle
  
  states:
    idle:
      on: start -> processing
    
    processing:
      on: 
        progress -> processing
        complete -> completed
        error -> error
    
    completed:
      on: reset -> idle
    
    error:
      on: retry -> processing
      on: reset -> idle

  handlers:
    on_enter_processing:
      - log: "开始处理"
      - init_progress
```

### 事件驱动

技能可以监听和触发事件。

```yaml
events:
  listen:
    - user.joined
    - task.completed
    - data.updated
  
  emit:
    - skill.started
    - skill.completed
    - skill.failed

handlers:
  on_user.joined:
    - welcome_user
    - update_stats
  
  on_task.completed:
    - notify_user
    - log_completion
```

### 插件式架构

技能可以支持插件扩展。

```yaml
plugins:
  enabled: true
  
  # 内置插件
  built-in:
    - logging
    - metrics
    - cache
  
  # 自定义插件
  custom:
    - path: ./plugins/custom-plugin
      enabled: true
      config:
        option1: value1
```

## 最佳实践

### 1. 错误处理

```yaml
errorHandling:
  retry:
    max-attempts: 3
    strategy: exponential-backoff
    on-retry: log_retry_info
  
  fallback:
    enabled: true
    action: return_default_value
  
  recovery:
    enabled: true
    strategies:
      - use_cache
      - use_alternative
```

### 2. 性能优化

```yaml
performance:
  caching:
    enabled: true
    ttl: 3600
    key: ${input.hash}
  
  batching:
    enabled: true
    batch-size: 100
    timeout: 5000
  
  limits:
    max-memory: 512MB
    max-cpu: 50%
```

### 3. 监控和日志

```yaml
monitoring:
  metrics:
    - execution_time
    - success_rate
    - error_count
  
  logging:
    level: info
    destinations:
      - file
      - stdout
      - remote
```

## 下一步

- 学习 [自定义技能开发](../custom/)
- 参考 [示例代码](../../04-examples/)
- 查看 [API 文档](../../05-api/)
