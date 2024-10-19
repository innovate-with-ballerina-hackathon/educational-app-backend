import ballerina/persist as _;
import ballerina/time;
import ballerinax/persist.sql;

// public type Payment record {|
//     @sql:Generated
//     readonly int paymentId;
//     int amount;
//     PaymentStatus status;
//     string paymentMethod;
//     string transactionDate;
//     Session session;
// |};

// public enum PaymentStatus {
//     PENDING, 
//     PAID
// }

public type Session record {|
    @sql:Generated
    readonly int sessionId;
    Tutor tutor;
    time:Civil startingTime;
    time:Civil endingTime;
    SessionStatus status;
    string eventId;
    Booking? booking;
    
|};

public type Booking record {|
    @sql:Generated
    readonly int bookingId;
    Session session;
    Student student;
|};

public enum SessionStatus {
    SCHEDULED,
    BOOKED,
    CANCELLED,
    ENDED   
}


public type Review record {|
    @sql:Generated
    readonly int reviewId;
    string review;
    int starRating;
    Student student;
	Tutor tutor;    
|};

public type AuthCredentials record {|
    @sql:Generated
    readonly int credId;
    string userRole;
    @sql:Varchar {length: 255}
    @sql:UniqueIndex {name: "access_token"}
    string accessToken;
    @sql:Varchar {length: 255}
    string refreshToken;
    @sql:Varchar {length: 1024}
    string idToken;
	Tutor? tutor;
	Student? student;

|};

public type Tutor record {|
    @sql:Generated
    readonly int tutorId;
    string firstName;
    string lastName;
    @sql:UniqueIndex {name: "tutor_email"}
    string email;
    TutorNStudent[] students;
    Session[] sessions;
    Review[] reviews;
    AuthCredentials credentials;
	Subject subject;
    int? experienceYears;
    int? price;
    Document? document;
|};

public type Subject record {|
    @sql:Generated
    readonly int subjectId;
    string name;
	Tutor[] tutors;   
|};

// public type Option record {|
//     @sql:Generated
//     readonly int optionId;
//     string text;
//     boolean isCorrect;
// 	Question question;
    
// |};

// public type Question record {|
//     @sql:Generated
//     readonly int questionId;
//     string questionText;
//     Option[] options;
// 	Quiz quiz;
// |};

// public type Quiz record {|
//     @sql:Generated
//     readonly int quizId;
//     Question[] questions;
// 	QuizTaken? quiztaken;    
// |};

// public type QuizTaken record {|
//     readonly string studentId;
//     readonly string quizId;
//     Quiz quiz;
//     int score;
//     string submisstedDate;  
// |};

public type Student record{|
    @sql:Generated
    readonly int studentId;
    string firstName;
    string lastName;
    @sql:UniqueIndex {name: "student_email"}
    string email;
    TutorNStudent[] tutors;
	Review? review;
    AuthCredentials credentials;
    Booking[] booking;
    
|};

public type TutorNStudent record {| 
    @sql:Generated
    readonly int id;
    Tutor tutor;
    Student student;
|};

public enum Category {
    ASTRO, 
    PHYSICS,
    CHEMISTRY,
    GEOMETRY,
    ENGLISH,
    FRENCH,
    GERMAN,
    BIOLOGY   
};


public type Document record {|
    @sql:Generated
    readonly int id;
    string filepath;
    string title;
    string description;
    Category category;
    Tutor tutor;    
|};