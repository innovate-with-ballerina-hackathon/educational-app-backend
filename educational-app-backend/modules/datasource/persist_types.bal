// AUTO-GENERATED FILE. DO NOT MODIFY.

// This file is an auto-generated file by Ballerina persistence layer for model.
// It should not be modified by hand.

import ballerina/time;

public enum PaymentStatus {
    PENDING,
    PAID
}

public enum SessionStatus {
    SCHEDULED,
    CANCELLED,
    STARTED,
    ENDED
}

public type Payment record {|
    readonly int paymentId;
    int amount;
    PaymentStatus status;
    string paymentMethod;
    string transactionDate;
    int sessionSessionId;
|};

public type PaymentOptionalized record {|
    int paymentId?;
    int amount?;
    PaymentStatus status?;
    string paymentMethod?;
    string transactionDate?;
    int sessionSessionId?;
|};

public type PaymentWithRelations record {|
    *PaymentOptionalized;
    SessionOptionalized session?;
|};

public type PaymentTargetType typedesc<PaymentWithRelations>;

public type PaymentInsert record {|
    int amount;
    PaymentStatus status;
    string paymentMethod;
    string transactionDate;
    int sessionSessionId;
|};

public type PaymentUpdate record {|
    int amount?;
    PaymentStatus status?;
    string paymentMethod?;
    string transactionDate?;
    int sessionSessionId?;
|};

public type Session record {|
    readonly int sessionId;
    int tutorTutorId;
    int studentStudentId;
    time:Civil sessionTime;
    int duration;
    SessionStatus status;

    boolean isBooked;
|};

public type SessionOptionalized record {|
    int sessionId?;
    int tutorTutorId?;
    int studentStudentId?;
    time:Civil sessionTime?;
    int duration?;
    SessionStatus status?;
    boolean isBooked?;
|};

public type SessionWithRelations record {|
    *SessionOptionalized;
    TutorOptionalized tutor?;
    StudentOptionalized student?;
    PaymentOptionalized payment?;
|};

public type SessionTargetType typedesc<SessionWithRelations>;

public type SessionInsert record {|
    int tutorTutorId;
    int studentStudentId;
    time:Civil sessionTime;
    int duration;
    SessionStatus status;
    boolean isBooked;
|};

public type SessionUpdate record {|
    int tutorTutorId?;
    int studentStudentId?;
    time:Civil sessionTime?;
    int duration?;
    SessionStatus status?;
    boolean isBooked?;
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

public type Option record {|
    readonly int optionId;
    string text;
    boolean isCorrect;
    int questionQuestionId;
|};

public type OptionOptionalized record {|
    int optionId?;
    string text?;
    boolean isCorrect?;
    int questionQuestionId?;
|};

public type OptionWithRelations record {|
    *OptionOptionalized;
    QuestionOptionalized question?;
|};

public type OptionTargetType typedesc<OptionWithRelations>;

public type OptionInsert record {|
    string text;
    boolean isCorrect;
    int questionQuestionId;
|};

public type OptionUpdate record {|
    string text?;
    boolean isCorrect?;
    int questionQuestionId?;
|};

public type Question record {|
    readonly int questionId;
    string questionText;

    int quizQuizId;
|};

public type QuestionOptionalized record {|
    int questionId?;
    string questionText?;
    int quizQuizId?;
|};

public type QuestionWithRelations record {|
    *QuestionOptionalized;
    OptionOptionalized[] options?;
    QuizOptionalized quiz?;
|};

public type QuestionTargetType typedesc<QuestionWithRelations>;

public type QuestionInsert record {|
    string questionText;
    int quizQuizId;
|};

public type QuestionUpdate record {|
    string questionText?;
    int quizQuizId?;
|};

public type Quiz record {|
    readonly int quizId;

|};

public type QuizOptionalized record {|
    int quizId?;
|};

public type QuizWithRelations record {|
    *QuizOptionalized;
    QuestionOptionalized[] questions?;
    QuizTakenOptionalized quiztaken?;
|};

public type QuizTargetType typedesc<QuizWithRelations>;

public type QuizInsert record {|
|};

public type QuizUpdate record {|
|};

public type QuizTaken record {|
    readonly string studentId;
    readonly string quizId;
    int quizQuizId;
    int score;
    string submisstedDate;
|};

public type QuizTakenOptionalized record {|
    string studentId?;
    string quizId?;
    int quizQuizId?;
    int score?;
    string submisstedDate?;
|};

public type QuizTakenWithRelations record {|
    *QuizTakenOptionalized;
    QuizOptionalized quiz?;
|};

public type QuizTakenTargetType typedesc<QuizTakenWithRelations>;

public type QuizTakenInsert QuizTaken;

public type QuizTakenUpdate record {|
    int quizQuizId?;
    int score?;
    string submisstedDate?;
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
    SessionOptionalized[] sessions?;
    TutorNStudentOptionalized[] tutors?;
    ReviewOptionalized review?;
    AuthCredentialsOptionalized credentials?;
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

