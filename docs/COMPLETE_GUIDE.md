# 🎯 完整授权方案

## 日历情况

### new jira 日历
- **类型**: 您的个人日历
- **操作**: 您可以直接授权

### Bo Coordinator 日历
- **类型**: DNEMY 群组的共享日历
- **日历 ID**: `ou_c6bdc791b875c3af1775a652bcf3b638`
- **操作**: 需要群组管理员授权

---

## 第一步：授权 new jira 日历（您自己的）

### 操作步骤：

1. **打开 Lark 日历应用**

2. **找到 new jira 日历**
   - 在左侧日历列表中找到 "new jira"
   - 点击日历名称旁的 "..." 或设置图标

3. **进入日历设置**
   - 选择 "日历设置" 或 "Calendar Settings"

4. **添加应用成员**
   - 找到 "成员管理" 或 "Members"
   - 点击 "添加成员" 或 "Add Member"

5. **搜索并添加应用**
   - 输入 App ID: `cli_aa84163b89789ed3`
   - 或搜索您的应用名称
   - 找到后点击添加

6. **设置权限**
   - 选择 "编辑者" 或 "Editor" 权限
   - 确保应用可以读取和创建事件

7. **保存**
   - 点击 "保存" 或 "确定"

---

## 第二步：授权 Bo Coordinator 日历（DNEMY 群组日历）

### 方法 A: 如果您是 DNEMY 群组管理员

**操作步骤**：

1. **打开 Lark**
2. **进入 DNEMY 群组**
3. **找到群组日历**
   - 在群组中找到 "BO Coordinator" 日历
   - 或在日历应用中找到该日历

4. **进入日历设置**
   - 点击日历的 "..." 菜单
   - 选择 "日历设置"

5. **添加应用成员**
   - 找到 "成员管理" 或 "权限管理"
   - 点击 "添加成员"

6. **搜索并添加应用**
   - 输入 App ID: `cli_aa84163b89789ed3`
   - 找到应用后添加

7. **设置权限**
   - 授予 "编辑者" 权限
   - 确保应用可以读取和创建事件

8. **保存设置**

---

### 方法 B: 如果您不是群组管理员

**操作步骤**：

1. **找到 DNEMY 群组管理员**
   - 在 DNEMY 群组中查看成员列表
   - 找到有管理员标识的成员

2. **联系群组管理员**
   - 发送消息给管理员
   - 说明需要授权应用访问 BO Coordinator 日历

3. **提供以下信息给管理员**：

```
您好，我需要授权一个 Lark 应用访问 DNEMY 群组的 BO Coordinator 日历。

应用信息：
- App ID: cli_aa84163b89789ed3
- 应用类型: 自建应用
- 用途: 日历同步工具

需要的权限：
- 读取日历事件
- 创建日历事件

操作步骤：
1. 打开 BO Coordinator 日历设置
2. 进入成员管理
3. 添加应用（搜索 App ID: cli_aa84163b89789ed3）
4. 授予编辑者权限

谢谢！
```

4. **等待管理员操作**
   - 管理员完成授权后通知您

---

## 第三步：验证授权

### 等待授权生效

授权完成后，等待 2-3 分钟让权限生效。

### 运行验证脚本

```bash
cd "/Users/Lark CLI/vantageUm_Calendar"
./list-calendars.sh
```

**预期结果**:
```
✅ 成功获取日历列表

可访问的日历:
- New Jira Assistant: feishu.cn_xxx (primary)
- new jira: ou_dc36b8ad99537b07510b9af57d152136 (shared/group)
- BO Coordinator: ou_c6bdc791b875c3af1775a652bcf3b638 (shared/group)
```

---

## 第四步：测试工作流

### 触发工作流

```bash
gh workflow run "Daily Calendar Sync" \
  --repo newjira1994-spec/vantageUm_Calendar
```

### 查看运行结果

访问: https://github.com/newjira1994-spec/vantageUm_Calendar/actions

**预期结果**:
```
=== Sync Summary ===
Total events checked: X
Events created: Y
Events skipped (conflicts): Z
Events failed: 0
```

---

## 🔄 临时测试方案

如果等待群组管理员授权时间较长，您可以：

### 方案 1: 先测试 new jira 日历

```bash
# 暂时只测试 new jira 日历
gh variable set BO_COORDINATOR_CALENDAR_ID \
  --body "ou_dc36b8ad99537b07510b9af57d152136" \
  --repo newjira1994-spec/vantageUm_Calendar

gh variable set NEW_JIRA_CALENDAR_ID \
  --body "ou_dc36b8ad99537b07510b9af57d152136" \
  --repo newjira1994-spec/vantageUm_Calendar

# 触发工作流
gh workflow run "Daily Calendar Sync" \
  --repo newjira1994-spec/vantageUm_Calendar
```

### 方案 2: 创建测试事件

1. 在 new jira 日历中创建一个测试事件（未来几天）
2. 运行工作流
3. 检查是否跳过该事件（因为已存在）
4. 删除该事件
5. 再次运行工作流
6. 检查是否重新创建了该事件

---

## 📋 完整检查清单

- [ ] 已授权 new jira 日历（您的个人日历）
- [ ] 已联系 DNEMY 群组管理员（或您是管理员）
- [ ] 管理员已授权 BO Coordinator 日历
- [ ] 运行 `./list-calendars.sh` 验证成功
- [ ] 两个日历都出现在列表中
- [ ] 工作流运行成功
- [ ] Lark 日历中看到新创建的事件

---

## 🎯 下一步行动

### 立即操作：

1. **授权 new jira 日历**（您可以直接操作）
   - 按照第一步的步骤完成

2. **处理 BO Coordinator 日历**
   - 如果您是 DNEMY 管理员：直接授权
   - 如果不是：联系管理员

3. **完成后告诉我**
   - 我会帮您验证和测试

---

## 📞 需要帮助？

请告诉我：

1. 您是否已授权 new jira 日历？
2. 您是否是 DNEMY 群组的管理员？
3. 如果不是，您是否已联系管理员？
4. 授权过程中是否遇到任何问题？

我会继续协助您完成配置！