# Deployment Guide

This guide covers deploying the calendar sync tool to GitHub Actions for automated daily execution.

## 🎯 Deployment Overview

The tool runs on GitHub Actions infrastructure, which means:
- ✅ Runs automatically even when your computer is offline
- ✅ No server maintenance required
- ✅ Free for public repositories
- ✅ Built-in logging and monitoring

## 📋 Prerequisites

1. GitHub account
2. Git installed locally
3. Lark developer account with App ID and App Secret
4. Repository created on GitHub

## 🚀 Deployment Steps

### Step 1: Initialize Git Repository

```bash
cd "/Users/Lark CLI/vantageUm_Calendar"
git init
git add .
git commit -m "Initial commit: calendar sync tool"
```

### Step 2: Create GitHub Repository

1. Go to [GitHub](https://github.com)
2. Click "New repository"
3. Name it `vantageUm_Calendar` (or your preferred name)
4. Choose Public or Private
5. Don't initialize with README (we already have one)
6. Click "Create repository"

### Step 3: Push to GitHub

```bash
git remote add origin https://github.com/YOUR_USERNAME/vantageUm_Calendar.git
git branch -M main
git push -u origin main
```

### Step 4: Configure GitHub Secrets

1. Go to your repository on GitHub
2. Navigate to **Settings** → **Secrets and variables** → **Actions**
3. Click **"New repository secret"**
4. Add the following secrets:

#### Required Secrets

| Name | Value | Description |
|------|-------|-------------|
| `LARK_APP_ID` | Your Lark App ID | Found in Lark Developer Platform |
| `LARK_APP_SECRET` | Your Lark App Secret | Found in Lark Developer Platform |

#### Optional Variables

You can also add these as **variables** (not secrets):

| Name | Default Value | Description |
|------|---------------|-------------|
| `BO_COORDINATOR_CALENDAR_ID` | `ou_c6bdc791b875c3af1775a652bcf3b638` | Bo Coordinator calendar ID |
| `NEW_JIRA_CALENDAR_ID` | `ou_dc36b8ad99537b07510b9af57d152136` | new jira calendar ID |
| `SYNC_DAYS_FORWARD` | `7` | Days to look ahead |
| `LOG_LEVEL` | `info` | Logging level |

### Step 5: Verify Workflow

1. Go to **Actions** tab in your repository
2. You should see a workflow called "Daily Calendar Sync"
3. Click on it to see the schedule

### Step 6: Test Manual Run

Before waiting for the scheduled run, test manually:

1. Go to **Actions** → "Daily Calendar Sync"
2. Click **"Run workflow"** → **"Run workflow"**
3. Wait for the run to complete
4. Check the logs to verify it worked

## ⏰ Schedule Configuration

The workflow is configured to run at **9:00 AM UTC+7 daily**.

In the GitHub Actions workflow file (`.github/workflows/daily-sync.yml`), the schedule is:
```yaml
schedule:
  - cron: '0 2 * * *'  # 9:00 AM UTC+7 = 2:00 AM UTC
```

### Understanding Cron Syntax

The cron expression `0 2 * * *` means:
- `0` - At minute 0
- `2` - At hour 2 (2:00 AM UTC)
- `*` - Every day of month
- `*` - Every month
- `*` - Every day of week

### Timezone Conversion

- UTC+7 is 7 hours ahead of UTC
- 9:00 AM UTC+7 = 2:00 AM UTC
- GitHub Actions runs in UTC timezone

### Adjusting the Schedule

To change the run time, edit `.github/workflows/daily-sync.yml`:

```yaml
schedule:
  - cron: '30 1 * * *'  # 8:30 AM UTC+7
```

Use a [cron converter](https://crontab.guru/) to generate the right expression.

## 📊 Monitoring

### View Run History

1. Go to **Actions** tab
2. Click on "Daily Calendar Sync"
3. See all past runs with status (success/failure)

### View Logs

1. Click on a specific run
2. Click on the "sync-calendars" job
3. Expand each step to see detailed logs

### Download Log Artifacts

1. At the bottom of a completed run
2. Download `calendar-sync-logs` artifact
3. Contains the `calendar-sync.log` file

### Email Notifications

GitHub sends email notifications for:
- Failed workflow runs
- Successful runs (if configured)

To configure notifications:
1. Go to GitHub Settings → Notifications
2. Customize for Actions

## 🔄 Updating the Tool

### Make Changes

1. Edit files locally
2. Test with `npm run sync`
3. Commit and push:

```bash
git add .
git commit -m "Update: your changes"
git push
```

### Changes Take Effect

- Next scheduled run will use the new code
- Or manually trigger to test immediately

## 🔒 Security Best Practices

### Never Commit Secrets

❌ **Don't** add `.env` file to git (it's in `.gitignore`)

✅ **Do** use GitHub Secrets for sensitive data

### Rotate Secrets

If you suspect credentials are compromised:
1. Generate new App Secret in Lark Developer Platform
2. Update GitHub Secret immediately
3. Revoke old secret

### Limit Permissions

In Lark Developer Platform:
- Only grant necessary calendar permissions
- Don't grant admin or other unnecessary access

## 🐛 Troubleshooting Deployment

### Workflow Not Running

**Possible causes:**
1. Repository must have activity in the last 60 days
2. Workflow file syntax error
3. GitHub Actions disabled in repository settings

**Solution:**
1. Check Actions tab for error messages
2. Verify workflow file syntax
3. Enable Actions in repository settings

### Authentication Errors

**Symptom:** "Failed to get tenant access token"

**Solutions:**
1. Verify `LARK_APP_ID` and `LARK_APP_SECRET` are correct
2. Check app is published and approved in Lark
3. Regenerate secret and update GitHub secret

### Permission Errors

**Symptom:** "Failed to get calendar events"

**Solutions:**
1. Verify calendar IDs are correct
2. Check app has calendar permissions
3. Ensure calendars are shared with the app

## 📈 Scaling and Performance

### Current Limits

- GitHub Actions free tier: 2,000 minutes/month
- Each sync run takes ~1-2 minutes
- Daily runs = ~30-60 minutes/month
- Well within free tier limits

### If You Need More

For multiple calendars or more frequent runs:
- Consider GitHub Actions paid plans
- Or deploy to AWS Lambda / Google Cloud Functions

## 🎓 Advanced Configuration

### Multiple Environments

Create separate workflows for different calendars:

1. Copy `.github/workflows/daily-sync.yml`
2. Rename to `daily-sync-dev.yml`
3. Use different secrets/variables
4. Adjust schedule as needed

### Conditional Execution

Add conditions to the workflow:

```yaml
jobs:
  sync-calendars:
    if: github.repository == 'your-username/vantageUm_Calendar'
```

### Notifications to Slack/Teams

Add a notification step after sync:

```yaml
- name: Notify Slack
  if: always()
  run: |
    curl -X POST -H 'Content-type: application/json' \
    --data '{"text":"Calendar sync completed"}' \
    ${{ secrets.SLACK_WEBHOOK_URL }}
```

## 📚 Additional Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Lark Open Platform](https://open.larksuite.com/document)
- [Cron Syntax Guide](https://crontab.guru/)

---

**Need help? Check the main [README.md](../README.md) or open an issue.**
