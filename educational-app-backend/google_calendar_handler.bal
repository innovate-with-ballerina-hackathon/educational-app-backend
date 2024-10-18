import ballerinax/googleapis.gcalendar;
import ballerina/uuid;
import educational_app_backend.datasource;

// configurable string clientId = ?;
// configurable string clientSecret = ?;
// configurable string refreshToken = ?;

gcalendar:ConnectionConfig gcalendarConfig = {
   auth: {
       clientId,
       clientSecret,
       refreshToken
   }
};

gcalendar:Client calendarClient = check new(gcalendarConfig);

function createCalendar() returns string|error {
    gcalendar:Calendar calendarResult = check calendarClient->/calendars.post({
       summary: "Session Schedule"
   });
    return <string>calendarResult.id;
}
function createEvent(string calendarId, datasource:Session session, gcalendar:EventAttendee[] eventAttendees, string subject, string tutorsFirstName) returns gcalendar:Event|error {
    string uuid1String = uuid:createType1AsString();
    gcalendar:Event event = check calendarClient->/calendars/[calendarId]/events.post(
   payload =
       {
       'start: {
           dateTime: "2024-10-17T16:00:00+00:00",//'2024-02-22T11:00:00+00:00'
           timeZone: "UTC"
       },
       end: {
           dateTime: "2024-10-17T17:00:00+00:00",
           timeZone: "UTC"
       },
       summary: subject +" with "+ tutorsFirstName,
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
            // overrides: [
            //     {
            //         method: "popup",
            //         minutes: 15
            //     },
            //     {
            //         method: "email",
            //         minutes: 30
            //     }
            // ]
        }
   },
   conferenceDataVersion = 1
);
    return event;
}


function createEventByPost(datasource:Session session, datasource:Tutor tutor, datasource:Student student) returns string|error {
    gcalendar:EventAttendee[] eventAttendees = [{email:tutor.email}, {email:student.email}];
    datasource:Subject subject = check dbClient->/subjects/[tutor.subjectSubjectId];
    string calendarId = check createCalendar();
    gcalendar:Event event = check createEvent(calendarId,session,eventAttendees, subject.name, tutor.firstName);
    return <string>event.id;
}