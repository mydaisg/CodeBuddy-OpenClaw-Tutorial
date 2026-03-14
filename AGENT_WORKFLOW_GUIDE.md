# CodeBuddy Agent 团队工作指南

## 🎯 如何让 Agent 团队协同工作

本指南详细说明如何在 CodeBuddy 中启动和管理多 Agent 团队的协同工作。

## 📋 前置准备

### 1. 确认配置状态

#### 检查 Agent 列表
```bash
# 在 CodeBuddy 中确认以下 Agent 已启用：
- Tai_ProductManager (产品经理)
- Tai_SystemAnalyst (系统分析师)
- Tai_Architect (架构师)
- Tai_Developer (开发工程师)
- Tai_Tester (测试工程师)
- Tai_DevOps (DevOps 工程师)
- Tai_Documenter (文档工程师)
- Tai_UserAgent (用户代理)
```

#### 验证 Home 目录
```bash
# 确认每个 Agent 的 Home 目录存在：
- 03-multiagent/Tai_ProductManager_Home/
- 03-multiagent/Tai_SystemAnalyst_Home/
- 03-multiagent/Tai_Architect_Home/
- 03-multiagent/Tai_Developer_Home/
- 03-multiagent/Tai_Tester_Home/
- 03-multiagent/Tai_DevOps_Home/
- 03-multiagent/Tai_Documenter_Home/
- 03-multiagent/Tai_UserAgent_Home/
```

### 2. 创建共享目录（首次使用）

#### 创建共享空间
```bash
# 创建 Agent 之间的文件共享目录
mkdir 03-multiagent/shared/
mkdir 03-multiagent/shared/messages/
mkdir 03-multiagent/shared/resources/
mkdir 03-multiagent/shared/outputs/
```

#### 创建说明文件
```bash
# 创建共享目录说明
echo "# Shared Directory

此目录用于 Agent 之间的文件共享和消息传递。

## 子目录说明
- messages/: Agent 之间的消息传递
- resources/: 共享资源和参考文件
- outputs/: 共享的工作成果

## 文件命名规则
[发起方Agent]_[接收方Agent]_[文件描述]_[时间戳].ext

示例: Tai_Architect_Tai_Developer_system_design_20260313.md
" > 03-multiagent/shared/README.md
```

## 🚀 启动 Agent 团队工作

### 方法一：通过 Task 工具启动（推荐）

#### 1. 启动单个 Agent
```javascript
// 使用 task 工具启动指定的 Agent
const agent = await task({
  subagent_name: "Tai_ProductManager",
  description: "收集项目需求",
  prompt: "请为以下项目收集和整理需求：[项目描述]"
});
```

#### 2. 启动多个 Agent（并行）
```javascript
// 并行启动多个 Agent
const pmAgent = await task({
  subagent_name: "Tai_ProductManager",
  description: "需求分析",
  prompt: "收集项目需求并生成需求文档"
});

const saAgent = await task({
  subagent_name: "Tai_SystemAnalyst",
  description: "系统分析",
  prompt: "分析业务流程和数据流"
});

// 等待两个 Agent 完成任务
await Promise.all([pmAgent, saAgent]);
```

#### 3. 使用团队模式（高级）
```javascript
// 创建团队并设置成员
const team = await team_create({
  team_name: "development-team",
  description: "软件开发团队"
});

// 启动团队成员
const pmMember = await task({
  subagent_name: "Tai_ProductManager",
  team_name: "development-team",
  name: "product-manager",
  prompt: "作为产品经理，开始需求收集工作"
});

const devMember = await task({
  subagent_name: "Tai_Developer",
  team_name: "development-team",
  name: "developer",
  prompt: "作为开发工程师，等待需求文档"
});
```

### 方法二：通过 send_message 工具协作

#### 1. Agent 之间发送消息
```javascript
// Agent A 向 Agent B 发送消息
await send_message({
  type: "message",
  recipient: "Tai_Developer",
  content: "需求文档已完成，请查看 shared/requirements.md",
  summary: "需求文档完成通知"
});
```

#### 2. 广播消息
```javascript
// 向所有团队成员发送广播
await send_message({
  type: "broadcast",
  content: "项目启动，请各 Agent 准备就绪",
  summary: "项目启动通知"
});
```

#### 3. 请求关闭
```javascript
// 请求关闭某个 Agent
await send_message({
  type: "shutdown_request",
  recipient: "Tai_Developer",
  content: "开发任务已完成，可以关闭",
  summary: "关闭开发者 Agent"
});
```

## 📝 标准工作流程

### 完整开发流程示例

#### 阶段 1: 需求分析和规划
```javascript
// 步骤 1: 产品经理收集需求
const requirements = await task({
  subagent_name: "Tai_ProductManager",
  description: "需求收集",
  prompt: `请为"在线文档管理系统"项目收集需求：
1. 用户需要在线编辑文档
2. 支持多用户协作
3. 需要版本控制
4. 需要权限管理

请生成详细的需求文档，保存在你的 outputs/ 目录中。`
});

// 步骤 2: 将需求文档共享给其他 Agent
await write_to_file({
  filePath: "03-multiagent/shared/requirements.md",
  content: "需求文档内容..."
});

// 步骤 3: 通知系统分析师和架构师
await send_message({
  type: "broadcast",
  content: "需求文档已生成在 shared/requirements.md，请查看",
  summary: "需求文档就绪"
});
```

#### 阶段 2: 系统分析和架构设计
```javascript
// 步骤 1: 系统分析师读取需求
const analysis = await task({
  subagent_name: "Tai_SystemAnalyst",
  description: "系统分析",
  prompt: `请阅读 shared/requirements.md 中的需求文档，
然后进行系统分析，包括：
1. 业务流程分析
2. 数据流分析
3. 用例建模
4. 接口定义

将分析结果保存在你的 outputs/ 目录中。`
});

// 步骤 2: 架构师进行架构设计
const architecture = await task({
  subagent_name: "Tai_Architect",
  description: "架构设计",
  prompt: `基于需求文档（shared/requirements.md）和系统分析结果，
设计系统架构，包括：
1. 技术栈选型
2. 系统模块设计
3. 数据库设计
4. API 设计

将架构文档保存在你的 outputs/ 目录中。`
});

// 步骤 3: 共享设计文档
await write_to_file({
  filePath: "03-multiagent/shared/system_design.md",
  content: "系统设计文档..."
});

await send_message({
  type: "message",
  recipient: "Tai_Developer",
  content: "系统设计文档已生成在 shared/system_design.md，请开始开发",
  summary: "设计文档就绪"
});
```

#### 阶段 3: 代码开发
```javascript
// 步骤 1: 开发者开始编码
const development = await task({
  subagent_name: "Tai_Developer",
  description: "代码开发",
  prompt: `基于 shared/system_design.md 中的系统设计文档，
开始编写代码：
1. 创建项目结构
2. 实现核心功能
3. 编写单元测试
4. 代码审查

将代码保存在你的 outputs/ 目录中。`
});

// 步骤 2: DevOps 配置环境
const devops = await task({
  subagent_name: "Tai_DevOps",
  description: "环境配置",
  prompt: `为项目配置开发环境：
1. 设置开发环境
2. 配置数据库
3. 设置 CI/CD 流水线
4. 配置监控

将配置文件保存在你的 outputs/ 目录中。`
});
```

#### 阶段 4: 测试和验证
```javascript
// 步骤 1: 测试工程师设计测试
const testing = await task({
  subagent_name: "Tai_Tester",
  description: "测试设计",
  prompt: `基于系统设计和开发代码，
设计测试计划：
1. 单元测试
2. 集成测试
3. 性能测试
4. 安全测试

执行测试并生成测试报告，保存在你的 outputs/ 目录中。`
});

// 步骤 2: 用户代理进行验收
const uat = await task({
  subagent_name: "Tai_UserAgent",
  description: "用户验收",
  prompt: `模拟真实用户使用系统：
1. 功能验证
2. 体验评估
3. 收集反馈
4. 生成验收报告

将验收报告保存在你的 outputs/ 目录中。`
});
```

#### 阶段 5: 文档和部署
```javascript
// 步骤 1: 文档工程师生成文档
const documentation = await task({
  subagent_name: "Tai_Documenter",
  description: "文档生成",
  prompt: `基于项目代码和系统设计，
生成完整的文档：
1. API 文档
2. 用户手册
3. 部署指南
4. 开发文档

将文档保存在你的 outputs/ 目录中。`
});

// 步骤 2: DevOps 部署系统
const deployment = await task({
  subagent_name: "Tai_DevOps",
  description: "系统部署",
  prompt: `将系统部署到生产环境：
1. 准备生产环境
2. 部署应用
3. 配置域名
4. 设置监控

生成部署报告，保存在你的 outputs/ 目录中。`
});
```

## 🔧 实际使用示例

### 示例 1: 快速启动项目
```javascript
// 1. 启动产品经理
const project = await task({
  subagent_name: "Tai_ProductManager",
  description: "项目启动",
  prompt: "启动一个'任务管理系统'项目，生成项目计划"
});

// 2. 依次启动后续 Agent
await task({
  subagent_name: "Tai_SystemAnalyst",
  description: "系统分析",
  prompt: "分析任务管理系统的业务流程"
});

await task({
  subagent_name: "Tai_Architect",
  description: "架构设计",
  prompt: "设计任务管理系统的技术架构"
});

// ... 继续
```

### 示例 2: 并行任务处理
```javascript
// 同时启动多个 Agent 处理不同任务
const [pmResult, saResult] = await Promise.all([
  task({
    subagent_name: "Tai_ProductManager",
    description: "需求分析",
    prompt: "收集项目需求"
  }),
  task({
    subagent_name: "Tai_SystemAnalyst",
    description: "技术分析",
    prompt: "分析技术可行性"
  })
]);

// 等待结果后继续
console.log("需求和技术分析完成");
```

### 示例 3: 团队协作模式
```javascript
// 创建团队
await team_create({
  team_name: "project-team",
  description: "项目开发团队"
});

// 启动团队成员
const members = await Promise.all([
  task({
    subagent_name: "Tai_ProductManager",
    team_name: "project-team",
    name: "product-manager",
    prompt: "作为产品经理，管理项目需求"
  }),
  task({
    subagent_name: "Tai_Developer",
    team_name: "project-team",
    name: "developer",
    prompt: "作为开发者，实现项目功能"
  })
]);

// Agent 之间可以相互通信
await send_message({
  type: "message",
  recipient: "developer",
  content: "新需求已添加，请查看",
  summary: "新需求通知"
});
```

## 📊 监控和管理

### 1. 查看 Agent 状态
```bash
# 查看所有 Agent 的状态
# 在 CodeBuddy 界面中查看 Agent 列表
```

### 2. 查看 Agent 输出
```bash
# 查看 Agent 生成的工作成果
ls 03-multiagent/Tai_ProductManager_Home/outputs/
ls 03-multiagent/Tai_Developer_Home/outputs/
# ... 其他 Agent
```

### 3. 查看共享消息
```bash
# 查看 Agent 之间的通信记录
cat 03-multiagent/shared/messages/*.json
```

### 4. 终止 Agent
```javascript
// 终止指定的 Agent
await send_message({
  type: "shutdown_request",
  recipient: "Tai_Developer",
  content: "任务已完成，可以关闭"
});
```

## 🎯 最佳实践

### 1. 任务分配原则
- 根据 Agent 的专业能力分配任务
- 避免跨专业分配任务
- 确保任务描述清晰明确

### 2. 协作模式选择
- 简单任务：单 Agent 完成
- 复杂任务：多 Agent 协作
- 大型项目：团队模式

### 3. 消息传递规范
- 使用标准化的消息格式
- 包含必要的上下文信息
- 设置合理的优先级

### 4. 文件共享规则
- 使用共享目录传递文件
- 遵循文件命名规范
- 及时清理过期文件

### 5. 错误处理
- 设置合理的超时时间
- 实现重试机制
- 记录错误日志

## 🔍 故障排除

### Agent 不响应
1. 检查 Agent 是否启用
2. 确认工具权限配置正确
3. 查看错误日志
4. 重启 Agent

### 文件共享失败
1. 确认共享目录存在
2. 检查文件命名规范
3. 验证文件权限
4. 重新发送消息

### 团队协作中断
1. 检查团队状态
2. 验证成员连接
3. 查看消息传递记录
4. 必要时重新创建团队

## 📚 相关资源

- [Agent 配置指南](./.codebuddy/TEAM_SETUP_GUIDE.md)
- [工作空间规则](./01-rules/agent-workspace-rules.md)
- [团队配置总结](./.codebuddy/AGENTS_SUMMARY.md)
- [CloudBase MCP 演示](./CloudBase_MCP_Demo.md)

---

*指南创建时间: 2026-03-13*  
*适用版本: CodeBuddy 多 Agent 团队 v1.0*  
*状态: ✅ 可投入使用*