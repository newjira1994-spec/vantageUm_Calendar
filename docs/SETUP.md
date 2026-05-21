# Setup Guide

Complete guide to set up the calendar sync tool from scratch.

## 📋 Table of Contents

1. [Prerequisites](#prerequisites)
2. [Lark App Setup](#lark-app-setup)
3. [Local Development Setup](#local-development-setup)
4. [Testing Locally](#testing-locally)
5. [GitHub Deployment](#github-deployment)
6. [Verification](#verification)

## Prerequisites

Before starting, ensure you have:

- [ ] Node.js 20+ installed
- [ ] npm or yarn installed
- [ ] Git installed
- [ ] GitHub account
- [ ] Lark account with developer access
- [ ] Access to both calendars (Bo Coordinator and new jira)

## Lark App Setup

### Step 1: Create Lark Developer Account

1. Go to [Lark Developer Platform](https://open.larksuite.com/)
2. Sign in with your Lark account
3. Accept the developer terms if prompted

### Step 2: Create a New App

1. Click **"Create App"**
2. Choose **"Self-built app"**
3. Fill in the details:
   - **App Name**: `Calendar Sync Tool` (or your preferred name)
   - **App Description**: `Automatically syncs calendar events`
   - **App Icon**: Upload an icon (optional)
4. Click **"Create"**

### Step 3: Get App Credentials

1. In your app dashboard, go to **"Credentials & Basic Info"**
2. Copy the **App ID** (starts with `cli_`)
3. Copy the **App Secret**
4. Save these securely - you'll need them later

### Step 4: Configure Permissions

1. Go to **"Permissions & Scopes"**
2. Search for and add these permissions:
   - `calendar:calendar:readonly` - Read calendar information
   - `calendar:calendar_event:readonly` - Read event details
   - `calendar:calendar_event:write` - Create events
3. Click **"Add"** for each permission
4. Click **"Apply for Approval"** (if required)

### Step 5: Publish the App

1. Go to **"Version Management"**
2. Click **"Create Version"**
3. Fill in version details:
   - **Version Number**: `1.0.0`
   - **Update Description**: `Initial version with calendar sync functionality`
4. Click **"Save"**
5. Click **"Submit for Approval"**
6. Wait for approval (usually takes 1-2 business days)

**Note:** The app must be approved before it can access calendars.

### Step 6: Get Calendar IDs

You need the calendar IDs for Bo Coordinator and new jira:

1. Open Lark Calendar
2. Go to each calendar's settings
3. Find the **Calendar ID** (starts with `ou_`)
4. Copy both calendar IDs:
   - Bo Coordinator: `ou_c6bdc791b875c3af1775a652bcf3b638`
   - new jira: `ou_dc36b8ad99537b07510b9af57d152136`

## Local Development Setup

### Step 1: Clone or Navigate to Project

```bash
cd "/Users/Lark CLI/vantageUm_Calendar"
```

### Step 2: Install Dependencies

```bash
npm install
```

This installs:
- `@larksuiteoapi/node-sdk` - Lark SDK
- `date-fns` - Date manipulation
- `dotenv` - Environment variables
- `winston` - Logging

### Step 3: Create Environment File

```bash
cp .env.example .env
```

### Step 4: Configure Environment Variables

Edit `.env` with your credentials:

```env
# Lark App Credentials (from Step 3 of Lark App Setup)
LARK_APP_ID=cli_your_actual_app_id_here
LARK_APP_SECRET=your_actual_app_secret_here

# Calendar IDs (from Step 6 of Lark App Setup)
BO_COORDINATOR_CALENDAR_ID=ou_c6bdc791b875c3af1775a652bcf3b638
NEW_JIRA_CALENDAR_ID=ou_dc36b8ad99537b07510b9af57d152136

# Sync Configuration
SYNC_DAYS_FORWARD=7
LOG_LEVEL=info
```

**Important:** Never commit `.env` to git!

## Testing Locally

### Step 1: Build the Project

```bash
npm run build
```

This compiles TypeScript to JavaScript in the `dist/` folder.

### Step 2: Run Sync

```bash
npm run sync
```

### Step 3: Check Output

You should see output like:

```
2024-05-21 10:30:00 [info]: Calendar sync tool starting
2024-05-21 10:30:01 [info]: Configuration loaded successfully
2024-05-21 10:30:02 [info]: Successfully obtained tenant access token
2024-05-21 10:30:03 [info]: Fetching calendar events
2024-05-21 10:30:04 [info]: Successfully fetched calendar events {"calendarId":"ou_xxx","count":5}

=== Sync Summary ===
Total events checked: 5
Events created: 3
Events skipped (conflicts): 2
Events failed: 0
```

### Step 4: Verify in Lark Calendar

1. Open Lark Calendar
2. Go to new jira's calendar
3. Check if events were created with title "from UM calendar"

### Step 5: Check Logs

Logs are saved to `calendar-sync.log`:

```bash
cat calendar-sync.log
```

### Troubleshooting Local Tests

**Error: "Missing required environment variables"**
- Solution: Ensure `.env` file exists and has all required variables

**Error: "Failed to get tenant access token"**
- Solution: Check App ID and App Secret are correct
- Solution: Ensure app is published and approved

**Error: "Failed to get calendar events"**
- Solution: Verify calendar IDs are correct
- Solution: Check app has calendar permissions
- Solution: Ensure calendars are accessible

## GitHub Deployment

### Step 1: Initialize Git Repository

```bash
cd "/Users/Lark CLI/vantageUm_Calendar"
git init
```

### Step 2: Create .gitignore

The `.gitignore` file should already exist with:

```
node_modules/
dist/
*.log
.env
.DS_Store
*.tsbuildinfo
```

### Step 3: Commit All Files

```bash
git add .
git commit -m "Initial commit: calendar sync tool"
```

### Step 4: Create GitHub Repository

1. Go to [GitHub](https://github.com)
2. Click **"New repository"**
3. Fill in details:
   - **Repository name**: `vantageUm_Calendar`
   - **Description**: `Calendar synchronization tool for Lark`
   - **Public** or **Private** (your choice)
   - **Don't** initialize with README (we have one)
4. Click **"Create repository"**

### Step 5: Push to GitHub

```bash
git remote add origin https://github.com/YOUR_USERNAME/vantageUm_Calendar.git
git branch -M main
git push -u origin main
```

### Step 6: Configure GitHub Secrets

1. Go to your repository on GitHub
2. Navigate to **Settings** → **Secrets and variables** → **Actions**
3. Click **"New repository secret"**
4. Add these secrets:

#### Secret 1: LARK_APP_ID
- **Name**: `LARK_APP_ID`
- **Value**: Your Lark App ID (from `.env`)

#### Secret 2: LARK_APP_SECRET
- **Name**: `LARK_APP_SECRET`
- **Value**: Your Lark App Secret (from `.env`)

### Step 7: (Optional) Add Variables

You can also add these as **variables** (not secrets):

1. Click **"Variables"** tab
2. Add variables:

| Name | Value |
|------|-------|
| `BO_COORDINATOR_CALENDAR_ID` | `ou_c6bdc791b875c3af1775a652bcf3b638` |
| `NEW_JIRA_CALENDAR_ID` | `ou_dc36b8ad99537b07510b9af57d152136` |
| `SYNC_DAYS_FORWARD` | `7` |
| `LOG_LEVEL` | `info` |

**Note:** If you don't add variables, the defaults in the workflow file will be used.

## Verification

### Step 1: Test Manual Workflow Run

1. Go to your repository on GitHub
2. Click **"Actions"** tab
3. Select **"Daily Calendar Sync"** workflow
4. Click **"Run workflow"** → **"Run workflow"**
5. Wait for the run to complete (takes 1-2 minutes)

### Step 2: Check Workflow Logs

1. Click on the completed run
2. Click on **"sync-calendars"** job
3. Expand each step to see logs
4. Look for the sync summary at the end

### Step 3: Download Log Artifacts

1. Scroll to the bottom of the run
2. Download **"calendar-sync-logs"**
3. Extract and open `calendar-sync.log`
4. Review detailed logs

### Step 4: Verify in Lark Calendar

1. Open Lark Calendar
2. Go to new jira's calendar
3. Check for newly created events with title "from UM calendar"

### Step 5: Monitor Scheduled Runs

The workflow will run automatically at **9:00 AM UTC+7 daily**.

To monitor:
1. Go to **Actions** tab
2. Check run history
3. Review logs for each run

## Next Steps

After successful setup:

1. **Monitor**: Check the Actions tab daily for run results
2. **Adjust**: Modify `.env` or GitHub variables as needed
3. **Scale**: Add more calendars if needed
4. **Customize**: Modify the code to suit your specific requirements

## Getting Help

If you encounter issues:

1. Check the [Troubleshooting](../README.md#-troubleshooting) section in README
2. Review the logs for error details
3. Consult the [API documentation](./API.md)
4. Open an issue in the repository

---

**Congratulations! Your calendar sync tool is now set up and running! 🎉**
