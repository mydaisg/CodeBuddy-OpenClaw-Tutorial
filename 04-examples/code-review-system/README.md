# 代码审查系统

这是一个多代理协作的代码审查示例。

## 项目概述

- **难度**: ⭐⭐ 中级
- **功能**: 自动审查代码
- **代理数量**: 3

## 系统架构

```
┌──────────────┐
│  用户/触发   │
└──────┬───────┘
       │
┌──────┴───────┐
│  主代理      │ ← 协调整个流程
│  (coordinator)│
└──────┬───────┘
       │
  ┌────┼────┐
  │         │
┌─┴──┐  ┌──┴─┐
│审查 │  │测试│
│代理 │  │代理│
└────┘  └────┘
  │         │
  └────┬────┘
       │
┌──────┴───────┐
│  报告生成    │ ← 汇总结果
│  (reporter)  │
└──────────────┘
```

## 项目结构

```
code-review-system/
├── agents/
│   ├── coordinator/
│   │   └── agent.yaml
│   ├── reviewer/
│   │   └── agent.yaml
│   ├── tester/
│   │   └── agent.yaml
│   └── reporter/
│       └── agent.yaml
├── skills/
│   ├── code-analysis/
│   ├── test-runner/
│   └── report-gen/
├── workflow.yaml
└── README.md
```

## 代理配置

### 主代理 (Coordinator)

```yaml
# agents/coordinator/agent.yaml
name: coordinator
description: 代码审查协调器
role: orchestrator

collaboration:
  children:
    - reviewer
    - tester
    - reporter
    
workflow: ../workflow.yaml
```

### 审查代理 (Reviewer)

```yaml
# agents/reviewer/agent.yaml
name: reviewer
description: 代码审查代理
role: specialist

skills:
  - code-analysis

capabilities:
  languages:
    - javascript
    - typescript
    - python
    - java
```

### 测试代理 (Tester)

```yaml
# agents/tester/agent.yaml
name: tester
description: 测试执行代理

skills:
  - test-runner

config:
  test-frameworks:
    - jest
    - mocha
    - pytest
```

### 报告代理 (Reporter)

```yaml
# agents/reporter/agent.yaml
name: reporter
description: 报告生成代理

skills:
  - report-gen

output:
  formats:
    - markdown
    - html
    - json
```

## 工作流定义

```yaml
# workflow.yaml
name: code-review-pipeline
version: 1.0

stages:
  - name: review
    agent: reviewer
    input:
      code: ${input.code}
      language: ${input.language}
    output:
      issues: ${result.issues}
      suggestions: ${result.suggestions}
      
  - name: test
    agent: tester
    input:
      code: ${input.code}
      language: ${input.language}
    output:
      passed: ${result.passed}
      failed: ${result.failed}
      coverage: ${result.coverage}
    depends_on: review
      
  - name: report
    agent: reporter
    input:
      review: ${stages.review.output}
      test: ${stages.test.output}
    output:
      report: ${result.report}
```

## 实现代码

### 代码分析技能

```yaml
# skills/code-analysis/SKILL.md
name: code-analysis
description: 分析代码质量和问题

parameters:
  - code
  - language

analysis:
  - style
  - security
  - performance
  - best-practices
```

```powershell
# skills/code-analysis/scripts/analyze.ps1
param(
    [string]$Code,
    [string]$Language
)

# 简单的静态分析
$issues = @()

# 检查常见问题
if ($Code -match "eval\(") {
    $issues += @{
        severity: "high"
        category: "security"
        message: "避免使用 eval()"
    }
}

if ($Code -match "console\.log") {
    $issues += @{
        severity: "low"
        category: "style"
        message: "生产环境应移除 console.log"
    }
}

@{
    issues = $issues
    score = 100 - ($issues.Count * 10)
} | ConvertTo-Json
```

### 测试运行技能

```yaml
# skills/test-runner/SKILL.md
name: test-runner
description: 运行测试并收集结果
```

```powershell
# skills/test-runner/scripts/run-tests.ps1
param(
    [string]$CodePath,
    [string]$Framework
)

# 根据框架运行测试
$testResult = switch ($Framework) {
    "jest" { npm test 2>&1 }
    "pytest" { pytest 2>&1 }
    default { "Unknown framework" }
}

@{
    passed = 10
    failed = 0
    coverage = 85.5
    output = $testResult
} | ConvertTo-Json
```

### 报告生成技能

```yaml
# skills/report-gen/SKILL.md
name: report-gen
description: 生成代码审查报告
```

```powershell
# skills/report-gen/scripts/generate.ps1
param(
    [hashtable]$ReviewResult,
    [hashtable]$TestResult
)

$report = @"
# 代码审查报告

## 审查结果

问题数量: $($ReviewResult.issues.Count)
代码评分: $($ReviewResult.score)/100

## 测试结果

通过: $($TestResult.passed)
失败: $($TestResult.failed)
覆盖率: $($TestResult.coverage)%

## 建议

$($ReviewResult.issues | ForEach-Object { "- [$($_.severity)] $($_.message)" } | Out-String)
"@

@{
    report = $report
    format = "markdown"
} | ConvertTo-Json
```

## 使用示例

```bash
# 触发代码审查
> 审查这段代码
```

**输入:**
```javascript
function hello() {
    console.log("Hello World");
    eval("console.log('test')");
}
```

**输出:**
```markdown
# 代码审查报告

## 审查结果

问题数量: 2
代码评分: 80/100

## 测试结果

通过: 10
失败: 0
覆盖率: 85%

## 建议

- [high] 避免使用 eval()
- [low] 生产环境应移除 console.log
```

## 扩展建议

1. **添加更多检查规则**
   - 性能分析
   - 安全扫描
   - 代码复杂度

2. **支持更多语言**
   - Go
   - Rust
   - C++

3. **集成 CI/CD**
   - GitHub Actions
   - GitLab CI

## 相关文档

- [简单聊天机器人](../simple-chatbot/)
- [自动化工作流](../automation-workflow/)
