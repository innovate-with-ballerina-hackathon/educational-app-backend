// AUTO-GENERATED FILE. DO NOT MODIFY.

// This file is an auto-generated file by Ballerina persistence layer for model.
// It should not be modified by hand.

public type Payment record {|
    readonly string paymentId;
    int amount;
    string status;
    string paymentMethod;
    string transactionDate;
    string sessionSessionId;
|};

public type PaymentOptionalized record {|
    string paymentId?;
    int amount?;
    string status?;
    string paymentMethod?;
    string transactionDate?;
    string sessionSessionId?;
|};

public type PaymentWithRelations record {|
    *PaymentOptionalized;
    SessionOptionalized session?;
|};

public type PaymentTargetType typedesc<PaymentWithRelations>;

public type PaymentInsert Payment;

public type PaymentUpdate record {|
    int amount?;
    string status?;
    string paymentMethod?;
    string transactionDate?;
    string sessionSessionId?;
|};

public type Session record {|
    readonly string sessionId;
    string tutorTutorId;
    string studentStudentId;
    string date;
    string startTime;
    string endTime;
    string status;

    boolean isBooked;
|};

public type SessionOptionalized record {|
    string sessionId?;
    string tutorTutorId?;
    string studentStudentId?;
    string date?;
    string startTime?;
    string endTime?;
    string status?;
    boolean isBooked?;
|};

public type SessionWithRelations record {|
    *SessionOptionalized;
    TutorOptionalized tutor?;
    StudentOptionalized student?;
    PaymentOptionalized payment?;
|};

public type SessionTargetType typedesc<SessionWithRelations>;

public type SessionInsert Session;

public type SessionUpdate record {|
    string tutorTutorId?;
    string studentStudentId?;
    string date?;
    string startTime?;
    string endTime?;
    string status?;
    boolean isBooked?;
|};

public type Tutor record {|
    readonly string tutorId;
    string firstName;
    string lastName;
    string email;
    string password;

    string subjectsSubjectId;

    int experienceYears;
|};

public type TutorOptionalized record {|
    string tutorId?;
    string firstName?;
    string lastName?;
    string email?;
    string password?;
    string subjectsSubjectId?;
    int experienceYears?;
|};

public type TutorWithRelations record {|
    *TutorOptionalized;
    TutorNStudentOptionalized[] students?;
    SubjectOptionalized subjects?;
    SessionOptionalized[] sessions?;
|};

public type TutorTargetType typedesc<TutorWithRelations>;

public type TutorInsert Tutor;

public type TutorUpdate record {|
    string firstName?;
    string lastName?;
    string email?;
    string password?;
    string subjectsSubjectId?;
    int experienceYears?;
|};

public type Subject record {|
    readonly string subjectId;
    string name;

|};

public type SubjectOptionalized record {|
    string subjectId?;
    string name?;
|};

public type SubjectWithRelations record {|
    *SubjectOptionalized;
    TutorOptionalized[] tutors?;
|};

public type SubjectTargetType typedesc<SubjectWithRelations>;

public type SubjectInsert Subject;

public type SubjectUpdate record {|
    string name?;
|};

public type Option record {|
    readonly string optionId;
    string text;
    boolean isCorrect;
    string questionQuestionId;
|};

public type OptionOptionalized record {|
    string optionId?;
    string text?;
    boolean isCorrect?;
    string questionQuestionId?;
|};

public type OptionWithRelations record {|
    *OptionOptionalized;
    QuestionOptionalized question?;
|};

public type OptionTargetType typedesc<OptionWithRelations>;

public type OptionInsert Option;

public type OptionUpdate record {|
    string text?;
    boolean isCorrect?;
    string questionQuestionId?;
|};

public type Question record {|
    readonly string questionId;
    string questionText;

    string quizQuizId;
|};

public type QuestionOptionalized record {|
    string questionId?;
    string questionText?;
    string quizQuizId?;
|};

public type QuestionWithRelations record {|
    *QuestionOptionalized;
    OptionOptionalized[] options?;
    QuizOptionalized quiz?;
|};

public type QuestionTargetType typedesc<QuestionWithRelations>;

public type QuestionInsert Question;

public type QuestionUpdate record {|
    string questionText?;
    string quizQuizId?;
|};

public type Quiz record {|
    readonly string quizId;

|};

public type QuizOptionalized record {|
    string quizId?;
|};

public type QuizWithRelations record {|
    *QuizOptionalized;
    QuestionOptionalized[] questions?;
    QuizTakenOptionalized quiztaken?;
|};

public type QuizTargetType typedesc<QuizWithRelations>;

public type QuizInsert Quiz;

public type QuizUpdate record {|
|};

public type QuizTaken record {|
    readonly string studentId;
    readonly string quizId;
    string quizQuizId;
    int score;
    string submisstedDate;
|};

public type QuizTakenOptionalized record {|
    string studentId?;
    string quizId?;
    string quizQuizId?;
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
    string quizQuizId?;
    int score?;
    string submisstedDate?;
|};

public type Student record {|
    readonly string studentId;
    string firstName;
    string lastName;
    string email;
    string password;

|};

public type StudentOptionalized record {|
    string studentId?;
    string firstName?;
    string lastName?;
    string email?;
    string password?;
|};

public type StudentWithRelations record {|
    *StudentOptionalized;
    SessionOptionalized[] sessions?;
    TutorNStudentOptionalized[] tutors?;
|};

public type StudentTargetType typedesc<StudentWithRelations>;

public type StudentInsert Student;

public type StudentUpdate record {|
    string firstName?;
    string lastName?;
    string email?;
    string password?;
|};

public type TutorNStudent record {|
    readonly string id;
    string tutorTutorId;
    string studentStudentId;
|};

public type TutorNStudentOptionalized record {|
    string id?;
    string tutorTutorId?;
    string studentStudentId?;
|};

public type TutorNStudentWithRelations record {|
    *TutorNStudentOptionalized;
    TutorOptionalized tutor?;
    StudentOptionalized student?;
|};

public type TutorNStudentTargetType typedesc<TutorNStudentWithRelations>;

public type TutorNStudentInsert TutorNStudent;

public type TutorNStudentUpdate record {|
    string tutorTutorId?;
    string studentStudentId?;
|};

