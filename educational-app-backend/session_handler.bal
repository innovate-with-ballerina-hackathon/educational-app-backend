import ballerina/http;
import educational_app_backend.datasource;
import ballerina/persist;
import ballerina/time;
service /users on new http:Listener(9091) {
    private final datasource:Client dbClient;

    function init() returns error?{
        self.dbClient = check new ();
    }

    //resource to handle the post requests for tutors
    resource function post tutors(datasource:TutorInsert tutor) returns http:InternalServerError| http:Conflict | http:Created{
        string[]|persist:Error result = self.dbClient ->/tutors.post([tutor]);
        if result is persist:Error {
            if result is persist:AlreadyExistsError{
                return http:CONFLICT;
            } return http:INTERNAL_SERVER_ERROR;
        }
        return http:CREATED;
    }

    //resource to handle post requests for students
    resource function post students(datasource:StudentInsert student) returns http:InternalServerError| http:Conflict | http:Created{
        string[]|persist:Error result = self.dbClient ->/students.post([student]);
        if result is persist:Error {
            if result is persist:AlreadyExistsError{
                return http:CONFLICT;
            } return http:INTERNAL_SERVER_ERROR;
        }
        return http:CREATED;  
    }

    //resource to handle post requests for sessions
    resource function post sessions(datasource:SessionInsert session) returns http:InternalServerError| http:Conflict | http:Created{
        string[]|persist:Error result = self.dbClient ->/sessions.post([session]);
        if result is persist:Error {
            if result is persist:AlreadyExistsError{
                return http:CONFLICT;
            } return http:INTERNAL_SERVER_ERROR;
        }
        return http:CREATED;  
    }

    //resource to handle get sessions for a given tutor at a given date
    resource function get tutor/[string tutorId]/sessions(int year, int month, int day, int hour) returns datasource:Session[] | error{
       stream<datasource:Session, persist:Error?> sessions = self.dbClient->/sessions();
        return from datasource:Session session in sessions
            where session.tutorTutorId == tutorId &&
        session.sessionTime.year == year &&
        session.sessionTime.month == month &&
        session.sessionTime.day == day &&
        session.sessionTime.hour == hour
            select session; 
    }

    //resource to handle GET requests for students by id
    resource function get students/[string id]() returns http:InternalServerError & readonly|http:NotFound & readonly|datasource:Student {
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
    resource function patch sessions/[string id](@http:Payload datasource:SessionStatus status) returns http:InternalServerError & readonly|http:NotFound & readonly|http:NoContent & readonly {
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
    resource function put sessions/[string sessionId]/reschedule(datasource:SessionUpdate rescheduledSession) returns http:InternalServerError & readonly|http:NoContent & readonly|http:NotFound & readonly|error {
    
    time:Civil newSessionTime = <time:Civil>rescheduledSession.sessionTime;
    int newDuration = <int>rescheduledSession.duration;

    // Fetch the existing session from the database
    // datasource:Session|persist:Error existingSession = self.dbClient->/sessions/[sessionId];

    // // Ensure the session is booked before allowing rescheduling
    // time:Utc currentTime = time:utcNow();

    // Calculate the cutoff time (24 hours before the scheduled session time)
    //time:Seconds cutoffTime = time:utcDiffSeconds(time:utcFromCivil(existingSession.sessionTime), time:utcNow());

    // // Check if rescheduling is allowed
    // if (currentTime >= cutoffTime) {
    //     // Respond with an error if the session cannot be rescheduled
    //     return caller->respond({
    //         message: "Rescheduling is only allowed 24 hours before the session.",
    //         status: "error"
    //     });
    // }

    datasource:Session|persist:Error result = self.dbClient->/sessions/[sessionId].put({sessionTime : newSessionTime, duration: newDuration});
    if result is persist:Error {
            if result is persist:NotFoundError {
                return http:NOT_FOUND;
            }
            return http:INTERNAL_SERVER_ERROR;
        }
        return http:NO_CONTENT;
}

    //resource to handle DELETE requests for sessions on students requests
    resource function delete students/[string id]/sessions(int year, int month, int day) returns http:InternalServerError & readonly|http:NoContent & readonly|http:NotFound & readonly {
        
        //deleting the calendar event needs to be implemented

        stream<datasource:Session, persist:Error?> sessions = self.dbClient->/sessions;
        datasource:Session[]|persist:Error result = from datasource:Session session in sessions
            where session.sessionId == id
                && session.sessionTime.year == year
                && session.sessionTime.month == month
                && session.sessionTime.day == day
            select session;
        if result is persist:Error {
            if result is persist:NotFoundError {
                return http:NOT_FOUND;
            }
            return http:INTERNAL_SERVER_ERROR;
        }
        foreach datasource:Session session in result {
            datasource:Session|persist:Error deleteResult = self.dbClient->/sessions/[session.sessionId].delete();
            if deleteResult is persist:Error {
                return http:INTERNAL_SERVER_ERROR;
            }
        }
        return http:NO_CONTENT;
    }


}

