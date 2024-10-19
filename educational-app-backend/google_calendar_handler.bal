import educational_app_backend.datasource;

import ballerina/time;
import ballerina/uuid;
import ballerinax/googleapis.gcalendar;
import ballerina/regex;

gcalendar:ConnectionConfig gcalendarConfig = {
    auth: {
        clientId,
        clientSecret,
        refreshToken
    }
};

gcalendar:Client calendarClient = check new (gcalendarConfig);
string calendarId = "";

public function main() returns error? {
    gcalendar:Calendar calendarResult = check calendarClient->/calendars.post({
        summary: "Session Schedule"
    });
    calendarId = <string>calendarResult.id;
}

function createEvent(string calendarId, datasource:Session session, gcalendar:EventAttendee[] eventAttendees, string subject, string tutorsFirstName) returns gcalendar:Event|error {
    string uuid1String = uuid:createType1AsString();
    string utcOffset = session.utcOffset;
    string[] result = regex:split(utcOffset, ":");

    int hours = check int:fromString(result[0]);
    int minutes = check int:fromString(result[1]);
    decimal seconds = check decimal:fromString(result[2]);
    time:Civil civil2 = {
        year: session.startingTime.year,
        month: session.startingTime.month,
        day: session.startingTime.day,
        hour: session.startingTime.hour,
        minute: session.startingTime.minute,
        second: session.startingTime.second,
        timeAbbrev: session.timeZoneOffset,
        utcOffset: {hours: hours, minutes: minutes, seconds: seconds}
    };
    time:Civil civil3 = {
        year: session.endingTime.year,
        month: session.endingTime.month,
        day: session.endingTime.day,
        hour: session.endingTime.hour,
        minute: session.endingTime.minute,
        second: session.endingTime.second,
        timeAbbrev: session.timeZoneOffset,
        utcOffset: {hours: hours, minutes: minutes, seconds: seconds}
    };
    string startingTimeString = check time:civilToString(civil2);
    string endingTimeString = check time:civilToString(civil3);
    gcalendar:Event event = check calendarClient->/calendars/[calendarId]/events.post(
        payload =
        {
            'start: {
                dateTime: startingTimeString,
                timeZone: "UTC"
            },
            end: {
                dateTime: endingTimeString,
                timeZone: "UTC"
            },
            summary: subject + " with " + tutorsFirstName,
            attendees: eventAttendees,
            conferenceData: {
                createRequest: {
                    requestId: uuid1String,
                    conferenceSolutionKey: {
                        'type: "hangoutsMeet"
                    }
                }
            },
            reminders: {
                useDefault: true
            }
        },
        conferenceDataVersion = 1
    );
    return event;
}

function createEventByPost(datasource:Session session, datasource:Tutor tutor, datasource:Student student) returns string|error {
    gcalendar:EventAttendee[] eventAttendees = [{email: tutor.email}, {email: student.email}];
    datasource:Subject subject = check dbClient->/subjects/[tutor.subjectSubjectId];
    gcalendar:Event event = check createEvent(calendarId, session, eventAttendees, subject.name, tutor.firstName);
    return <string>event.id;
}

function deleteEvent(string eventId) returns error? {
    error? result = calendarClient->/calendars/[calendarId]/events/[eventId].delete();
    if (result is error) {
        return result;
    }
}