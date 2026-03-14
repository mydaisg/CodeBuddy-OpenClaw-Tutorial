# CodeBuddy Agent 团队快速启动示例

## 🚀 立即开始使用 Agent 团队

本指南提供具体的命令和步骤，让你立即开始使用 CodeBuddy 的多 Agent 团队。

## 📝 步骤 1: 创建共享目录

```bash
# 在 03-multiagent 目录下创建共享空间
mkdir 03-multiagent/shared
mkdir 03-multiagent/shared/messages
mkdir 03-multiagent/shared/resources
mkdir 03-multiagent/shared/outputs
```

## 🎯 步骤 2: 选择启动模式

### 模式 A: 顺序启动（推荐新手）

#### 1. 启动产品经理
```
请调用 Tai_ProductManager Agent，任务描述：
"为'在线文档编辑器'项目收集需求，项目需要支持：
1. 用户登录和认证
2. 文档创建和编辑
3. 多用户协作
4. 实时保存
5. 版本控制

请生成详细的需求文档，保存在 03-multiagent/Tai_ProductManager_Home/outputs/requirements.md
完成后将文档复制到 03-multiagent/shared/requirements.md"
```

#### 2. 启动系统分析师
```
请调用 Tai_SystemAnalyst Agent，任务描述：
"阅读 03-multiagent/shared/requirements.md 中的需求文档，
进行系统分析，包括：
1. 业务流程分析
2. 数据流设计
3. 用例建模
4. 接口定义

将分析结果保存在 03-multiagent/Tai_SystemAnalyst_Home/outputs/system_analysis.md
完成后复制到 03-multiagent/shared/system_analysis.md"
```

#### 3. 启动架构师
```
请调用 Tai_Architect Agent，任务描述：
"基于 03-multiagent/shared/requirements.md 和 03-multiagent/shared/system_analysis.md
设计系统架构，包括：
1. 技术栈选型
2. 系统模块设计
3. 数据库设计
4. API 设计

将架构文档保存在 03-multiagent/Tai_Architect_Home/outputs/architecture.md
完成后复制到 03-multiagent/shared/architecture.md"
```

#### 4. 启动开发工程师
```
请调用 Tai_Developer Agent，任务描述：
"基于 03-multiagent/shared/architecture.md 中的架构设计，
开始编写代码：
1. 创建项目结构
2. 实现核心功能模块
3. 编写单元测试
4. 代码审查

将代码保存在 03-multiagent/Tai_Developer_Home/outputs/src/ 目录"
```

### 模式 B: 并行启动（推荐进阶用户）

```
请并行启动以下三个 Agent：

1. Tai_ProductManager: 收集项目需求
2. Tai_SystemAnalyst: 分析技术可行性
3. Tai_Architect: 研究技术栈

等待三个任务都完成后，继续下一步：启动 Tai_Developer 进行开发。
```

### 模式 C: 团队模式（高级用户）

```
请创建一个名为 "doc-editor-team" 的团队，包含以下成员：

1. product-manager (基于 Tai_ProductManager)
2. developer (基于 Tai_Developer)
3. tester (基于 Tai_Tester)

团队成员建立后，让 product-manager 开始工作，其他成员等待协作。
```

## 💡 实际对话示例

### 对话 1: 启动单个 Agent
```
用户: 启动 Tai_ProductManager，让它收集一个"任务管理应用"的需求

Agent (主): 正在调用 Tai_ProductManager Agent...

Tai_ProductManager: 我将开始收集任务管理应用的需求。
需求分析：
- 用户需要创建、编辑、删除任务
- 支持任务分类和标签
- 需要设置截止日期和优先级
- 支持任务搜索和过滤

已将需求文档保存到 03-multiagent/Tai_ProductManager_Home/outputs/requirements.md

主 Agent: Tai_ProductManager 已完成任务，需求文档已生成。
```

### 对话 2: Agent 协作
```
用户: 让 Tai_SystemAnalyst 分析任务管理应用的需求

主 Agent: 正在调用 Tai_SystemAnalyst Agent...
读取需求文档：03-multiagent/shared/requirements.md

Tai_SystemAnalyst: 我将分析需求并进行系统设计。
分析结果：
- 业务流程：用户登录 → 创建任务 → 管理任务 → 完成任务
- 数据模型：用户、任务、分类、标签
- API 接口：RESTful API 设计
- 数据库：推荐使用 PostgreSQL

已将分析结果保存到 03-multiagent/Tai_SystemAnalyst_Home/outputs/analysis.md

主 Agent: Tai_SystemAnalyst 已完成系统分析。
是否继续启动 Tai_Architect 进行架构设计？
```

### 对话 3: 多 Agent 并行
```
用户: 让 Tai_Developer、Tai_Tester、Tai_DevOps 同时开始工作

主 Agent: 正在并行启动三个 Agent...

Tai_Developer: 我将开始实现核心功能...
Tai_Tester: 我将设计测试用例...
Tai_DevOps: 我将配置开发环境...

（等待中...）

Tai_Developer: ✅ 代码实现完成
Tai_Tester: ✅ 测试用例设计完成
Tai_DevOps: ✅ 环境配置完成

主 Agent: 所有 Agent 已完成任务。
接下来可以启动 Tai_Documenter 生成文档。
```

## 🎮 交互式工作流程

### 1. 项目启动阶段
```
用户: 启动一个"在线考试系统"项目

主 Agent: 好的，我将启动完整的项目流程。

第一步：启动 Tai_ProductManager 收集需求...
（调用 Tai_ProductManager）

第二步：启动 Tai_SystemAnalyst 进行系统分析...
（调用 Tai_SystemAnalyst）

第三步：启动 Tai_Architect 设计架构...
（调用 Tai_Architect）

前期准备完成，是否开始开发？
```

### 2. 开发实施阶段
```
用户: 是的，开始开发

主 Agent: 启动开发实施阶段。

启动 Tai_Developer 进行代码开发...
启动 Tai_DevOps 配置环境...

（开发中...）

Tai_Developer: ✅ 核心功能开发完成
Tai_DevOps: ✅ 环境配置完成

是否开始测试？
```

### 3. 测试验证阶段
```
用户: 开始测试

主 Agent: 启动测试验证阶段。

启动 Tai_Tester 进行功能测试...
启动 Tai_UserAgent 进行用户体验测试...

（测试中...）

Tai_Tester: ✅ 测试通过，发现 2 个小问题
Tai_UserAgent: ✅ 用户体验良好，提出 3 个改进建议

是否继续修复问题并重新测试？
```

## 📊 监控 Agent 工作状态

### 查看工作成果
```bash
# 查看产品经理的输出
cat 03-multiagent/Tai_ProductManager_Home/outputs/requirements.md

# 查看系统分析师的输出
cat 03-multiagent/Tai_SystemAnalyst_Home/outputs/analysis.md

# 查看架构师的输出
cat 03-multiagent/Tai_Architect_Home/outputs/architecture.md

# 查看开发者的代码
ls 03-multiagent/Tai_Developer_Home/outputs/src/
```

### 查看共享文件
```bash
# 查看所有共享文件
ls 03-multiagent/shared/

# 查看需求文档
cat 03-multiagent/shared/requirements.md
```

## 🔄 常用操作命令

### 重新启动 Agent
```
请重新启动 Tai_Developer Agent，继续开发工作
```

### 切换 Agent 任务
```
让 Tai_Developer 停止当前任务，开始实现用户认证功能
```

### 获取 Agent 报告
```
让 Tai_Tester 提供当前测试进度的详细报告
```

### 终止 Agent 工作
```
请终止 Tai_Developer 的工作，保存当前进度
```

## 🎯 实际项目示例

### 示例 1: 开发博客系统
```
用户: 开发一个博客系统

主 Agent: 启动博客系统项目...

1. Tai_ProductManager: 收集博客需求
   - 文章发布和管理
   - 用户评论
   - 分类和标签
   - 搜索功能

2. Tai_SystemAnalyst: 系统分析
   - 用户角色：作者、读者、管理员
   - 数据模型：文章、评论、用户、分类
   - 业务流程

3. Tai_Architect: 架构设计
   - 前端：React + TypeScript
   - 后端：Node.js + Express
   - 数据库：MongoDB
   - 缓存：Redis

4. Tai_Developer: 代码实现
   - 用户认证模块
   - 文章管理模块
   - 评论系统
   - 搜索功能

5. Tai_Tester: 测试验证
   - 功能测试
   - 性能测试
   - 安全测试

6. Tai_DevOps: 部署上线
   - CI/CD 配置
   - 环境部署
   - 监控配置

博客系统开发完成！
```

## 💪 下一步

1. **选择项目**: 确定要开发的项目
2. **启动流程**: 按照上述步骤启动 Agent
3. **监控进度**: 查看 Agent 的工作成果
4. **调整任务**: 根据需要调整 Agent 的任务
5. **完成项目**: 所有 Agent 完成后进行验收

---

*示例文档创建时间: 2026-03-13*  
*适用范围: CodeBuddy 多 Agent 团队*  
*状态: ✅ 可直接使用*