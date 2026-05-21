import LarkClient from './lark-client';
import { CalendarEvent, SyncResult, ErrorDetails } from './types';
import logger from './logger';
import { addDays } from 'date-fns';

export class CalendarSync {
  private larkClient: LarkClient;
  private boCoordinatorCalendarId: string;
  private newJiraCalendarId: string;

  constructor(
    larkClient: LarkClient,
    boCoordinatorCalendarId: string,
    newJiraCalendarId: string
  ) {
    this.larkClient = larkClient;
    this.boCoordinatorCalendarId = boCoordinatorCalendarId;
    this.newJiraCalendarId = newJiraCalendarId;
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
        boCoordinatorCalendarId: this.boCoordinatorCalendarId,
        newJiraCalendarId: this.newJiraCalendarId,
        syncDaysForward,
      });

      const now = new Date();
      const endDate = addDays(now, syncDaysForward);

      logger.info('Date range for sync', {
        startTime: now.toISOString(),
        endTime: endDate.toISOString(),
      });

      // Get Bo Coordinator's events
      const boEvents = await this.larkClient.getCalendarEvents(
        this.boCoordinatorCalendarId,
        now,
        endDate
      );

      logger.info('Fetched Bo Coordinator events', { count: boEvents.length });

      result.totalChecked = boEvents.length;

      // Process each event
      for (const boEvent of boEvents) {
        try {
          const eventStartTime = new Date(boEvent.startTime);
          const eventEndTime = new Date(boEvent.endTime);

          logger.info('Processing event', {
            summary: boEvent.summary,
            startTime: eventStartTime.toISOString(),
            endTime: eventEndTime.toISOString(),
          });

          // Check if new jira's calendar is free during this time
          const isFree = await this.larkClient.checkAvailability(
            this.newJiraCalendarId,
            eventStartTime,
            eventEndTime
          );

          if (isFree) {
            // Create a new event in new jira's calendar
            const newEvent: CalendarEvent = {
              id: '',
              summary: 'from UM calendar',
              startTime: boEvent.startTime,
              endTime: boEvent.endTime,
              attendees: [this.newJiraCalendarId],
            };

            await this.larkClient.createEvent(this.newJiraCalendarId, newEvent);
            result.created++;

            logger.info('Created new event', {
              summary: newEvent.summary,
              startTime: eventStartTime.toISOString(),
            });
          } else {
            result.skipped++;

            logger.info('Skipped event due to conflict', {
              summary: boEvent.summary,
              startTime: eventStartTime.toISOString(),
            });
          }
        } catch (error) {
          result.failed++;
          const errorDetails: ErrorDetails = {
            eventSummary: boEvent.summary,
            eventTime: boEvent.startTime,
            error: error instanceof Error ? error.message : String(error),
          };
          result.errors.push(errorDetails);

          logger.error('Failed to process event', {
            summary: boEvent.summary,
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