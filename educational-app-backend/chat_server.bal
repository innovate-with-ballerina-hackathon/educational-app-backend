import educational_app_backend.datasource;

import ballerina/io;
import ballerina/persist;
import ballerina/time;
import ballerina/websocket;

map<websocket:Caller> connectionsMap = {};

// Define constant keys for storing IDs as attributes in the WebSocket session.
const string TUTOR_ID_KEY = "tutor_id";
const string STUDENT_ID_KEY = "student_id";

listener websocket:Listener Chat = new websocket:Listener(9096);

service /chat/student on Chat {

    // Resource to create WebSocket connections for a specific tutor and student pair.
    resource function get [int tutor_id]/[int student_id]() returns websocket:Service|websocket:UpgradeError {
        // Return a new service for each connection, tied to the specific tutor and student.
        string previous_messages = "";
        stream<datasource:Message, persist:Error?> messageStream = dbClient->/messages();
        if messageStream is stream<datasource:Message> {
            datasource:Message[] messages = from datasource:Message message in messageStream
                where message.senderId == student_id && message.receiverId == tutor_id ||
                message.senderId == tutor_id && message.receiverId == student_id
                select message;

            if messages is datasource:Message[] {
                foreach var message in messages {
                    previous_messages = previous_messages + message.message + "\n";
                }
            }
            return new ChatServerforStudent(tutor_id, student_id, previous_messages);
        }
        return error("Error creating the chat service");
    }
}

service /chat/tutor on Chat {

    // Resource to create WebSocket connections for a specific tutor and student pair.
    resource function get [int tutor_id]/[int student_id]() returns websocket:Service|websocket:UpgradeError {
        // Return a new service for each connection, tied to the specific tutor and student.
        string previous_messages = "";
        stream<datasource:Message, persist:Error?> messageStream = dbClient->/messages();
        if messageStream is stream<datasource:Message> {
            datasource:Message[] messages = from datasource:Message message in messageStream
                where message.senderId == student_id && message.receiverId == tutor_id ||
                message.senderId == tutor_id && message.receiverId == student_id
                select message;

            if messages is datasource:Message[] {
                foreach var message in messages {
                    previous_messages = previous_messages + message.message + "\n";
                }
            }
            return new ChatServerforTeacher(tutor_id, student_id, previous_messages);
        }
        return error("Error creating the chat service");
    }
}

service class ChatServerforStudent {
    *websocket:Service;

    int tutor_id;
    int student_id;
    string previous_messages;

    public function init(int tutor_id, int student_id, string previous_messages) {
        self.tutor_id = tutor_id;
        self.student_id = student_id;
        self.previous_messages = previous_messages;

    }

    // When a new WebSocket connection is opened.
    remote function onOpen(websocket:Caller caller) returns error? {
        // Welcome message when connection is established.
        string welcomeMsg = "Hi! You have successfully connected to the chat between Tutor "
                            + self.tutor_id.toString() + " and Student " + self.student_id.toString();
        check caller->writeMessage(welcomeMsg);
        check caller->writeMessage("Previous messages:\n" + self.previous_messages);
        // Store the tutor_id and student_id as attributes on the WebSocket session.
        caller.setAttribute(TUTOR_ID_KEY, self.tutor_id.toString());
        caller.setAttribute(STUDENT_ID_KEY, self.student_id.toString());

        // Add the WebSocket connection to the map using a unique key based on tutor and student IDs.
        lock {
            connectionsMap[getConnectionKey(self.tutor_id, self.student_id, "student")] = caller;
        }

        // Notify the tutor and student that the connection is established.
        string msg = "Student " + self.student_id.toString() + " have joined the chat.";
        io:println(msg);
    }

    // When a message is received on the WebSocket connection.
    // When a message is received from the student, route it to the tutor.
    remote function onMessage(websocket:Caller caller, string text) returns error?{
        string msg = "Message from Student " + self.student_id.toString() + " to Tutor " + self.tutor_id.toString() + ": " + text;
        time:Utc currentUtc = time:utcNow();
        // Store the message in the database

        _ = check dbClient->/messages.post([
            {
                senderId: self.student_id,
                receiverId: self.tutor_id,
                message: text,
                timeStamp: currentUtc,
                senderType: "student",
                receiverType: "tutor"
            }
        ]);

        io:println(msg); // Log the message.

        // Send the message to the relevant tutor
        check sendMessageToRelevantTeacher(self.tutor_id, self.student_id, text, "tutor");
    }

    // When the WebSocket connection is closed.
    remote function onClose(websocket:Caller caller, int statusCode, string reason) returns error? {
        lock {
            _ = connectionsMap.remove(getConnectionKey(self.tutor_id, self.student_id, "student"));
        }
        //string tutor = check getUsername(caller, TUTOR_ID_KEY);
        string student = check getUsername(caller, STUDENT_ID_KEY);
        string msg = student + " left the chat.";

        io:println(msg); // Log the disconnect.
    }
}

service class ChatServerforTeacher {
    *websocket:Service;

    int tutor_id;
    int student_id;
    string previous_messages;

    public function init(int tutor_id, int student_id, string previous_messages) {
        self.tutor_id = tutor_id;
        self.student_id = student_id;
        self.previous_messages = previous_messages;

    }

    // When a new WebSocket connection is opened.
    remote function onOpen(websocket:Caller caller) returns error? {
        // Welcome message when connection is established.
        string welcomeMsg = "Hi! You have successfully connected to the chat between Tutor "
                            + self.tutor_id.toString() + " and Student " + self.student_id.toString();
        check caller->writeMessage(welcomeMsg);
        check caller->writeMessage("Previous messages:\n" + self.previous_messages);
        // Store the tutor_id and student_id as attributes on the WebSocket session.
        caller.setAttribute(TUTOR_ID_KEY, self.tutor_id.toString());
        caller.setAttribute(STUDENT_ID_KEY, self.student_id.toString());

        // Add the WebSocket connection to the map using a unique key based on tutor and student IDs.
        lock {
            connectionsMap[getConnectionKey(self.tutor_id, self.student_id, "tutor")] = caller;
        }

        // Notify the tutor and student that the connection is established.
        string msg = "Tutor " + self.tutor_id.toString() + " and Student " + self.student_id.toString() + " have joined the chat.";
        io:println(msg);
    }

    // When a message is received on the WebSocket connection.
    remote function onMessage(websocket:Caller caller, string text) returns error? {
        string msg = "Message from Tutor " + self.tutor_id.toString() + " to Student " + self.student_id.toString() + ": " + text;
        time:Utc currentUtc = time:utcNow();
        // Store the message in the database
        
        _ = check dbClient->/messages.post([
            {
                senderId: self.tutor_id,
                receiverId: self.student_id,
                message: text,
                timeStamp: currentUtc,
                senderType: "tutor",
                receiverType: "student"
            }
        ]);

        io:println(msg); // Log the message.

        // Send the message to the relevant student
        check sendMessageToRelevantStudent(self.tutor_id, self.student_id, text, "student");
        
    }

    // When the WebSocket connection is closed.
    remote function onClose(websocket:Caller caller, int statusCode, string reason) returns error? {
        lock {
            _ = connectionsMap.remove(getConnectionKey(self.tutor_id, self.student_id, "tutor"));
        }
        string tutor = check getUsername(caller, TUTOR_ID_KEY);
        string student = check getUsername(caller, STUDENT_ID_KEY);
        string msg = "Tutor " + tutor + " and Student " + student + " left the chat.";

        io:println(msg); // Log the disconnect.
    }
}

// Helper function to send messages only between the relevant tutor and student.
function sendMessageToRelevantParty(int tutor_id, int student_id, string text, string role) returns error? {
    string connectionKey = getConnectionKey(tutor_id, student_id, role);
    websocket:Caller? relevantConnection = connectionsMap[connectionKey];

    if relevantConnection is websocket:Caller {
        // Send the message only to the relevant tutor-student pair.
        check relevantConnection->writeMessage(text);
    } else {
        io:println("No active connection for Tutor " + tutor_id.toString() + " and Student " + student_id.toString());
    }

    return;
}

function getConnectionKey(int tutor_id, int student_id, string role) returns string {
    if role == "tutor" {
        return "tutor" + tutor_id.toString() + "_" + student_id.toString();
    } else if role == "student" {
        return "student_" + tutor_id.toString() + "_" + student_id.toString();
    }
    return "";
}

function getUsername(websocket:Caller caller, string key) returns string|error {
    return <string>check caller.getAttribute(key);
}

// Send the message to the relevant student
function sendMessageToRelevantStudent(int tutor_id, int student_id, string text, string role) returns error? {
    string studentConnectionKey = getConnectionKey(tutor_id, student_id, role);
    websocket:Caller? studentConnection = connectionsMap[studentConnectionKey];

    if studentConnection is websocket:Caller {
        // Send the message only to the student
        check studentConnection->writeMessage(text);
    } else {
        io:println("No active connection for Student " + student_id.toString());
    }
}

// Send the message to the relevant teacher
function sendMessageToRelevantTeacher(int tutor_id, int student_id, string text, string role) returns error? {
    string tutorConnectionKey = getConnectionKey(tutor_id, student_id, role);
    websocket:Caller? tutorConnection = connectionsMap[tutorConnectionKey];

    if tutorConnection is websocket:Caller {
        // Send the message only to the tutor
        check tutorConnection->writeMessage(text);
    } else {
        io:println("No active connection for Tutor " + tutor_id.toString());
    }
}

