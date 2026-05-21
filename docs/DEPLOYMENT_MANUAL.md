# 部署指南 - 手动步骤

由于您的系统没有安装 GitHub CLI 或 Homebrew，我将为您提供详细的手动部署步骤。

## 🚀 第一步：在 GitHub 网站创建仓库

### 1.1 访问 GitHub
1. 打开浏览器，访问 [https://github.com](https://github.com)
2. 登录您的 GitHub 账号

### 1.2 创建新仓库
1. 点击右上角的 **"+"** 号
2. 选择 **"New repository"**
3. 填写仓库信息：
   - **Repository name**: `vantageUm_Calendar`
   - **Description** (可选): `日历同步工具 - 自动同步 Lark 日历`
   - **可见性**: 选择 Public（公开）或 Private（私有）
   - **不要**勾选以下选项：
     - ❌ Add a README file
     - ❌ Add .gitignore
     - ❌ Choose a license
4. 点击 **"Create repository"**

### 1.3 记录仓库 URL
创建后，您会看到仓库 URL，格式类似：
```
https://github.com/YOUR_USERNAME/vantageUm_Calendar.git
```
请保存这个 URL，稍后需要使用。

## 🔧 第二步：推送代码到 GitHub

在终端执行以下命令（请替换 `YOUR_USERNAME` 为您的 GitHub 用户名）：

```bash
cd "/Users/Lark CLI/vantageUm_Calendar"

# 添加远程仓库
git remote add origin https://github.com/YOUR_USERNAME/vantageUm_Calendar.git

# 推送代码
git push -u origin main
```

如果提示输入用户名和密码：
- **Username**: 输入您的 GitHub 用户名
- **Password**: 使用 Personal Access Token (PAT)，而不是密码

### 2.1 创建 Personal Access Token (如果需要)
1. 访问 [GitHub Settings → Developer settings → Personal access tokens → Tokens (classic)](https://github.com/settings/tokens)
2. 点击 **"Generate new token (classic)"**
3. 设置：
   - **Note**: `Calendar Sync Tool`
   - **Expiration**: 选择有效期（建议 90 天）
   - **Select scopes**: 勾选 `repo` (完整仓库访问权限)
4. 点击 **"Generate token"**
5. **立即复制** token（只显示一次！）
6. 在推送时使用这个 token 作为密码

## 🔐 第三步：配置 GitHub Secrets

### 3.1 进入仓库设置
1. 在 GitHub 仓库页面，点击 **"Settings"** 标签
2. 在左侧菜单找到 **"Secrets and variables"** → **"Actions"**

### 3.2 添加必需的 Secrets

#### Secret 1: LARK_APP_ID
1. 点击 **"New repository secret"**
2. **Name**: `LARK_APP_ID`
3. **Secret**: 输入您的 Lark App ID
4. 点击 **"Add secret"**

#### Secret 2: LARK_APP_SECRET
1. 点击 **"New repository secret"**
2. **Name**: `LARK_APP_SECRET`
3. **Secret**: 输入您的 Lark App Secret
4. 点击 **"Add secret"**

### 3.3 添加可选的 Variables（或使用默认值）

点击 **"Variables"** 标签，添加以下变量（如果不想使用默认值）：

| Name | Value | 说明 |
|------|-------|------|
| `BO_COORDINATOR_CALENDAR_ID` | `ou_c6bdc791b875c3af1775a652bcf3b638` | Bo Coordinator 日历 ID |
| `NEW_JIRA_CALENDAR_ID` | `ou_dc36b8ad99537b07510b9af57d152136` | new jira 日历 ID |
| `SYNC_DAYS_FORWARD` | `7` | 查询未来天数 |
| `LOG_LEVEL` | `info` | 日志级别 |

**注意**: 如果不添加这些变量，workflow 会使用默认值。

## ✅ 第四步：测试 GitHub Actions

### 4.1 手动触发工作流
1. 在 GitHub 仓库页面，点击 **"Actions"** 标签
2. 在左侧选择 **"Daily Calendar Sync"** 工作流
3. 点击右侧的 **"Run workflow"** 按钮
4. 选择 **"Branch: main"**
5. 点击绿色的 **"Run workflow"** 按钮

### 4.2 查看运行结果
1. 等待几秒钟，刷新页面
2. 点击最新的工作流运行记录
3. 点击 **"sync-calendars"** 任务
4. 展开各个步骤查看日志

### 4.3 预期输出
如果一切正常，您应该看到：
```
=== Sync Summary ===
Total events checked: X
Events created: Y
Events skipped (conflicts): Z
Events failed: 0
```

### 4.4 下载日志文件
1. 在工作流运行页面底部
2. 找到 **"Artifacts"** 部分
3. 下载 `calendar-sync-logs`
4. 解压查看详细日志

## 📅 第五步：验证定时任务

### 5.1 检查定时计划
工作流配置为每天 UTC+7 早上 9:00 运行（即 UTC 时间 2:00 AM）。

Cron 表达式: `0 2 * * *`

### 5.2 监控运行
- 每天检查 Actions 标签页
- 查看运行历史
- 如有失败，查看日志排查

## 🔧 故障排除

### 问题 1: 推送失败 "Authentication failed"
**解决方案**:
- 确保使用 Personal Access Token，而不是密码
- Token 需要 `repo` 权限

### 问题 2: 工作流未运行
**解决方案**:
- 确保仓库有最近的活动（GitHub 会暂停不活跃仓库的定时任务）
- 检查 Actions 是否在仓库设置中启用

### 问题 3: "Failed to get tenant access token"
**解决方案**:
- 检查 `LARK_APP_ID` 和 `LARK_APP_SECRET` 是否正确
- 确保 Lark 应用已发布并获得批准

### 问题 4: "Failed to get calendar events"
**解决方案**:
- 验证日历 ID 是否正确
- 检查 Lark 应用是否有日历权限
- 确保日历对应用可访问

## 📝 快速命令参考

```bash
# 进入项目目录
cd "/Users/Lark CLI/vantageUm_Calendar"

# 查看远程仓库
git remote -v

# 推送更新
git add .
git commit -m "Update: your message"
git push

# 查看工作流状态
# 访问: https://github.com/YOUR_USERNAME/vantageUm_Calendar/actions
```

## 🎯 下一步

完成部署后：
1. ✅ 验证工作流手动运行成功
2. ✅ 检查 Lark 日历中是否创建了会议
3. ✅ 监控第二天的自动运行
4. ✅ 根据需要调整配置

---

**需要帮助？** 查看项目文档：
- [README.md](../README.md) - 项目概览
- [docs/SETUP.md](./SETUP.md) - 详细设置指南
- [docs/API.md](./API.md) - API 文档
