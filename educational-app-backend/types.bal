import ballerina/graphql;
import ballerina/ftp;

public type ReviewInput record {|
    string review;
    int starRating;
    int tutorTutorId;
|};

public type SftpConfig record {|
    ftp:Protocol protocol;
    string host;
    int port;
    ftp:AuthConfiguration auth;
|};

public type SftpListenerConfig record {|
    ftp:Protocol protocol;
    string host;
    int port;
    string path = "/";
    ftp:AuthConfiguration auth;
    string fileNamePattern;
    decimal pollingInterval;
|};

public type UtcOffset record {|
    int hours; 
    int minutes;
    decimal seconds;
|};


readonly service class TutorAuthInterceptor {
    *graphql:Interceptor;

    isolated remote function execute(graphql:Context context, graphql:Field 'field) returns anydata|error {
        check validateUserRole(context, "tutor");
        return context.resolve('field);
    }
}
readonly service class StudentAuthInterceptor {
    *graphql:Interceptor;

    isolated remote function execute(graphql:Context context, graphql:Field 'field) returns anydata|error {
        check validateUserRole(context, "student");
        return context.resolve('field);
    }
}
