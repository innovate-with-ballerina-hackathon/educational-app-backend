import ballerinax/googleapis.gcalendar;
import ballerina/io;
import ballerina/uuid;
import educational_app_backend.datasource;

// configurable string clientId = ?;
// configurable string clientSecret = ?;
// configurable string refreshToken = ?;
configurable string email = ?;

gcalendar:ConnectionConfig gcalendarConfig = {
   auth: {
       clientId,
       clientSecret,
       refreshToken
   }
};

gcalendar:Client calendar ;

string calendarId = "";

function createEvent(gcalendar:Client calendar, string calendarId, datasource:Session session, gcalendar:EventAttendee[] eventAttendees, string subject, string tutorsFirstName) returns gcalendar:Event|error {
    string uuid1String = uuid:createType1AsString();
    gcalendar:Event event = check calendar->/calendars/[calendarId]/events.post(
   payload =
       {
       'start: {
           dateTime: session.sessionTime.toString(),//'2024-02-22T11:00:00+00:00'
           timeZone: "UTC"
       },
       end: {
           dateTime: "2024-02-22T11:00:00+00:00",
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
       }
   },
   conferenceDataVersion = 1
);
    return event;
}


function createEventByPost(datasource:Session session, datasource:Tutor tutor) returns string|error {
    gcalendar:EventAttendee[] eventAttendees = [{email:tutor.email}];
    gcalendar:Event event = check createEvent(calendar,calendarId,session,eventAttendees, subject, tutor.firstName);
    
    return <string>event.id;
}