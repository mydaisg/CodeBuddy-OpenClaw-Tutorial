# 示例代码 (Examples)

实际项目示例，帮助理解 OpenClaw 的使用。

## 项目列表

| 项目 | 难度 | 描述 |
|------|------|------|
| [简单聊天机器人](./simple-chatbot/) | ⭐ 入门级 | 最基础的对话代理 |
| [代码审查系统](./code-review-system/) | ⭐⭐ 中级 | 多代理协作的代码审查 |
| [自动化工作流](./automation-workflow/) | ⭐⭐⭐ 高级 | 定时任务和自动化流程 |

## 示例 1: 简单聊天机器人

### 概述
- **代理数量**: 1
- **功能**: 处理日常对话
- **技能**: conversation

### 关键文件
```
simple-chatbot/
├── agents/chat/agent.yaml
├── skills/conversation/SKILL.md
└── prompts/system.md
```

### 学习要点
- 代理配置基础
- 技能定义
- 对话提示设计

## 示例 2: 代码审查系统

### 概述
- **代理数量**: 4
- **功能**: 自动代码审查和测试
- **技能**: 代码分析、测试运行、报告生成

### 系统架构
```
Coordinator → Reviewer ─┐
              → Tester  ─┼→ Reporter
```

### 关键文件
```
code-review-system/
├── agents/{coordinator,reviewer,tester,reporter}/
├── skills/{code-analysis,test-runner,report-gen}/
└── workflow.yaml
```

### 学习要点
- 多代理协作
- 工作流编排
- 结果聚合

## 示例 3: 自动化工作流

### 概述
- **代理数量**: 4
- **功能**: 定时数据处理和通知
- **特性**: 定时任务、工作流、监控

### 工作流类型
1. **每日报告**: 定时生成报告
2. **数据同步**: 定期同步数据
3. **备份**: 自动备份

### 关键文件
```
automation-workflow/
├── agents/{scheduler,fetcher,processor,notifier}/
├── workflows/{daily-report,data-sync,backup}.yaml
├── cron/jobs.yaml
└── monitoring.yaml
```

### 学习要点
- Cron 定时任务
- 事件驱动工作流
- 监控和告警

## 使用建议

### 学习顺序
1. 先学习 [简单聊天机器人](./simple-chatbot/) - 理解基础
2. 再学 [代码审查系统](./code-review-system/) - 理解协作
3. 最后学 [自动化工作流](./automation-workflow/) - 掌握高级功能

### 实践建议
1. **动手修改**: 基于示例修改配置
2. **添加功能**: 为示例添加新功能
3. **组合使用**: 将多个示例组合

## 相关文档

- [技能开发](../02-skills/) - 技能详细指南
- [多代理系统](../03-multiagent/) - 多代理架构
- [代码规范](../01-rules/code-standards.md) - 开发规范
