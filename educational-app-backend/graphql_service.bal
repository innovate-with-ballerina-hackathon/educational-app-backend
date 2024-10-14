import educational_app_backend.datasource;

import ballerina/graphql;

@graphql:ServiceConfig {
    graphiql: {
        enabled: true
    },
    introspection: false,
    contextInit: initContext,
    cacheConfig: {
        enabled: true,
        maxSize: 200
    }
}

service on new graphql:Listener(9090) {

    @graphql:ResourceConfig {
        interceptors: new StudentAuthInterceptor()
    }
    resource function get tutors(string? subject, int? expYears, int? price) returns Tutor[]|error {
        stream<datasource:Tutor, error?> tutorStream = dbClient->/tutors();
        return from datasource:Tutor t in tutorStream
        where (subject is () || getSubject(t.subjectSubjectId) == subject) &&
        (expYears is () || t.experienceYears == expYears) && 
        (price is () || t.price == price)
            select new (t);
    }

    @graphql:ResourceConfig {
        interceptors: new StudentAuthInterceptor()
    }
    resource function get tutorById(int tutorId) returns Tutor | error {
        datasource:Tutor tutor = check dbClient->/tutors/[tutorId]();
        return new (tutor);
    }

    @graphql:ResourceConfig {
        interceptors: new StudentAuthInterceptor()
    }
    remote function addReview(graphql:Context context, ReviewInput reviewInput) returns Review|error {
        int userId = check getUserIdFromContext(context);
        datasource:ReviewInsert reviewInsert = {
            "studentStudentId" : userId,
            ...reviewInput
        };
        int[] review = check dbClient->/reviews.post([reviewInsert]);
        int reviewId = review[0];
        datasource:Review updatedReview = check dbClient->/reviews/[reviewId];
        check context.invalidate("reviews");
        return new (updatedReview);
    }


}

service class Tutor {

    private final readonly & datasource:Tutor tutor;

    function init(datasource:Tutor tutor) {
        self.tutor = tutor.cloneReadOnly();
    }

    resource function get id() returns @graphql:ID int => self.tutor.tutorId;

    resource function get firstName() returns string => self.tutor.firstName;

    resource function get lastName() returns string => self.tutor.lastName;

    resource function get experienceYears() returns int? => self.tutor.experienceYears;

    resource function get subject() returns string|error {
        datasource:Subject subject = check dbClient->/subjects/[self.tutor.subjectSubjectId];
        return subject.name;
    }

    resource function get price() returns int? => self.tutor.price;

    resource function get reviews() returns Review[] | error {
        stream<datasource:Review, error?> reviewStream = dbClient->/reviews();
    
    // Filter reviews based on the provided tutorId
        return from datasource:Review r in reviewStream
            where r.tutorTutorId == self.tutor.tutorId
            select new Review(r);
    }
}

service class Review {
    private final readonly & datasource:Review review;

    function init(datasource:Review review) {
        self.review = review.cloneReadOnly();
    }
    resource function get id() returns @graphql:ID int => self.review.reviewId;

    resource function get review() returns string => self.review.review;

    resource function get rating() returns int => self.review.starRating;

    resource function get student() returns Student[] | error {
        stream<datasource:Student, error?> studentStream = dbClient->/students();
    
    // Filter reviews based on the provided tutorId
        return from datasource:Student s in studentStream
            where s.studentId == self.review.studentStudentId
            select new Student(s);
    }

    resource function get tutor() returns Tutor[] | error {
        stream<datasource:Tutor, error?> tutorStream = dbClient->/tutors();
    
    // Filter reviews based on the provided tutorId
        return from datasource:Tutor t in tutorStream
            where t.tutorId == self.review.tutorTutorId
            select new Tutor(t);
    }
}

service class Student {
    private final readonly & datasource:Student student;

    function init(datasource:Student student) {
        self.student = student.cloneReadOnly();
    }
    resource function get firstName() returns string => self.student.firstName;

    resource function get lastName() returns string => self.student.lastName;

}

function getSubject(int subjectId) returns string|error {
    datasource:Subject subject = check dbClient->/subjects/[subjectId];
    return subject.name;
}