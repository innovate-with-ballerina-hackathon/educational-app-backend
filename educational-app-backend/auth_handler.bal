import educational_app_backend.datasource;

import ballerina/http;
import ballerina/io;
import ballerina/persist;

configurable string GOOGLE_CLIENT_ID = ?;
configurable string GOOGLE_CLIENT_SECRET = ?;

http:Client googleClient = check new ("https://oauth2.googleapis.com");

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
            "client_id": GOOGLE_CLIENT_ID,
            "client_secret": GOOGLE_CLIENT_SECRET,
            "code": authorizationCode,
            "grant_type": "authorization_code",
            "redirect_uri": redirectUri
        };

        map<string|string[]>? headers = {
            "Content-Type": "application/x-www-form-urlencoded"
        };

        // FIXME:
        json|error dummyResponse = check googleClient->/token.post(requestBody, headers);
        io:print(dummyResponse);
        // json dummyResponse = {
        //     "access_token": "ya29.a0AcM612wfX9dyjnGM6ec6IMPHmoqBpfOi-QFdym_80U-06XqRh1-4n5X1PGvPGdwDhwkXLcI43MeO30IZZqY_eMgNxiK4aEx0m5XnA8TYq-spFyHb3sg-TBzy2VwKT-4WVgIBjTbKwALkpd1wqTpwo_ddz_fr7vZZUa3E6u5KaCgYKAQISARMSFQHGX2Miseqx02hwxftI2_VM0N6Zhw0175",
        //     "expires_in": 3599,
        //     "refresh_token": "1//0gqwqy9uagj5gCgYIARAAGBASNwF-L9IrWLXoNy87XnVeutRfPvK9NeUZYobZZbzdO8jQjgXj80VfSHFT8CatuPYh-kXlfPx8qtA",
        //     "scope": "https://www.googleapis.com/auth/drive.metadata.readonly",
        //     "token_type": "Bearer"
        // };

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
                    "userRole" : userRole,
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
                    "credentialsCredId" : credentialId
                };
                _ = check self.dbClient->/students.post([student]);

            } else {
                datasource:AuthCredentialsInsert credentials = {
                    "userRole" : userRole,
                    "accessToken": accessToken,
                    "refreshToken": refreshToken,
                    "idToken": "idToken"
                };
                int[] credId = check self.dbClient->/authcredentials.post([credentials]);
                int credentialId = credId[0];

                datasource:TutorInsert tutor = {
                    "firstName": firstName,
                    "lastName": lastName,
                    "email": email,
                    "experienceYears": 0,
                    "price": 0,
                    "credentialsCredId" : credentialId,
                    "subjectSubjectId": subjectId
                };
                _ = check self.dbClient->/tutors.post([tutor]);
            }

            json responseJson = {
                "access_token": accessToken,
                "refresh_token": refreshToken
            };
            response.setHeader("message", http:OK.toString());
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
            "client_id": GOOGLE_CLIENT_ID,
            "client_secret": GOOGLE_CLIENT_SECRET,
            "grant_type": "refresh_token",
            "refresh_token": refreshToken
        };

        map<string|string[]>? headers = {
            "Content-Type": "application/x-www-form-urlencoded"
        };

        // FIXME:
        json|error dummyResponse = check googleClient->/token.post(requestBody, headers);

        if dummyResponse is json{
            string accessToken = check dummyResponse.access_token;
            string idToken = check dummyResponse.id_token;

            stream<datasource:AuthCredentials, persist:Error?> authStream = self.dbClient->/authcredentials();
            int[] credId = check from datasource:AuthCredentials cred in authStream
             where cred.refreshToken == refreshToken select cred.credId;
            
            // TODO: extract credID from the array, suitable data type to store id_token             
            int credentialId = credId[0];
            _ = check self.dbClient->/authcredentials/[credentialId].put({accessToken : accessToken, idToken : "id_token"});

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

