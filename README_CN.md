# 日历同步工具 📅

自动同步 Lark 日历的工具，每天 UTC+7 早上 9:00 自动运行。

## 🎯 功能特性

- ✅ 读取 Bo Coordinator 日历（未来 7 天）
- ✅ 检查 new jira 日历的空闲时间
- ✅ 自动创建会议（标题：from UM calendar）
- ✅ 智能跳过冲突时间段
- ✅ 完整的日志记录
- ✅ 云端自动运行（GitHub Actions）

## 🚀 快速开始

### 1. 安装依赖
```bash
cd "/Users/Lark CLI/vantageUm_Calendar"
npm install
```

### 2. 配置环境变量
```bash
cp .env.example .env
# 编辑 .env 文件，填入您的 Lark 凭证
```

### 3. 本地测试
```bash
npm run sync
```

### 4. 部署到 GitHub
```bash
# 使用部署助手
./deploy.sh

# 或手动部署，参考 docs/DEPLOYMENT_MANUAL.md
```

## 📖 详细文档

- [部署状态](docs/DEPLOYMENT_STATUS.md) - 当前部署进度
- [部署指南](docs/DEPLOYMENT_MANUAL.md) - 详细部署步骤
- [设置指南](docs/SETUP.md) - Lark 应用配置
- [API 文档](docs/API.md) - Lark API 说明
- [检查清单](docs/CHECKLIST.md) - 部署检查项

## ⚙️ 配置要求

### 必需的环境变量
- `LARK_APP_ID` - Lark 应用 ID
- `LARK_APP_SECRET` - Lark 应用密钥
- `BO_COORDINATOR_CALENDAR_ID` - Bo Coordinator 日历 ID
- `NEW_JIRA_CALENDAR_ID` - new jira 日历 ID

### 可选配置
- `SYNC_DAYS_FORWARD` - 查询天数（默认：7）
- `LOG_LEVEL` - 日志级别（默认：info）

## 📊 运行示例

```
=== 同步摘要 ===
检查的会议总数: 15
创建的会议: 8
跳过的会议（冲突）: 6
失败的会议: 1
```

## 🔧 故障排除

### 问题：推送代码失败
**解决**: 使用 Personal Access Token (PAT) 而非密码
- 创建 PAT: https://github.com/settings/tokens/new
- 需要权限: `repo`

### 问题：工作流未运行
**解决**:
1. 确保仓库有最近的活动
2. 检查 Actions 是否启用
3. 验证 GitHub Secrets 已正确配置

### 问题：认证失败
**解决**:
1. 检查 LARK_APP_ID 和 LARK_APP_SECRET 是否正确
2. 确保 Lark 应用已发布并获得批准

## 📞 获取帮助

遇到问题？查看：
1. [故障排除文档](README.md#-troubleshooting)
2. [部署指南](docs/DEPLOYMENT_MANUAL.md)
3. [GitHub Issues](https://github.com/YOUR_USERNAME/vantageUm_Calendar/issues)

## 📝 更新日志

### v1.0.0 (2026-05-21)
- ✅ 初始版本发布
- ✅ 实现日历同步核心功能
- ✅ GitHub Actions 自动化部署
- ✅ 完整文档和部署指南

## 📄 许可证

ISC

---

**开发完成**: ✅
**部署状态**: 🟡 等待手动部署
**文档状态**: ✅ 完整

立即开始部署 → [部署指南](docs/DEPLOYMENT_MANUAL.md)
