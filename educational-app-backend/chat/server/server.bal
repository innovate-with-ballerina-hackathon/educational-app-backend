import ballerina/io;
import ballerina/websocket;
import ballerina/sql;
import ballerinax/mysql;
import ballerinax/mysql.driver as _;
map<websocket:Caller> connectionsMap = {};

// Define constant keys for storing IDs as attributes in the WebSocket session.
const string TUTOR_ID_KEY = "tutor_id";
const string STUDENT_ID_KEY = "student_id";

type MessageRead record {|
    int id;
    int sender_id;
    int receiver_id;
    string message;
    string timestamp;
    string sender_type;
    string receiver_type;
|};

type MessageWrite record {|
    int sender_id;
    int receiver_id;
    string message;
    string timestamp;
    string sender_type;
    string receiver_type;
|};
listener websocket:Listener Chat = new websocket:Listener(9090);
service /chat/student on Chat {
    private final mysql:Client db;
    function init() returns error? {
        // Initialize MySQL client
        self.db = check new (host = "localhost", user = "root", password = "Asdf1234@", database = "tutoring", port = 3306);
    }
    
    // Resource to create WebSocket connections for a specific tutor and student pair.
    resource function get [int tutor_id]/[int student_id]() returns websocket:Service|websocket:UpgradeError {
        // Return a new service for each connection, tied to the specific tutor and student.
        string previous_messages = "";
       stream<MessageRead, sql:Error?> messages = self.db->query(`SELECT * FROM tutoring.messages WHERE (sender_id = ${tutor_id} AND receiver_id = ${student_id}) OR (sender_id = ${student_id} AND receiver_id = ${tutor_id});`);
        MessageRead[]|error messages_arr = from MessageRead s in messages
                             select s;
        if messages_arr is MessageRead[] {
            foreach var message in messages_arr {
                previous_messages = previous_messages + message.message + "\n";
            }
        }
        return new ChatServerforStudent(tutor_id, student_id, previous_messages,self.db);
    }
}

service /chat/teacher on Chat {
    private final mysql:Client db;
    function init() returns error? {
        // Initialize MySQL client
        self.db = check new (host = "localhost", user = "root", password = "Asdf1234@", database = "tutoring", port = 3306);
    }
    
    // Resource to create WebSocket connections for a specific tutor and student pair.
    resource function get [int tutor_id]/[int student_id]() returns websocket:Service|websocket:UpgradeError {
        // Return a new service for each connection, tied to the specific tutor and student.
        string previous_messages = "";
       stream<MessageRead, sql:Error?> messages = self.db->query(`SELECT * FROM tutoring.messages WHERE (sender_id = ${tutor_id} AND receiver_id = ${student_id}) OR (sender_id = ${student_id} AND receiver_id = ${tutor_id});`);
        MessageRead[]|error messages_arr = from MessageRead s in messages
                             select s;
        if messages_arr is MessageRead[] {
            foreach var message in messages_arr {
                previous_messages = previous_messages + message.message + "\n";
            }
        }
        return new ChatServerforTeacher(tutor_id, student_id, previous_messages,self.db);
    }
}

service class ChatServerforStudent {
    *websocket:Service;

    int tutor_id;
    int student_id;
    string previous_messages;
    mysql:Client db;
    public function init(int tutor_id, int student_id, string previous_messages, mysql:Client db) {
        self.tutor_id = tutor_id;
        self.student_id = student_id;
        self.previous_messages = previous_messages;
        self.db = db;
        
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
            connectionsMap[getConnectionKey(self.tutor_id, self.student_id,"student")] = caller;
        }

        // Notify the tutor and student that the connection is established.
        string msg = "Tutor " + self.tutor_id.toString() + " and Student " + self.student_id.toString() + " have joined the chat.";
        io:println(msg);
    }

    // When a message is received on the WebSocket connection.
    // When a message is received from the student, route it to the tutor.
remote function onMessage(websocket:Caller caller, string text) returns error? {
    string msg = "Message from Student " + self.student_id.toString() + " to Tutor " + self.tutor_id.toString() + ": " + text;

    // Store the message in the database
    MessageWrite message = {
        sender_id: self.student_id,
        receiver_id: self.tutor_id,
        message: text,
        timestamp: "2021-09-01 12:00:00", // Timestamp should be dynamically generated
        sender_type: "students",
        receiver_type: "tutors"
    };
    _ = check self.db->execute(`INSERT INTO tutoring.messages (sender_id,receiver_id,message,timestamp, sender_type,receiver_type) VALUES (${message.sender_id}, ${message.receiver_id}, ${message.message}, ${message.timestamp}, ${message.sender_type}, ${message.receiver_type});`);

    io:println(msg);  // Log the message.

    // Send the message to the relevant tutor
    check sendMessageToRelevantTeacher(self.tutor_id, self.student_id, text,"teacher");
}


    // When the WebSocket connection is closed.
    remote function onClose(websocket:Caller caller, int statusCode, string reason) returns error? {
        lock {
            _ = connectionsMap.remove(getConnectionKey(self.tutor_id, self.student_id,"student"));
        }
        string tutor = check getUsername(caller, TUTOR_ID_KEY);
        string student = check getUsername(caller, STUDENT_ID_KEY);
        string msg =  student + " left the chat.";
        
        io:println(msg);  // Log the disconnect.
    }
}

service class ChatServerforTeacher {
    *websocket:Service;

    int tutor_id;
    int student_id;
    string previous_messages;
    mysql:Client db;
    public function init(int tutor_id, int student_id, string previous_messages, mysql:Client db) {
        self.tutor_id = tutor_id;
        self.student_id = student_id;
        self.previous_messages = previous_messages;
        self.db = db;
        
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
            connectionsMap[getConnectionKey(self.tutor_id, self.student_id,"teacher")] = caller;
        }

        // Notify the tutor and student that the connection is established.
        string msg = "Tutor " + self.tutor_id.toString() + " and Student " + self.student_id.toString() + " have joined the chat.";
        io:println(msg);
    }

    // When a message is received on the WebSocket connection.
    remote function onMessage(websocket:Caller caller, string text) returns error? {
    string msg = "Message from Tutor " + self.tutor_id.toString() + " to Student " + self.student_id.toString() + ": " + text;

    // Store the message in the database
    MessageWrite message = {
        sender_id: self.tutor_id,
        receiver_id: self.student_id,
        message: text,
        timestamp: "2021-09-01 12:00:00", // Timestamp should be dynamically generated
        sender_type: "tutors",
        receiver_type: "students"
    };
    _ = check self.db->execute(`INSERT INTO tutoring.messages (sender_id,receiver_id,message,timestamp, sender_type,receiver_type) VALUES (${message.sender_id}, ${message.receiver_id}, ${message.message}, ${message.timestamp}, ${message.sender_type}, ${message.receiver_type});`);

    io:println(msg);  // Log the message.

    // Send the message to the relevant student
    check sendMessageToRelevantStudent(self.tutor_id, self.student_id, text,"student");
}

    // When the WebSocket connection is closed.
    remote function onClose(websocket:Caller caller, int statusCode, string reason) returns error? {
        lock {
            _ = connectionsMap.remove(getConnectionKey(self.tutor_id, self.student_id,"teacher"));
        }
        string tutor = check getUsername(caller, TUTOR_ID_KEY);
        string student = check getUsername(caller, STUDENT_ID_KEY);
        string msg = "Tutor " + tutor + " and Student " + student + " left the chat.";
        
        io:println(msg);  // Log the disconnect.
    }
}

// Helper function to send messages only between the relevant tutor and student.
function sendMessageToRelevantParty(int tutor_id, int student_id, string text,string role) returns error? {
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
    if role == "teacher" {
        return "teacher_" + tutor_id.toString() + "_" + student_id.toString();
    } else if role == "student" {
        return "student_" + tutor_id.toString() + "_" + student_id.toString();
    }
    return "";
}


function getUsername(websocket:Caller caller, string key) returns string|error {
    return <string> check caller.getAttribute(key);
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

