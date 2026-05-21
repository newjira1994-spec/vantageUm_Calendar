#!/bin/bash

# 简化版日历同步脚本 - 测试版本

echo "=========================================="
echo "   日历同步工具 - Lark CLI 版本（测试）"
echo "=========================================="
echo ""

BO_COORDINATOR_USER="ou_c6bdc791b875c3af1775a652bcf3b638"
NEW_JIRA_USER="ou_dc36b8ad99537b07510b9af57d152136"

# 时间范围
START_TIME="2026-05-25T00:00:00Z"
END_TIME="2026-05-31T23:59:59Z"

echo "步骤 1: 读取 BO Coordinator 忙闲状态"
echo ""

lark-cli calendar +freebusy \
  --user-id "$BO_COORDINATOR_USER" \
  --start "$START_TIME" \
  --end "$END_TIME" \
  --format pretty

echo ""
echo "步骤 2: 读取 new jira 忙闲状态"
echo ""

lark-cli calendar +freebusy \
  --user-id "$NEW_JIRA_USER" \
  --start "$START_TIME" \
  --end "$END_TIME" \
  --format pretty

echo ""
echo "=========================================="
echo "测试完成！"
echo "=========================================="