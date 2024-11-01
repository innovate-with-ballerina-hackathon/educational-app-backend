import educational_app_backend.datasource;

import ballerina/log;
import ballerina/persist;
import ballerinax/googleapis.gmail;
import ballerinax/kafka;
import ballerina/mime;

configurable string kafkaGroupId = ?;
configurable string kafkaTopic = ?;

listener kafka:Listener kafkaListener = new (kafka:DEFAULT_URL, {
    groupId: kafkaGroupId,
    topics: kafkaTopic
});
service on kafkaListener {
    final gmail:Client|error gmail;

    function init() returns error? {
        self.gmail = trap new ({
            auth: {
                clientId,
                clientSecret,
                refreshToken
            }
        });
    }

    remote function onConsumerRecord(datasource:Document[] documents) returns error? {
        gmail:Client|error gmail = self.gmail;
        if gmail is error {
            log:printError("Error initializing gmail client: " + gmail.message());
            return;
        }
        foreach datasource:Document document in documents {
            datasource:Category category = document.category;
            stream<datasource:Student, persist:Error?> studentStream = dbClient->/students();
            string[] emailArray = check from datasource:Student student in studentStream
                where student.subscribedCategory == category
                select student.email;
            foreach string email in emailArray {
                error? send = sendSubscriptionEmail(gmail, email, document);
                if send is error {
                    log:printError("Error sending email to: " + email);
                }
            }
        }
    }

    function sendMail(gmail:Client gmail, string body, string recipientEmail) returns error? {
        gmail:MessageRequest message = {
            to: [recipientEmail],
            subject: "New Movies Released",
            bodyInHtml: string `<html>
                                    <head>
                                        <title>New Releases</title>
                                        <body>${body}</body>
                                    </head>
                                </html>`
        };
        _ = check gmail->/users/me/messages/send.post(message);
    }
}

function sendSubscriptionEmail(gmail:Client gmail, string email, datasource:Document document) returns error? {
    gmail:AttachmentFile attachmentFile= {
        mimeType: mime:APPLICATION_PDF,
        name: "File.pdf",
        path: "./local/" + document.fileName
    };
    
    datasource:Tutor tutor = check dbClient->/tutors/[document.tutorTutorId];
    gmail:MessageRequest message = {
        to: [email],
        subject: "New Document Released - " + document.category,
        bodyInHtml: string `<html>
                                    <head>
                                        <title>New Releases</title>
                                        <body>
                                            <p>Hi there!</p>
                                            <p>We wanted to inform you that a new document titled "${document.title}" has been uploaded by ${tutor.firstName} ${tutor.lastName}.</p>
                                            <p>Document Title: ${document.title}</p>
                                            <p>Category: ${document.category}</p>
                                            <p>Document Description: ${document.description}</p>
                                            <p>You can access this document in the ${document.category} section of your learning portal.</p>
                                            <p>If you have any questions, feel free to reach out to ${tutor.email} or check the learning resources section for more details</p>
                                            <p>Best Regards,</p>
                                            <p>${companyName} Team</p>
                                        </body>
                                    </head>
                                </html>`,
        attachments: [attachmentFile]
    };
    _ = check gmail->/users/me/messages/send.post(message);

}
