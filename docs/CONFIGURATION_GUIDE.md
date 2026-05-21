# 📋 后续配置步骤指南

本指南将帮助您完成剩余的 10% 配置工作，确保日历同步工具能够成功运行。

---

## 🎯 总体目标

解决 "invalid calendar_id" 错误，确保工作流能够成功读取和创建日历事件。

---

## 第一步：检查 Lark 应用状态

### 1.1 访问 Lark 开发平台

**操作**:
1. 打开浏览器
2. 访问: https://open.larksuite.com/
3. 使用您的 Lark 账号登录

**预期结果**: 进入 Lark 开发者控制台

---

### 1.2 找到您的应用

**操作**:
1. 在控制台首页，找到应用列表
2. 找到 App ID 为 `cli_aa84163b89789ed3` 的应用
3. 点击进入应用详情

**如果找不到应用**:
- 可能应用名称不同，请根据 App ID 查找
- 或者重新创建应用（参考第二步）

---

### 1.3 检查应用发布状态

**操作**:
1. 在应用详情页，找到左侧菜单
2. 点击 **"版本管理"** 或 **"Version Management"**
3. 查看当前状态

**可能的状态**:

#### 情况 A: 应用未发布
**表现**: 显示 "创建版本" 或 "Create Version" 按钮

**解决**:
1. 点击 **"创建版本"**
2. 填写版本信息:
   - 版本号: `1.0.0`
   - 更新说明: `日历同步工具初始版本`
3. 点击 **"保存"**
4. 点击 **"提交审批"** 或 **"Submit for Approval"**
5. 等待审批（通常 1-2 个工作日）

#### 情况 B: 应用待审批
**表现**: 显示 "审批中" 或 "Pending Approval"

**解决**: 等待审批完成

#### 情况 C: 应用已发布
**表现**: 显示 "已发布" 或 "Published"，有绿色勾号

**操作**: ✅ 继续下一步

---

## 第二步：检查权限配置

### 2.1 进入权限设置

**操作**:
1. 在应用详情页左侧菜单
2. 点击 **"权限与范围"** 或 **"Permissions & Scopes"**

---

### 2.2 检查已有权限

**需要的权限**:
- ✅ `calendar:calendar:readonly` - 读取日历信息
- ✅ `calendar:calendar_event:readonly` - 读取日历事件
- ✅ `calendar:calendar_event:write` - 创建日历事件

**操作**:
1. 查看已添加的权限列表
2. 检查是否包含上述三个权限

---

### 2.3 添加缺失的权限

**如果缺少权限**:

1. 点击 **"添加权限"** 或 **"Add Permission"**
2. 在搜索框输入: `calendar`
3. 找到以下权限并勾选:
   - `calendar:calendar:readonly`
   - `calendar:calendar_event:readonly`
   - `calendar:calendar_event:write`
4. 点击 **"确认"** 或 **"Confirm"**
5. **重要**: 添加权限后需要重新发布应用
   - 回到 "版本管理"
   - 创建新版本（如 1.0.1）
   - 提交审批

---

## 第三步：验证日历 ID

### 3.1 获取正确的日历 ID

**操作**:

#### 方法 A: 通过 Lark 日历应用
1. 打开 Lark 应用（桌面或网页版）
2. 进入 **"日历"** 应用
3. 找到 **Bo Coordinator** 日历
4. 点击日历名称旁的 **"..."** 或设置图标
5. 选择 **"日历设置"** 或 **"Calendar Settings"**
6. 找到 **"日历 ID"** 或 **"Calendar ID"**
7. 复制该 ID（格式：`ou_xxxxxx`）

8. 重复以上步骤获取 **new jira** 日历的 ID

#### 方法 B: 通过日历分享链接
1. 在日历应用中，右键点击日历
2. 选择 **"分享日历"** 或 **"Share Calendar"**
3. 在分享链接中找到日历 ID
   - 链接格式通常为: `https://xxx/calendar/ou_xxxxxx`
   - `ou_xxxxxx` 部分就是日历 ID

---

### 3.2 对比日历 ID

**当前配置的日历 ID**:
- Bo Coordinator: `ou_c6bdc791b875c3af1775a652bcf3b638`
- new jira: `ou_dc36b8ad99537b07510b9af57d152136`

**操作**:
1. 将您获取的实际日历 ID 与上述 ID 对比
2. 记录是否一致

---

### 3.3 更新日历 ID（如果不一致）

**如果日历 ID 不一致**，有两种更新方法:

#### 方法 A: 使用 GitHub Variables（推荐）

打开终端，执行以下命令:

```bash
# 设置 Bo Coordinator 日历 ID（替换为实际 ID）
gh variable set BO_COORDINATOR_CALENDAR_ID \
  --body "ou_实际的Bo_Coordinator日历ID" \
  --repo newjira1994-spec/vantageUm_Calendar

# 设置 new jira 日历 ID（替换为实际 ID）
gh variable set NEW_JIRA_CALENDAR_ID \
  --body "ou_实际的new_jira日历ID" \
  --repo newjira1994-spec/vantageUm_Calendar
```

#### 方法 B: 更新工作流文件

编辑 `.github/workflows/daily-sync.yml` 文件，修改默认值。

---

## 第四步：验证日历访问权限

### 4.1 确认应用有权访问日历

**重要**: 即使日历 ID 正确，应用也需要获得访问权限。

**操作**:

#### 情况 A: 您是日历所有者
- 应用自动拥有访问权限
- ✅ 无需额外操作

#### 情况 B: 您不是日历所有者
需要日历所有者授权:

1. 日历所有者访问 Lark 开发平台
2. 找到您的应用
3. 在应用详情中，找到 **"可用范围"** 或 **"Available Scopes"**
4. 授权应用访问其日历

#### 情况 C: 组织日历
如果是组织日历:
1. 组织管理员需要在管理后台授权应用
2. 路径: 管理后台 → 应用管理 → 找到您的应用 → 授权

---

## 第五步：测试配置

### 5.1 重新触发工作流

**操作**:

#### 方法 A: 通过 GitHub 网页
1. 访问: https://github.com/newjira1994-spec/vantageUm_Calendar/actions
2. 点击 **"Daily Calendar Sync"** 工作流
3. 点击右侧 **"Run workflow"** 按钮
4. 选择 **"Branch: main"**
5. 点击绿色的 **"Run workflow"** 按钮

#### 方法 B: 通过命令行
```bash
gh workflow run "Daily Calendar Sync" \
  --repo newjira1994-spec/vantageUm_Calendar
```

---

### 5.2 查看运行结果

**操作**:
1. 等待 1-2 分钟
2. 刷新 Actions 页面
3. 点击最新的工作流运行记录
4. 点击 **"sync-calendars"** 任务
5. 展开各个步骤查看日志

---

### 5.3 判断运行结果

#### 成功标志 ✅

看到以下输出:
```
=== Sync Summary ===
Total events checked: X
Events created: Y
Events skipped (conflicts): Z
Events failed: 0
```

**恭喜！配置成功！**

#### 失败标志 ❌

仍然看到错误信息

**操作**: 查看错误详情，根据提示调整配置

---

## 第六步：验证日历事件创建

### 6.1 检查 Lark 日历

**操作**:
1. 打开 Lark 日历应用
2. 切换到 **new jira** 日历
3. 查看未来 7 天的日历
4. 检查是否有标题为 **"from UM calendar"** 的新会议

**预期结果**:
- 看到新创建的会议
- 会议时间与 Bo Coordinator 日历中的会议时间一致
- 会议标题为 "from UM calendar"

---

## 🔄 故障排除流程图

```
开始
  ↓
检查应用发布状态 → 未发布 → 发布应用 → 等待审批
  ↓ 已发布
检查权限配置 → 缺少权限 → 添加权限 → 重新发布
  ↓ 权限完整
验证日历 ID → ID 不正确 → 更新 ID
  ↓ ID 正确
验证访问权限 → 无权限 → 授权应用
  ↓ 有权限
重新测试工作流 → 失败 → 查看日志 → 调整配置
  ↓ 成功
验证事件创建 → 完成！✅
```

---

## 📞 遇到问题？

### 常见问题及解决方案

#### Q1: 找不到应用
**A**: 根据App ID `cli_aa84163b89789ed3` 查找，或重新创建应用

#### Q2: 权限添加后仍报错
**A**: 添加权限后必须重新发布应用才能生效

#### Q3: 日历 ID 正确但仍无法访问
**A**: 检查应用是否获得日历访问授权，特别是组织日历

#### Q4: 工作流运行成功但未创建会议
**A**:
- 检查 Bo Coordinator 日历是否有未来 7 天的会议
- 检查 new jira 日历是否已有冲突会议
- 查看日志中的 "skipped" 数量

---

## ✅ 完成检查清单

完成所有步骤后，确认以下项目:

- [ ] Lark 应用已发布并获得批准
- [ ] 应用拥有三个必需的日历权限
- [ ] 日历 ID 正确无误
- [ ] 应用有权访问两个日历
- [ ] 工作流运行成功（exit code 0）
- [ ] Lark 日历中看到新创建的会议

全部勾选后，配置完成！🎉

---

## 📊 下一步

配置完成后:

1. **监控运行**: 每天检查 Actions 页面，确认自动运行成功
2. **调整配置**: 根据需要修改同步天数、日志级别等
3. **扩展功能**: 如需同步更多日历，可添加新的配置

---

**准备好了吗？让我们开始第一步！**

请告诉我：
1. 您是否已访问 Lark 开发平台？
2. 您是否找到了 App ID 为 `cli_aa84163b89789ed3` 的应用？
3. 应用的当前状态是什么（未发布/待审批/已发布）？

我会根据您的反馈继续指导下一步！
