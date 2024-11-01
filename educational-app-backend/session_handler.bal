import educational_app_backend.datasource;

import ballerina/ftp;
import ballerina/http;
import ballerina/io;
import ballerina/mime;
import ballerina/persist;
import ballerina/regex;
import ballerina/time;
import ballerinax/googleapis.gcalendar;

ftp:ClientConfiguration ftpConfig = {
    protocol: ftp:FTP,
    host: "localhost",
    port: 21,
    auth: {credentials: {username: "one", password: "12345678"}}
};

ftp:Client ftpClient = check new (ftpConfig);

// Request Interceptor service class
service class RequestInterceptor {
    *http:RequestInterceptor;

    resource function 'default [string... path](
            http:RequestContext ctx,
            @http:Header {name: "Authorization"} string xApiVersion)
        returns http:NotImplemented|http:NextService|error? {
        boolean validated = true;
        //validate the token
        if !validated {
            return http:NOT_IMPLEMENTED;
        }
        return ctx.next();
    }
}

// Response Interceptor service class
service class ResponseInterceptor {
    *http:ResponseInterceptor;

    remote function interceptResponse(http:RequestContext ctx, http:Response res)
        returns http:NextService|error? {
        res.setHeader("x-api-version", "v2");
        return ctx.next();
    }
}

@http:ServiceConfig {
    cors: {
        allowOrigins: ["*"]
    }
}
service http:InterceptableService /users on new http:Listener(9091) {
    private final datasource:Client dbClient;

    function init() returns error? {
        self.dbClient = check new ();
    }

    public function createInterceptors() returns (RequestInterceptor|ResponseInterceptor)[] {
        return [new RequestInterceptor(), new ResponseInterceptor()];
    }

    //resource to get tutor by tutorId
    resource function get tutor/[int tutorId]() returns datasource:Tutor|http:InternalServerError|http:NotFound|error {
        datasource:Tutor|persist:Error tutor = self.dbClient->/tutors/[tutorId];
        if tutor is persist:Error {
            if tutor is persist:NotFoundError {
                return http:NOT_FOUND;
            }
            return http:INTERNAL_SERVER_ERROR;
        }
        return tutor;

    }

    //resource to get student by studentId
    resource function get student/[int studentId]() returns datasource:Student|http:InternalServerError|http:NotFound|error {
        datasource:Student|persist:Error student = self.dbClient->/students/[studentId];
        if student is persist:Error {
            if student is persist:NotFoundError {
                return http:NOT_FOUND;
            }
            return http:INTERNAL_SERVER_ERROR;
        }
        return student;
    }

    //resource to get the list of students for a given tutor
    resource function get tutor/[int tutorId]/students() returns datasource:Student[]|http:InternalServerError|http:NotFound|error {
        stream<datasource:Session, persist:Error?> sessions = self.dbClient->/sessions();
        int[] sessionIdArray = check from datasource:Session session in sessions
            where session.tutorTutorId == tutorId
            select session.sessionId;
        datasource:Student[] studentArray = [];
        foreach int sessionId in sessionIdArray {
            stream<datasource:Booking, persist:Error?> bookings = self.dbClient->/bookings();
            int[] studentIdArray = check from datasource:Booking booking in bookings
                where booking.sessionSessionId == sessionId
                select booking.studentStudentId;
            foreach int studentId in studentIdArray {
                datasource:Student student = check self.dbClient->/students/[studentId];
                studentArray.push(student);
            }
        }
        return studentArray;
    }

    //resource to get a list of tutors for a given student
    resource function get student/[int studentId]/tutors() returns datasource:Tutor[]|http:InternalServerError|http:NotFound|error {
        stream<datasource:Booking, persist:Error?> bookings = self.dbClient->/bookings();
        int[] sessionIdArray = check from datasource:Booking booking in bookings
            where booking.studentStudentId == studentId
            select booking.sessionSessionId;
        datasource:Tutor[] tutorArray = [];
        foreach int sessionId in sessionIdArray {
            datasource:Session|persist:Error session = self.dbClient->/sessions/[sessionId];
            if session is persist:Error {
                if session is persist:NotFoundError {
                    return http:NOT_FOUND;
                }
                return http:INTERNAL_SERVER_ERROR;
            }
            datasource:Tutor tutor = check self.dbClient->/tutors/[session.tutorTutorId];
            tutorArray.push(tutor);
        }
        return tutorArray;
    }

    //resource to edit tutor details
    resource function put tutor/[int tutorId]/profile(datasource:TutorUpdate tutorUpdate) returns datasource:Tutor|http:InternalServerError|http:NotFound|error {
        if tutorUpdate?.experienceYears is int && tutorUpdate?.price is int {
            datasource:Tutor|persist:Error tutor = self.dbClient->/tutors/[tutorId].put({
                firstName: tutorUpdate.firstName,
                lastName: tutorUpdate.lastName,
                experienceYears: tutorUpdate?.experienceYears,
                price: tutorUpdate?.price
            });
            if tutor is persist:Error {
                if tutor is persist:NotFoundError {
                    return http:NOT_FOUND;
                }
                return http:INTERNAL_SERVER_ERROR;
            }
            return tutor;
        } else {
            datasource:Tutor|persist:Error tutor = self.dbClient->/tutors/[tutorId].put({
                firstName: tutorUpdate.firstName,
                lastName: tutorUpdate.lastName
            });
            if tutor is persist:Error {
                if tutor is persist:NotFoundError {
                    return http:NOT_FOUND;
                }
                return http:INTERNAL_SERVER_ERROR;
            }
            return tutor;
        }
    }

    //resource to edit student details
    resource function put student/[int studentId]/profile(datasource:StudentUpdate studentUpdate) returns datasource:Student|http:InternalServerError|http:NotFound|error {
        if studentUpdate?.subscribedCategory is datasource:Category {
            datasource:Student|persist:Error student = self.dbClient->/students/[studentId].put({
                firstName: studentUpdate.firstName,
                lastName: studentUpdate.lastName,
                subscribedCategory: studentUpdate?.subscribedCategory
            });
            if student is persist:Error {
                if student is persist:NotFoundError {
                    return http:NOT_FOUND;
                }
                return http:INTERNAL_SERVER_ERROR;
            }
            return student;
        } else {
            datasource:Student|persist:Error student = self.dbClient->/students/[studentId].put({
                firstName: studentUpdate.firstName,
                lastName: studentUpdate.lastName
            });
            if student is persist:Error {
                if student is persist:NotFoundError {
                    return http:NOT_FOUND;
                }
                return http:INTERNAL_SERVER_ERROR;
            }
            return student;
        }
    }

    //resource for tutors to post new sessions
    resource function post sessions(datasource:SessionInsert session) returns http:InternalServerError|http:Conflict|http:Created|datasource:Session[]|error {
        int[]|persist:Error result = self.dbClient->/sessions.post([session]);
        if result is persist:Error {
            if result is persist:AlreadyExistsError {
                return http:CONFLICT;
            }
            return http:INTERNAL_SERVER_ERROR;
        } else {
            datasource:Session[] postedSessions = [];
            foreach int sessionId in result {
                datasource:Session postedSession = check self.dbClient->/sessions/[sessionId];
                postedSessions.push(postedSession);
            }
            return postedSessions;
        }
    }

    //resource for students to book sessions
    resource function put session_booking/[int sessionId](http:Caller caller, http:Request req) returns error? {
        string? stuId = req.getQueryParamValue("studentId");
        http:Response response = new;
        if (stuId == null) {
            response.setHeader("error", "Missing required parameters.");
            string[] missingParams = [];
            response.setPayload({"missingParameters": missingParams});
            return caller->respond(response);
        }
        int studentId = check int:fromString(stuId);
        int[]|persist:Error booking = self.dbClient->/bookings.post([
            {
                sessionSessionId: sessionId,
                studentStudentId: studentId
            }
        ]);

        // TODO: need to set a session unique by the starting time and ending time
        if booking is persist:Error {
            if booking is persist:AlreadyExistsError {
                return caller->respond(http:CONFLICT.toString());
            }
            return caller->respond(http:INTERNAL_SERVER_ERROR.toString());
        }
        datasource:Session session = check self.dbClient->/sessions/[sessionId];
        datasource:Tutor tutor = check self.dbClient->/tutors/[session.tutorTutorId];
        datasource:Student student = check self.dbClient->/students/[studentId];
        gcalendar:Event event = check createEventByPost(session, tutor, student);
        string eventId = <string>event.id;
        string eventUrl = <string>event.hangoutLink;
        datasource:Session|persist:Error updatedSession = self.dbClient->/sessions/[sessionId].put({eventUrl: eventUrl, eventId: eventId, status: datasource:BOOKED});
        //if enroling is successful
        if updatedSession is datasource:Session {
            _ = check self.dbClient->/tutornstudents.post([{tutorTutorId: tutor.tutorId, studentStudentId: student.studentId}]);
            return caller->respond(updatedSession);
        }
        return caller->respond(updatedSession);
    }

    //resource to handle get sessions for a given tutor at a given date
    resource function get tutor/[int tutorId]/sessions(int year, int month, int day) returns datasource:Session[]|error {
        stream<datasource:Session, persist:Error?> sessions = self.dbClient->/sessions();
        return from datasource:Session session in sessions
            where session.tutorTutorId == tutorId &&
            session.startingTime.year == year &&
            session.startingTime.month == month &&
            session.startingTime.day == day
            select session;
    }

    //resource to handle get requests for upcoming sessions for a given student
    resource function get sessions/[int studentId]() returns http:InternalServerError & readonly|http:NotFound & readonly|datasource:Session[]|error {
        stream<datasource:Booking, persist:Error?> bookings = self.dbClient->/bookings();
        int[] sessionIds = check from datasource:Booking booking in bookings
            where booking.studentStudentId == studentId
            select booking.sessionSessionId;
        datasource:Session[] upcomingSessions = [];
        foreach int sessionId in sessionIds {
            datasource:Session|persist:Error session = self.dbClient->/sessions/[sessionId];
            if session is persist:Error {
                if session is persist:NotFoundError {
                    return http:NOT_FOUND;
                }
                return http:INTERNAL_SERVER_ERROR;
            }
            time:Utc currentTime = time:utcNow();
            string[] result = regex:split(session.utcOffset, ":");

            int hours = check int:fromString(result[0]);
            int minutes = check int:fromString(result[1]);
            decimal seconds = check decimal:fromString(result[2]);
            time:Civil civil2 = {
                year: session.endingTime.year,
                month: session.endingTime.month,
                day: session.endingTime.day,
                hour: session.endingTime.hour,
                minute: session.endingTime.minute,
                second: session.endingTime.second,
                timeAbbrev: session.timeZoneOffset,
                utcOffset: {hours: hours, minutes: minutes, seconds: seconds}
            };
            time:Utc endingTime = check time:utcFromCivil(civil2);
            if endingTime > currentTime {
                upcomingSessions.push(session);
            }
        }
        return upcomingSessions;
    }

    // Define the resource to handle update session status
    resource function patch sessions/[int id](@http:Payload datasource:SessionStatus status) returns http:InternalServerError & readonly|http:NotFound & readonly|http:NoContent & readonly {
        datasource:Session|persist:Error result = self.dbClient->/sessions/[id].put({status});
        if result is persist:Error {
            if result is persist:NotFoundError {
                return http:NOT_FOUND;
            }
            return http:INTERNAL_SERVER_ERROR;
        }
        return http:NO_CONTENT;
    }

    // Define the resource to reschedule the session by sessionID
    resource function put sessions/[int sessionId]/reschedule(datasource:SessionUpdate rescheduledSession) returns http:InternalServerError & readonly|http:NoContent & readonly|http:NotFound & readonly|error {

        time:Civil newStartingTime = <time:Civil>rescheduledSession.startingTime;
        time:Civil newEndingTime = <time:Civil>rescheduledSession.endingTime;

        datasource:Session|persist:Error updatedSession = self.dbClient->/sessions/[sessionId].put({startingTime: newStartingTime, endingTime: newEndingTime});
        if updatedSession is persist:Error {
            if updatedSession is persist:NotFoundError {
                return http:NOT_FOUND;
            }
            return http:INTERNAL_SERVER_ERROR;
        } else if updatedSession.status == datasource:BOOKED && updatedSession.eventId != "" && updatedSession.eventId != () {
            _ = check updateEvent(<string>updatedSession.eventId, updatedSession);
        }
        return http:NO_CONTENT;
    }

    //resource to handle DELETE requests for sessions by the tutors
    resource function delete session/[int sessionId]/delete() returns (http:InternalServerError & readonly)|(http:NoContent & readonly)|(http:NotFound & readonly)|error {
        datasource:Session|persist:Error session = self.dbClient->/sessions/[sessionId]();
        if session is persist:Error {
            if session is persist:NotFoundError {
                return http:NOT_FOUND;
            }
            return http:INTERNAL_SERVER_ERROR;
        } else {
            string? eventId = session.eventId;
            if eventId != "" && eventId != () {
                _ = check deleteEvent(eventId);
                datasource:Session|persist:Error cancelledSession = self.dbClient->/sessions/[session.sessionId].put({eventId: "0", status: datasource:CANCELLED});
                if cancelledSession is persist:Error {
                    return http:INTERNAL_SERVER_ERROR;
                }
            } else {
                datasource:Session|persist:Error deleteSession = self.dbClient->/sessions/[session.sessionId].delete();
                if deleteSession is persist:Error {
                    return http:INTERNAL_SERVER_ERROR;
                }
            }
        }
        return http:NO_CONTENT;
    }

    // resource to add a category to a student
    resource function put students/[int studentId]/category(@http:Payload datasource:Category subscribedCategory) returns http:Created|http:NotFound|http:InternalServerError|error {
        datasource:Student|persist:Error addCategory = self.dbClient->/students/[studentId].put({subscribedCategory: subscribedCategory});
        if addCategory is persist:Error {
            if addCategory is persist:NotFoundError {
                return http:NOT_FOUND;
            }
            return http:INTERNAL_SERVER_ERROR;
        }
        return http:CREATED;
    }

    //resource for tutors to upload materials to the ftp server
    resource function post uploadFile(http:Caller caller, http:Request req) returns error? {
        string? tutorStringId = req.getQueryParamValue("tutorId");
        if tutorStringId == null {
            return caller->respond("Missing required parameters.");
        }
        int tutorId = check int:fromString(tutorStringId);
        string description = "";
        string title = "";
        string fileName = "";
        datasource:Category category = datasource:NOT_SPECIFIED;
        string stringCategory = "";

        mime:Entity[] parts = check req.getBodyParts();
        if parts.length() > 0 {
            foreach mime:Entity part in parts {
                if part.getContentDisposition().name == "text_file" {
                    fileName = part.getContentDisposition().fileName;
                    stream<byte[], io:Error?> byteStream = check part.getByteStream(5);
                    stream<io:Block, io:Error?> filter = byteStream.'map(value => value.cloneReadOnly());
                    _ = check ftpClient->put("/home/in/" + fileName, filter);

                } else if part.getContentDisposition().name == "title" {
                    title = check part.getText();
                } else if part.getContentDisposition().name == "description" {
                    description = check part.getText();
                } else if part.getContentDisposition().name == "category" {
                    stringCategory = check part.getText();
                    if stringCategory == "ASTRO" {
                        category = datasource:ASTRO;
                    } else if stringCategory == "MATHS" {
                        category = datasource:MATHS;
                    } else if stringCategory == "PHYSICS" {
                        category = datasource:PHYSICS;
                    } else if stringCategory == "CHEMISTRY" {
                        category = datasource:CHEMISTRY;
                    } else if stringCategory == "GEOMETRY" {
                        category = datasource:GEOMETRY;
                    } else if stringCategory == "ENGLISH" {
                        category = datasource:ENGLISH;
                    } else if stringCategory == "FRENCH" {
                        category = datasource:FRENCH;
                    } else if stringCategory == "GERMAN" {
                        category = datasource:GERMAN;
                    } else if stringCategory == "BIOLOGY" {
                        category = datasource:BIOLOGY;
                    }
                }
            }
            datasource:DocumentInsert document = {
                fileName: fileName,
                description: description,
                title: title,
                category: category,
                tutorTutorId: tutorId
            };

            _ = check self.dbClient->/documents.post([document]);
            check caller->respond("File uploaded successfully as " + fileName);
        }
        else {
            check caller->respond("No file found in the request.");
        }
    }

    //resource to get all the documents uploaded by a tutor
    resource function get tutor/[int tutorId]/documents() returns datasource:Document[]|http:InternalServerError|http:NotFound|error {
        stream<datasource:Document, persist:Error?> documents = self.dbClient->/documents();
        datasource:Document[] documentArray = check from datasource:Document document in documents
            where document.tutorTutorId == tutorId
            select document;
        return documentArray;  
    }
}
