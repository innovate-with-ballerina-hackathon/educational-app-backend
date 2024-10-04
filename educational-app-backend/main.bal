import educational_app_backend.datasource;

import ballerina/graphql;

datasource:Client dbClient = check new;

@graphql:ServiceConfig{
    graphiql: {
        enabled: true
    }
}

service on new graphql:Listener(9090) {

    resource function get tutors() returns Tutor[] | error {
        stream<datasource:Tutor, error?> tutorStream = dbClient->/tutors();
        return from datasource:Tutor t in tutorStream select new (t);
    }
    
}

service class Tutor {

    private final readonly & datasource:Tutor tutor;

    function init(datasource:Tutor tutor) {
        self.tutor = tutor.cloneReadOnly();  
    }
    resource function get id() returns @graphql:ID string => self.tutor.tutorId;

    resource function get firstName() returns string => self.tutor.firstName;

    resource function get lastName() returns string => self.tutor.lastName;

    resource function get experienceYears() returns int => self.tutor.experienceYears;
    resource function get subject() returns string | error {
        datasource:Subject subject = check dbClient->/subjects/[self.tutor.subjectsSubjectId];
        return subject.name;
    }
}

// public function main() returns error? {

//     //_ = check dbClient->/tutornstudents.post([connection1,connection2,connection3,connection4,connection5]);
//     //_ = check dbClient->/students.post([student1, student2, student3]);
//     // _ = check dbClient->/subjects.post([subject1,subject2]);
//     // _ = check dbClient->/tutors.post([tutor1, tutor2]);

//     stream<datasource:Tutor, error?> tutors = dbClient->/tutors();
//     datasource:Tutor[] tutorArr = check from datasource:Tutor t in tutors
//         select t;
//     io:print(tutorArr);

//     stream<datasource:Student, error?> students = dbClient->/students();
//     datasource:Student[] studentArr = check from datasource:Student s in students
//         select s;
//     io:print(studentArr);
// }
