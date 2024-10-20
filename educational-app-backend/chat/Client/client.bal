import ballerina/io;
import ballerina/websocket;
import ballerina/http;
import ballerina/sql;
import ballerinax/mysql;
import ballerinax/mysql.driver as _;

type Book record {|
int booking_id;
int session_id;
int student_id;
string booking_status;
int tutor_id;
|};

@http:ServiceConfig {
    cors: {
        allowOrigins: ["http://localhost:3000"],
        allowCredentials: false,
        allowHeaders: ["CORELATION_ID"],
        exposeHeaders: ["X-CUSTOM-HEADER"],
        maxAge: 84900
    }
}

service /chat on new http:Listener(8090) {
    private final mysql:Client db;
    function init() returns error? {
        // Initialize MySQL client
        self.db = check new (host = "localhost", user = "root", password = "Asdf1234@", database = "tutoring", port = 3306);
    }

    resource function get teacher/[string student_id]() returns Book[]|error {
        stream<Book, sql:Error?> bookings =self.db->query(`SELECT * FROM tutoring.bookings WHERE student_id = ${student_id}`);
        return from Book b in bookings
            select b;
    }

    resource function get student/[string tutor_id]() returns Book[]|error {
        stream<Book, sql:Error?> bookings =self.db->query(`SELECT * FROM tutoring.bookings WHERE student_id = ${tutor_id}`);
        return from Book b in bookings
            select b;
    }

    resource function post student/startChat/[int tutor_id]/[int student_id]() returns string|error {
        //check ChatStudent(tutor_id, student_id);// this is no use connect with server using frontend directly
        return "ws://localhost:9090/chat/student"+tutor_id.toString()+student_id.toString();
    }
    resource function post teacher/startChat/[int tutor_id]/[int student_id]() returns string|error {
        //check ChatTeacher(tutor_id, student_id);// this is no use connect with server using frontend directly
        return "ws://localhost:9090/chat/teacher"+tutor_id.toString()+student_id.toString();
    }

}


public function main() returns error? {
    
   
}

function messaging(websocket:Client chatClient) returns error? {
    io:println("Enter 'exit' to close the connection.");
    worker readWorker returns error? {
        while true {
            string textResp = check chatClient->readMessage();
            io:println("Received: ", textResp);
        }
    }
    worker writeWorker returns error? {
        while true {
            string msg = io:readln("");
            if (msg == "exit") {
                check chatClient->close();
                return;
            } else {
                check chatClient->writeMessage(msg);
            }
        }
    }
}

// function  ChatStudent(int tutor_id, int student_id) returns error? {
//     // Create a new WebSocket client.
//     string s_id=student_id.toString();
//     string t_id=tutor_id.toString();
//     string url="ws://localhost:9090/chat/student/"+t_id+"/"+s_id;
//     websocket:Client chatClient = check new (url);
//     string message = check chatClient->readMessage();
//     string message2 = check chatClient->readMessage();
//     io:println(message);
//     io:println(message2);
//     //_= check messaging(chatClient);
//     while true {
//             string textResp = check chatClient->readMessage();
//             string msg = io:readln("");
//             if (msg == "exit") {
//                 check chatClient->close();
//                 return;
//             } else {
//                 io:println("Received: ", textResp);
//                 check chatClient->writeMessage(msg);
                
//             }
//         }
// }

// function  ChatTeacher(int tutor_id, int student_id) returns error? {
//     // Create a new WebSocket client.
//     string s_id=student_id.toString();
//     string t_id=tutor_id.toString();
//     string url="ws://localhost:9090/chat/teacher/"+t_id+"/"+s_id;
//     websocket:Client chatClient = check new (url);
//     string message = check chatClient->readMessage();
//     string message2 = check chatClient->readMessage();
//     io:println(message);
//     io:println(message2);
//     //_= check messaging(chatClient);
//     while true {
//             string textResp = check chatClient->readMessage();
            
//             string msg = io:readln("");
//             if (msg == "exit") {
//                 check chatClient->close();
//                 return;
//             } else {
//                 io:println("Received: ", textResp);
//                 check chatClient->writeMessage(msg);
                
//             }
//         }
// }

