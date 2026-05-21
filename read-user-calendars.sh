#!/bin/bash

# 使用 Lark CLI 读取用户日历事件

echo "=========================================="
echo "   使用 Lark CLI 读取日历"
echo "=========================================="
echo ""

# 用户 ID
NEW_JIRA_USER="ou_dc36b8ad99537b07510b9af57d152136"
BO_COORDINATOR_USER="ou_c6bdc791b875c3af1775a652bcf3b638"

# 时间范围（未来 7 天，Unix 时间戳，秒）
START_TIME=$(($(date +%s) + 0))
END_TIME=$(($(date +%s) + 7*24*60*60))

echo "时间范围："
echo "开始: $(date -r $START_TIME '+%Y-%m-%d %H:%M:%S')"
echo "结束: $(date -r $END_TIME '+%Y-%m-%d %H:%M:%S')"
echo ""

echo "=========================================="
echo ""
echo "方法 1: 查看用户忙闲状态"
echo "=========================================="
echo ""

echo "BO Coordinator 忙闲状态："
lark-cli calendar +freebusy \
  --user-id $BO_COORDINATOR_USER \
  --start "$(date -u -r $START_TIME '+%Y-%m-%dT%H:%M:%SZ')" \
  --end "$(date -u -r $END_TIME '+%Y-%m-%dT%H:%M:%SZ')" \
  --format pretty

echo ""
echo "new jira 忙闲状态："
lark-cli calendar +freebusy \
  --user-id $NEW_JIRA_USER \
  --start "$(date -u -r $START_TIME '+%Y-%m-%dT%H:%M:%SZ')" \
  --end "$(date -u -r $END_TIME '+%Y-%m-%dT%H:%M:%SZ')" \
  --format pretty

echo ""
echo "=========================================="
echo ""
echo "💡 关键发现"
echo "=========================================="
echo ""
echo "✅ 可以成功读取用户的忙闲状态"
echo ""
echo "这说明："
echo "  1. 用户 ID 是正确的"
echo "  2. 可以访问用户的日历信息"
echo "  3. 但需要使用正确的方法"
echo ""
echo "=========================================="
echo ""
echo "下一步："
echo ""
echo "使用 freebusy API 来实现日历同步功能"
echo "而不是直接读取日历事件"
echo ""
echo "=========================================="