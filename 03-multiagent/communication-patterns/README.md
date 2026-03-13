# 通信模式

本目录包含代理间通信的模式和实现。

## 概述

通信模式定义了代理之间如何交换信息。

## 基本模式

### 1. 请求-响应模式

```
Agent A ──────► Agent B
   │              │
   │   Request    │
   │──────────────►│
   │              │
   │   Response   │
   │◄─────────────│
   │              │
   ▼              ▼
```

```typescript
// 实现
async function requestResponse(
  target: Agent,
  request: Message
): Promise<Response> {
  const message = {
    type: 'request',
    to: target.id,
    payload: request,
    correlationId: generateId()
  }
  
  const response = await sendMessage(message)
  return response
}
```

### 2. 发布-订阅模式

```
         ┌──────────┐
         │  消息    │
         │  主题    │
         └────┬─────┘
              │
    ┌─────────┼─────────┐
    │         │         │
    ▼         ▼         ▼
 Agent A   Agent B   Agent C
```

```typescript
// 发布消息
await publish('task-completed', {
  taskId: '123',
  result: { ... }
})

// 订阅消息
subscribe('task-completed', async (event) => {
  await processEvent(event)
})
```

### 3. 消息队列模式

```
Agent A      ┌─────────┐      Agent B
  ──────►   │  队列   │  ──────►
            └─────────┘
```

```typescript
// 发送消息到队列
await queue.send('agent-b', {
  type: 'task',
  payload: { ... }
})

// 从队列接收
const message = await queue.receive('agent-a')
```

## 消息格式

### 基础消息结构

```typescript
interface Message {
  id: string              // 唯一标识
  type: MessageType       // 消息类型
  from: AgentId           // 发送者
  to: AgentId             // 接收者
  timestamp: Date          // 时间戳
  payload: any            // 内容
  correlationId?: string   // 关联ID
  replyTo?: string        // 回复地址
}

enum MessageType {
  REQUEST = 'request',
  RESPONSE = 'response',
  EVENT = 'event',
  COMMAND = 'command',
  BROADCAST = 'broadcast'
}
```

### 消息示例

```json
{
  "id": "msg-001",
  "type": "request",
  "from": "agent-main",
  "to": "agent-data-processor",
  "timestamp": "2026-03-13T10:00:00Z",
  "payload": {
    "action": "process",
    "data": { ... }
  },
  "correlationId": "workflow-123"
}
```

## 通信协议

### 1. 同步通信

```typescript
// 同步请求-响应
async function syncCall(
  agent: Agent,
  request: Request
): Promise<Response> {
  const timeout = 30000  // 30秒超时
  
  try {
    const response = await Promise.race([
      agent.send(request),
      new Promise((_, reject) => 
        setTimeout(() => reject(new TimeoutError()), timeout)
      )
    ])
    return response
  } catch (error) {
    throw new CommunicationError('Sync call failed', error)
  }
}
```

### 2. 异步通信

```typescript
// 异步消息
async function asyncSend(
  agent: Agent,
  message: Message
): Promise<void> {
  // 不等待响应
  await messageQueue.publish({
    topic: `agent.${agent.id}`,
    message: message
  })
}
```

### 3. 流式通信

```typescript
// 流式数据
async function* streamData(
  agent: Agent,
  request: Request
): AsyncGenerator<Chunk> {
  const stream = await agent.createStream(request)
  
  for await (const chunk of stream) {
    yield chunk
  }
}
```

## 可靠性

### 消息确认

```typescript
interface Acknowledgment {
  messageId: string
  status: 'received' | 'processed' | 'failed'
  timestamp: Date
}

// 发送确认请求
const message = {
  requireAck: true,
  ackTimeout: 5000
}

// 处理确认
on('acknowledgment', async (ack) => {
  if (ack.status === 'failed') {
    await retry(ack.messageId)
  }
})
```

### 重试机制

```typescript
interface RetryPolicy {
  maxAttempts: number
  backoff: 'linear' | 'exponential'
  initialDelay: number
  maxDelay: number
}

async function sendWithRetry(
  agent: Agent,
  message: Message,
  policy: RetryPolicy
): Promise<void> {
  let attempt = 0
  
  while (attempt < policy.maxAttempts) {
    try {
      await agent.send(message)
      return
    } catch (error) {
      attempt++
      const delay = calculateBackoff(attempt, policy)
      await sleep(delay)
    }
  }
  
  throw new MaxRetriesExceeded()
}
```

### 消息持久化

```typescript
// 持久化消息
await messageStore.save({
  id: message.id,
  payload: message.payload,
  status: 'pending',
  createdAt: new Date()
})

// 标记已处理
await messageStore.update(message.id, {
  status: 'processed',
  processedAt: new Date()
})
```

## 安全性

### 认证

```typescript
interface AuthMessage {
  token: string
  timestamp: Date
  signature: string
}

// 消息签名
function signMessage(message: Message, secret: string): string {
  const payload = JSON.stringify({
    ...message,
    timestamp: Date.now()
  })
  return crypto.sign(payload, secret)
}

// 验证消息
function verifyMessage(message: Message, signature: string): boolean {
  return crypto.verify(message, signature)
}
```

### 加密

```typescript
// 端到端加密
async function sendEncrypted(
  agent: Agent,
  message: Message,
  publicKey: string
): Promise<void> {
  const encrypted = await crypto.encrypt(
    JSON.stringify(message.payload),
    publicKey
  )
  
  await agent.send({
    ...message,
    payload: encrypted,
    encrypted: true
  })
}
```

## 监控

### 消息追踪

```typescript
// 追踪消息
interface MessageTrace {
  messageId: string
  path: AgentId[]
  timestamps: Date[]
  status: 'pending' | 'delivered' | 'failed'
}

// 记录追踪
function trace(message: Message): void {
  traceStore.save({
    messageId: message.id,
    from: message.from,
    to: message.to,
    timestamp: new Date()
  })
}
```

### 性能指标

```typescript
// 收集指标
const metrics = {
  messagesSent: counter('messages_sent'),
  messagesReceived: counter('messages_received'),
  messageLatency: histogram('message_latency'),
  failedMessages: counter('failed_messages')
}
```

## 最佳实践

1. **消息格式**: 使用结构化消息格式
2. **错误处理**: 实现重试和确认机制
3. **监控**: 追踪消息生命周期
4. **安全**: 加密敏感信息
5. **解耦**: 使用异步通信解耦代理

## 相关文档

- [代理协作](../agent-coordination/)
- [工作流编排](../workflow-orchestration/)
