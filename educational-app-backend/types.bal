import ballerina/graphql;

public type ReviewInput record {|
    string review;
    int starRating;
    int tutorTutorId;
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
