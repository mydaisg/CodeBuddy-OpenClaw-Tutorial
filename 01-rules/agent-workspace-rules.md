# Agent 工作空间规则

## Agent Home 目录结构

每个 Agent 都有专属的 Home 目录，位于 `03-multiagent/` 下，命名为 `[Agent名称]_Home`。

### Home 目录列表

| Agent 名称 | Home 目录路径 | 用途 |
|-----------|--------------|------|
| Tai_ProductManager | `03-multiagent/Tai_ProductManager_Home/` | 产品经理专属工作空间 |
| Tai_SystemAnalyst | `03-multiagent/Tai_SystemAnalyst_Home/` | 系统分析师专属工作空间 |
| Tai_Architect | `03-multiagent/Tai_Architect_Home/` | 架构师专属工作空间 |
| Tai_Developer | `03-multiagent/Tai_Developer_Home/` | 开发工程师专属工作空间 |
| Tai_Tester | `03-multiagent/Tai_Tester_Home/` | 测试工程师专属工作空间 |
| Tai_DevOps | `03-multiagent/Tai_DevOps_Home/` | DevOps 工程师专属工作空间 |
| Tai_Documenter | `03-multiagent/Tai_Documenter_Home/` | 文档工程师专属工作空间 |
| Tai_UserAgent | `03-multiagent/Tai_UserAgent_Home/` | 用户代理专属工作空间 |

## 核心规则

### 1. 专属空间原则
- **规则**: 每个 Agent 只能在自己的 Home 目录内创建和修改文件
- **目的**: 保持工作空间的清晰和隔离
- **违规**: 跨目录访问或修改其他 Agent 的文件是严格禁止的

### 2. 文件放置规则
- **默认规则**: 除非有特定声明，所有 Agent 生成的文件必须存放到自己的 Home 目录
- **协同工作**: 需要共享文件时，应通过指定的共享机制（如 `shared/` 目录）
- **临时文件**: 临时文件也应存放在自己的 Home 目录下的 `temp/` 子目录

### 3. 目录组织规范

每个 Agent Home 目录建议的子目录结构：

```
[AgentName]_Home/
├── README.md              # Home 目录说明（可选）
├── outputs/              # 生成的工作成果
├── drafts/               # 草稿和临时文件
├── configs/              # 配置文件和设置
├── notes/                # 工作笔记和想法
├── resources/            # 参考资源和模板
└── .gitkeep             # 确保空目录被版本控制
```

### 4. 跨 Agent 通信规则

#### 共享文件机制
```markdown
当需要跨 Agent 共享文件时：
1. 发起方 Agent 将文件复制到 `03-multiagent/shared/` 目录
2. 接收方 Agent 从 `03-multiagent/shared/` 目录读取文件
3. 文件命名格式: `[发起方Agent]_[接收方Agent]_[文件描述]_[时间戳].ext`
```

#### 消息传递格式
```markdown
Agent 之间需要传递信息时，建议使用标准化的消息格式：

```json
{
  "from": "Tai_Architect",
  "to": "Tai_Developer",
  "timestamp": "2026-03-13T10:30:00Z",
  "subject": "架构设计文档更新",
  "content": "已更新系统架构文档，请查看。",
  "files": [
    "shared/Tai_Architect_Tai_Developer_system_architecture_20260313.md"
  ],
  "priority": "high"
}
```

### 5. 工作成果命名规范

#### 文件命名规则
- **格式**: `[项目名]_[模块名]_[文件类型]_[版本]_[日期].ext`
- **示例**: `project_core_design_doc_v1.0_20260313.md`

#### 想法和笔记命名规则
- **格式**: `[日期]_[主题]_[编号].md`
- **示例**: `20260313_architecture_decision_notes_001.md`

### 6. 版本控制规则

#### 提交信息规范
```bash
# 格式
git commit -m "[Agent]: [简短描述]"

# 示例
git commit -m "[Tai_Architect]: 更新系统架构设计文档"
```

#### 分支策略
```markdown
每个 Agent 的主要工作应在自己的工作目录中进行，
避免频繁的分支创建和合并。

如需要创建分支：
- 分支名: `[Agent名]/[功能描述]`
- 示例: `Tai_Developer/user-authentication-feature`
```

### 7. 备份和恢复规则

#### 自动备份
- 每个 Agent 应定期备份自己的工作成果
- 建议备份频率: 每日结束时
- 备份位置: `[AgentHome]/backups/[日期]/`

#### 重要文件保护
```markdown
标记重要文件：
- 在文件开头添加标记: `#! IMPORTANT`
- 确保重要文件有备份
- 避免意外删除
```

### 8. 性能和清理规则

#### 定期清理
```markdown
每个 Agent 应定期清理自己的 Home 目录：
- 删除过期的临时文件
- 整理和归档已完成的工作
- 更新过期的参考资源
```

#### 存储空间管理
```markdown
存储空间使用建议：
- 单个 Home 目录大小限制: 100MB
- 超出限制时，应进行清理或归档
- 大文件应考虑压缩存储
```

## 协作场景示例

### 场景 1: 架构师 → 开发者
```
1. Tai_Architect 在 Tai_Architect_Home/outputs/ 创建架构文档
2. 将文档复制到 03-multiagent/shared/Tai_Architect_Tai_Developer_system_design.md
3. 发送消息通知 Tai_Developer
4. Tai_Developer 从 shared/ 读取文档到 Tai_Developer_Home/inputs/
5. Tai_Developer 基于文档进行开发工作
```

### 场景 2: 产品经理 → 团队
```
1. Tai_ProductManager 在 Tai_ProductManager_Home/outputs/ 创建需求文档
2. 将文档复制到 03-multiagent/shared/requirements/
3. 发送消息通知相关 Agent
4. 各 Agent 从 shared/requirements/ 读取相关需求
```

### 场景 3: 开发者 → 测试工程师
```
1. Tai_Developer 完成功能开发
2. 在 Tai_Developer_Home/outputs/ 创建功能说明文档
3. 将文档和代码信息复制到 03-multiagent/shared/Tai_Developer_Tai_Tester_feature_ready.md
4. 发送消息通知 Tai_Tester
5. Tai_Tester 根据文档设计测试用例
```

## 违规处理

### 发现违规时的处理流程
```markdown
1. 记录违规事件
2. 通知相关 Agent
3. 恢复到合规状态
4. 分析违规原因
5. 更新规则以防止类似问题
```

### 常见违规行为
- ❌ 在其他 Agent 的 Home 目录中创建或修改文件
- ❌ 直接修改共享目录中其他 Agent 的文件
- ❌ 跳过标准通信流程传递信息
- ❌ 不遵守文件命名规范
- ❌ 超出存储空间限制

## 最佳实践

### 1. 定期同步
- 每日结束时同步重要文件
- 定期备份工作成果
- 保持与其他 Agent 的沟通

### 2. 文档化
- 记录重要的决策过程
- 为文件和目录添加说明
- 维护清晰的变更日志

### 3. 质量保证
- 定期审查工作成果
- 确保符合项目规范
- 主动发现和修复问题

### 4. 团队协作
- 尊重其他 Agent 的工作空间
- 及时响应共享文件请求
- 建设性的反馈和沟通

## 工具和模板

### Home 目录初始化脚本
每个 Agent 的 Home 目录应包含一个初始化脚本（可选）：

```bash
#!/bin/bash
# 初始化 Agent Home 目录结构

AGENT_NAME=$1
HOME_DIR="03-multiagent/${AGENT_NAME}_Home"

# 创建标准子目录
mkdir -p "$HOME_DIR"/{outputs,drafts,configs,notes,resources,temp,backups}

# 创建说明文件
cat > "$HOME_DIR/README.md" <<EOF
# $AGENT_NAME Home Directory

这是 $AGENT_NAME 的专属工作空间。

## 目录说明
- \`outputs/\`: 生成的工作成果
- \`drafts/\`: 草稿和临时文件
- \`configs/\`: 配置文件和设置
- \`notes/\`: 工作笔记和想法
- \`resources/\`: 参考资源和模板
- \`temp/\`: 临时文件（定期清理）
- \`backups/\`: 备份文件

## 使用规则
请遵守 \`01-rules/agent-workspace-rules.md\` 中定义的所有规则。

---
初始化时间: $(date)
EOF

echo "$AGENT_NAME Home 目录初始化完成"
```

---

*规则创建时间: 2026-03-13*  
*适用范围: 所有 CodeBuddy Agent*  
*状态: ✅ 已生效*