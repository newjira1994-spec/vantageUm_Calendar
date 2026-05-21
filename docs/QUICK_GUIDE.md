# 🎉 简化授权指南 - 您是群主

## 好消息！

- ✅ new jira 是 Meeting schedules 群组的群主
- ✅ BO Coordinator 日历在 Meeting schedules 群组中
- ✅ 您有权限直接授权应用访问两个日历

---

## 🚀 快速操作步骤

### 第一步：授权 new jira 日历（您的个人日历）

#### 操作：

1. **打开 Lark 日历应用**

2. **找到 new jira 日历**
   - 在左侧日历列表中找到 "new jira"
   - 点击日历名称旁的 **"..."** 菜单

3. **进入设置**
   - 选择 **"日历设置"**

4. **添加应用**
   - 找到 **"成员"** 或 **"成员管理"**
   - 点击 **"添加成员"**

5. **搜索应用**
   - 输入 App ID: `cli_aa84163b89789ed3`
   - 或搜索您的应用名称

6. **授予权限**
   - 选择 **"编辑者"** 权限
   - 点击 **"确定"** 或 **"添加"**

---

### 第二步：授权 BO Coordinator 日历（群组日历）

#### 操作：

1. **打开 Lark**

2. **进入 Meeting schedules 群组**
   - 在 Lark 左侧找到群组列表
   - 点击进入 **"Meeting schedules"** 群组

3. **找到群组日历**
   - 在群组信息或群组设置中找到日历
   - 或在日历应用中找到 **"BO Coordinator"** 日历

4. **进入日历设置**
   - 点击 BO Coordinator 日历的 **"..."** 菜单
   - 选择 **"日历设置"**

5. **添加应用成员**
   - 找到 **"成员管理"** 或 **"权限管理"**
   - 点击 **"添加成员"**

6. **搜索并添加应用**
   - 输入 App ID: `cli_aa84163b89789ed3`
   - 找到应用后点击添加

7. **设置权限**
   - 授予 **"编辑者"** 权限
   - 确保可以读取和创建事件

8. **保存设置**
   - 点击 **"保存"** 或 **"确定"**

---

## 第三步：验证授权

### 等待生效

授权完成后，等待 **2-3 分钟**让权限生效。

### 运行验证脚本

```bash
cd "/Users/Lark CLI/vantageUm_Calendar"
./list-calendars.sh
```

**预期看到**:
```
✅ 成功获取日历列表

可访问的日历:
- New Jira Assistant: feishu.cn_xxx (primary)
- new jira: ou_dc36b8ad99537b07510b9af57d152136
- BO Coordinator: ou_c6bdc791b875c3af1775a652bcf3b638
```

---

## 第四步：测试工作流

### 触发工作流

```bash
gh workflow run "Daily Calendar Sync" \
  --repo newjira1994-spec/vantageUm_Calendar
```

### 查看结果

访问: https://github.com/newjira1994-spec/vantageUm_Calendar/actions

等待 1-2 分钟后查看运行结果。

**成功标志**:
```
=== Sync Summary ===
Total events checked: X
Events created: Y
Events skipped (conflicts): Z
Events failed: 0
```

---

## 📋 操作检查清单

完成以下步骤：

- [ ] 打开 Lark 日历应用
- [ ] 授权 new jira 日历（添加应用，授予编辑权限）
- [ ] 进入 Meeting schedules 群组
- [ ] 授权 BO Coordinator 日历（添加应用，授予编辑权限）
- [ ] 等待 2-3 分钟
- [ ] 运行 `./list-calendars.sh` 验证
- [ ] 确认两个日历都出现在列表中
- [ ] 触发 GitHub Actions 工作流
- [ ] 查看运行结果

---

## 🎯 预计时间

- **授权 new jira**: 2 分钟
- **授权 BO Coordinator**: 3 分钟
- **验证和测试**: 5 分钟

**总计**: 约 10 分钟

---

## 📞 遇到问题？

### 常见问题：

#### Q1: 找不到 "添加成员" 选项
**A**: 可能是界面版本不同，尝试：
- 在日历设置中找 "共享" 或 "Share"
- 或找 "权限" 或 "Permissions"
- 或直接搜索应用并邀请

#### Q2: 搜索不到应用
**A**: 确保：
- 应用已发布（您已确认）
- 使用正确的 App ID: `cli_aa84163b89789ed3`
- 尝试使用应用名称搜索

#### Q3: 授权后仍无法访问
**A**:
- 等待 3-5 分钟让权限生效
- 重新运行验证脚本
- 检查权限是否正确授予

---

## ✅ 完成后

完成所有步骤后，请告诉我：

1. 是否成功授权了两个日历？
2. 运行 `./list-calendars.sh` 是否看到两个日历？
3. GitHub Actions 工作流是否运行成功？

我会帮您确认最终结果！