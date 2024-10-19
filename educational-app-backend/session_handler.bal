import educational_app_backend.datasource;

import ballerina/http;
import ballerina/persist;
//import ballerina/time;
import ballerina/mime;
import ballerina/io;
//import ballerina/ftp;



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

service http:InterceptableService /users on new http:Listener(9091) {
    private final datasource:Client dbClient;

    function init() returns error? {
        self.dbClient = check new ();
    }

    public function createInterceptors() returns (RequestInterceptor|ResponseInterceptor)[] {
        return [new RequestInterceptor(), new ResponseInterceptor()];
    }

    //resource to handle post requests for sessions
    resource function post sessions(datasource:SessionInsert session) returns http:InternalServerError|http:Conflict|http:Created|error {
        int[]|persist:Error result = self.dbClient->/sessions.post([session]);
        if result is persist:Error {
            if result is persist:AlreadyExistsError {
                return http:CONFLICT;
            }
            return http:INTERNAL_SERVER_ERROR;
        }
        return http:CREATED;
    }

    //resource to handle book sessions
    resource function put session_booking/[int sessionId](http:Caller caller, http:Request req) returns error?{
        string? stuId = req.getQueryParamValue("studentId");
        http:Response response = new;
        if (stuId == null) {
            response.setHeader("error", "Missing required parameters.");
            string[] missingParams = [];
            response.setPayload({"missingParameters": missingParams});
            return caller->respond(response);
        }
        int studentId = check int:fromString(stuId);
        _ = check self.dbClient->/bookings.post([{
            sessionSessionId: sessionId, 
            studentStudentId : studentId
        }]);
        
        // TODO: need to set a session unique by the starting time and ending time
        // if booking is persist:Error {
        //     if booking is persist:AlreadyExistsError {
        //         return caller->respond(http:CONFLICT.toString());
        //     }
        //     return caller->respond(http:INTERNAL_SERVER_ERROR.toString());
        // }
        datasource:Session session = check self.dbClient->/sessions/[sessionId];
        datasource:Tutor tutor = check self.dbClient->/tutors/[session.tutorTutorId];
        datasource:Student student = check self.dbClient->/students/[studentId];
        string event_id = check createEventByPost(session, tutor, student);
        datasource:Session|persist:Error updatedSession = self.dbClient->/sessions/[sessionId].put({eventId: event_id, status: datasource:BOOKED});
        return caller->respond(updatedSession);
    }

    //resource to handle get sessions for a given tutor at a given date
    resource function get tutor/[int tutorId]/sessions(int year, int month, int day, int hour) returns datasource:Session[]|error {
        stream<datasource:Session, persist:Error?> sessions = self.dbClient->/sessions();
        return from datasource:Session session in sessions
            where session.tutorTutorId == tutorId &&
            session.startingTime.year == year &&
            session.startingTime.month == month &&
            session.startingTime.day == day &&
            session.startingTime.hour == hour
            select session;
    }

    //resource to handle GET requests for students by id
    resource function get students/[int id]() returns http:InternalServerError & readonly|http:NotFound & readonly|datasource:Student {
        datasource:Student|persist:Error result = self.dbClient->/students/[id];
        if result is persist:Error {
            if result is persist:NotFoundError {
                return http:NOT_FOUND;
            }
            return http:INTERNAL_SERVER_ERROR;
        }
        return result;
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
    // resource function put sessions/[int sessionId]/reschedule(datasource:SessionUpdate rescheduledSession) returns http:InternalServerError & readonly|http:NoContent & readonly|http:NotFound & readonly|error {

    //     time:Civil newStartingTime = <time:Civil>rescheduledSession.startingTime;
    //     time:Civil newEndingTime = <time:Civil>rescheduledSession.endingTime;
        

    //     // Fetch the existing session from the database
    //     // datasource:Session|persist:Error existingSession = self.dbClient->/sessions/[sessionId];

    //     // // Ensure the session is booked before allowing rescheduling
    //     // time:Utc currentTime = time:utcNow();

    //     // Calculate the cutoff time (24 hours before the scheduled session time)
    //     //time:Seconds cutoffTime = time:utcDiffSeconds(time:utcFromCivil(existingSession.sessionTime), time:utcNow());

    //     // // Check if rescheduling is allowed
    //     // if (currentTime >= cutoffTime) {
    //     //     // Respond with an error if the session cannot be rescheduled
    //     //     return caller->respond({
    //     //         message: "Rescheduling is only allowed 24 hours before the session.",
    //     //         status: "error"
    //     //     });
    //     // }

    //     datasource:Session|persist:Error result = self.dbClient->/sessions/[sessionId].put({startingTime: newStartingTime, endingTime : newEndingTime});
    //     if result is persist:Error {
    //         if result is persist:NotFoundError {
    //             return http:NOT_FOUND;
    //         }
    //         return http:INTERNAL_SERVER_ERROR;
    //     }
    //     return http:NO_CONTENT;
    // }

    // //resource to handle DELETE requests for sessions on students requests
    // resource function delete students/[int id]/sessions(int year, int month, int day) returns http:InternalServerError & readonly|http:NoContent & readonly|http:NotFound & readonly {

    //     //calender event also needs to be deleted
    //     stream<datasource:Session, persist:Error?> sessions = self.dbClient->/sessions;
    //     datasource:Session[]|persist:Error result = from datasource:Session session in sessions
    //         where session.sessionId == id
    //         && session.startingTime.year == year
    //         && session.startingTime.month == month
    //         && session.startingTime.day == day
    //         select session;
    //     if result is persist:Error {
    //         if result is persist:NotFoundError {
    //             return http:NOT_FOUND;
    //         }
    //         return http:INTERNAL_SERVER_ERROR;
    //     }
    //     foreach datasource:Session session in result {
    //         datasource:Session|persist:Error deleteResult = self.dbClient->/sessions/[session.sessionId].delete();
    //         if deleteResult is persist:Error {
    //             return http:INTERNAL_SERVER_ERROR;
    //         }
    //     }
    //     return http:NO_CONTENT;
    // }

    resource function post uploadFile(http:Caller caller, http:Request req) returns error?{
            mime:Entity[] parts = check req.getBodyParts();
            // Assume the first part is the file part
            if parts.length() > 0 {
                mime:Entity filePart = parts[0];

                // Get the filename from the headers (optional)
                string? fileName = filePart.getContentDisposition().toString();
                // filePart.getContentDisposition()?.getParameter("filename");
                if fileName is () {
                    fileName = "uploaded_file.txt"; // Default filename if none provided
                } else {
                //stream<io:Block, io:Error?> bStream = check io:fileReadBlocksAsStream("./resources/docs/mid_exam.pdf", 5);
                // ftp:Error? response = check clientEp->put("/home/in/final_exam_1.pdf", bStream);

                stream<byte[], io:Error?>|mime:ParserError byteStream = filePart.getByteStream();
                io:println(byteStream);
                //TODO:
                //ftp:Error? response = check clientEp->put("/home/in/" + fileName + ".txt", byteStream);

                // Respond back to the caller
                check caller->respond("File uploaded successfully as " + fileName);
                }
            } else {
                check caller->respond("No file found in the request.");
            }
    }
}

