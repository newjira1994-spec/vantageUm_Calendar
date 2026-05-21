# VantageUM Calendar Synchronization Tool

A TypeScript-based calendar synchronization tool that automatically creates meetings in one Lark calendar based on another calendar's events.

## 📋 Overview

This tool reads the Bo Coordinator calendar and automatically creates corresponding meetings in the new jira calendar when time slots are available.

### Key Features

- ✅ Reads calendar events for the next 7 days
- ✅ Checks for time slot conflicts before creating meetings
- ✅ Automatically creates meetings with title "from UM calendar"
- ✅ Comprehensive logging and error handling
- ✅ Scheduled execution via GitHub Actions (9:00 AM UTC+7 daily)
- ✅ Works even when your computer is offline (cloud-based)

## 🚀 Quick Start

### Prerequisites

- Node.js 20 or higher
- npm or yarn
- Lark developer account with App ID and App Secret
- Git (for deployment)

### Installation

1. Clone the repository:
```bash
git clone <your-repo-url>
cd vantageUm_Calendar
```

2. Install dependencies:
```bash
npm install
```

3. Create `.env` file from template:
```bash
cp .env.example .env
```

4. Edit `.env` with your credentials:
```env
LARK_APP_ID=your_actual_app_id
LARK_APP_SECRET=your_actual_app_secret
BO_COORDINATOR_CALENDAR_ID=ou_c6bdc791b875c3af1775a652bcf3b638
NEW_JIRA_CALENDAR_ID=ou_dc36b8ad99537b07510b9af57d152136
SYNC_DAYS_FORWARD=7
LOG_LEVEL=info
```

### Local Execution

Run the sync manually:
```bash
npm run sync
```

Build the project:
```bash
npm run build
```

Run the compiled version:
```bash
npm start
```

## 📖 How It Works

### Sync Logic

1. **Fetch Events**: Reads Bo Coordinator calendar for the next 7 days
2. **Check Availability**: For each event, checks if new jira's calendar is free during that time
3. **Create Meetings**: If the time slot is free, creates a new meeting in new jira's calendar:
   - Title: "from UM calendar"
   - Same start/end time as Bo Coordinator's event
   - Attendee: new jira
4. **Skip Conflicts**: If new jira has a conflict, skips that time slot
5. **Log Results**: Outputs summary with counts of checked, created, skipped, and failed events

### Example Output

```
=== Sync Summary ===
Total events checked: 15
Events created: 8
Events skipped (conflicts): 6
Events failed: 1
```

## ☁️ Cloud Deployment (GitHub Actions)

The tool is configured to run automatically on GitHub Actions at 9:00 AM UTC+7 daily.

### Setup GitHub Secrets

1. Go to your GitHub repository
2. Navigate to **Settings** → **Secrets and variables** → **Actions**
3. Add the following **secrets**:
   - `LARK_APP_ID`: Your Lark App ID
   - `LARK_APP_SECRET`: Your Lark App Secret

4. Optionally add these **variables** (or use defaults):
   - `BO_COORDINATOR_CALENDAR_ID`: Default is `ou_c6bdc791b875c3af1775a652bcf3b638`
   - `NEW_JIRA_CALENDAR_ID`: Default is `ou_dc36b8ad99537b07510b9af57d152136`
   - `SYNC_DAYS_FORWARD`: Default is `7`
   - `LOG_LEVEL`: Default is `info`

### Manual Trigger

You can manually trigger the workflow:
1. Go to **Actions** tab in GitHub
2. Select "Daily Calendar Sync" workflow
3. Click "Run workflow"

### View Logs

- Check the workflow run logs in the Actions tab
- Download the `calendar-sync-logs` artifact for detailed logs

## 🔧 Configuration

### Environment Variables

| Variable | Description | Required | Default |
|----------|-------------|----------|---------|
| `LARK_APP_ID` | Lark application ID | Yes | - |
| `LARK_APP_SECRET` | Lark application secret | Yes | - |
| `BO_COORDINATOR_CALENDAR_ID` | Bo Coordinator calendar ID | Yes | - |
| `NEW_JIRA_CALENDAR_ID` | new jira calendar ID | Yes | - |
| `SYNC_DAYS_FORWARD` | Days to look ahead | No | 7 |
| `LOG_LEVEL` | Logging level (info, debug, error) | No | info |

### Log Levels

- `error`: Only errors
- `warn`: Warnings and errors
- `info`: Info, warnings, and errors (recommended)
- `debug`: All logs including debug information

## 📁 Project Structure

```
vantageUm_Calendar/
├── src/
│   ├── index.ts              # Main entry point
│   ├── calendar-sync.ts      # Core sync logic
│   ├── lark-client.ts        # Lark API wrapper
│   ├── logger.ts             # Logging utility
│   └── types.ts              # TypeScript types
├── docs/                     # Documentation
├── .github/workflows/        # GitHub Actions
├── package.json              # Dependencies
├── tsconfig.json             # TypeScript config
├── .env.example              # Environment template
└── README.md                 # This file
```

## 🔐 Getting Lark Credentials

### Step 1: Create a Lark App

1. Go to [Lark Developer Platform](https://open.larksuite.com/)
2. Click "Create App"
3. Choose "Self-built app"
4. Fill in app name and description

### Step 2: Get Credentials

1. In your app, go to "Credentials & Basic Info"
2. Copy the **App ID** and **App Secret**
3. Add these to your `.env` file or GitHub secrets

### Step 3: Configure Permissions

Your app needs these calendar permissions:
- `calendar:calendar:readonly` - Read calendar events
- `calendar:calendar_event:readonly` - Read event details
- `calendar:calendar_event:write` - Create events

### Step 4: Publish App

1. Go to "Version Management"
2. Create a version and submit for approval
3. Once approved, the app can access calendars

## 🐛 Troubleshooting

### Common Issues

**1. "Missing required environment variables"**
- Solution: Ensure all required variables are set in `.env` or GitHub secrets

**2. "Failed to get tenant access token"**
- Solution: Check your Lark App ID and App Secret are correct
- Ensure the app is published and approved

**3. "Failed to get calendar events"**
- Solution: Verify calendar IDs are correct
- Check app has necessary permissions
- Ensure calendars are shared with the app

**4. No events created**
- Check logs to see if events are being skipped due to conflicts
- Verify Bo Coordinator calendar has events in the next 7 days
- Check new jira calendar ID is correct

### Debug Mode

Enable debug logging:
```env
LOG_LEVEL=debug
```

This will show detailed information about each operation.

## 📊 Monitoring

### GitHub Actions

- View workflow run history in the Actions tab
- Check run duration and success rate
- Download log artifacts for detailed analysis

### Local Logs

When running locally, logs are saved to:
- `calendar-sync.log` - File with all logs
- Console output with color-coded messages

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## 📄 License

ISC

## 🆘 Support

For issues or questions:
1. Check the [Troubleshooting](#-troubleshooting) section
2. Review the logs for error details
3. Open an issue in the repository

---

**Built with ❤️ using TypeScript and Lark Open Platform**
