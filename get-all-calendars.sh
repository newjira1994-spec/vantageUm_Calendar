#!/bin/bash

# 获取所有可访问的日历详细信息

echo "=========================================="
echo "   获取所有可访问的日历"
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
echo "正在获取所有可访问的日历..."
echo ""

# 获取日历列表（多次尝试获取所有日历）
PAGE_TOKEN=""
ALL_CALENDARS="[]"

while true; do
  if [ -z "$PAGE_TOKEN" ]; then
    RESPONSE=$(curl -s -X GET \
      "https://open.larksuite.com/open-apis/calendar/v4/calendars?page_size=50" \
      -H "Authorization: Bearer $TOKEN")
  else
    RESPONSE=$(curl -s -X GET \
      "https://open.larksuite.com/open-apis/calendar/v4/calendars?page_size=50&page_token=$PAGE_TOKEN" \
      -H "Authorization: Bearer $TOKEN")
  fi

  CALENDARS=$(echo "$RESPONSE" | jq -r '.data.calendar_list' 2>/dev/null)
  ALL_CALENDARS=$(echo "$ALL_CALENDARS" "$CALENDARS" | jq -s 'add')

  HAS_MORE=$(echo "$RESPONSE" | jq -r '.data.has_more' 2>/dev/null)

  if [ "$HAS_MORE" != "true" ]; then
    break
  fi

  PAGE_TOKEN=$(echo "$RESPONSE" | jq -r '.data.page_token' 2>/dev/null)
done

echo "找到以下日历："
echo ""
echo "$ALL_CALENDARS" | jq -r '.[] | "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n名称: \(.summary)\nID: \(.calendar_id)\n类型: \(.type)\n角色: \(.role)\n权限: \(.permissions)"' 2>/dev/null

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# 统计
TOTAL=$(echo "$ALL_CALENDARS" | jq -r 'length' 2>/dev/null)
echo "总计: $TOTAL 个日历"
echo ""

echo "=========================================="
echo ""
echo "💡 分析"
echo "=========================================="
echo ""

if [ "$TOTAL" -eq 1 ]; then
  echo "⚠️  只能访问 1 个日历"
  echo ""
  echo "可能的原因："
  echo "  1. 机器人账号没有被邀请到其他日历"
  echo "  2. 日历 ID 不正确"
  echo "  3. 需要手动授权机器人访问日历"
  echo ""
  echo "解决方案："
  echo "  1. 在 Lark 中，打开目标日历设置"
  echo "  2. 添加机器人为日历成员"
  echo "  3. 授予适当的权限"
  echo ""
else
  echo "✅ 可以访问 $TOTAL 个日历"
  echo ""
  echo "请检查上面的列表，找到您需要的日历 ID"
  echo ""
fi

echo "=========================================="