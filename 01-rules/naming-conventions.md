# OpenClaw 命名规范

## 文件命名规范

### 配置文件
- **主配置文件**: `openclaw.json`
- **备份文件**: `openclaw.json.bak`
- **网关脚本**: `gateway.cmd` (Windows) / `gateway.sh` (Linux/macOS)

### 目录命名
- **代理目录**: `agents/`
- **工作区**: `workspace/`
- **日志目录**: `logs/`
- **身份认证**: `identity/`
- **设备管理**: `devices/`

### 代理命名
- **主代理**: `main`
- **专用代理**: 按功能命名，如 `web-search`, `code-review`
- **项目代理**: 按项目命名，如 `project-alpha`

## 变量命名规范

### 环境变量
```bash
OPENCLAW_GATEWAY_PORT=18789
OPENCLAW_SERVICE_MARKER=openclaw
```

### 配置键名
- 使用小写字母和连字符
- 层级结构使用点分隔
```json
{
  "gateway.port": 18789,
  "agents.defaults.workspace": "path/to/workspace"
}
```

## 命令命名规范

### CLI 命令
- 使用动词+名词结构
- 子命令使用连字符
```bash
openclaw gateway status
openclaw agent run
openclaw models list
```

### API 端点
- RESTful 风格
- 资源复数形式
```
/api/v1/agents
/api/v1/sessions
/api/v1/models
```

## 最佳实践

1. **一致性**: 在整个项目中保持命名一致
2. **描述性**: 名称应清晰表达其用途
3. **简洁性**: 避免过长的名称
4. **可读性**: 使用有意义的单词组合