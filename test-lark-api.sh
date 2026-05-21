#!/bin/bash

# Lark API 测试脚本
# 用于诊断日历访问问题

echo "=========================================="
echo "   Lark API 测试工具"
echo "=========================================="
echo ""

# 配置
APP_ID="cli_aa84163b89789ed3"
APP_SECRET="DU0O71dKC270CkxUwmuSocSpzvzpIvZU"
CALENDAR_ID="ou_c6bdc791b875c3af1775a652bcf3b638"

echo "步骤 1: 获取 Tenant Access Token"
echo ""

# 获取 token
TOKEN_RESPONSE=$(curl -s -X POST \
  "https://open.larksuite.com/open-apis/auth/v3/tenant_access_token/internal" \
  -H "Content-Type: application/json" \
  -d "{\"app_id\":\"$APP_ID\",\"app_secret\":\"$APP_SECRET\"}")

echo "Token 响应:"
echo "$TOKEN_RESPONSE" | jq '.' 2>/dev/null || echo "$TOKEN_RESPONSE"
echo ""

# 提取 token
TOKEN=$(echo "$TOKEN_RESPONSE" | jq -r '.tenant_access_token' 2>/dev/null)

if [ -z "$TOKEN" ] || [ "$TOKEN" = "null" ]; then
  echo "❌ 获取 Token 失败"
  echo ""
  echo "可能的原因:"
  echo "1. App ID 或 App Secret 不正确"
  echo "2. 应用未发布"
  echo "3. 网络连接问题"
  exit 1
fi

echo "✅ Token 获取成功: $TOKEN"
echo ""
echo "=========================================="
echo ""
echo "步骤 2: 测试日历访问"
echo ""

# 计算时间范围（未来 7 天）
START_TIME=$(date +%s)000
END_TIME=$(($(date +%s) + 7*24*60*60))000

echo "时间范围:"
echo "开始: $START_TIME ($(date))"
echo "结束: $END_TIME ($(date -v+7d))"
echo ""

# 测试日历 API
CALENDAR_RESPONSE=$(curl -s -X GET \
  "https://open.larksuite.com/open-apis/calendar/v4/calendars/$CALENDAR_ID/events?start_time=$START_TIME&end_time=$END_TIME&page_size=50" \
  -H "Authorization: Bearer $TOKEN")

echo "日历 API 响应:"
echo "$CALENDAR_RESPONSE" | jq '.' 2>/dev/null || echo "$CALENDAR_RESPONSE"
echo ""

# 检查响应
CODE=$(echo "$CALENDAR_RESPONSE" | jq -r '.code' 2>/dev/null)

if [ "$CODE" = "0" ]; then
  echo "✅ 日历访问成功！"
  echo ""
  EVENT_COUNT=$(echo "$CALENDAR_RESPONSE" | jq -r '.data.items | length' 2>/dev/null)
  echo "找到 $EVENT_COUNT 个事件"
elif [ "$CODE" = "99991663" ]; then
  echo "❌ 日历 ID 无效"
  echo ""
  echo "可能的原因:"
  echo "1. 日历 ID 不正确"
  echo "2. 应用无权访问该日历"
  echo "3. 日历不存在或已被删除"
  echo ""
  echo "解决方案:"
  echo "1. 验证日历 ID 是否正确"
  echo "2. 检查应用是否获得日历访问授权"
  echo "3. 联系日历所有者授权应用"
else
  echo "❌ 日历访问失败"
  echo "错误代码: $CODE"
  echo "错误信息: $(echo "$CALENDAR_RESPONSE" | jq -r '.msg' 2>/dev/null)"
fi

echo ""
echo "=========================================="