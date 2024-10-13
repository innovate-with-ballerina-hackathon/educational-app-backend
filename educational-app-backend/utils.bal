import educational_app_backend.datasource;

import ballerina/graphql;
import ballerina/http;
import ballerina/persist;

const string DATASOURCE = "datasource";
const string USER_ROLE = "userRole";
const string USER_ID = "userId";

final datasource:Client datasourceClient = check new;

isolated function validateUserRole(graphql:Context context, string expectedRole) returns error? {
    string? user_role = check context.get(USER_ROLE).ensureType();
    if user_role is () {
        return error("Authentication error: Invalid user");
    }
    if user_role != expectedRole {
        return error("Authorization error: Insufficient permissions");
    }
}

isolated function initContext(http:RequestContext requestContext, http:Request request) returns graphql:Context|error {
    graphql:Context context = new;

    string|http:HeaderNotFoundError idHeader = request.getHeader(USER_ID);
    string|http:HeaderNotFoundError userRole = request.getHeader(USER_ROLE);
    if idHeader is http:HeaderNotFoundError {
        return error("User not logged in");
    } else {
        int|error userId = int:fromString(idHeader);
        if userRole == "student" && userId is int {
            datasource:Student|persist:Error user = check datasourceClient->/students/[userId];
            if user is error {
                return error("User not found");
            }

        } else if userRole == "tutor" && userId is int {
            datasource:Tutor|persist:Error user = check datasourceClient->/tutors/[userId];
            if user is error {
                return error("User not found");
            }

        }
        context.set(USER_ROLE, userRole);
        context.set(USER_ID, userId);
    }
    return context;
}

isolated function getUserIdFromContext(graphql:Context context) returns int|error {
    string idHeader = check context.get(USER_ID).ensureType();
    int|error userId = int:fromString(idHeader);
    if userId is error {
        return error("User is not logged in");
    }
    return userId;
}
