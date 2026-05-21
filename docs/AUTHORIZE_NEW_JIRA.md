# 🎯 快速操作指南 - 授权应用访问 new jira 日历

## 您的情况

- ✅ new jira 日历是您自己的
- ✅ 您可以直接授权应用访问
- ⏳ Bo Coordinator 日历需要确认所有者

---

## 第一步：授权应用访问 new jira 日历

### 方法 A: 通过 Lark 日历应用（推荐）

#### 操作步骤：

1. **打开 Lark 应用**
   - 在电脑或手机上打开 Lark
   - 进入 "日历" 应用

2. **找到 new jira 日历**
   - 在日历列表中找到 "new jira" 日历
   - 点击日历名称旁的 "..." 或设置图标

3. **进入日历设置**
   - 选择 "日历设置" 或 "Calendar Settings"

4. **添加应用成员**
   - 找到 "成员" 或 "Members" 部分
   - 点击 "添加成员" 或 "Add Member"

5. **搜索并添加应用**
   - 在搜索框输入 App ID: `cli_aa84163b89789ed3`
   - 或搜索应用名称（您在 Lark 开发平台设置的名字）
   - 找到应用后，点击添加

6. **设置权限**
   - 授予应用 "编辑者" 或 "Editor" 权限
   - 这样应用可以读取和创建事件

7. **保存设置**
   - 点击 "保存" 或 "确定"

---

### 方法 B: 通过 Lark 开发平台（如果方法 A 不可行）

#### 操作步骤：

1. **访问 Lark 开发平台**
   - 打开: https://open.larksuite.com/
   - 进入您的应用（App ID: `cli_aa84163b89789ed3`）

2. **找到应用可用范围**
   - 左侧菜单找到 "应用可用范围" 或 "Available Scopes"
   - 找到日历相关的权限

3. **添加日历访问**
   - 如果有 "添加日历" 选项，点击添加
   - 选择 new jira 日历

---

## 第二步：验证授权是否成功

### 运行测试脚本

完成授权后，等待 1-2 分钟，然后运行：

```bash
cd "/Users/Lark CLI/vantageUm_Calendar"
./list-calendars.sh
```

**预期结果**:
- ✅ new jira 日历出现在列表中
- ✅ 日历 ID: `ou_dc36b8ad99537b07510b9af57d152136`

---

## 第三步：处理 Bo Coordinator 日历

### 确认 Bo Coordinator 日历所有者

请回答以下问题：

1. Bo Coordinator 日历是您自己的吗？
2. 如果不是，所有者是谁？
3. 您是否可以联系到所有者？

---

## 🚀 快速测试方案

### 方案：先测试 new jira 日历

在等待 Bo Coordinator 日历权限期间，您可以：

1. **暂时使用 new jira 日历作为源和目标**
   - 这样可以测试工作流是否正常运行
   - 验证应用能否成功读取和创建事件

2. **更新配置进行测试**

```bash
# 暂时将两个日历 ID 都设置为 new jira
gh variable set BO_COORDINATOR_CALENDAR_ID \
  --body "ou_dc36b8ad99537b07510b9af57d152136" \
  --repo newjira1994-spec/vantageUm_Calendar

gh variable set NEW_JIRA_CALENDAR_ID \
  --body "ou_dc36b8ad99537b07510b9af57d152136" \
  --repo newjira1994-spec/vantageUm_Calendar
```

**注意**: 使用同一个日历作为源和目标时，所有事件都会被跳过（因为已存在）。要真正测试创建功能，您需要：

- 在 new jira 日历中创建一个测试事件
- 然后删除这个事件
- 再运行工作流，看是否能重新创建

---

## 📋 操作检查清单

完成授权后，确认：

- [ ] 在 Lark 日历中找到了 new jira 日历
- [ ] 进入了日历设置
- [ ] 添加了应用（App ID: `cli_aa84163b89789ed3`）
- [ ] 授予了编辑权限
- [ ] 运行 `./list-calendars.sh` 验证成功
- [ ] new jira 日历出现在列表中

---

## 🎯 下一步

请告诉我：

1. 您是否已按照上述步骤添加应用到 new jira 日历？
2. 添加过程中是否遇到任何问题？
3. Bo Coordinator 日历的所有者是谁？

完成 new jira 日历授权后，我们就可以进行测试了！
