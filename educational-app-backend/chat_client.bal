import ballerina/http;
import ballerina/persist;
import educational_app_backend.datasource;


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

service /chat on new http:Listener(9095) {
    
    // resource function get teacher/[string tutor_id]() returns TutorNStudent[]|error { //fetch students for the teacher
    //     stream<TutorNStudent, sql:Error?> pairs =self.db->query(`SELECT * FROM tutoring.tutornstudents WHERE tutor_id = ${tutor_id}`);
    //     return from TutorNStudent b in pairs
    //         select b;
    // }

    resource function get tutor/[int tutorId]()  returns int[]|error {
        stream<datasource:TutorNStudent, persist:Error?> tutorNStudentIds = dbClient->/tutornstudents();
        return from datasource:TutorNStudent tutorNStudent in tutorNStudentIds
            where tutorNStudent.tutorTutorId == tutorId
            select tutorNStudent.studentStudentId;
        
    }
    // resource function get student/[string student_id]() returns TutorNStudent[]|error { //fetch teachers for the student
    //     stream<TutorNStudent, sql:Error?> pairs =self.db->query(`SELECT * FROM tutoring.tutornstudents WHERE student_id = ${student_id}`);
    //     return from TutorNStudent b in pairs
    //         select b;
    // }

    resource function get student/[int studentId]()  returns int[]|error {
        stream<datasource:TutorNStudent, persist:Error?> tutorNStudentIds = dbClient->/tutornstudents();
        return from datasource:TutorNStudent tutorNStudent in tutorNStudentIds
            where tutorNStudent.studentStudentId == studentId
            select tutorNStudent.tutorTutorId;
        
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
