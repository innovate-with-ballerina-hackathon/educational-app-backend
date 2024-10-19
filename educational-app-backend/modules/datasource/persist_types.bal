// AUTO-GENERATED FILE. DO NOT MODIFY.

// This file is an auto-generated file by Ballerina persistence layer for model.
// It should not be modified by hand.

import ballerina/time;

public enum SessionStatus {
    SCHEDULED,
    BOOKED,
    CANCELLED,
    ENDED
}

public enum Category {
    ASTRO,
    PHYSICS,
    CHEMISTRY,
    GEOMETRY,
    ENGLISH,
    FRENCH,
    GERMAN,
    BIOLOGY
}

public type Session record {|
    readonly int sessionId;
    int tutorTutorId;
    time:Civil startingTime;
    time:Civil endingTime;
    SessionStatus status;
    string? eventId;

    string timeZoneOffset;
    string utcOffset;
|};

public type SessionOptionalized record {|
    int sessionId?;
    int tutorTutorId?;
    time:Civil startingTime?;
    time:Civil endingTime?;
    SessionStatus status?;
    string? eventId?;
    string timeZoneOffset?;
    string utcOffset?;
|};

public type SessionWithRelations record {|
    *SessionOptionalized;
    TutorOptionalized tutor?;
    BookingOptionalized booking?;
|};

public type SessionTargetType typedesc<SessionWithRelations>;

public type SessionInsert record {|
    int tutorTutorId;
    time:Civil startingTime;
    time:Civil endingTime;
    SessionStatus status;
    string? eventId;
    string timeZoneOffset;
    string utcOffset;
|};

public type SessionUpdate record {|
    int tutorTutorId?;
    time:Civil startingTime?;
    time:Civil endingTime?;
    SessionStatus status?;
    string? eventId?;
    string timeZoneOffset?;
    string utcOffset?;
|};

public type Booking record {|
    readonly int bookingId;
    int sessionSessionId;
    int studentStudentId;
|};

public type BookingOptionalized record {|
    int bookingId?;
    int sessionSessionId?;
    int studentStudentId?;
|};

public type BookingWithRelations record {|
    *BookingOptionalized;
    SessionOptionalized session?;
    StudentOptionalized student?;
|};

public type BookingTargetType typedesc<BookingWithRelations>;

public type BookingInsert record {|
    int sessionSessionId;
    int studentStudentId;
|};

public type BookingUpdate record {|
    int sessionSessionId?;
    int studentStudentId?;
|};

public type Review record {|
    readonly int reviewId;
    string review;
    int starRating;
    int studentStudentId;
    int tutorTutorId;
|};

public type ReviewOptionalized record {|
    int reviewId?;
    string review?;
    int starRating?;
    int studentStudentId?;
    int tutorTutorId?;
|};

public type ReviewWithRelations record {|
    *ReviewOptionalized;
    StudentOptionalized student?;
    TutorOptionalized tutor?;
|};

public type ReviewTargetType typedesc<ReviewWithRelations>;

public type ReviewInsert record {|
    string review;
    int starRating;
    int studentStudentId;
    int tutorTutorId;
|};

public type ReviewUpdate record {|
    string review?;
    int starRating?;
    int studentStudentId?;
    int tutorTutorId?;
|};

public type AuthCredentials record {|
    readonly int credId;
    string userRole;
    string accessToken;
    string refreshToken;
    string idToken;

|};

public type AuthCredentialsOptionalized record {|
    int credId?;
    string userRole?;
    string accessToken?;
    string refreshToken?;
    string idToken?;
|};

public type AuthCredentialsWithRelations record {|
    *AuthCredentialsOptionalized;
    TutorOptionalized tutor?;
    StudentOptionalized student?;
|};

public type AuthCredentialsTargetType typedesc<AuthCredentialsWithRelations>;

public type AuthCredentialsInsert record {|
    string userRole;
    string accessToken;
    string refreshToken;
    string idToken;
|};

public type AuthCredentialsUpdate record {|
    string userRole?;
    string accessToken?;
    string refreshToken?;
    string idToken?;
|};

public type Tutor record {|
    readonly int tutorId;
    string firstName;
    string lastName;
    string email;

    int credentialsCredId;
    int subjectSubjectId;
    int? experienceYears;
    int? price;

|};

public type TutorOptionalized record {|
    int tutorId?;
    string firstName?;
    string lastName?;
    string email?;
    int credentialsCredId?;
    int subjectSubjectId?;
    int? experienceYears?;
    int? price?;
|};

public type TutorWithRelations record {|
    *TutorOptionalized;
    TutorNStudentOptionalized[] students?;
    SessionOptionalized[] sessions?;
    ReviewOptionalized[] reviews?;
    AuthCredentialsOptionalized credentials?;
    SubjectOptionalized subject?;
    DocumentOptionalized document?;
|};

public type TutorTargetType typedesc<TutorWithRelations>;

public type TutorInsert record {|
    string firstName;
    string lastName;
    string email;
    int credentialsCredId;
    int subjectSubjectId;
    int? experienceYears;
    int? price;
|};

public type TutorUpdate record {|
    string firstName?;
    string lastName?;
    string email?;
    int credentialsCredId?;
    int subjectSubjectId?;
    int? experienceYears?;
    int? price?;
|};

public type Subject record {|
    readonly int subjectId;
    string name;

|};

public type SubjectOptionalized record {|
    int subjectId?;
    string name?;
|};

public type SubjectWithRelations record {|
    *SubjectOptionalized;
    TutorOptionalized[] tutors?;
|};

public type SubjectTargetType typedesc<SubjectWithRelations>;

public type SubjectInsert record {|
    string name;
|};

public type SubjectUpdate record {|
    string name?;
|};

public type Student record {|
    readonly int studentId;
    string firstName;
    string lastName;
    string email;

    int credentialsCredId;

|};

public type StudentOptionalized record {|
    int studentId?;
    string firstName?;
    string lastName?;
    string email?;
    int credentialsCredId?;
|};

public type StudentWithRelations record {|
    *StudentOptionalized;
    TutorNStudentOptionalized[] tutors?;
    ReviewOptionalized review?;
    AuthCredentialsOptionalized credentials?;
    BookingOptionalized[] booking?;
|};

public type StudentTargetType typedesc<StudentWithRelations>;

public type StudentInsert record {|
    string firstName;
    string lastName;
    string email;
    int credentialsCredId;
|};

public type StudentUpdate record {|
    string firstName?;
    string lastName?;
    string email?;
    int credentialsCredId?;
|};

public type TutorNStudent record {|
    readonly int id;
    int tutorTutorId;
    int studentStudentId;
|};

public type TutorNStudentOptionalized record {|
    int id?;
    int tutorTutorId?;
    int studentStudentId?;
|};

public type TutorNStudentWithRelations record {|
    *TutorNStudentOptionalized;
    TutorOptionalized tutor?;
    StudentOptionalized student?;
|};

public type TutorNStudentTargetType typedesc<TutorNStudentWithRelations>;

public type TutorNStudentInsert record {|
    int tutorTutorId;
    int studentStudentId;
|};

public type TutorNStudentUpdate record {|
    int tutorTutorId?;
    int studentStudentId?;
|};

public type Document record {|
    readonly int id;
    string filepath;
    string title;
    string description;
    Category category;
    int tutorTutorId;
|};

public type DocumentOptionalized record {|
    int id?;
    string filepath?;
    string title?;
    string description?;
    Category category?;
    int tutorTutorId?;
|};

public type DocumentWithRelations record {|
    *DocumentOptionalized;
    TutorOptionalized tutor?;
|};

public type DocumentTargetType typedesc<DocumentWithRelations>;

public type DocumentInsert record {|
    string filepath;
    string title;
    string description;
    Category category;
    int tutorTutorId;
|};

public type DocumentUpdate record {|
    string filepath?;
    string title?;
    string description?;
    Category category?;
    int tutorTutorId?;
|};

