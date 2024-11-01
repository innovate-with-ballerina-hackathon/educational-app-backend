import educational_app_backend.datasource;

import ballerina/ftp;
import ballerina/log;
import ballerinax/kafka;
import ballerina/persist;

listener ftp:Listener fileListener = new ({
    host: "localhost",
    auth: {
        credentials: {
            username: "one",
            password: "12345678"
        }
    },
    path: "/home/in",
    fileNamePattern: "(.*).pdf"
});

service on fileListener {
    final kafka:Producer producer;

    function init() returns error? {
        self.producer = check new (kafka:DEFAULT_URL);
    }
    remote function onFileChange(ftp:WatchEvent & readonly event, ftp:Caller caller) returns error? {
        foreach ftp:FileInfo addedFile in event.addedFiles {
            log:printInfo(string `New Document has been uploaded: ${addedFile.name}`);
            stream<datasource:Document, persist:Error?> documentStream = dbClient->/documents();
            datasource:Document[] documents = check from datasource:Document document in documentStream
            where document.fileName == addedFile.name select document;
            foreach datasource:Document document in documents {
                //datasource:Category category = document.category;
                return check self.producer->send({
                topic: kafkaTopic,
                value: {
                    id : document.id,
                    fileName : document.fileName,
                    title : document.title,
                    description : document.description,
                    category : document.category,
                    tutorTutorId : document.tutorTutorId
                }
            });
            }
        }
    }
}

               

                
// function sendSubscriptionEmail(string email, datasource:Document document) {
//     string htmlContent = string `<html>
//     <head>
//         <title>Welcome to Edu-App</title>
//     </head>
//     <body>
//         <img src="cid:eduLogo" alt="Company Logo">
//         <p>Dear ${firstName},</p>
//         <p>${emailBody}</p>
//         <p>Best Regards,</p>
//         <p>${companyName}</p>
//     </body>
//     </html>`;

//     gmail:MessageRequest message = {
//         to: [email],
//         subject: "Welcome to Edu-App!",
//         bodyInHtml: htmlContent,
//         inlineImages: [
//             {
//                 contentId: "eduLogo",
//                 mimeType: "image/jpg",
//                 name: "eduAppLogo.jpg",
//                 path: "resources/images/edu-app-logo.jpg"
//             }
//         ]
//     };
//     gmail:Message|error sendResult = gmail->/users/me/messages/send.post(message);
//     io:println(sendResult);
    
// }