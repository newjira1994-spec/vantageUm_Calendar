export interface CalendarEvent {
  id: string;
  summary: string;
  startTime: string;
  endTime: string;
  attendees?: string[];
  location?: string;
  description?: string;
}

export interface SyncResult {
  totalChecked: number;
  created: number;
  skipped: number;
  failed: number;
  errors: ErrorDetails[];
}

export interface ErrorDetails {
  eventSummary: string;
  eventTime: string;
  error: string;
}

export interface Config {
  larkAppId: string;
  larkAppSecret: string;
  boCoordinatorCalendarId: string;
  newJiraCalendarId: string;
  syncDaysForward: number;
  logLevel: string;
}
