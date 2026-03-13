# 多智能体系统 (Multi-Agent)

多智能体系统让多个 AI 代理协同工作，完成复杂任务。

## 目录结构

```
03-multiagent/
├── README.md                        # 本文件 - 概述
├── agent-coordination/              # 代理协作
│   └── README.md                   # 协作模式详解
├── workflow-orchestration/          # 工作流编排
│   └── README.md                   # 工作流实现指南
└── communication-patterns/          # 通信模式
    └── README.md                   # 通信协议详解
```

## 核心概念

### 代理 (Agent)
- 独立的 AI 实体
- 有自己的角色和能力
- 可以与其他代理通信

### 会话 (Session)
- 代理工作的上下文
- 包含历史消息和状态

### 编排 (Orchestration)
- 协调多个代理的工作
- 管理代理间的通信
- 处理错误和异常

## 学习路径

### 阶段一：代理协作
学习多代理如何协同：
- [代理协作指南](./agent-coordination/README.md)
- 主从/对等/层级模式
- 任务分配和结果汇总
- 冲突解决

### 阶段二：工作流编排
掌握任务流程管理：
- [工作流编排指南](./workflow-orchestration/README.md)
- 顺序/并行/条件/循环步骤
- 错误处理和重试
- 数据传递

### 阶段三：通信模式
理解代理间通信：
- [通信模式指南](./communication-patterns/README.md)
- 请求-响应/发布-订阅/消息队列
- 可靠性保证
- 安全和监控

## 协作模式

### 1. 顺序执行
```
用户 → Agent A → Agent B → Agent C → 用户
```

### 2. 并行执行
```
用户 → Agent A ─┬→ 用户
            Agent B ─┘
            Agent C ─┘
```

### 3. 循环迭代
```
用户 → Agent A → 评估 → 反馈 → Agent A → ... → 用户
```

## 快速开始

```yaml
# 1. 定义代理
agents:
  - id: main
    role: coordinator
  - id: worker-a
    role: processor
  - id: worker-b
    role: processor

# 2. 定义工作流
workflow:
  name: example-pipeline
  steps:
    - agent: worker-a
    - agent: worker-b
      depends_on: worker-a
```

## 相关文档

- [02-skills/](../02-skills/) - 技能开发
- [04-examples/](../04-examples/) - 示例代码
- [01-rules/](../01-rules/) - 开发规范
