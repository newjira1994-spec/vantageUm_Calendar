import dotenv from 'dotenv';
import LarkClient from './lark-client';
import CalendarSync from './calendar-sync';
import logger from './logger';
import { Config } from './types';

dotenv.config();

function loadConfig(): Config {
  const config: Config = {
    larkAppId: process.env.LARK_APP_ID || '',
    larkAppSecret: process.env.LARK_APP_SECRET || '',
    boCoordinatorCalendarId: process.env.BO_COORDINATOR_CALENDAR_ID || '',
    newJiraCalendarId: process.env.NEW_JIRA_CALENDAR_ID || '',
    syncDaysForward: parseInt(process.env.SYNC_DAYS_FORWARD || '7', 10),
    logLevel: process.env.LOG_LEVEL || 'info',
  };

  // Validate configuration
  const missingVars: string[] = [];
  if (!config.larkAppId) missingVars.push('LARK_APP_ID');
  if (!config.larkAppSecret) missingVars.push('LARK_APP_SECRET');
  if (!config.boCoordinatorCalendarId) missingVars.push('BO_COORDINATOR_CALENDAR_ID');
  if (!config.newJiraCalendarId) missingVars.push('NEW_JIRA_CALENDAR_ID');

  if (missingVars.length > 0) {
    const errorMsg = `Missing required environment variables: ${missingVars.join(', ')}`;
    logger.error(errorMsg);
    throw new Error(errorMsg);
  }

  logger.info('Configuration loaded successfully', {
    boCoordinatorCalendarId: config.boCoordinatorCalendarId,
    newJiraCalendarId: config.newJiraCalendarId,
    syncDaysForward: config.syncDaysForward,
    logLevel: config.logLevel,
  });

  return config;
}

async function main() {
  try {
    logger.info('Calendar sync tool starting');

    // Load configuration
    const config = loadConfig();

    // Initialize Lark client
    const larkClient = new LarkClient(config.larkAppId, config.larkAppSecret);

    // Initialize calendar sync
    const calendarSync = new CalendarSync(
      larkClient,
      config.boCoordinatorCalendarId,
      config.newJiraCalendarId
    );

    // Run sync
    const result = await calendarSync.sync(config.syncDaysForward);

    // Print summary
    console.log('\n=== Sync Summary ===');
    console.log(`Total events checked: ${result.totalChecked}`);
    console.log(`Events created: ${result.created}`);
    console.log(`Events skipped (conflicts): ${result.skipped}`);
    console.log(`Events failed: ${result.failed}`);

    if (result.errors.length > 0) {
      console.log('\n=== Errors ===');
      result.errors.forEach((error, index) => {
        console.log(`${index + 1}. Event: ${error.eventSummary} at ${error.eventTime}`);
        console.log(`   Error: ${error.error}`);
      });
    }

    logger.info('Calendar sync tool completed successfully');
    process.exit(0);
  } catch (error) {
    logger.error('Calendar sync tool failed', {
      error: error instanceof Error ? error.message : String(error),
      stack: error instanceof Error ? error.stack : undefined,
    });
    console.error('\n❌ Calendar sync failed:', error instanceof Error ? error.message : String(error));
    process.exit(1);
  }
}

// Run the main function
main();