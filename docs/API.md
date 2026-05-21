# Lark API Documentation

This document describes the Lark Open Platform APIs used by the calendar sync tool.

## 📋 API Overview

The tool uses the Lark Calendar API to:
1. Read calendar events
2. Check calendar availability
3. Create new events

## 🔑 Authentication

### Tenant Access Token

All API calls require a tenant access token obtained via:

```
POST /auth/v3/tenant_access_token/internal
```

**Request:**
```json
{
  "app_id": "cli_xxx",
  "app_secret": "xxx"
}
```

**Response:**
```json
{
  "code": 0,
  "msg": "ok",
  "tenant_access_token": "t-xxx",
  "expire": 7200
}
```

**Implementation:** See [lark-client.ts](../src/lark-client.ts) → `getTenantAccessToken()`

## 📅 Calendar Events API

### List Calendar Events

Retrieve events from a calendar within a time range.

```
GET /calendar/v4/calendars/:calendar_id/events
```

**Parameters:**
- `calendar_id` (path): Calendar identifier
- `start_time` (query): Start timestamp in milliseconds
- `end_time` (query): End timestamp in milliseconds
- `page_size` (query): Number of events per page (max 100)

**Headers:**
```
Authorization: Bearer t-xxx
```

**Response:**
```json
{
  "code": 0,
  "msg": "ok",
  "data": {
    "items": [
      {
        "event_id": "xxx",
        "summary": "Meeting Title",
        "start_time": {
          "timestamp": "1234567890000"
        },
        "end_time": {
          "timestamp": "1234567890000"
        },
        "attendees": [
          {
            "open_id": "ou_xxx"
          }
        ],
        "location": "Room 101",
        "description": "Meeting description"
      }
    ]
  }
}
```

**Implementation:** See [lark-client.ts](../src/lark-client.ts) → `getCalendarEvents()`

### Create Calendar Event

Create a new event in a calendar.

```
POST /calendar/v4/calendars/:calendar_id/events
```

**Parameters:**
- `calendar_id` (path): Calendar identifier

**Headers:**
```
Authorization: Bearer t-xxx
Content-Type: application/json
```

**Request Body:**
```json
{
  "summary": "from UM calendar",
  "start_time": {
    "timestamp": "1234567890000"
  },
  "end_time": {
    "timestamp": "1234567890000"
  },
  "attendees": [
    {
      "open_id": "ou_xxx"
    }
  ],
  "location": "Room 101",
  "description": "Event description"
}
```

**Response:**
```json
{
  "code": 0,
  "msg": "ok",
  "data": {
    "event": {
      "event_id": "xxx",
      "summary": "from UM calendar",
      "start_time": {
        "timestamp": "1234567890000"
      },
      "end_time": {
        "timestamp": "1234567890000"
      }
    }
  }
}
```

**Implementation:** See [lark-client.ts](../src/lark-client.ts) → `createEvent()`

## 🔍 Free/Busy API

### Check Availability

Check if a calendar has events during a time range.

The tool uses the `getCalendarEvents` API to check availability by:
1. Fetching all events in the time range
2. Checking if any events exist
3. If no events exist, the calendar is free

**Implementation:** See [lark-client.ts](../src/lark-client.ts) → `checkAvailability()`

## 📊 Data Models

### CalendarEvent

```typescript
interface CalendarEvent {
  id: string;              // Event unique identifier
  summary: string;         // Event title
  startTime: string;       // Start timestamp (milliseconds)
  endTime: string;         // End timestamp (milliseconds)
  attendees?: string[];    // List of attendee open_ids
  location?: string;       // Event location
  description?: string;    // Event description
}
```

### Time Format

All timestamps are in **milliseconds since Unix epoch**.

Example:
```javascript
const timestamp = Date.now(); // e.g., 1716273600000
```

## 🔐 Required Permissions

Your Lark app needs these permissions:

| Permission | Scope | Description |
|------------|-------|-------------|
| `calendar:calendar:readonly` | Calendar | Read calendar information |
| `calendar:calendar_event:readonly` | Calendar Event | Read event details |
| `calendar:calendar_event:write` | Calendar Event | Create events |

### Adding Permissions

1. Go to Lark Developer Platform
2. Open your app
3. Navigate to "Permissions & Scopes"
4. Add the required permissions
5. Submit for approval

## ⚡ Rate Limits

Lark API has rate limits:

| API | Limit |
|-----|-------|
| Get Tenant Access Token | 100 requests/minute |
| List Calendar Events | 100 requests/minute |
| Create Calendar Event | 100 requests/minute |

### Handling Rate Limits

The tool implements:
- Automatic token refresh
- Error logging for rate limit errors
- Retry logic (future enhancement)

## 🌐 API Endpoints

### Base URL

```
https://open.larksuite.com/open-apis
```

### Full Endpoints

| Operation | Endpoint |
|-----------|----------|
| Get Token | `POST /auth/v3/tenant_access_token/internal` |
| List Events | `GET /calendar/v4/calendars/{calendar_id}/events` |
| Create Event | `POST /calendar/v4/calendars/{calendar_id}/events` |

## 📝 Error Handling

### Common Error Codes

| Code | Description | Solution |
|------|-------------|----------|
| 0 | Success | - |
| 99991663 | Invalid calendar_id | Check calendar ID format |
| 99991661 | Permission denied | Grant required permissions |
| 99991664 | Event conflict | Event already exists at this time |
| 99991667 | Invalid time range | Check start/end timestamps |

### Error Response Format

```json
{
  "code": 99991663,
  "msg": "calendar not found"
}
```

## 🔧 SDK Usage

The tool uses the official Lark Node.js SDK:

```typescript
import lark from '@larksuiteoapi/node-sdk';

const client = new lark.Client({
  appId: 'cli_xxx',
  appSecret: 'xxx',
  appType: lark.AppType.SelfBuild,
  domain: lark.Domain.Lark,
});
```

### SDK Methods

#### Get Tenant Access Token

```typescript
const response = await client.auth.tenantAccessToken.internalGetTenantAccessToken({
  data: {
    app_id: appId,
    app_secret: appSecret,
  },
});
```

#### List Calendar Events

```typescript
const response = await client.calendar.v4.calendarEvent.listWithIterator({
  path: {
    calendar_id: calendarId,
  },
  params: {
    start_time: startTime.toString(),
    end_time: endTime.toString(),
    page_size: 100,
  },
});
```

#### Create Calendar Event

```typescript
const response = await client.calendar.v4.calendarEvent.create({
  path: {
    calendar_id: calendarId,
  },
  data: {
    summary: 'Event Title',
    start_time: { timestamp: startTime },
    end_time: { timestamp: endTime },
    attendees: [{ open_id: attendeeId }],
  },
});
```

## 📚 Additional Resources

- [Lark Open Platform Documentation](https://open.larksuite.com/document)
- [Calendar API Reference](https://open.larksuite.com/document/server-docs/calendar-v4/calendar-event/create)
- [Node.js SDK Documentation](https://github.com/larksuite/oapi-sdk-node)

## 🧪 Testing APIs

### Using cURL

```bash
# Get tenant access token
curl -X POST \
  https://open.larksuite.com/open-apis/auth/v3/tenant_access_token/internal \
  -H 'Content-Type: application/json' \
  -d '{
    "app_id": "your_app_id",
    "app_secret": "your_app_secret"
  }'

# List calendar events
curl -X GET \
  'https://open.larksuite.com/open-apis/calendar/v4/calendars/ou_xxx/events?start_time=1234567890000&end_time=1234567890000' \
  -H 'Authorization: Bearer t-xxx'
```

### Using Postman

1. Import the Lark API collection
2. Set environment variables for `app_id`, `app_secret`, `calendar_id`
3. Run requests to test

---

**For implementation details, see the source code in [src/](../src/)**
