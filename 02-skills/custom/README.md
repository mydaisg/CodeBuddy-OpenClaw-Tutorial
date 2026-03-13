# 自定义技能开发

本目录包含创建完全自定义技能的指南。

## 概述

自定义技能让你可以：
- 定义全新的功能
- 集成外部系统
- 实现复杂业务逻辑
- 创建领域特定的解决方案

## 创建自定义技能的步骤

### 1. 规划技能

在创建之前，明确：
- 技能的目标和用途
- 触发条件
- 需要的能力（工具）
- 输入输出格式
- 错误处理策略

### 2. 创建项目结构

```bash
my-custom-skill/
├── SKILL.yaml           # 技能定义
├── README.md            # 说明文档
├── scripts/             # 执行脚本
│   ├── main.ps1        # 主入口
│   ├── lib/            # 库文件
│   └── utils/          # 工具函数
├── tests/              # 测试
│   └── test-main.ps1
└── config/             # 配置文件
    └── defaults.yaml
```

### 3. 编写 SKILL.yaml

```yaml
# my-custom-skill/SKILL.yaml
apiVersion: openclaw.dev/v1
kind: Skill

metadata:
  name: my-custom-skill
  version: 1.0.0
  description: 自定义技能描述
  author: your-name
  tags:
    - custom
    - example

spec:
  # 触发条件
  triggers:
    - type: keyword
      pattern: "(我的技能|custom skill)"
    - type: intent
      name: custom_action
  
  # 输入参数
  parameters:
    - name: action
      type: string
      required: true
      enum: [create, update, delete, list]
    - name: target
      type: string
      required: false
    - name: options
      type: object
      required: false
  
  # 工具权限
  capabilities:
    tools:
      allowed:
        - read
        - write
        - exec
      denied: []
    
    resources:
      memory: 256MB
      timeout: 30s
  
  # 脚本入口
  entrypoint: scripts/main.ps1
  
  # 环境变量
  environment:
    SKILL_MODE: production
    DEBUG: "false"
  
  # 依赖
  dependencies:
    - name: common-lib
      path: ./scripts/lib/common.ps1
    - external:
        npm:
          - axios
```

### 4. 编写主脚本

```powershell
# my-custom-skill/scripts/main.ps1
param(
    [Parameter(Mandatory=$true)]
    [string]$Action,
    
    [Parameter(Mandatory=$false)]
    [string]$Target,
    
    [Parameter(Mandatory=$false)]
    [hashtable]$Options
)

# 导入依赖
. "$PSScriptRoot/lib/common.ps1"

# 初始化日志
$Logger = New-Logger -SkillName "my-custom-skill"

try {
    $Logger.Info("Starting skill with action: $Action")
    
    # 验证输入
    if (-not (Test-Input -Action $Action -Target $Target)) {
        throw "Invalid input parameters"
    }
    
    # 执行操作
    $result = switch ($Action) {
        "create"  { New-Item -Target $Target -Options $Options }
        "update"  { Update-Item -Target $Target -Options $Options }
        "delete"  { Remove-Item -Target $Target }
        "list"    { Get-Items -Options $Options }
        default   { throw "Unknown action: $Action" }
    }
    
    # 返回结果
    @{
        success = $true
        data    = $result
        action  = $Action
    } | ConvertTo-Json
    
} catch {
    $Logger.Error("Skill failed: $_")
    
    @{
        success = $false
        error   = $_.Exception.Message
    } | ConvertTo-Json
    
    exit 1
}
```

### 5. 添加工具库

```powershell
# my-custom-skill/scripts/lib/common.ps1

function New-Logger {
    param([string]$SkillName)
    
    return @{
        Info    = { param($m) Write-Host "[INFO] $m" }
        Warn    = { param($m) Write-Host "[WARN] $m" }
        Error   = { param($m) Write-Host "[ERROR] $m" }
    }
}

function Test-Input {
    param($Action, $Target)
    
    $validActions = @("create", "update", "delete", "list")
    
    if ($Action -notin $validActions) {
        return $false
    }
    
    if ($Action -ne "list" -and -not $Target) {
        return $false
    }
    
    return $true
}

function New-Item {
    param($Target, $Options)
    
    Write-Host "Creating: $Target"
    return @{
        id      = [guid]::NewGuid().ToString()
        target  = $Target
        status  = "created"
        options = $Options
    }
}

function Update-Item {
    param($Target, $Options)
    
    Write-Host "Updating: $Target"
    return @{
        target  = $Target
        status  = "updated"
        options = $Options
    }
}

function Remove-Item {
    param($Target)
    
    Write-Host "Deleting: $Target"
    return @{
        target  = $Target
        status  = "deleted"
    }
}

function Get-Items {
    param($Options)
    
    Write-Host "Listing items"
    return @{
        items = @()
        count = 0
    }
}
```

## 示例项目

### 示例 1: 数据库管理技能

```yaml
# database-manager/SKILL.yaml
name: database-manager
description: 数据库管理技能

parameters:
  - name: operation
    type: string
    enum: [query, insert, update, delete, backup]
  - name: table
    type: string
  - name: data
    type: object

capabilities:
  tools:
    allowed: [exec, read]
    denied: []
```

### 示例 2: API 网关技能

```yaml
# api-gateway/SKILL.yaml
name: api-gateway
description: API 请求代理

parameters:
  - name: method
    type: string
    enum: [GET, POST, PUT, DELETE]
  - name: endpoint
    type: string
  - name: headers
    type: object
  - name: body
    type: object
```

### 示例 3: 定时任务技能

```yaml
# scheduler/SKILL.yaml
name: scheduler
description: 定时任务调度

parameters:
  - name: schedule
    type: string
    description: Cron 表达式
  - name: task
    type: string
  - name: enabled
    type: boolean
    default: true
```

## 测试

### 单元测试

```powershell
# tests/test-main.ps1

describe "my-custom-skill" {
    it "should create item" {
        $result = & "$PSScriptRoot/../scripts/main.ps1" `
            -Action "create" `
            -Target "test-item"
        
        $result | ConvertFrom-Json | Should -Not -BeNullOrEmpty
    }
    
    it "should list items" {
        $result = & "$PSScriptRoot/../scripts/main.ps1" `
            -Action "list"
        
        $result | ConvertFrom-Json | Should -Not -BeNullOrEmpty
    }
}
```

## 打包和发布

### 打包技能

```bash
# 打包为 zip
Compress-Archive -Path ./my-custom-skill -DestinationPath ./my-custom-skill.zip
```

### 发布到技能市场

```yaml
# package.json
{
  "name": "my-custom-skill",
  "version": "1.0.0",
  "openclaw": {
    "skill": {
      "entry": "scripts/main.ps1"
    }
  }
}
```

## 最佳实践

1. **模块化设计**: 分离关注点，使用库文件
2. **错误处理**: 总是处理异常，提供有意义的错误信息
3. **日志记录**: 记录关键操作，便于调试
4. **测试覆盖**: 为关键功能编写测试
5. **文档完善**: 详细说明参数和使用方法
6. **版本管理**: 遵循语义化版本号

## 相关文档

- [基础技能](../basic/)
- [高级技能](../advanced/)
- [代码规范](../../01-rules/code-standards.md)
