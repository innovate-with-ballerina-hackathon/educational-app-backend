// AUTO-GENERATED FILE. DO NOT MODIFY.

// This file is an auto-generated file by Ballerina persistence layer for model.
// It should not be modified by hand.

import ballerina/jballerina.java;
import ballerina/persist;
import ballerina/sql;
import ballerinax/mysql;
import ballerinax/mysql.driver as _;
import ballerinax/persist.sql as psql;

const PAYMENT = "payments";
const SESSION = "sessions";
const REVIEW = "reviews";
const TUTOR = "tutors";
const SUBJECT = "subjects";
const OPTION = "options";
const QUESTION = "questions";
const QUIZ = "quizzes";
const QUIZ_TAKEN = "quiztakens";
const STUDENT = "students";
const TUTOR_N_STUDENT = "tutornstudents";

public isolated client class Client {
    *persist:AbstractPersistClient;

    private final mysql:Client dbClient;

    private final map<psql:SQLClient> persistClients;

    private final record {|psql:SQLMetadata...;|} & readonly metadata = {
        [PAYMENT]: {
            entityName: "Payment",
            tableName: "Payment",
            fieldMetadata: {
                paymentId: {columnName: "paymentId"},
                amount: {columnName: "amount"},
                status: {columnName: "status"},
                paymentMethod: {columnName: "paymentMethod"},
                transactionDate: {columnName: "transactionDate"},
                sessionSessionId: {columnName: "sessionSessionId"},
                "session.sessionId": {relation: {entityName: "session", refField: "sessionId"}},
                "session.tutorTutorId": {relation: {entityName: "session", refField: "tutorTutorId"}},
                "session.studentStudentId": {relation: {entityName: "session", refField: "studentStudentId"}},
                "session.sessionTime": {relation: {entityName: "session", refField: "sessionTime"}},
                "session.duration": {relation: {entityName: "session", refField: "duration"}},
                "session.status": {relation: {entityName: "session", refField: "status"}},
                "session.isBooked": {relation: {entityName: "session", refField: "isBooked"}}
            },
            keyFields: ["paymentId"],
            joinMetadata: {session: {entity: Session, fieldName: "session", refTable: "Session", refColumns: ["sessionId"], joinColumns: ["sessionSessionId"], 'type: psql:ONE_TO_ONE}}
        },
        [SESSION]: {
            entityName: "Session",
            tableName: "Session",
            fieldMetadata: {
                sessionId: {columnName: "sessionId"},
                tutorTutorId: {columnName: "tutorTutorId"},
                studentStudentId: {columnName: "studentStudentId"},
                sessionTime: {columnName: "sessionTime"},
                duration: {columnName: "duration"},
                status: {columnName: "status"},
                isBooked: {columnName: "isBooked"},
                "tutor.tutorId": {relation: {entityName: "tutor", refField: "tutorId"}},
                "tutor.firstName": {relation: {entityName: "tutor", refField: "firstName"}},
                "tutor.lastName": {relation: {entityName: "tutor", refField: "lastName"}},
                "tutor.email": {relation: {entityName: "tutor", refField: "email"}},
                "tutor.password": {relation: {entityName: "tutor", refField: "password"}},
                "tutor.subjectsSubjectId": {relation: {entityName: "tutor", refField: "subjectsSubjectId"}},
                "tutor.experienceYears": {relation: {entityName: "tutor", refField: "experienceYears"}},
                "tutor.price": {relation: {entityName: "tutor", refField: "price"}},
                "student.studentId": {relation: {entityName: "student", refField: "studentId"}},
                "student.firstName": {relation: {entityName: "student", refField: "firstName"}},
                "student.lastName": {relation: {entityName: "student", refField: "lastName"}},
                "student.email": {relation: {entityName: "student", refField: "email"}},
                "student.password": {relation: {entityName: "student", refField: "password"}},
                "payment.paymentId": {relation: {entityName: "payment", refField: "paymentId"}},
                "payment.amount": {relation: {entityName: "payment", refField: "amount"}},
                "payment.status": {relation: {entityName: "payment", refField: "status"}},
                "payment.paymentMethod": {relation: {entityName: "payment", refField: "paymentMethod"}},
                "payment.transactionDate": {relation: {entityName: "payment", refField: "transactionDate"}},
                "payment.sessionSessionId": {relation: {entityName: "payment", refField: "sessionSessionId"}}
            },
            keyFields: ["sessionId"],
            joinMetadata: {
                tutor: {entity: Tutor, fieldName: "tutor", refTable: "Tutor", refColumns: ["tutorId"], joinColumns: ["tutorTutorId"], 'type: psql:ONE_TO_MANY},
                student: {entity: Student, fieldName: "student", refTable: "Student", refColumns: ["studentId"], joinColumns: ["studentStudentId"], 'type: psql:ONE_TO_MANY},
                payment: {entity: Payment, fieldName: "payment", refTable: "Payment", refColumns: ["sessionSessionId"], joinColumns: ["sessionId"], 'type: psql:ONE_TO_ONE}
            }
        },
        [REVIEW]: {
            entityName: "Review",
            tableName: "Review",
            fieldMetadata: {
                reviewId: {columnName: "reviewId"},
                review: {columnName: "review"},
                starRating: {columnName: "starRating"},
                studentStudentId: {columnName: "studentStudentId"},
                tutorTutorId: {columnName: "tutorTutorId"},
                "student.studentId": {relation: {entityName: "student", refField: "studentId"}},
                "student.firstName": {relation: {entityName: "student", refField: "firstName"}},
                "student.lastName": {relation: {entityName: "student", refField: "lastName"}},
                "student.email": {relation: {entityName: "student", refField: "email"}},
                "student.password": {relation: {entityName: "student", refField: "password"}},
                "tutor.tutorId": {relation: {entityName: "tutor", refField: "tutorId"}},
                "tutor.firstName": {relation: {entityName: "tutor", refField: "firstName"}},
                "tutor.lastName": {relation: {entityName: "tutor", refField: "lastName"}},
                "tutor.email": {relation: {entityName: "tutor", refField: "email"}},
                "tutor.password": {relation: {entityName: "tutor", refField: "password"}},
                "tutor.subjectsSubjectId": {relation: {entityName: "tutor", refField: "subjectsSubjectId"}},
                "tutor.experienceYears": {relation: {entityName: "tutor", refField: "experienceYears"}},
                "tutor.price": {relation: {entityName: "tutor", refField: "price"}}
            },
            keyFields: ["reviewId"],
            joinMetadata: {
                student: {entity: Student, fieldName: "student", refTable: "Student", refColumns: ["studentId"], joinColumns: ["studentStudentId"], 'type: psql:ONE_TO_ONE},
                tutor: {entity: Tutor, fieldName: "tutor", refTable: "Tutor", refColumns: ["tutorId"], joinColumns: ["tutorTutorId"], 'type: psql:ONE_TO_MANY}
            }
        },
        [TUTOR]: {
            entityName: "Tutor",
            tableName: "Tutor",
            fieldMetadata: {
                tutorId: {columnName: "tutorId"},
                firstName: {columnName: "firstName"},
                lastName: {columnName: "lastName"},
                email: {columnName: "email"},
                password: {columnName: "password"},
                subjectsSubjectId: {columnName: "subjectsSubjectId"},
                experienceYears: {columnName: "experienceYears"},
                price: {columnName: "price"},
                "students[].id": {relation: {entityName: "students", refField: "id"}},
                "students[].tutorTutorId": {relation: {entityName: "students", refField: "tutorTutorId"}},
                "students[].studentStudentId": {relation: {entityName: "students", refField: "studentStudentId"}},
                "subjects.subjectId": {relation: {entityName: "subjects", refField: "subjectId"}},
                "subjects.name": {relation: {entityName: "subjects", refField: "name"}},
                "sessions[].sessionId": {relation: {entityName: "sessions", refField: "sessionId"}},
                "sessions[].tutorTutorId": {relation: {entityName: "sessions", refField: "tutorTutorId"}},
                "sessions[].studentStudentId": {relation: {entityName: "sessions", refField: "studentStudentId"}},
                "sessions[].sessionTime": {relation: {entityName: "sessions", refField: "sessionTime"}},
                "sessions[].duration": {relation: {entityName: "sessions", refField: "duration"}},
                "sessions[].status": {relation: {entityName: "sessions", refField: "status"}},
                "sessions[].isBooked": {relation: {entityName: "sessions", refField: "isBooked"}},
                "reviews[].reviewId": {relation: {entityName: "reviews", refField: "reviewId"}},
                "reviews[].review": {relation: {entityName: "reviews", refField: "review"}},
                "reviews[].starRating": {relation: {entityName: "reviews", refField: "starRating"}},
                "reviews[].studentStudentId": {relation: {entityName: "reviews", refField: "studentStudentId"}},
                "reviews[].tutorTutorId": {relation: {entityName: "reviews", refField: "tutorTutorId"}}
            },
            keyFields: ["tutorId"],
            joinMetadata: {
                students: {entity: TutorNStudent, fieldName: "students", refTable: "TutorNStudent", refColumns: ["tutorTutorId"], joinColumns: ["tutorId"], 'type: psql:MANY_TO_ONE},
                subjects: {entity: Subject, fieldName: "subjects", refTable: "Subject", refColumns: ["subjectId"], joinColumns: ["subjectsSubjectId"], 'type: psql:ONE_TO_MANY},
                sessions: {entity: Session, fieldName: "sessions", refTable: "Session", refColumns: ["tutorTutorId"], joinColumns: ["tutorId"], 'type: psql:MANY_TO_ONE},
                reviews: {entity: Review, fieldName: "reviews", refTable: "Review", refColumns: ["tutorTutorId"], joinColumns: ["tutorId"], 'type: psql:MANY_TO_ONE}
            }
        },
        [SUBJECT]: {
            entityName: "Subject",
            tableName: "Subject",
            fieldMetadata: {
                subjectId: {columnName: "subjectId"},
                name: {columnName: "name"},
                "tutors[].tutorId": {relation: {entityName: "tutors", refField: "tutorId"}},
                "tutors[].firstName": {relation: {entityName: "tutors", refField: "firstName"}},
                "tutors[].lastName": {relation: {entityName: "tutors", refField: "lastName"}},
                "tutors[].email": {relation: {entityName: "tutors", refField: "email"}},
                "tutors[].password": {relation: {entityName: "tutors", refField: "password"}},
                "tutors[].subjectsSubjectId": {relation: {entityName: "tutors", refField: "subjectsSubjectId"}},
                "tutors[].experienceYears": {relation: {entityName: "tutors", refField: "experienceYears"}},
                "tutors[].price": {relation: {entityName: "tutors", refField: "price"}}
            },
            keyFields: ["subjectId"],
            joinMetadata: {tutors: {entity: Tutor, fieldName: "tutors", refTable: "Tutor", refColumns: ["subjectsSubjectId"], joinColumns: ["subjectId"], 'type: psql:MANY_TO_ONE}}
        },
        [OPTION]: {
            entityName: "Option",
            tableName: "Option",
            fieldMetadata: {
                optionId: {columnName: "optionId"},
                text: {columnName: "text"},
                isCorrect: {columnName: "isCorrect"},
                questionQuestionId: {columnName: "questionQuestionId"},
                "question.questionId": {relation: {entityName: "question", refField: "questionId"}},
                "question.questionText": {relation: {entityName: "question", refField: "questionText"}},
                "question.quizQuizId": {relation: {entityName: "question", refField: "quizQuizId"}}
            },
            keyFields: ["optionId"],
            joinMetadata: {question: {entity: Question, fieldName: "question", refTable: "Question", refColumns: ["questionId"], joinColumns: ["questionQuestionId"], 'type: psql:ONE_TO_MANY}}
        },
        [QUESTION]: {
            entityName: "Question",
            tableName: "Question",
            fieldMetadata: {
                questionId: {columnName: "questionId"},
                questionText: {columnName: "questionText"},
                quizQuizId: {columnName: "quizQuizId"},
                "options[].optionId": {relation: {entityName: "options", refField: "optionId"}},
                "options[].text": {relation: {entityName: "options", refField: "text"}},
                "options[].isCorrect": {relation: {entityName: "options", refField: "isCorrect"}},
                "options[].questionQuestionId": {relation: {entityName: "options", refField: "questionQuestionId"}},
                "quiz.quizId": {relation: {entityName: "quiz", refField: "quizId"}}
            },
            keyFields: ["questionId"],
            joinMetadata: {
                options: {entity: Option, fieldName: "options", refTable: "Option", refColumns: ["questionQuestionId"], joinColumns: ["questionId"], 'type: psql:MANY_TO_ONE},
                quiz: {entity: Quiz, fieldName: "quiz", refTable: "Quiz", refColumns: ["quizId"], joinColumns: ["quizQuizId"], 'type: psql:ONE_TO_MANY}
            }
        },
        [QUIZ]: {
            entityName: "Quiz",
            tableName: "Quiz",
            fieldMetadata: {
                quizId: {columnName: "quizId"},
                "questions[].questionId": {relation: {entityName: "questions", refField: "questionId"}},
                "questions[].questionText": {relation: {entityName: "questions", refField: "questionText"}},
                "questions[].quizQuizId": {relation: {entityName: "questions", refField: "quizQuizId"}},
                "quiztaken.studentId": {relation: {entityName: "quiztaken", refField: "studentId"}},
                "quiztaken.quizId": {relation: {entityName: "quiztaken", refField: "quizId"}},
                "quiztaken.quizQuizId": {relation: {entityName: "quiztaken", refField: "quizQuizId"}},
                "quiztaken.score": {relation: {entityName: "quiztaken", refField: "score"}},
                "quiztaken.submisstedDate": {relation: {entityName: "quiztaken", refField: "submisstedDate"}}
            },
            keyFields: ["quizId"],
            joinMetadata: {
                questions: {entity: Question, fieldName: "questions", refTable: "Question", refColumns: ["quizQuizId"], joinColumns: ["quizId"], 'type: psql:MANY_TO_ONE},
                quiztaken: {entity: QuizTaken, fieldName: "quiztaken", refTable: "QuizTaken", refColumns: ["quizQuizId"], joinColumns: ["quizId"], 'type: psql:ONE_TO_ONE}
            }
        },
        [QUIZ_TAKEN]: {
            entityName: "QuizTaken",
            tableName: "QuizTaken",
            fieldMetadata: {
                studentId: {columnName: "studentId"},
                quizId: {columnName: "quizId"},
                quizQuizId: {columnName: "quizQuizId"},
                score: {columnName: "score"},
                submisstedDate: {columnName: "submisstedDate"},
                "quiz.quizId": {relation: {entityName: "quiz", refField: "quizId"}}
            },
            keyFields: ["studentId", "quizId"],
            joinMetadata: {quiz: {entity: Quiz, fieldName: "quiz", refTable: "Quiz", refColumns: ["quizId"], joinColumns: ["quizQuizId"], 'type: psql:ONE_TO_ONE}}
        },
        [STUDENT]: {
            entityName: "Student",
            tableName: "Student",
            fieldMetadata: {
                studentId: {columnName: "studentId"},
                firstName: {columnName: "firstName"},
                lastName: {columnName: "lastName"},
                email: {columnName: "email"},
                password: {columnName: "password"},
                "sessions[].sessionId": {relation: {entityName: "sessions", refField: "sessionId"}},
                "sessions[].tutorTutorId": {relation: {entityName: "sessions", refField: "tutorTutorId"}},
                "sessions[].studentStudentId": {relation: {entityName: "sessions", refField: "studentStudentId"}},
                "sessions[].sessionTime": {relation: {entityName: "sessions", refField: "sessionTime"}},
                "sessions[].duration": {relation: {entityName: "sessions", refField: "duration"}},
                "sessions[].status": {relation: {entityName: "sessions", refField: "status"}},
                "sessions[].isBooked": {relation: {entityName: "sessions", refField: "isBooked"}},
                "tutors[].id": {relation: {entityName: "tutors", refField: "id"}},
                "tutors[].tutorTutorId": {relation: {entityName: "tutors", refField: "tutorTutorId"}},
                "tutors[].studentStudentId": {relation: {entityName: "tutors", refField: "studentStudentId"}},
                "review.reviewId": {relation: {entityName: "review", refField: "reviewId"}},
                "review.review": {relation: {entityName: "review", refField: "review"}},
                "review.starRating": {relation: {entityName: "review", refField: "starRating"}},
                "review.studentStudentId": {relation: {entityName: "review", refField: "studentStudentId"}},
                "review.tutorTutorId": {relation: {entityName: "review", refField: "tutorTutorId"}}
            },
            keyFields: ["studentId"],
            joinMetadata: {
                sessions: {entity: Session, fieldName: "sessions", refTable: "Session", refColumns: ["studentStudentId"], joinColumns: ["studentId"], 'type: psql:MANY_TO_ONE},
                tutors: {entity: TutorNStudent, fieldName: "tutors", refTable: "TutorNStudent", refColumns: ["studentStudentId"], joinColumns: ["studentId"], 'type: psql:MANY_TO_ONE},
                review: {entity: Review, fieldName: "review", refTable: "Review", refColumns: ["studentStudentId"], joinColumns: ["studentId"], 'type: psql:ONE_TO_ONE}
            }
        },
        [TUTOR_N_STUDENT]: {
            entityName: "TutorNStudent",
            tableName: "TutorNStudent",
            fieldMetadata: {
                id: {columnName: "id"},
                tutorTutorId: {columnName: "tutorTutorId"},
                studentStudentId: {columnName: "studentStudentId"},
                "tutor.tutorId": {relation: {entityName: "tutor", refField: "tutorId"}},
                "tutor.firstName": {relation: {entityName: "tutor", refField: "firstName"}},
                "tutor.lastName": {relation: {entityName: "tutor", refField: "lastName"}},
                "tutor.email": {relation: {entityName: "tutor", refField: "email"}},
                "tutor.password": {relation: {entityName: "tutor", refField: "password"}},
                "tutor.subjectsSubjectId": {relation: {entityName: "tutor", refField: "subjectsSubjectId"}},
                "tutor.experienceYears": {relation: {entityName: "tutor", refField: "experienceYears"}},
                "tutor.price": {relation: {entityName: "tutor", refField: "price"}},
                "student.studentId": {relation: {entityName: "student", refField: "studentId"}},
                "student.firstName": {relation: {entityName: "student", refField: "firstName"}},
                "student.lastName": {relation: {entityName: "student", refField: "lastName"}},
                "student.email": {relation: {entityName: "student", refField: "email"}},
                "student.password": {relation: {entityName: "student", refField: "password"}}
            },
            keyFields: ["id"],
            joinMetadata: {
                tutor: {entity: Tutor, fieldName: "tutor", refTable: "Tutor", refColumns: ["tutorId"], joinColumns: ["tutorTutorId"], 'type: psql:ONE_TO_MANY},
                student: {entity: Student, fieldName: "student", refTable: "Student", refColumns: ["studentId"], joinColumns: ["studentStudentId"], 'type: psql:ONE_TO_MANY}
            }
        }
    };

    public isolated function init() returns persist:Error? {
        mysql:Client|error dbClient = new (host = host, user = user, password = password, database = database, port = port, options = connectionOptions);
        if dbClient is error {
            return <persist:Error>error(dbClient.message());
        }
        self.dbClient = dbClient;
        self.persistClients = {
            [PAYMENT]: check new (dbClient, self.metadata.get(PAYMENT), psql:MYSQL_SPECIFICS),
            [SESSION]: check new (dbClient, self.metadata.get(SESSION), psql:MYSQL_SPECIFICS),
            [REVIEW]: check new (dbClient, self.metadata.get(REVIEW), psql:MYSQL_SPECIFICS),
            [TUTOR]: check new (dbClient, self.metadata.get(TUTOR), psql:MYSQL_SPECIFICS),
            [SUBJECT]: check new (dbClient, self.metadata.get(SUBJECT), psql:MYSQL_SPECIFICS),
            [OPTION]: check new (dbClient, self.metadata.get(OPTION), psql:MYSQL_SPECIFICS),
            [QUESTION]: check new (dbClient, self.metadata.get(QUESTION), psql:MYSQL_SPECIFICS),
            [QUIZ]: check new (dbClient, self.metadata.get(QUIZ), psql:MYSQL_SPECIFICS),
            [QUIZ_TAKEN]: check new (dbClient, self.metadata.get(QUIZ_TAKEN), psql:MYSQL_SPECIFICS),
            [STUDENT]: check new (dbClient, self.metadata.get(STUDENT), psql:MYSQL_SPECIFICS),
            [TUTOR_N_STUDENT]: check new (dbClient, self.metadata.get(TUTOR_N_STUDENT), psql:MYSQL_SPECIFICS)
        };
    }

    isolated resource function get payments(PaymentTargetType targetType = <>, sql:ParameterizedQuery whereClause = ``, sql:ParameterizedQuery orderByClause = ``, sql:ParameterizedQuery limitClause = ``, sql:ParameterizedQuery groupByClause = ``) returns stream<targetType, persist:Error?> = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.MySQLProcessor",
        name: "query"
    } external;

    isolated resource function get payments/[string paymentId](PaymentTargetType targetType = <>) returns targetType|persist:Error = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.MySQLProcessor",
        name: "queryOne"
    } external;

    isolated resource function post payments(PaymentInsert[] data) returns string[]|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(PAYMENT);
        }
        _ = check sqlClient.runBatchInsertQuery(data);
        return from PaymentInsert inserted in data
            select inserted.paymentId;
    }

    isolated resource function put payments/[string paymentId](PaymentUpdate value) returns Payment|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(PAYMENT);
        }
        _ = check sqlClient.runUpdateQuery(paymentId, value);
        return self->/payments/[paymentId].get();
    }

    isolated resource function delete payments/[string paymentId]() returns Payment|persist:Error {
        Payment result = check self->/payments/[paymentId].get();
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(PAYMENT);
        }
        _ = check sqlClient.runDeleteQuery(paymentId);
        return result;
    }

    isolated resource function get sessions(SessionTargetType targetType = <>, sql:ParameterizedQuery whereClause = ``, sql:ParameterizedQuery orderByClause = ``, sql:ParameterizedQuery limitClause = ``, sql:ParameterizedQuery groupByClause = ``) returns stream<targetType, persist:Error?> = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.MySQLProcessor",
        name: "query"
    } external;

    isolated resource function get sessions/[string sessionId](SessionTargetType targetType = <>) returns targetType|persist:Error = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.MySQLProcessor",
        name: "queryOne"
    } external;

    isolated resource function post sessions(SessionInsert[] data) returns string[]|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(SESSION);
        }
        _ = check sqlClient.runBatchInsertQuery(data);
        return from SessionInsert inserted in data
            select inserted.sessionId;
    }

    isolated resource function put sessions/[string sessionId](SessionUpdate value) returns Session|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(SESSION);
        }
        _ = check sqlClient.runUpdateQuery(sessionId, value);
        return self->/sessions/[sessionId].get();
    }

    isolated resource function delete sessions/[string sessionId]() returns Session|persist:Error {
        Session result = check self->/sessions/[sessionId].get();
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(SESSION);
        }
        _ = check sqlClient.runDeleteQuery(sessionId);
        return result;
    }

    isolated resource function get reviews(ReviewTargetType targetType = <>, sql:ParameterizedQuery whereClause = ``, sql:ParameterizedQuery orderByClause = ``, sql:ParameterizedQuery limitClause = ``, sql:ParameterizedQuery groupByClause = ``) returns stream<targetType, persist:Error?> = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.MySQLProcessor",
        name: "query"
    } external;

    isolated resource function get reviews/[string reviewId](ReviewTargetType targetType = <>) returns targetType|persist:Error = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.MySQLProcessor",
        name: "queryOne"
    } external;

    isolated resource function post reviews(ReviewInsert[] data) returns string[]|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(REVIEW);
        }
        _ = check sqlClient.runBatchInsertQuery(data);
        return from ReviewInsert inserted in data
            select inserted.reviewId;
    }

    isolated resource function put reviews/[string reviewId](ReviewUpdate value) returns Review|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(REVIEW);
        }
        _ = check sqlClient.runUpdateQuery(reviewId, value);
        return self->/reviews/[reviewId].get();
    }

    isolated resource function delete reviews/[string reviewId]() returns Review|persist:Error {
        Review result = check self->/reviews/[reviewId].get();
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(REVIEW);
        }
        _ = check sqlClient.runDeleteQuery(reviewId);
        return result;
    }

    isolated resource function get tutors(TutorTargetType targetType = <>, sql:ParameterizedQuery whereClause = ``, sql:ParameterizedQuery orderByClause = ``, sql:ParameterizedQuery limitClause = ``, sql:ParameterizedQuery groupByClause = ``) returns stream<targetType, persist:Error?> = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.MySQLProcessor",
        name: "query"
    } external;

    isolated resource function get tutors/[string tutorId](TutorTargetType targetType = <>) returns targetType|persist:Error = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.MySQLProcessor",
        name: "queryOne"
    } external;

    isolated resource function post tutors(TutorInsert[] data) returns string[]|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(TUTOR);
        }
        _ = check sqlClient.runBatchInsertQuery(data);
        return from TutorInsert inserted in data
            select inserted.tutorId;
    }

    isolated resource function put tutors/[string tutorId](TutorUpdate value) returns Tutor|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(TUTOR);
        }
        _ = check sqlClient.runUpdateQuery(tutorId, value);
        return self->/tutors/[tutorId].get();
    }

    isolated resource function delete tutors/[string tutorId]() returns Tutor|persist:Error {
        Tutor result = check self->/tutors/[tutorId].get();
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(TUTOR);
        }
        _ = check sqlClient.runDeleteQuery(tutorId);
        return result;
    }

    isolated resource function get subjects(SubjectTargetType targetType = <>, sql:ParameterizedQuery whereClause = ``, sql:ParameterizedQuery orderByClause = ``, sql:ParameterizedQuery limitClause = ``, sql:ParameterizedQuery groupByClause = ``) returns stream<targetType, persist:Error?> = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.MySQLProcessor",
        name: "query"
    } external;

    isolated resource function get subjects/[string subjectId](SubjectTargetType targetType = <>) returns targetType|persist:Error = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.MySQLProcessor",
        name: "queryOne"
    } external;

    isolated resource function post subjects(SubjectInsert[] data) returns string[]|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(SUBJECT);
        }
        _ = check sqlClient.runBatchInsertQuery(data);
        return from SubjectInsert inserted in data
            select inserted.subjectId;
    }

    isolated resource function put subjects/[string subjectId](SubjectUpdate value) returns Subject|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(SUBJECT);
        }
        _ = check sqlClient.runUpdateQuery(subjectId, value);
        return self->/subjects/[subjectId].get();
    }

    isolated resource function delete subjects/[string subjectId]() returns Subject|persist:Error {
        Subject result = check self->/subjects/[subjectId].get();
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(SUBJECT);
        }
        _ = check sqlClient.runDeleteQuery(subjectId);
        return result;
    }

    isolated resource function get options(OptionTargetType targetType = <>, sql:ParameterizedQuery whereClause = ``, sql:ParameterizedQuery orderByClause = ``, sql:ParameterizedQuery limitClause = ``, sql:ParameterizedQuery groupByClause = ``) returns stream<targetType, persist:Error?> = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.MySQLProcessor",
        name: "query"
    } external;

    isolated resource function get options/[string optionId](OptionTargetType targetType = <>) returns targetType|persist:Error = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.MySQLProcessor",
        name: "queryOne"
    } external;

    isolated resource function post options(OptionInsert[] data) returns string[]|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(OPTION);
        }
        _ = check sqlClient.runBatchInsertQuery(data);
        return from OptionInsert inserted in data
            select inserted.optionId;
    }

    isolated resource function put options/[string optionId](OptionUpdate value) returns Option|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(OPTION);
        }
        _ = check sqlClient.runUpdateQuery(optionId, value);
        return self->/options/[optionId].get();
    }

    isolated resource function delete options/[string optionId]() returns Option|persist:Error {
        Option result = check self->/options/[optionId].get();
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(OPTION);
        }
        _ = check sqlClient.runDeleteQuery(optionId);
        return result;
    }

    isolated resource function get questions(QuestionTargetType targetType = <>, sql:ParameterizedQuery whereClause = ``, sql:ParameterizedQuery orderByClause = ``, sql:ParameterizedQuery limitClause = ``, sql:ParameterizedQuery groupByClause = ``) returns stream<targetType, persist:Error?> = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.MySQLProcessor",
        name: "query"
    } external;

    isolated resource function get questions/[string questionId](QuestionTargetType targetType = <>) returns targetType|persist:Error = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.MySQLProcessor",
        name: "queryOne"
    } external;

    isolated resource function post questions(QuestionInsert[] data) returns string[]|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(QUESTION);
        }
        _ = check sqlClient.runBatchInsertQuery(data);
        return from QuestionInsert inserted in data
            select inserted.questionId;
    }

    isolated resource function put questions/[string questionId](QuestionUpdate value) returns Question|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(QUESTION);
        }
        _ = check sqlClient.runUpdateQuery(questionId, value);
        return self->/questions/[questionId].get();
    }

    isolated resource function delete questions/[string questionId]() returns Question|persist:Error {
        Question result = check self->/questions/[questionId].get();
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(QUESTION);
        }
        _ = check sqlClient.runDeleteQuery(questionId);
        return result;
    }

    isolated resource function get quizzes(QuizTargetType targetType = <>, sql:ParameterizedQuery whereClause = ``, sql:ParameterizedQuery orderByClause = ``, sql:ParameterizedQuery limitClause = ``, sql:ParameterizedQuery groupByClause = ``) returns stream<targetType, persist:Error?> = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.MySQLProcessor",
        name: "query"
    } external;

    isolated resource function get quizzes/[string quizId](QuizTargetType targetType = <>) returns targetType|persist:Error = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.MySQLProcessor",
        name: "queryOne"
    } external;

    isolated resource function post quizzes(QuizInsert[] data) returns string[]|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(QUIZ);
        }
        _ = check sqlClient.runBatchInsertQuery(data);
        return from QuizInsert inserted in data
            select inserted.quizId;
    }

    isolated resource function put quizzes/[string quizId](QuizUpdate value) returns Quiz|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(QUIZ);
        }
        _ = check sqlClient.runUpdateQuery(quizId, value);
        return self->/quizzes/[quizId].get();
    }

    isolated resource function delete quizzes/[string quizId]() returns Quiz|persist:Error {
        Quiz result = check self->/quizzes/[quizId].get();
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(QUIZ);
        }
        _ = check sqlClient.runDeleteQuery(quizId);
        return result;
    }

    isolated resource function get quiztakens(QuizTakenTargetType targetType = <>, sql:ParameterizedQuery whereClause = ``, sql:ParameterizedQuery orderByClause = ``, sql:ParameterizedQuery limitClause = ``, sql:ParameterizedQuery groupByClause = ``) returns stream<targetType, persist:Error?> = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.MySQLProcessor",
        name: "query"
    } external;

    isolated resource function get quiztakens/[string studentId]/[string quizId](QuizTakenTargetType targetType = <>) returns targetType|persist:Error = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.MySQLProcessor",
        name: "queryOne"
    } external;

    isolated resource function post quiztakens(QuizTakenInsert[] data) returns [string, string][]|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(QUIZ_TAKEN);
        }
        _ = check sqlClient.runBatchInsertQuery(data);
        return from QuizTakenInsert inserted in data
            select [inserted.studentId, inserted.quizId];
    }

    isolated resource function put quiztakens/[string studentId]/[string quizId](QuizTakenUpdate value) returns QuizTaken|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(QUIZ_TAKEN);
        }
        _ = check sqlClient.runUpdateQuery({"studentId": studentId, "quizId": quizId}, value);
        return self->/quiztakens/[studentId]/[quizId].get();
    }

    isolated resource function delete quiztakens/[string studentId]/[string quizId]() returns QuizTaken|persist:Error {
        QuizTaken result = check self->/quiztakens/[studentId]/[quizId].get();
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(QUIZ_TAKEN);
        }
        _ = check sqlClient.runDeleteQuery({"studentId": studentId, "quizId": quizId});
        return result;
    }

    isolated resource function get students(StudentTargetType targetType = <>, sql:ParameterizedQuery whereClause = ``, sql:ParameterizedQuery orderByClause = ``, sql:ParameterizedQuery limitClause = ``, sql:ParameterizedQuery groupByClause = ``) returns stream<targetType, persist:Error?> = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.MySQLProcessor",
        name: "query"
    } external;

    isolated resource function get students/[string studentId](StudentTargetType targetType = <>) returns targetType|persist:Error = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.MySQLProcessor",
        name: "queryOne"
    } external;

    isolated resource function post students(StudentInsert[] data) returns string[]|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(STUDENT);
        }
        _ = check sqlClient.runBatchInsertQuery(data);
        return from StudentInsert inserted in data
            select inserted.studentId;
    }

    isolated resource function put students/[string studentId](StudentUpdate value) returns Student|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(STUDENT);
        }
        _ = check sqlClient.runUpdateQuery(studentId, value);
        return self->/students/[studentId].get();
    }

    isolated resource function delete students/[string studentId]() returns Student|persist:Error {
        Student result = check self->/students/[studentId].get();
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(STUDENT);
        }
        _ = check sqlClient.runDeleteQuery(studentId);
        return result;
    }

    isolated resource function get tutornstudents(TutorNStudentTargetType targetType = <>, sql:ParameterizedQuery whereClause = ``, sql:ParameterizedQuery orderByClause = ``, sql:ParameterizedQuery limitClause = ``, sql:ParameterizedQuery groupByClause = ``) returns stream<targetType, persist:Error?> = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.MySQLProcessor",
        name: "query"
    } external;

    isolated resource function get tutornstudents/[string id](TutorNStudentTargetType targetType = <>) returns targetType|persist:Error = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.MySQLProcessor",
        name: "queryOne"
    } external;

    isolated resource function post tutornstudents(TutorNStudentInsert[] data) returns string[]|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(TUTOR_N_STUDENT);
        }
        _ = check sqlClient.runBatchInsertQuery(data);
        return from TutorNStudentInsert inserted in data
            select inserted.id;
    }

    isolated resource function put tutornstudents/[string id](TutorNStudentUpdate value) returns TutorNStudent|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(TUTOR_N_STUDENT);
        }
        _ = check sqlClient.runUpdateQuery(id, value);
        return self->/tutornstudents/[id].get();
    }

    isolated resource function delete tutornstudents/[string id]() returns TutorNStudent|persist:Error {
        TutorNStudent result = check self->/tutornstudents/[id].get();
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(TUTOR_N_STUDENT);
        }
        _ = check sqlClient.runDeleteQuery(id);
        return result;
    }

    remote isolated function queryNativeSQL(sql:ParameterizedQuery sqlQuery, typedesc<record {}> rowType = <>) returns stream<rowType, persist:Error?> = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.MySQLProcessor"
    } external;

    remote isolated function executeNativeSQL(sql:ParameterizedQuery sqlQuery) returns psql:ExecutionResult|persist:Error = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.MySQLProcessor"
    } external;

    public isolated function close() returns persist:Error? {
        error? result = self.dbClient.close();
        if result is error {
            return <persist:Error>error(result.message());
        }
        return result;
    }
}

