# 🚀 立即开始部署

## 当前状态

✅ **项目开发完成**
✅ **Git 仓库已初始化**
✅ **所有代码已提交**
⏳ **等待推送到 GitHub**

---

## 📋 您需要做的 3 个步骤

### 步骤 1️⃣: 创建 GitHub 仓库（5 分钟）

#### 方法 A: 使用部署脚本（推荐）
```bash
cd "/Users/Lark CLI/vantageUm_Calendar"
./deploy.sh
```

脚本会引导您完成整个流程！

#### 方法 B: 手动创建
1. 打开浏览器访问: **https://github.com/new**
2. 填写信息:
   - Repository name: `vantageUm_Calendar`
   - Description: `日历同步工具`
   - 选择 Public 或 Private
   - **不要勾选任何初始化选项**
3. 点击 **Create repository**

### 步骤 2️⃣: 推送代码（2 分钟）

```bash
cd "/Users/Lark CLI/vantageUm_Calendar"

# 替换 YOUR_USERNAME 为您的 GitHub 用户名
git remote add origin https://github.com/YOUR_USERNAME/vantageUm_Calendar.git
git push -u origin main
```

**认证提示**:
- Username: 输入您的 GitHub 用户名
- Password: 使用 **Personal Access Token**（不是密码）

**创建 Token**: https://github.com/settings/tokens/new
- 需要权限: `repo`（完整仓库访问）

### 步骤 3️⃣: 配置 Secrets（3 分钟）

1. 访问: **https://github.com/YOUR_USERNAME/vantageUm_Calendar/settings/secrets/actions**
2. 点击 **New repository secret**
3. 添加两个 secrets:

| Name | Value | 来源 |
|------|-------|------|
| `LARK_APP_ID` | 您的 Lark App ID | Lark 开发平台 |
| `LARK_APP_SECRET` | 您的 Lark App Secret | Lark 开发平台 |

---

## ✅ 测试部署（2 分钟）

1. 访问: **https://github.com/YOUR_USERNAME/vantageUm_Calendar/actions**
2. 点击 **Daily Calendar Sync**
3. 点击 **Run workflow** → **Run workflow**
4. 等待运行完成（约 1-2 分钟）
5. 查看日志，确认成功

---

## 🎯 成功标志

看到以下输出表示成功：
```
=== Sync Summary ===
Total events checked: X
Events created: Y
Events skipped (conflicts): Z
Events failed: 0
```

---

## 📚 详细文档

需要更多帮助？查看：

- 🇨🇳 [中文快速指南](../README_CN.md)
- 📖 [详细部署步骤](../docs/DEPLOYMENT_MANUAL.md)
- 📊 [部署状态跟踪](../docs/DEPLOYMENT_STATUS.md)
- ✅ [部署检查清单](../docs/CHECKLIST.md)
- 🔧 [故障排除](../README.md#-troubleshooting)

---

## 💡 快速提示

### 如果没有 Lark 凭证
1. 访问: https://open.larksuite.com/
2. 创建自建应用
3. 获取 App ID 和 App Secret
4. 添加日历权限并发布应用
5. 详细步骤: [docs/SETUP.md](../docs/SETUP.md)

### 如果推送失败
- 确保使用 **Personal Access Token** 而非密码
- Token 需要 `repo` 权限
- 创建 token: https://github.com/settings/tokens/new

### 如果工作流失败
- 检查 Secrets 是否正确配置
- 验证 Lark 应用已发布
- 确认日历 ID 正确

---

## 📞 需要帮助？

遇到问题？按以下顺序查看：
1. [故障排除文档](../README.md#-troubleshooting)
2. [详细部署指南](../docs/DEPLOYMENT_MANUAL.md)
3. [Lark 设置指南](../docs/SETUP.md)

---

## ⏰ 自动运行时间表

部署完成后，工作流将：
- **每天 UTC+7 早上 9:00** 自动运行
- **即 UTC 时间 2:00 AM**
- **即使您的电脑关闭** 也能运行（云端执行）

---

**准备好了吗？开始部署！** 👇

### 快速命令（复制粘贴）

```bash
# 进入项目目录
cd "/Users/Lark CLI/vantageUm_Calendar"

# 运行部署助手
./deploy.sh
```

或手动执行：

```bash
cd "/Users/Lark CLI/vantageUm_Calendar"
git remote add origin https://github.com/YOUR_USERNAME/vantageUm_Calendar.git
git push -u origin main
```

---

**祝您部署顺利！🎉**