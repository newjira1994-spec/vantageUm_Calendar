#!/bin/bash

# 日历同步工具 - GitHub 部署助手
# 此脚本将帮助您推送代码到 GitHub

set -e

echo "================================================"
echo "   日历同步工具 - GitHub 部署助手"
echo "================================================"
echo ""

# 检查是否在正确的目录
if [ ! -f "package.json" ]; then
    echo "❌ 错误: 请在 vantageUm_Calendar 目录下运行此脚本"
    exit 1
fi

# 检查 Git 是否已初始化
if [ ! -d ".git" ]; then
    echo "📦 初始化 Git 仓库..."
    git init
    git branch -m main
    git add .
    git commit -m "Initial commit: Calendar sync tool"
    echo "✅ Git 仓库初始化完成"
else
    echo "✅ Git 仓库已存在"
fi

echo ""
echo "================================================"
echo "   下一步：在 GitHub 创建仓库"
echo "================================================"
echo ""
echo "请按照以下步骤操作："
echo ""
echo "1. 打开浏览器，访问: https://github.com/new"
echo "2. 填写仓库信息："
echo "   - Repository name: vantageUm_Calendar"
echo "   - Description: 日历同步工具 - 自动同步 Lark 日历"
echo "   - 选择 Public 或 Private"
echo "   - 不要勾选 'Add a README file'"
echo "3. 点击 'Create repository'"
echo ""

# 询问 GitHub 用户名
read -p "请输入您的 GitHub 用户名: " username

if [ -z "$username" ]; then
    echo "❌ 用户名不能为空"
    exit 1
fi

# 设置远程仓库
REPO_URL="https://github.com/${username}/vantageUm_Calendar.git"

echo ""
echo "🔗 设置远程仓库: $REPO_URL"

# 检查是否已有 remote
if git remote | grep -q "origin"; then
    echo "⚠️  远程仓库已存在，更新 URL..."
    git remote set-url origin "$REPO_URL"
else
    git remote add origin "$REPO_URL"
fi

echo ""
echo "================================================"
echo "   推送代码到 GitHub"
echo "================================================"
echo ""
echo "即将推送代码到 GitHub..."
echo "如果提示输入密码，请使用 Personal Access Token (PAT)"
echo ""
echo "创建 PAT: https://github.com/settings/tokens/new"
echo "需要的权限: repo (完整仓库访问)"
echo ""

read -p "按 Enter 继续..."

# 推送代码
echo ""
echo "📤 推送代码..."
git push -u origin main

if [ $? -eq 0 ]; then
    echo ""
    echo "================================================"
    echo "   ✅ 推送成功！"
    echo "================================================"
    echo ""
    echo "🎉 代码已成功推送到 GitHub！"
    echo ""
    echo "下一步："
    echo "1. 访问: https://github.com/${username}/vantageUm_Calendar/settings/secrets/actions"
    echo "2. 添加以下 Secrets:"
    echo "   - LARK_APP_ID: 您的 Lark App ID"
    echo "   - LARK_APP_SECRET: 您的 Lark App Secret"
    echo ""
    echo "3. 测试工作流:"
    echo "   访问: https://github.com/${username}/vantageUm_Calendar/actions"
    echo "   点击 'Daily Calendar Sync' → 'Run workflow'"
    echo ""
    echo "📖 详细文档: docs/DEPLOYMENT_MANUAL.md"
    echo ""
else
    echo ""
    echo "❌ 推送失败"
    echo ""
    echo "可能的原因："
    echo "1. GitHub 仓库尚未创建"
    echo "2. 认证失败 - 请使用 Personal Access Token"
    echo "3. 网络连接问题"
    echo ""
    echo "请查看错误信息并重试，或参考 docs/DEPLOYMENT_MANUAL.md"
fi
