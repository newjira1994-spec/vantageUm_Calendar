import LarkClient from './lark-client';
import { CalendarEvent, SyncResult, ErrorDetails } from './types';
import logger from './logger';
import { addDays } from 'date-fns';

export class CalendarSync {
  private larkClient: LarkClient;
  private boCoordinatorUserId: string;
  private newJiraUserId: string;

  constructor(
    larkClient: LarkClient,
    boCoordinatorUserId: string,
    newJiraUserId: string
  ) {
    this.larkClient = larkClient;
    this.boCoordinatorUserId = boCoordinatorUserId;
    this.newJiraUserId = newJiraUserId;
  }

  async sync(syncDaysForward: number): Promise<SyncResult> {
    const result: SyncResult = {
      totalChecked: 0,
      created: 0,
      skipped: 0,
      failed: 0,
      errors: [],
    };

    try {
      logger.info('Starting calendar sync', {
        boCoordinatorUserId: this.boCoordinatorUserId,
        newJiraUserId: this.newJiraUserId,
        syncDaysForward,
      });

      const now = new Date();
      const endDate = addDays(now, syncDaysForward);

      logger.info('Date range for sync', {
        startTime: now.toISOString(),
        endTime: endDate.toISOString(),
      });

      // Get Bo Coordinator's busy periods
      const boBusyPeriods = await this.larkClient.getFreeBusy(
        this.boCoordinatorUserId,
        now,
        endDate
      );

      logger.info('Fetched Bo Coordinator busy periods', { count: boBusyPeriods.length });

      result.totalChecked = boBusyPeriods.length;

      // Process each busy period
      for (const busyPeriod of boBusyPeriods) {
        try {
          const eventStartTime = new Date(parseInt(busyPeriod.start) * 1000);
          const eventEndTime = new Date(parseInt(busyPeriod.end) * 1000);

          logger.info('Processing busy period', {
            startTime: eventStartTime.toISOString(),
            endTime: eventEndTime.toISOString(),
          });

          // Check if new jira's calendar is free during this time
          const isFree = await this.larkClient.checkAvailability(
            this.newJiraUserId,
            eventStartTime,
            eventEndTime
          );

          if (isFree) {
            // Create a new event in new jira's calendar
            // Note: We need the actual calendar_id to create events
            // For now, we'll use the user_id as calendar_id (primary calendar)
            const newEvent: CalendarEvent = {
              id: '',
              summary: 'from UM calendar',
              startTime: busyPeriod.start,
              endTime: busyPeriod.end,
              attendees: [this.newJiraUserId],
            };

            await this.larkClient.createEvent(this.newJiraUserId, newEvent);
            result.created++;

            logger.info('Created new event', {
              summary: newEvent.summary,
              startTime: eventStartTime.toISOString(),
            });
          } else {
            result.skipped++;

            logger.info('Skipped period due to conflict', {
              startTime: eventStartTime.toISOString(),
            });
          }
        } catch (error) {
          result.failed++;
          const errorDetails: ErrorDetails = {
            eventSummary: 'Busy period',
            eventTime: busyPeriod.start,
            error: error instanceof Error ? error.message : String(error),
          };
          result.errors.push(errorDetails);

          logger.error('Failed to process busy period', {
            error: errorDetails.error,
          });
        }
      }

      logger.info('Calendar sync completed', {
        totalChecked: result.totalChecked,
        created: result.created,
        skipped: result.skipped,
        failed: result.failed,
      });

      return result;
    } catch (error) {
      logger.error('Calendar sync failed', {
        error: error instanceof Error ? error.message : String(error),
      });
      throw error;
    }
  }
}

export default CalendarSync;