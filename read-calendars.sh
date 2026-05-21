#!/bin/bash

# 读取日历事件脚本

echo "=========================================="
echo "   读取日历事件"
echo "=========================================="
echo ""

APP_ID="cli_aa84163b89789ed3"
APP_SECRET="DU0O71dKC270CkxUwmuSocSpzvzpIvZU"

# 日历 ID
NEW_JIRA_ID="ou_dc36b8ad99537b07510b9af57d152136"
BO_COORDINATOR_ID="ou_c6bdc791b875c3af1775a652bcf3b638"

# 获取 token
echo "步骤 1: 获取 Tenant Access Token"
TOKEN_RESPONSE=$(curl -s -X POST \
  "https://open.larksuite.com/open-apis/auth/v3/tenant_access_token/internal" \
  -H "Content-Type: application/json" \
  -d "{\"app_id\":\"$APP_ID\",\"app_secret\":\"$APP_SECRET\"}")

TOKEN=$(echo "$TOKEN_RESPONSE" | jq -r '.tenant_access_token' 2>/dev/null)

if [ -z "$TOKEN" ] || [ "$TOKEN" = "null" ]; then
  echo "❌ 获取 Token 失败"
  exit 1
fi

echo "✅ Token 获取成功"
echo ""

# 计算时间范围（未来 7 天）
START_TIME=$(date +%s)000
END_TIME=$(($(date +%s) + 7*24*60*60))000

echo "时间范围: 未来 7 天"
echo "开始: $(date)"
echo "结束: $(date -v+7d)"
echo ""

echo "=========================================="
echo ""
echo "步骤 2: 读取 BO Coordinator 日历事件"
echo "=========================================="
echo ""

BO_RESPONSE=$(curl -s -X GET \
  "https://open.larksuite.com/open-apis/calendar/v4/calendars/$BO_COORDINATOR_ID/events?start_time=$START_TIME&end_time=$END_TIME&page_size=50" \
  -H "Authorization: Bearer $TOKEN")

BO_CODE=$(echo "$BO_RESPONSE" | jq -r '.code' 2>/dev/null)

if [ "$BO_CODE" = "0" ]; then
  echo "✅ 成功读取 BO Coordinator 日历"
  echo ""
  BO_EVENTS=$(echo "$BO_RESPONSE" | jq -r '.data.items | length' 2>/dev/null)
  echo "找到 $BO_EVENTS 个事件:"
  echo ""
  echo "$BO_RESPONSE" | jq -r '.data.items[] | "  - \(.summary) | \(.start_time.timestamp) - \(.end_time.timestamp)"' 2>/dev/null || echo "  无事件"
  echo ""
else
  echo "❌ 无法读取 BO Coordinator 日历"
  echo "错误代码: $BO_CODE"
  echo "错误信息: $(echo "$BO_RESPONSE" | jq -r '.msg' 2>/dev/null)"
  echo ""
fi

echo "=========================================="
echo ""
echo "步骤 3: 读取 new jira 日历事件"
echo "=========================================="
echo ""

NJ_RESPONSE=$(curl -s -X GET \
  "https://open.larksuite.com/open-apis/calendar/v4/calendars/$NEW_JIRA_ID/events?start_time=$START_TIME&end_time=$END_TIME&page_size=50" \
  -H "Authorization: Bearer $TOKEN")

NJ_CODE=$(echo "$NJ_RESPONSE" | jq -r '.code' 2>/dev/null)

if [ "$NJ_CODE" = "0" ]; then
  echo "✅ 成功读取 new jira 日历"
  echo ""
  NJ_EVENTS=$(echo "$NJ_RESPONSE" | jq -r '.data.items | length' 2>/dev/null)
  echo "找到 $NJ_EVENTS 个事件:"
  echo ""
  echo "$NJ_RESPONSE" | jq -r '.data.items[] | "  - \(.summary) | \(.start_time.timestamp) - \(.end_time.timestamp)"' 2>/dev/null || echo "  无事件"
  echo ""
else
  echo "❌ 无法读取 new jira 日历"
  echo "错误代码: $NJ_CODE"
  echo "错误信息: $(echo "$NJ_RESPONSE" | jq -r '.msg' 2>/dev/null)"
  echo ""
fi

echo "=========================================="
echo ""
echo "总结"
echo "=========================================="
echo ""

if [ "$BO_CODE" = "0" ] && [ "$NJ_CODE" = "0" ]; then
  echo "✅ 两个日历都成功读取！"
  echo ""
  echo "BO Coordinator: $BO_EVENTS 个事件"
  echo "new jira:       $NJ_EVENTS 个事件"
  echo ""
  echo "🎉 授权成功！可以开始同步了！"
  echo ""
  echo "下一步：运行 GitHub Actions 工作流"
  echo "  gh workflow run 'Daily Calendar Sync' --repo newjira1994-spec/vantageUm_Calendar"
elif [ "$BO_CODE" != "0" ] && [ "$NJ_CODE" != "0" ]; then
  echo "❌ 两个日历都无法读取"
  echo ""
  echo "请检查："
  echo "  1. 是否已授权应用访问日历"
  echo "  2. 日历 ID 是否正确"
  echo "  3. 应用是否已发布"
else
  echo "⚠️  只能读取部分日历"
  echo ""
  if [ "$BO_CODE" = "0" ]; then
    echo "✅ BO Coordinator: 可以读取"
  else
    echo "❌ BO Coordinator: 无法读取 - 需要授权"
  fi
  echo ""
  if [ "$NJ_CODE" = "0" ]; then
    echo "✅ new jira: 可以读取"
  else
    echo "❌ new jira: 无法读取 - 需要授权"
  fi
fi

echo ""
echo "=========================================="