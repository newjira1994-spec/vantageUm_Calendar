#!/bin/bash

# 日历同步脚本 - 使用 Lark CLI
# 读取 BO Coordinator 的忙闲状态，在 new jira 空闲时创建事件

set -e

# 配置
BO_COORDINATOR_USER="ou_c6bdc791b875c3af1775a652bcf3b638"
NEW_JIRA_USER="ou_dc36b8ad99537b07510b9af57d152136"
SYNC_DAYS=7

# 日志文件
LOG_FILE="calendar-sync.log"
exec > >(tee -a "$LOG_FILE") 2>&1

echo "=========================================="
echo "   日历同步工具 - Lark CLI 版本"
echo "=========================================="
echo "开始时间: $(date '+%Y-%m-%d %H:%M:%S')"
echo ""

# 计算时间范围（兼容 Linux 和 macOS）
START_TIME=$(date -u '+%Y-%m-%dT%H:%M:%SZ')
if date -v+7d >/dev/null 2>&1; then
  # macOS
  END_TIME=$(date -u -v+${SYNC_DAYS}d '+%Y-%m-%dT%H:%M:%SZ')
else
  # Linux
  END_TIME=$(date -u -d "+${SYNC_DAYS} days" '+%Y-%m-%dT%H:%M:%SZ')
fi

echo "时间范围："
echo "  开始: $START_TIME"
echo "  结束: $END_TIME"
echo ""

# 统计变量
TOTAL_CHECKED=0
CREATED=0
SKIPPED=0
FAILED=0

echo "=========================================="
echo "步骤 1: 读取 BO Coordinator 忙闲状态"
echo "=========================================="
echo ""

# 获取 BO Coordinator 的忙闲状态
BO_FREEBUSY=$(lark-cli calendar +freebusy \
  --user-id "$BO_COORDINATOR_USER" \
  --start "$START_TIME" \
  --end "$END_TIME" \
  --format json 2>/dev/null)

if [ $? -ne 0 ]; then
  echo "❌ 无法读取 BO Coordinator 忙闲状态"
  exit 1
fi

# 解析忙闲时段
BO_BUSY_PERIODS=$(echo "$BO_FREEBUSY" | jq -r '.data.ranges[] | @base64' 2>/dev/null || echo "")
BO_COUNT=$(echo "$BO_BUSY_PERIODS" | grep -c . || echo "0")

echo "✅ 找到 $BO_COUNT 个忙碌时段"
echo ""

TOTAL_CHECKED=$BO_COUNT

echo "=========================================="
echo "步骤 2: 检查 new jira 可用性并创建事件"
echo "=========================================="
echo ""

# 处理每个忙碌时段
while IFS= read -r period; do
  if [ -z "$period" ]; then
    continue
  fi

  # 解析时段
  PERIOD_JSON=$(echo "$period" | base64 -d)
  START=$(echo "$PERIOD_JSON" | jq -r '.start_time.timestamp')
  END=$(echo "$PERIOD_JSON" | jq -r '.end_time.timestamp')

  # 转换为 ISO 格式
  START_ISO=$(date -u -r "$START" '+%Y-%m-%dT%H:%M:%SZ' 2>/dev/null || date -u -r "$((START/1000))" '+%Y-%m-%dT%H:%M:%SZ')
  END_ISO=$(date -u -r "$END" '+%Y-%m-%dT%H:%M:%SZ' 2>/dev/null || date -u -r "$((END/1000))" '+%Y-%m-%dT%H:%M:%SZ')

  echo "处理时段: $START_ISO - $END_ISO"

  # 检查 new jira 在此时段是否空闲
  NJ_FREEBUSY=$(lark-cli calendar +freebusy \
    --user-id "$NEW_JIRA_USER" \
    --start "$START_ISO" \
    --end "$END_ISO" \
    --format json 2>/dev/null)

  if [ $? -ne 0 ]; then
    echo "  ❌ 无法检查 new jira 忙闲状态"
    ((FAILED++))
    continue
  fi

  # 检查是否有冲突
  NJ_BUSY_COUNT=$(echo "$NJ_FREEBUSY" | jq -r '.data.ranges | length' 2>/dev/null || echo "0")

  if [ "$NJ_BUSY_COUNT" -eq 0 ]; then
    echo "  ✅ new jira 空闲，创建事件..."

    # 创建事件
    CREATE_RESULT=$(lark-cli calendar events create \
      --user-id "$NEW_JIRA_USER" \
      --params "{\"summary\":\"from UM calendar\",\"start_time\":{\"timestamp\":\"$START\"},\"end_time\":{\"timestamp\":\"$END\"}}" \
      --format json 2>/dev/null)

    if [ $? -eq 0 ]; then
      echo "  ✅ 事件创建成功"
      ((CREATED++))
    else
      echo "  ❌ 事件创建失败: $CREATE_RESULT"
      ((FAILED++))
    fi
  else
    echo "  ⏭️  new jira 忙碌，跳过"
    ((SKIPPED++))
  fi

  echo ""

done <<< "$BO_BUSY_PERIODS"

echo "=========================================="
echo "同步完成"
echo "=========================================="
echo ""
echo "统计："
echo "  检查的时段: $TOTAL_CHECKED"
echo "  创建的事件: $CREATED"
echo "  跳过的时段: $SKIPPED"
echo "  失败的时段: $FAILED"
echo ""
echo "结束时间: $(date '+%Y-%m-%d %H:%M:%S')"
echo "=========================================="

# 返回退出码
if [ "$FAILED" -gt 0 ]; then
  exit 1
else
  exit 0
fi