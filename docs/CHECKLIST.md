# Deployment Checklist

Use this checklist to ensure everything is set up correctly before deploying.

## 📋 Pre-Deployment Checklist

### Lark App Setup
- [ ] Created Lark developer account
- [ ] Created self-built app in Lark Developer Platform
- [ ] Copied App ID and App Secret
- [ ] Added required permissions:
  - [ ] `calendar:calendar:readonly`
  - [ ] `calendar:calendar_event:readonly`
  - [ ] `calendar:calendar_event:write`
- [ ] App submitted for approval
- [ ] App approved and published
- [ ] Verified calendar IDs are correct:
  - [ ] Bo Coordinator: `ou_c6bdc791b875c3af1775a652bcf3b638`
  - [ ] new jira: `ou_dc36b8ad99537b07510b9af57d152136`

### Local Setup
- [ ] Node.js 20+ installed
- [ ] npm installed
- [ ] Git installed
- [ ] Project directory exists: `/Users/Lark CLI/vantageUm_Calendar`
- [ ] Dependencies installed: `npm install` completed successfully
- [ ] `.env` file created from `.env.example`
- [ ] `.env` file configured with:
  - [ ] `LARK_APP_ID` set to your App ID
  - [ ] `LARK_APP_SECRET` set to your App Secret
  - [ ] `BO_COORDINATOR_CALENDAR_ID` set correctly
  - [ ] `NEW_JIRA_CALENDAR_ID` set correctly
  - [ ] `SYNC_DAYS_FORWARD` set (default: 7)
  - [ ] `LOG_LEVEL` set (default: info)
- [ ] `.env` file NOT committed to git (in `.gitignore`)
- [ ] Project builds successfully: `npm run build` completed
- [ ] Local test successful: `npm run sync` completed
- [ ] Verified meetings created in Lark calendar

### GitHub Setup
- [ ] GitHub account exists
- [ ] GitHub repository created
- [ ] Repository cloned/pushed successfully
- [ ] Repository contains all files:
  - [ ] `src/` directory with TypeScript files
  - [ ] `docs/` directory with documentation
  - [ ] `.github/workflows/daily-sync.yml`
  - [ ] `package.json`
  - [ ] `tsconfig.json`
  - [ ] `.gitignore`
  - [ ] `README.md`
  - [ ] `.env.example`
- [ ] GitHub Secrets configured:
  - [ ] `LARK_APP_ID` secret added
  - [ ] `LARK_APP_SECRET` secret added
- [ ] GitHub Variables configured (optional):
  - [ ] `BO_COORDINATOR_CALENDAR_ID` variable added
  - [ ] `NEW_JIRA_CALENDAR_ID` variable added
  - [ ] `SYNC_DAYS_FORWARD` variable added
  - [ ] `LOG_LEVEL` variable added

### Workflow Testing
- [ ] GitHub Actions workflow visible in Actions tab
- [ ] Manual workflow trigger successful
- [ ] Workflow run completed without errors
- [ ] Logs show successful sync
- [ ] Sync summary shows expected results:
  - [ ] Total events checked > 0
  - [ ] Events created count
  - [ ] Events skipped count
  - [ ] Events failed count (should be 0)
- [ ] Downloaded log artifact and verified details
- [ ] Verified meetings created in Lark calendar

### Verification
- [ ] Workflow schedule correct: `cron: '0 2 * * *'` (9 AM UTC+7)
- [ ] Email notifications configured in GitHub settings
- [ ] Repository has activity (workflow will run)
- [ ] GitHub Actions enabled in repository settings

## 🚀 Deployment Steps

Follow these steps in order:

### Step 1: Initialize Git (if not done)
```bash
cd "/Users/Lark CLI/vantageUm_Calendar"
git init
git add .
git commit -m "Initial commit: calendar sync tool"
```

### Step 2: Create GitHub Repository
1. Go to github.com
2. Click "New repository"
3. Name: `vantageUm_Calendar`
4. Don't initialize with README
5. Create repository

### Step 3: Push to GitHub
```bash
git remote add origin https://github.com/YOUR_USERNAME/vantageUm_Calendar.git
git branch -M main
git push -u origin main
```

### Step 4: Add GitHub Secrets
1. Repository → Settings → Secrets and variables → Actions
2. Add `LARK_APP_ID` secret
3. Add `LARK_APP_SECRET` secret

### Step 5: Test Workflow
1. Actions → "Daily Calendar Sync"
2. Click "Run workflow"
3. Wait for completion
4. Check logs

### Step 6: Monitor
- Check Actions tab daily
- Review run history
- Download logs if needed

## ✅ Post-Deployment Checklist

### First Day
- [ ] Workflow ran successfully at scheduled time
- [ ] No errors in workflow logs
- [ ] Meetings created in new jira calendar
- [ ] Sync summary shows reasonable counts

### First Week
- [ ] Workflow runs daily without failures
- [ ] Calendar sync working as expected
- [ ] No duplicate meetings created
- [ ] Conflicts properly skipped

### Ongoing Monitoring
- [ ] Check Actions tab weekly for run history
- [ ] Review logs if failures occur
- [ ] Update credentials if needed
- [ ] Adjust configuration if requirements change

## 🐛 Troubleshooting Quick Reference

### Workflow Not Running
- Check repository has recent activity
- Verify workflow file syntax
- Ensure Actions are enabled

### Authentication Error
- Verify App ID and Secret are correct
- Check app is published and approved
- Regenerate secret if needed

### Permission Error
- Check calendar IDs are correct
- Verify app has required permissions
- Ensure calendars are accessible

### No Events Created
- Check Bo Coordinator calendar has events
- Verify new jira calendar ID
- Check logs for conflicts

## 📞 Getting Help

1. Check [README.md](../README.md) troubleshooting section
2. Review [docs/SETUP.md](./SETUP.md) for setup details
3. Consult [docs/API.md](./API.md) for API information
4. Open GitHub issue with:
   - Error message
   - Workflow logs
   - Steps to reproduce

## 🎉 Success Indicators

You'll know everything is working when:
- ✅ Workflow runs daily at 9 AM UTC+7
- ✅ Sync summary shows events processed
- ✅ Meetings appear in new jira calendar
- ✅ No errors in logs
- ✅ Workflow history shows consistent success

---

**Print this checklist and mark items as you complete them!**