import educational_app_backend.datasource;

import ballerina/graphql;

datasource:Client dbClient = check new;

@graphql:ServiceConfig {
    graphiql: {
        enabled: true
    }
}

service on new graphql:Listener(9090) {

    resource function get tutors(string? subject, int? expYears, int? price) returns Tutor[]|error {
        stream<datasource:Tutor, error?> tutorStream = dbClient->/tutors();
        return from datasource:Tutor t in tutorStream
        where (subject is () || getSubject(t.subjectsSubjectId) == subject) &&
        (expYears is () || t.experienceYears == expYears) && 
        (price is () || t.price == price)
            select new (t);
    }

    resource function get tutorById(string tutorId) returns Tutor | error {
        datasource:Tutor tutor = check dbClient->/tutors/[tutorId]();
        return new (tutor);
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

    resource function get subject() returns string|error {
        datasource:Subject subject = check dbClient->/subjects/[self.tutor.subjectsSubjectId];
        return subject.name;
    }

    resource function get price() returns int => self.tutor.price;

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
    resource function get id() returns @graphql:ID string => self.review.reviewId;

    resource function get review() returns string => self.review.review;

    resource function get rating() returns int => self.review.starRating;
}

function getSubject(string subjectId) returns string|error {
    datasource:Subject subject = check dbClient->/subjects/[subjectId];
    return subject.name;
}