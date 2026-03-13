# OpenClaw 代码规范

## 配置文件规范

### JSON 格式
- 使用 2 个空格缩进
- 键名使用双引号
- 文件末尾保留换行符

```json
{
  "gateway": {
    "port": 18789,
    "mode": "local"
  }
}
```

### 配置结构
- 按功能模块分组
- 使用合理的默认值
- 包含必要的注释

## 脚本编写规范

### Shell 脚本
```bash
#!/bin/bash
# OpenClaw Gateway Startup Script

set -euo pipefail

GATEWAY_PORT=${OPENCLAW_GATEWAY_PORT:-18789}

# 启动网关服务
node /path/to/openclaw/dist/index.js gateway --port $GATEWAY_PORT
```

### 错误处理
- 使用 `set -euo pipefail`
- 检查命令执行结果
- 提供有意义的错误信息

## 日志规范

### 日志级别
- `ERROR`: 错误信息
- `WARN`: 警告信息
- `INFO`: 一般信息
- `DEBUG`: 调试信息

### 日志格式
```json
{
  "timestamp": "2026-03-12T06:11:00Z",
  "level": "INFO",
  "message": "Gateway started successfully",
  "port": 18789
}
```

## 安全规范

### 敏感信息
- API 密钥不写入代码
- 使用环境变量或配置文件
- 配置文件不提交到版本控制

### 权限控制
- 限制网关绑定地址
- 使用令牌认证
- 禁用危险命令

## 性能规范

### 资源管理
- 合理设置并发数量
- 监控内存使用
- 定期清理临时文件

### 错误恢复
- 实现优雅的重启机制
- 保存会话状态
- 提供健康检查端点