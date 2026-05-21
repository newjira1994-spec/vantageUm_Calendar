import { CalendarEvent } from './types';
import logger from './logger';

export class LarkClient {
  private appId: string;
  private appSecret: string;
  private tenantAccessToken: string | null = null;
  private baseUrl = 'https://open.larksuite.com/open-apis';

  constructor(appId: string, appSecret: string) {
    this.appId = appId;
    this.appSecret = appSecret;
  }

  async getTenantAccessToken(): Promise<string> {
    try {
      const response = await fetch(`${this.baseUrl}/auth/v3/tenant_access_token/internal`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          app_id: this.appId,
          app_secret: this.appSecret,
        }),
      });

      const data = await response.json() as any;

      if (data.code !== 0) {
        throw new Error(`Failed to get tenant access token: ${data.msg}`);
      }

      this.tenantAccessToken = data.tenant_access_token;
      logger.info('Successfully obtained tenant access token');
      return this.tenantAccessToken!;
    } catch (error) {
      logger.error('Failed to get tenant access token', { error: error instanceof Error ? error.message : String(error) });
      throw error;
    }
  }

  async getCalendarEvents(calendarId: string, startTime: Date, endTime: Date): Promise<CalendarEvent[]> {
    try {
      if (!this.tenantAccessToken) {
        await this.getTenantAccessToken();
      }

      logger.info('Fetching calendar events', {
        calendarId,
        startTime: startTime.toISOString(),
        endTime: endTime.toISOString(),
      });

      const params = new URLSearchParams({
        start_time: Math.floor(startTime.getTime() / 1000).toString(),
        end_time: Math.floor(endTime.getTime() / 1000).toString(),
        page_size: '100',
      });

      const response = await fetch(
        `${this.baseUrl}/calendar/v4/calendars/${calendarId}/events?${params}`,
        {
          method: 'GET',
          headers: {
            'Authorization': `Bearer ${this.tenantAccessToken}`,
          },
        }
      );

      const data = await response.json() as any;

      if (data.code !== 0) {
        const errorMsg = `Failed to get calendar events: ${data.msg} (code: ${data.code})`;
        logger.error('API error response', {
          calendarId,
          code: data.code,
          msg: data.msg,
        });
        throw new Error(errorMsg);
      }

      const events: CalendarEvent[] = [];
      const items = data.data?.items || [];

      for (const item of items) {
        // Convert timestamp from seconds to milliseconds if needed
        let startTimestamp = item.start_time?.timestamp || '';
        let endTimestamp = item.end_time?.timestamp || '';

        // Ensure timestamps are in milliseconds
        if (startTimestamp && startTimestamp.length === 10) {
          startTimestamp = startTimestamp + '000';
        }
        if (endTimestamp && endTimestamp.length === 10) {
          endTimestamp = endTimestamp + '000';
        }

        events.push({
          id: item.event_id || '',
          summary: item.summary || '',
          startTime: startTimestamp,
          endTime: endTimestamp,
          attendees: item.attendees?.map((a: any) => a.open_id || '') || [],
          location: item.location?.name || '',
          description: item.description || '',
        });
      }

      logger.info('Successfully fetched calendar events', {
        calendarId,
        count: events.length,
      });

      return events;
    } catch (error) {
      logger.error('Failed to get calendar events', {
        calendarId,
        error: error instanceof Error ? error.message : String(error),
      });
      throw error;
    }
  }

  async checkAvailability(calendarId: string, startTime: Date, endTime: Date): Promise<boolean> {
    try {
      if (!this.tenantAccessToken) {
        await this.getTenantAccessToken();
      }

      logger.info('Checking calendar availability', {
        calendarId,
        startTime: startTime.toISOString(),
        endTime: endTime.toISOString(),
      });

      const events = await this.getCalendarEvents(calendarId, startTime, endTime);

      const isFree = events.length === 0;
      logger.info('Calendar availability check result', {
        calendarId,
        isFree,
        eventCount: events.length,
      });

      return isFree;
    } catch (error) {
      logger.error('Failed to check calendar availability', {
        calendarId,
        error: error instanceof Error ? error.message : String(error),
      });
      throw error;
    }
  }

  async createEvent(calendarId: string, event: CalendarEvent): Promise<void> {
    try {
      if (!this.tenantAccessToken) {
        await this.getTenantAccessToken();
      }

      logger.info('Creating calendar event', {
        calendarId,
        summary: event.summary,
        startTime: event.startTime,
        endTime: event.endTime,
      });

      // Ensure timestamps are in milliseconds
      let startTimestamp = event.startTime;
      let endTimestamp = event.endTime;

      // Convert to milliseconds if in seconds
      if (startTimestamp.length === 10) {
        startTimestamp = startTimestamp + '000';
      }
      if (endTimestamp.length === 10) {
        endTimestamp = endTimestamp + '000';
      }

      const body: any = {
        summary: event.summary,
        start_time: {
          timestamp: startTimestamp,
        },
        end_time: {
          timestamp: endTimestamp,
        },
      };

      if (event.attendees && event.attendees.length > 0) {
        body.attendees = event.attendees.map(id => ({ open_id: id }));
      }

      if (event.location) {
        body.location = { name: event.location };
      }

      if (event.description) {
        body.description = event.description;
      }

      logger.debug('Creating event with body', {
        calendarId,
        body: JSON.stringify(body),
      });

      const response = await fetch(
        `${this.baseUrl}/calendar/v4/calendars/${calendarId}/events`,
        {
          method: 'POST',
          headers: {
            'Authorization': `Bearer ${this.tenantAccessToken}`,
            'Content-Type': 'application/json',
          },
          body: JSON.stringify(body),
        }
      );

      const data = await response.json() as any;

      if (data.code !== 0) {
        const errorMsg = `Failed to create calendar event: ${data.msg} (code: ${data.code})`;
        logger.error('API error response', {
          calendarId,
          code: data.code,
          msg: data.msg,
          summary: event.summary,
        });
        throw new Error(errorMsg);
      }

      logger.info('Successfully created calendar event', {
        calendarId,
        eventId: data.data?.event?.event_id,
        summary: event.summary,
      });
    } catch (error) {
      logger.error('Failed to create calendar event', {
        calendarId,
        summary: event.summary,
        error: error instanceof Error ? error.message : String(error),
      });
      throw error;
    }
  }
}

export default LarkClient;