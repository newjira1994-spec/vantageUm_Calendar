#!/bin/bash

# 获取用户主日历 ID

echo "=========================================="
echo "   获取主日历 ID"
echo "=========================================="
echo ""

APP_ID="cli_aa84163b89789ed3"
APP_SECRET="DU0O71dKC270CkxUwmuSocSpzvzpIvZU"

# 获取 token
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
echo "正在获取日历列表..."
echo ""

# 获取日历列表
CALENDARS_RESPONSE=$(curl -s -X GET \
  "https://open.larksuite.com/open-apis/calendar/v4/calendars?page_size=50" \
  -H "Authorization: Bearer $TOKEN")

echo "$CALENDARS_RESPONSE" | jq '.' 2>/dev/null || echo "$CALENDARS_RESPONSE"
echo ""

# 检查是否有日历
CODE=$(echo "$CALENDARS_RESPONSE" | jq -r '.code' 2>/dev/null)

if [ "$CODE" = "0" ]; then
  echo "✅ 成功获取日历列表"
  echo ""
  echo "可访问的日历:"
  echo "$CALENDARS_RESPONSE" | jq -r '.data.calendars[] | "- \(.summary): \(.calendar_id) (\(.type))"' 2>/dev/null
else
  echo "❌ 获取日历列表失败"
  echo "错误代码: $CODE"
  echo "错误信息: $(echo "$CALENDARS_RESPONSE" | jq -r '.msg' 2>/dev/null)"
fi

echo ""
echo "=========================================="
echo ""
echo "💡 提示:"
echo "如果上面的列表中没有 Bo Coordinator 和 new jira 日历，"
echo "说明应用没有访问这些日历的权限。"
echo ""
echo "解决方案:"
echo "1. 确认这些日历是否存在"
echo "2. 联系日历所有者授权您的应用"
echo "3. 或者使用上面列出的日历 ID 进行测试"
echo "=========================================="