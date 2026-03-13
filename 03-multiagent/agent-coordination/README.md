# 代理协作

本目录包含多代理协作模式和实现。

## 概述

代理协作是多代理系统的核心，让多个代理协同完成复杂任务。

## 协作模式

### 1. 主从模式

```
┌─────────────┐
│  主代理     │ ← 决策者
│  (Main)     │
└──────┬──────┘
       │
   ┌───┴───┐
   │       │
┌──┴──┐┌──┴──┐
│子代理││子代理│
│ A    ││ B    │
└─────┘└─────┘
```

### 2. 对等模式

```
┌──────┐    ┌──────┐
│代理 A │◄──►│代理 B │
└──────┘    └──────┘
   │           │
   └─────┬─────┘
         │
    ┌────┴────┐
    │ 共享状态 │
    └─────────┘
```

### 3. 层级模式

```
         ┌──────────┐
         │  调度器  │
         └────┬─────┘
        ┌─────┴─────┐
        │           │
   ┌────┴────┐ ┌───┴────┐
   │ 组1     │ │ 组2    │
   │ A1 A2   │ │ B1 B2  │
   └─────────┘ └────────┘
```

## 协作机制

### 任务分配

```typescript
// 任务分配示例
interface TaskAssignment {
  taskId: string
  description: string
  priority: number
  assignedTo: AgentId
  deadline?: Date
  dependencies?: TaskId[]
}

// 分配策略
enum AssignmentStrategy {
  ROUND_ROBIN,    // 轮询
  LOAD_BALANCED,  // 负载均衡
  SKILL_BASED,    // 基于技能
  PRIORITY        // 优先级
}
```

### 结果汇总

```typescript
// 结果聚合
interface ResultAggregation {
  taskId: string
  results: Map<AgentId, TaskResult>
  
  aggregate(): CombinedResult {
    // 合并多个代理的结果
    const combined = {
      data: this.mergeData(),
      confidence: this.calculateConfidence(),
      metadata: this.collectMetadata()
    }
    return combined
  }
}
```

### 冲突解决

```typescript
// 冲突检测和解决
interface ConflictResolver {
  detect(results: TaskResult[]): Conflict[]
  
  resolve(conflict: Conflict): Resolution {
    switch (conflict.type) {
      case 'DATA_CONFLICT':
        return this.resolveDataConflict(conflict)
      case 'DECISION_CONFLICT':
        return this.resolveDecisionConflict(conflict)
      case 'RESOURCE_CONFLICT':
        return this.resolveResourceConflict(conflict)
    }
  }
}
```

## 实现示例

### 协作代理配置

```yaml
# agents/team-leader/agent.yaml
name: team-leader
role: coordinator

collaboration:
  mode: hierarchical
  
  children:
    - agent: data-processor
      tasks:
        - data-cleaning
        - data-validation
    - agent: analyzer
      tasks:
        - data-analysis
        - pattern-detection
    - agent: reporter
      tasks:
        - report-generation
        - summary-creation
  
  communication:
    protocol: event-driven
    broadcast: true
    
  conflict-resolution:
    strategy: voting
    timeout: 30s
```

### 协作协议

```typescript
// 协作协议定义
interface CollaborationProtocol {
  // 初始化协作
  initialize(context: CollaborationContext): Promise<void>
  
  // 分发任务
  distribute(task: Task): Promise<TaskDistribution>
  
  // 收集结果
  collect(partialResults: PartialResult[]): Promise<AggregatedResult>
  
  // 处理冲突
  resolve(conflicts: Conflict[]): Promise<Resolution[]>
  
  // 结束协作
  finalize(): Promise<void>
}
```

## 最佳实践

1. **明确角色**: 每个代理应有明确的职责
2. **最小通信**: 只传递必要的信息
3. **容错设计**: 单个代理失败不应影响整体
4. **状态同步**: 保持代理间状态一致性
5. **超时处理**: 设置合理的超时时间

## 相关文档

- [工作流编排](../workflow-orchestration/)
- [通信模式](../communication-patterns/)
