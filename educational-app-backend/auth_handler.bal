import educational_app_backend.datasource;

import ballerina/http;
import ballerina/io;
import ballerina/mime;
import ballerina/persist;
import ballerinax/googleapis.gmail;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;

string companyName = "Edu-App";

http:Client googleClient = check new ("https://oauth2.googleapis.com", followRedirects = {enabled: true});

datasource:Client dbClient = check new;

gmail:Client gmail = check new gmail:Client(
    config = {
        auth: {
            refreshToken,
            clientId,
            clientSecret
        }
    }
);

service / on new http:Listener(9093) {

    resource function post token(http:Caller caller, http:Request req) returns http:ListenerError?|error {
        //Extract parameters from the request
        string? authorizationCode = req.getQueryParamValue("code");
        string? userRole = req.getQueryParamValue("role");
        string? redirectUri = req.getQueryParamValue("redirect_uri");
        string? subject = req.getQueryParamValue("subject");

        http:Response response = new;
        if (authorizationCode == null || userRole == null || redirectUri == null) {
            response.setHeader("error", "Missing required parameters.");
            string[] missingParams = [];
            if (authorizationCode == null) {
                missingParams.push("authorizationCode");
            }
            if (userRole == null) {
                missingParams.push("userRole");
            }
            if (redirectUri == null) {
                missingParams.push("redirectUri");
            }
            response.setPayload({"missingParameters": missingParams});
            return caller->respond(response);
        }

        // Prepare the request body for the token endpoint
        http:RequestMessage requestBody = {
            "client_id": clientId,
            "client_secret": clientSecret,
            "code": authorizationCode,
            "grant_type": "authorization_code",
            "redirect_uri": redirectUri
        };

        json|error dummyResponse = googleClient->/token.post(requestBody, mediaType = mime:APPLICATION_FORM_URLENCODED);

        if (dummyResponse is json) {
            string accessToken = check dummyResponse.access_token;
            string? refreshToken = check dummyResponse.refresh_token;
            string idToken = check dummyResponse.id_token;

            json decodedIdToken = check decodeIdToken(idToken);

            // Extract user information
            string firstName = check decodedIdToken.given_name;
            string lastName = check decodedIdToken.family_name;
            string email = check decodedIdToken.email;

            int userId = 0;
            if (refreshToken is string) {
                if userRole == "student" {
                    int credentialId = check addAuthCredentials(userRole, accessToken, refreshToken, idToken);
                    datasource:StudentInsert student = {
                        "firstName": firstName,
                        "lastName": lastName,
                        "email": email,
                        "credentialsCredId": credentialId,
                        "subscribedCategory": datasource:NOT_SPECIFIED
                    };
                    int[]|persist:Error result = dbClient->/students.post([student]);
                    if result is persist:Error {
                        if result is persist:AlreadyExistsError {
                            response.setHeader("message", http:CONFLICT.toString() + "User Already Exists");
                        }
                        response.setHeader("message", http:INTERNAL_SERVER_ERROR.toString() + "Internal Server Error Occured");
                    } else {
                        userId = result[0];
                        response.setHeader("message", http:OK.toString() + "User Created Successfully");
                        string emailBody = "Welcome to Edu-App! We're excited to have you onboard. Start exploring and connecting with expert tutors to reach your learning goals today!";
                        sendOnboardingEmails(firstName, emailBody, email);
                    }
                } else {
                    int credentialId = check addAuthCredentials(userRole, accessToken, refreshToken, idToken);
                    stream<datasource:Subject, persist:Error?> subjectStream = dbClient->/subjects();
                    int[] subId = check from datasource:Subject sub in subjectStream
                        where sub.name == subject
                        select sub.subjectId;

                    int subjectId = subId[0];

                    datasource:TutorInsert tutor = {
                        "firstName": firstName,
                        "lastName": lastName,
                        "email": email,
                        "experienceYears": 0,
                        "price": 0,
                        "credentialsCredId": credentialId,
                        "subjectSubjectId": subjectId
                    };
                    int[]|persist:Error result = dbClient->/tutors.post([tutor]);
                    if result is persist:Error {
                        if result is persist:AlreadyExistsError {
                            response.setHeader("message", http:CONFLICT.toString() + "User Already Exists");
                        }
                        response.setHeader("message", http:INTERNAL_SERVER_ERROR.toString() + "Internal Server Error Occured");
                    } else {
                        userId = result[0];
                        response.setHeader("message", http:OK.toString() + "User Created Successfully");
                        string emailBody = "Welcome to Edu-App! We're thrilled to have you join our community of educators. Get ready to share your expertise and help students succeed!";
                        sendOnboardingEmails(firstName, emailBody, email);
                    }
                }
            } else {
                stream<datasource:AuthCredentials, persist:Error?> authStream = dbClient->/authcredentials();
                string[] reqToken = check from datasource:AuthCredentials cred in authStream
                    where cred.accessToken == accessToken
                    select cred.refreshToken;
                refreshToken = reqToken[0];
            }
            json responseJson = {
                "access_token": accessToken,
                "refresh_token": refreshToken,
                "user_id": userId
            };
            response.setPayload(responseJson);
            return caller->respond(response);
        } else {
            response.setHeader("error", "Invalid Access Token");
            response.setPayload({"Invalid Access Token": "You may request a new access token using the refresh token"});
            return caller->respond(response);
        }
    }

    resource function post acc_token(http:Caller caller, http:Request req) returns http:ListenerError?|error {
        string? accessToken = req.getQueryParamValue("access_token");
        string? userRole = req.getQueryParamValue("role");
        string? subject = req.getQueryParamValue("subject");
        http:Response response = new;
        if (accessToken == null || userRole == null) {
            response.setHeader("error", "Missing required parameters.");
            string[] missingParams = [];
            if (accessToken == null) {
                missingParams.push("accessToken");
            }
            if (userRole == null) {
                missingParams.push("userRole");
            }
            response.setPayload({"missingParameters": missingParams});
            return caller->respond(response);
        }
        json decodedAccessToken = check decodeAccessToken(accessToken);

        // Extract user information
        string email = check decodedAccessToken.email;

        int userId = 0;
        if userRole == "student" {
            int credentialId = check addAuthCredentials(userRole, accessToken, "refreshToken", "idToken");
            datasource:StudentInsert student = {
                "firstName": "firstName",
                "lastName": "lastName",
                "email": email,
                "credentialsCredId": credentialId,
                "subscribedCategory": datasource:NOT_SPECIFIED
            };
            int[]|persist:Error result = dbClient->/students.post([student]);
            if result is persist:Error {
                if result is persist:AlreadyExistsError {
                    response.setHeader("message", http:CONFLICT.toString() + "User Already Exists");
                }
                response.setHeader("message", http:INTERNAL_SERVER_ERROR.toString() + "Internal Server Error Occured");
            } else {
                userId = result[0];
                response.setHeader("message", http:OK.toString() + "User Created Successfully");
                string emailBody = "Welcome to Edu-App! We're excited to have you onboard. Start exploring and connecting with expert tutors to reach your learning goals today!";
                sendOnboardingEmails("Student", emailBody, email);
            }
        } else {
            int credentialId = check addAuthCredentials(userRole, accessToken, "refreshToken", "idToken");
            stream<datasource:Subject, persist:Error?> subjectStream = dbClient->/subjects();
            int[] subId = check from datasource:Subject sub in subjectStream
                where sub.name == subject
                select sub.subjectId;

            int subjectId = subId[0];

            datasource:TutorInsert tutor = {
                "firstName": "firstName",
                "lastName": "lastName",
                "email": email,
                "experienceYears": 0,
                "price": 0,
                "credentialsCredId": credentialId,
                "subjectSubjectId": subjectId
            };
            int[]|persist:Error result = dbClient->/tutors.post([tutor]);
            if result is persist:Error {
                if result is persist:AlreadyExistsError {
                    response.setHeader("message", http:CONFLICT.toString() + "User Already Exists");
                }
                response.setHeader("message", http:INTERNAL_SERVER_ERROR.toString() + "Internal Server Error Occured");
            } else {
                userId = result[0];
                response.setHeader("message", http:OK.toString() + "User Created Successfully");
                string emailBody = "Welcome to Edu-App! We're thrilled to have you join our community of educators. Get ready to share your expertise and help students succeed!";
                sendOnboardingEmails("Tutor", emailBody, email);
            }
        }
        json responseJson = {
            "access_token": accessToken,
            "user_id": userId
        };
        response.setPayload(responseJson);
        return caller->respond(response);
    }

    resource function post req_token(http:Caller caller, http:Request req) returns http:ListenerError?|error {
        string? refreshToken = req.getQueryParamValue("refresh_token");
        string? userRole = req.getQueryParamValue("role");

        http:Response response = new;
        if (refreshToken == null || userRole == null) {
            response.setHeader("error", "Missing required parameters.");
            string[] missingParams = [];
            if (refreshToken == null) {
                missingParams.push("refreshToken");
            }
            if (userRole == null) {
                missingParams.push("userRole");
            }
            response.setPayload({"missingParameters": missingParams});
            return caller->respond(response);
        }
        // Prepare the request body for the token endpoint
        http:RequestMessage requestBody = {
            "client_id": clientId,
            "client_secret": clientSecret,
            "grant_type": "refresh_token",
            "refresh_token": refreshToken
        };

        json|error dummyResponse = check googleClient->/token.post(requestBody, mediaType = mime:APPLICATION_FORM_URLENCODED);

        if dummyResponse is json {
            string accessToken = check dummyResponse.access_token;
            string idToken = check dummyResponse.id_token;

            stream<datasource:AuthCredentials, persist:Error?> authStream = dbClient->/authcredentials();
            int[] credId = check from datasource:AuthCredentials cred in authStream
                where cred.refreshToken == refreshToken
                select cred.credId;
            int credentialId = credId[0];
            _ = check dbClient->/authcredentials/[credentialId].put({accessToken: accessToken, idToken: idToken});

            json responseJson = {
                "access_token": accessToken,
                "refresh_token": refreshToken
            };
            response.setHeader("message", http:OK.toString());
            response.setPayload(responseJson);
            return caller->respond(response);
        } else {
            response.setHeader("error", "Invalid Refresh Token");
            response.setPayload({"Invalid Refresh Token": "You may request a new pair of tokens using either refresh token or access token"});
            return caller->respond(response);
        }
    }

    resource function post revoke(http:Caller caller, http:Request req) returns http:ListenerError?|error {
        //TODO: 
    }
}

function decodeAccessToken(string accessToken) returns json|error {
    string url = "/tokeninfo?access_token=" + accessToken;
    http:Response response = check googleClient->get(url);
    if (response.statusCode == 200) {
        json responseBody = check response.getJsonPayload();
        return responseBody;
    } else {
        io:println("Failed to retrieve token info. Status Code: " + response.statusCode.toString(), response.getJsonPayload());
    }
}

function sendOnboardingEmails(string firstName, string emailBody, string email) {
    string htmlContent = string `<html>
    <head>
        <title>Welcome to Edu-App</title>
    </head>
    <body>
        <img src="cid:eduLogo" alt="Company Logo">
        <p>Dear ${firstName},</p>
        <p>${emailBody}</p>
        <p>Best Regards,</p>
        <p>${companyName}</p>
    </body>
    </html>`;

    gmail:MessageRequest message = {
        to: [email],
        subject: "Welcome to Edu-App!",
        bodyInHtml: htmlContent,
        inlineImages: [
            {
                contentId: "eduLogo",
                mimeType: "image/jpg",
                name: "eduAppLogo.jpg",
                path: "resources/images/edu-app-logo.jpg"
            }
        ]
    };
    gmail:Message|error sendResult = gmail->/users/me/messages/send.post(message);
    io:println(sendResult);
}

function addAuthCredentials(string userRole, string accessToken, string refreshToken1, string idToken) returns int|persist:Error {
    datasource:AuthCredentialsInsert credentials = {
        "userRole": userRole,
        "accessToken": accessToken,
        "refreshToken": refreshToken,
        "idToken": "idToken"
    };
    int[] credId = check dbClient->/authcredentials.post([credentials]);
    return credId[0];
}

function decodeIdToken(string idToken) returns json|error {
    string url = "/tokeninfo?id_token=" + idToken;
    http:Response response = check googleClient->get(url);
    if (response.statusCode == 200) {
        json responseBody = check response.getJsonPayload();
        return responseBody;
    } else {
        io:println("Failed to retrieve token info. Status Code: " + response.statusCode.toString(), response.getJsonPayload());
    }
}

