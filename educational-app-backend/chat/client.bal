import ballerina/io;
import ballerina/websocket;
import ballerina/http;
import ballerina/sql;
import ballerinax/mysql;
import ballerinax/mysql.driver as _;

// type Book record {|
// int booking_id;
// int session_id;
// int student_id;
// string booking_status;
// int tutor_id;
// |};

type TutorNStudent record {|
int tutor_id;
int student_id;
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

    resource function get teacher/[string tutor_id]() returns TutorNStudent[]|error { //fetch students for the teacher
        stream<TutorNStudent, sql:Error?> pairs =self.db->query(`SELECT * FROM tutoring.tutornstudents WHERE tutor_id = ${tutor_id}`);
        return from TutorNStudent b in pairs
            select b;
    }

    resource function get student/[string student_id]() returns TutorNStudent[]|error { //fetch teachers for the student
        stream<TutorNStudent, sql:Error?> pairs =self.db->query(`SELECT * FROM tutoring.tutornstudents WHERE student_id = ${student_id}`);
        return from TutorNStudent b in pairs
            select b;
    }

    // resource function post student/startChat/[int tutor_id]/[int student_id]() returns string|error {
    //     //check ChatStudent(tutor_id, student_id);// this is no use connect with server using frontend directly
    //     return "ws://localhost:9090/chat/student"+tutor_id.toString()+student_id.toString();
    // }
    // resource function post teacher/startChat/[int tutor_id]/[int student_id]() returns string|error {
    //     //check ChatTeacher(tutor_id, student_id);// this is no use connect with server using frontend directly
    //     return "ws://localhost:9090/chat/teacher"+tutor_id.toString()+student_id.toString();
    // }

}
