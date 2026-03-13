# OpenClaw 目录结构规范

## 核心目录结构

```
~/.openclaw/
├── agents/                    # 代理配置和状态
│   ├── main/                  # 主代理
│   └── [agent-id]/           # 其他代理
├── workspace/                 # 工作区文件
│   ├── AGENTS.md
│   ├── BOOTSTRAP.md
│   └── [其他文档]
├── logs/                     # 日志文件
│   └── [按日期组织的日志]
├── identity/                # 身份认证
│   └── [身份配置文件]
├── devices/                 # 设备管理
│   └── [设备配置文件]
├── canvas/                  # 画布相关
├── completions/             # 命令补全
├── cron/                    # 定时任务
└── [其他功能目录]
```

## 教程项目结构

```
D:/CodeBuddy-OpenClaw-Tutorial/
├── 01-rules/                 # 规则和规范
│   ├── README.md
│   ├── naming-conventions.md
│   ├── code-standards.md
│   └── directory-structure.md
├── 02-skills/               # 技能开发
│   ├── basic-skills/
│   ├── advanced-skills/
│   └── custom-skills/
├── 03-multiagent/           # 多代理系统
│   ├── agent-coordination/
│   ├── workflow-orchestration/
│   └── communication-patterns/
├── 04-examples/            # 实际示例
│   ├── simple-chatbot/
│   ├── code-review-system/
│   └── automation-workflows/
├── 02-setup/               # 安装配置
├── 03-basic-usage/         # 基础使用
├── 04-advanced-features/   # 高级功能
├── 05-troubleshooting/     # 故障排除
└── examples/               # 示例代码
```

## 目录组织原则

### 功能分组
- 按功能模块组织目录
- 相关文件放在同一目录下
- 避免过深的目录嵌套

### 命名约定
- 使用小写字母
- 使用连字符分隔单词
- 避免特殊字符和空格

### 文件管理
- 配置文件使用 `.json` 扩展名
- 脚本文件使用适当的扩展名
- 文档文件使用 `.md` 扩展名

## 最佳实践

1. **一致性**: 在整个项目中保持目录结构一致
2. **模块化**: 每个目录应有明确的职责
3. **可扩展性**: 设计时考虑未来的扩展需求
4. **文档化**: 每个目录应有 README 文件说明其用途