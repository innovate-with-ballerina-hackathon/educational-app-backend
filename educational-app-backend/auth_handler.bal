import educational_app_backend.datasource;

import ballerina/http;
import ballerina/io;
import ballerina/persist;
import ballerinax/googleapis.gmail;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;

string companyName = "Edu-App";

http:Client googleClient = check new ("https://oauth2.googleapis.com");

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
    private final datasource:Client dbClient;

    function init() returns error? {
        self.dbClient = check new ();
    }

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

        stream<datasource:Subject, persist:Error?> subjectStream = self.dbClient->/subjects();
        int[] subId = check from datasource:Subject sub in subjectStream
            where sub.name == subject
            select sub.subjectId;

        int subjectId = subId[0];

        // Prepare the request body for the token endpoint
        http:RequestMessage requestBody = {
            "client_id": clientId,
            "client_secret": clientSecret,
            "code": authorizationCode,
            "grant_type": "authorization_code",
            "redirect_uri": redirectUri
        };

        map<string|string[]>? headers = {
            "Content-Type": "application/x-www-form-urlencoded"
        };

        // FIXME:
        //json|error dummyResponse = check googleClient->/token.post(requestBody, headers);
        //io:print(dummyResponse);
        json dummyResponse =
        {
            "access_token": "ya29.a0AcM612yWg6O6aa1Iq4dDpqtZMdw9RfJ33C3mVRg7RaUL7jHtzKnh8PvQsg926Pr9pdi664aYbNUu7K9qPoSg6ipDgXEvX4EbKaxYvbOGEtrRS1yai6C3F19ORJgF_vDTkP23E6A-bU_SY-5PJDl-oPuRfIC9UpycjGaKLnH7aCgYKAWoSARISFQHGX2MiU9pRVBgLCwbllAOl7u4dPQ0175",
            "expires_in": 3599,
            "scope": "https://www.googleapis.com/auth/gmail.addons.current.message.action https://www.googleapis.com/auth/gmail.settings.basic https://www.googleapis.com/auth/gmail.addons.current.action.compose https://www.googleapis.com/auth/gmail.settings.sharing https://www.googleapis.com/auth/userinfo.email https://mail.google.com/ https://www.googleapis.com/auth/gmail.insert https://www.googleapis.com/auth/gmail.labels https://www.googleapis.com/auth/gmail.modify https://www.googleapis.com/auth/gmail.readonly https://www.googleapis.com/auth/gmail.compose https://www.googleapis.com/auth/gmail.send https://www.googleapis.com/auth/userinfo.profile https://www.googleapis.com/auth/gmail.addons.current.message.metadata https://www.googleapis.com/auth/gmail.addons.current.message.readonly openid",
            "token_type": "Bearer",
            "refresh_token": "1//041YTZLinpExoCgYIARAAGAQSNwF-L9Ir_k5WKInZY6Rj8J_op5j8EnSYj-p0PwFtssnnYmJ_An9r_0iL8gEMFIHtvnVNssI1L4A",
            "id_token": "eyJhbGciOiJSUzI1NiIsImtpZCI6ImE1MGY2ZTcwZWY0YjU0OGE1ZmQ5MTQyZWVjZDFmYjhmNTRkY2U5ZWUiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiIyMjI4OTU5NTg3MzYtOGsxcG5jN2pxOXFxajdkMzZoMnRhNnJvdjI0ZTE1Y3AuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdWQiOiIyMjI4OTU5NTg3MzYtOGsxcG5jN2pxOXFxajdkMzZoMnRhNnJvdjI0ZTE1Y3AuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMDQxNTM5MjU1MDYyMTY0NTcwOTYiLCJlbWFpbCI6ImhpbWFuc2hpcG9kaW5pLjIwMDBAZ21haWwuY29tIiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImF0X2hhc2giOiJuMDJVVHV4M2dSS3RRSXl2S3RXSl9nIiwibmFtZSI6IkhpbWFuc2hpIERlIFNpbHZhIiwicGljdHVyZSI6Imh0dHBzOi8vbGgzLmdvb2dsZXVzZXJjb250ZW50LmNvbS9hL0FDZzhvY0oycWJPRU5HaU9QX2ZKRGkzMFBRSzgwWmhCNXYtSHlSR0QxZWNMTVZTb3V5Q0lDT2EyPXM5Ni1jIiwiZ2l2ZW5fbmFtZSI6IkhpbWFuc2hpIiwiZmFtaWx5X25hbWUiOiJEZSBTaWx2YSIsImlhdCI6MTcyODg0NDk5NiwiZXhwIjoxNzI4ODQ4NTk2fQ.YIrrR8rT2-n7_v026arl_7p0uU22kvhsnD314bIQ1I6kFFG3ug7dbsXOvzmm5Y_lBehfHBc25RvwIy0C3VBTycE8FXdox857T594A6eJPCmNPQc0uEBdSpxbVZktFapPPrQkJ21iBktEfC7nDKpTff77Gb5n435fN8NbaHUvNyWYr6ew3D8P2_1PfnsglHXUDkj-a2O_sMC_poiJVwdS3sHexXBN8wAVP0NffSQm1m--8oVwKslzHhoiHXzkyR3vSncTz9zoo_9DkL-P3LhvG6AUxNkGB2FLQ_KLi9wn3ixkx7tw2z1cT55dgmkv1VtE3ZOHVw2gomwX9gJBHorL7g"
        };

        if (dummyResponse is json) {
            string accessToken = check dummyResponse.access_token;
            string refreshToken = check dummyResponse.refresh_token;
            string idToken = check dummyResponse.id_token;

            json decodedIdToken = check decodeIdToken(idToken);

            // Extract user information
            string firstName = check decodedIdToken.given_name;
            string lastName = check decodedIdToken.family_name;
            string email = check decodedIdToken.email;

            if userRole == "student" {
                datasource:AuthCredentialsInsert credentials = {
                    "userRole": userRole,
                    "accessToken": accessToken,
                    "refreshToken": refreshToken,
                    "idToken": "idToken"
                };
                int[] credId = check self.dbClient->/authcredentials.post([credentials]);
                int credentialId = credId[0];

                datasource:StudentInsert student = {
                    "firstName": firstName,
                    "lastName": lastName,
                    "email": email,
                    "credentialsCredId": credentialId
                };
                int[]|persist:Error result = self.dbClient->/students.post([student]);
                if result is persist:Error {
                    if result is persist:AlreadyExistsError {
                        response.setHeader("message", http:CONFLICT.toString() + "User Already Exists");
                    }
                    response.setHeader("message", http:INTERNAL_SERVER_ERROR.toString() + "Internal Server Error Occured");
                } else {
                    response.setHeader("message", http:OK.toString() + "User Created Successfully");

                    string htmlContent = string `<html>
    <head>
        <title>Welcome to Edu-App</title>
    </head>
    <body>
        <img src="cid:eduLogo" alt="Company Logo">
        <p>Dear ${firstName},</p>
        <p>Welcome to Edu-App! We're excited to have you onboard. Start exploring and connecting with expert tutors to reach your learning goals today!</p>
        <p>Best Regards,</p>
        <p>${companyName}</p>
    </body>
    </html>`;

                    gmail:MessageRequest message = {
                        to: [email],
                        subject: "Welcome to Edu-App! Start Your Learning Journey Today",
                        bodyInHtml: htmlContent,
                        inlineImages: [
                            {
                                contentId: "eduLogo",
                                mimeType: "image/jpg",
                                name: "eduAppLogo.jpg",
                                path: "resources/edu-app-logo.jpg"
                            }
                        ]
                    };

                    gmail:Message sendResult = check gmail->/users/[email]/messages/send.post(message);
                    io:println("Email sent. Message ID: " + sendResult.id);
                }

            } else {
                datasource:AuthCredentialsInsert credentials = {
                    "userRole": userRole,
                    "accessToken": accessToken,
                    "refreshToken": refreshToken,
                    "idToken": idToken
                };
                int[] credId = check self.dbClient->/authcredentials.post([credentials]);
                int credentialId = credId[0];

                datasource:TutorInsert tutor = {
                    "firstName": firstName,
                    "lastName": lastName,
                    "email": email,
                    "experienceYears": 0,
                    "price": 0,
                    "credentialsCredId": credentialId,
                    "subjectSubjectId": subjectId
                };
                int[]|persist:Error result = self.dbClient->/tutors.post([tutor]);
                if result is persist:Error {
                    if result is persist:AlreadyExistsError {
                        response.setHeader("message", http:CONFLICT.toString() + "User Already Exists");
                    }
                    response.setHeader("message", http:INTERNAL_SERVER_ERROR.toString() + "Internal Server Error Occured");
                } else {
                    response.setHeader("message", http:OK.toString() + "User Created Successfully");

                    string htmlContent = string `<html>
    <head>
        <title>Welcome to Edu-App</title>
    </head>
    <body>
        <img src="cid:eduLogo" alt="Company Logo">
        <p>Dear ${firstName},</p>
        <p>Welcome to Edu-App! We're thrilled to have you join our community of educators. Get ready to share your expertise and help students succeed!</p>
        <p>Best Regards,</p>
        <p>${companyName}</p>
    </body>
    </html>`;

                    gmail:MessageRequest message = {
                        to: [email],
                        subject: "Welcome to Edu-App! Ready to Inspire and Teach?",
                        bodyInHtml: htmlContent,
                        inlineImages: [
                            {
                                contentId: "eduLogo",
                                mimeType: "image/jpg",
                                name: "eduAppLogo.jpg",
                                path: "resources/edu-app-logo.jpg"
                            }
                        ]
                    };

                    gmail:Message sendResult = check gmail->/users/[email]/messages/send.post(message);
                    io:println("Email sent. Message ID: " + sendResult.id);
                }
            }

            json responseJson = {
                "access_token": accessToken,
                "refresh_token": refreshToken
            };
            response.setPayload(responseJson);
            return caller->respond(response);
        } else {
            // TODO: handle the expired access token
        }
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

        map<string|string[]>? headers = {
            "Content-Type": "application/x-www-form-urlencoded"
        };

        // FIXME:
        json|error dummyResponse = check googleClient->/token.post(requestBody, headers);

        if dummyResponse is json {
            string accessToken = check dummyResponse.access_token;
            string idToken = check dummyResponse.id_token;

            stream<datasource:AuthCredentials, persist:Error?> authStream = self.dbClient->/authcredentials();
            int[] credId = check from datasource:AuthCredentials cred in authStream
                where cred.refreshToken == refreshToken
                select cred.credId;

            // TODO: extract credID from the array, suitable data type to store id_token             
            int credentialId = credId[0];
            _ = check self.dbClient->/authcredentials/[credentialId].put({accessToken: accessToken, idToken: idToken});

            json responseJson = {
                "access_token": accessToken,
                "refresh_token": refreshToken
            };
            response.setHeader("message", http:OK.toString());
            response.setPayload(responseJson);
            return caller->respond(response);
        } else {
            //TODO: handle expired refresh token
        }
    }

    resource function post revoke(http:Caller caller, http:Request req) returns http:ListenerError?|error {
        //TODO: 
    }
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

