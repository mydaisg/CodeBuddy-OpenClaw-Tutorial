# 基础技能开发

本目录包含 OpenClaw 基础技能的开发和实现。

## 目录内容

- [README.md](./README.md) - 基础技能概述
- [hello-world/](hello-world/) - Hello World 示例
- [file operations/](file-operations/) - 文件操作技能
- [web-request/](web-request/) - HTTP 请求技能

## 快速开始

### 1. 创建技能目录
```bash
mkdir skills/my-skill
mkdir skills/my-skill/scripts
mkdir skills/my-skill/references
```

### 2. 编写 SKILL.md
```markdown
# 我的技能

描述：技能功能描述

激活条件：用户提到关键词

## 工具
- read: 读取文件
- write: 写入文件
- exec: 执行命令

## 使用示例
```
用户输入 → 技能处理 → 返回结果
```
```

### 3. 编写执行脚本
```bash
# scripts/run.sh
echo "Skill executed!"
```

## 示例 1: Hello World 技能

完整的 Hello World 技能示例。

### 项目结构
```
hello-world/
├── SKILL.md
└── scripts/
    └── hello.sh
```

### SKILL.md
```markdown
# Hello World 技能

描述：最简单的技能示例，输出问候信息

激活条件：用户提到 "hello" 或 "你好"

## 工具
- exec: 执行 shell 命令

## 执行脚本
运行 `scripts/hello.sh`
```

### hello.sh
```bash
#!/bin/bash
echo "Hello from OpenClaw Skill!"
echo "Current time: $(date)"
```

## 示例 2: 文件操作技能

### 项目结构
```
file-operations/
├── SKILL.md
└── scripts/
    ├── read-file.ps1
    └── write-file.ps1
```

### SKILL.md
```markdown
# 文件操作技能

描述：读取和写入文件

激活条件：用户请求文件操作

## 工具
- read: 读取文件内容
- write: 写入文件内容

## 参数
- action: 操作类型 (read/write)
- path: 文件路径
- content: 写入内容 (write 时使用)
```

### read-file.ps1
```powershell
param(
    [Parameter(Mandatory=$true)]
    [string]$Path
)

if (Test-Path $Path) {
    Get-Content $Path -Raw
} else {
    Write-Error "File not found: $Path"
}
```

### write-file.ps1
```powershell
param(
    [Parameter(Mandatory=$true)]
    [string]$Path,
    
    [Parameter(Mandatory=$true)]
    [string]$Content
)

$Content | Out-File -FilePath $Path -Encoding UTF8
Write-Output "File written: $Path"
```

## 示例 3: Web 请求技能

### 项目结构
```
web-request/
├── SKILL.md
└── scripts/
    └── http-get.ps1
```

### SKILL.md
```markdown
# Web 请求技能

描述：发起 HTTP 请求

激活条件：用户请求获取网页内容

## 工具
- exec: 执行 HTTP 请求
```

### http-get.ps1
```powershell
param(
    [Parameter(Mandatory=$true)]
    [string]$Url
)

try {
    $response = Invoke-WebRequest -Uri $Url -Method GET
    @{
        status = $response.StatusCode
        content = $response.Content
    } | ConvertTo-Json
} catch {
    @{
        error = $_.Exception.Message
    } | ConvertTo-Json
}
```

## 基础规范

### 命名规范
- 技能目录: `kebab-case`
- 脚本文件: `kebab-case.ps1` 或 `kebab-case.sh`
- SKILL.md: 固定名称

### 错误处理
```powershell
try {
    # 执行操作
} catch {
    Write-Error $_.Exception.Message
    exit 1
}
```

### 日志输出
```bash
echo "[INFO] Starting skill..."
echo "[ERROR] Error message"
```

## 下一步

- 学习 [高级技能开发](../advanced/)
- 学习 [自定义技能](../custom/)
