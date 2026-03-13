# 简单聊天机器人

这是一个最简单的对话代理示例。

## 项目概述

- **难度**: ⭐ 入门级
- **功能**: 处理日常对话
- **代理数量**: 1

## 项目结构

```
simple-chatbot/
├── agents/
│   └── chat/
│       └── agent.yaml
├── skills/
│   └── conversation/
│       ├── SKILL.md
│       └── scripts/
│           └── respond.ps1
├── prompts/
│   └── system.md
└── README.md
```

## 代理配置

```yaml
# agents/chat/agent.yaml
name: chat
description: 简单聊天机器人
model: MiniMax-M2.5
context: 200k

skills:
  - conversation

personality:
  tone: friendly
  response_length: medium
  traits:
    - helpful
    - patient
    - humorous
```

## 技能定义

```yaml
# skills/conversation/SKILL.md
name: conversation
description: 处理日常对话

activation:
  keywords:
    - 你好
    - hello
    - 嗨
  exclude:
    - 命令
    - 执行
```

## 对话提示

```markdown
# prompts/system.md
你是一个友好的聊天机器人。

角色设定：
- 乐于助人
- 回答简洁明了
- 适当加入幽默

限制：
- 不讨论政治话题
- 不透露个人隐私
- 不执行命令
```

## 实现代码

```powershell
# skills/conversation/scripts/respond.ps1
param(
    [Parameter(Mandatory=$true)]
    [string]$Input,
    
    [hashtable]$Context
)

# 简单的响应逻辑
$response = switch -Regex ($Input) {
    "(你好|嗨|hello)" {
        "你好！有什么我可以帮助你的吗？"
    }
    "名字" {
        "我叫 ChatBot，是一个简单的对话机器人。"
    }
    "帮助" {
        "我可以陪你聊天，回答简单问题。试着对我说'你好'吧！"
    }
    default {
        "有意思！告诉我更多关于这个话题的内容吧。"
    }
}

@{
    response = $response
    intent = "conversation"
} | ConvertTo-Json
```

## 测试

```bash
# 测试对话
> 你好
你好！有什么我可以帮助你的吗？

> 你叫什么名字
我叫 ChatBot，是一个简单的对话机器人。

> 帮我执行命令
抱歉，我只是一个聊天机器人，不会执行命令哦。
```

## 扩展建议

1. **添加情感识别**
   - 检测用户情绪
   - 根据情绪调整回复

2. **添加话题识别**
   - 识别对话主题
   - 提供相关响应

3. **添加记忆功能**
   - 记住用户偏好
   - 维护对话历史

## 下一步

- 学习 [代码审查系统](../code-review-system/)
- 学习 [自动化工作流](../automation-workflow/)
