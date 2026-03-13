# 技能 (Skills)

技能是 OpenClaw 的扩展能力模块，让 AI 能够执行特定任务。

## 目录结构

```
02-skills/
├── README.md              # 本文件 - 技能概述
├── basic/                 # 基础技能开发
│   ├── README.md
│   ├── hello-world/       # Hello World 示例
│   ├── file-operations/   # 文件操作技能
│   └── web-request/      # HTTP 请求技能
├── advanced/              # 高级技能开发
│   ├── README.md
│   ├── conditional-triggers/   # 条件触发
│   ├── tool-permissions/      # 工具权限控制
│   └── context-passing/        # 上下文传递
└── custom/               # 自定义技能开发
    ├── README.md
    ├── database-manager/  # 数据库管理示例
    ├── api-gateway/      # API 网关示例
    └── scheduler/        # 定时任务示例
```

## 学习路径

### 阶段一：基础技能
学习创建简单技能：
- [基础技能开发指南](./basic/README.md)
- 技能结构
- SKILL.md 格式
- 简单示例

### 阶段二：高级技能
掌握复杂技能开发：
- [高级技能开发指南](./advanced/README.md)
- 条件触发
- 工具权限
- 异步执行

### 阶段三：自定义技能
创建完全自定义的技能：
- [自定义技能开发指南](./custom/README.md)
- 项目结构
- 完整示例
- 测试和发布

## 快速开始

```bash
# 1. 创建技能目录
mkdir skills/my-skill

# 2. 编写 SKILL.md
# 见 basic/README.md 示例

# 3. 编写执行脚本
# scripts/main.ps1 或 main.sh

# 4. 注册技能
# 在 openclaw.json 中添加技能配置
```

## 相关文档

- [01-rules/](../01-rules/) - 开发规范
- [03-multiagent/](../03-multiagent/) - 多代理系统
- [04-examples/](../04-examples/) - 示例代码
