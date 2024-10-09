import ballerina/persist as _;
import ballerina/time;

public type Payment record {|
    readonly string paymentId;
    int amount;
    PaymentStatus status;
    string paymentMethod;
    string transactionDate;
    Session session;
|};

public enum PaymentStatus {
    PENDING, 
    PAID
}

public type Session record {|
    readonly string sessionId;
    Tutor tutor;
    Student student;
    time:Civil sessionTime;
    int duration;
    SessionStatus status;
    Payment? payment;
    boolean isBooked;
    
|};

public enum SessionStatus {
    SCHEDULED, 
    CANCELLED,
    STARTED,
    ENDED   
}


public type Review record {|
    readonly string reviewId;
    string review;
    int starRating;
    Student student;
	Tutor tutor;    
|};

public type Tutor record {|
    readonly string tutorId;
    string firstName;
    string lastName;
    string email;
    string password;
    TutorNStudent[] students;
    Subject subjects;
    Session[] sessions;
    int experienceYears;
    int price;
    Review[] reviews;
    
|};

public type Subject record {|
    readonly string subjectId;
    string name;
    Tutor[] tutors;   
|};

public type Option record {|
    readonly string optionId;
    string text;
    boolean isCorrect;
	Question question;
    
|};

public type Question record {|
    readonly string questionId;
    string questionText;
    Option[] options;
	Quiz quiz;
|};

public type Quiz record {|
    readonly string quizId;
    Question[] questions;
	QuizTaken? quiztaken;    
|};

public type QuizTaken record {|
    readonly string studentId;
    readonly string quizId;
    Quiz quiz;
    int score;
    string submisstedDate;  
|};

public type Student record{|
    readonly string studentId;
    string firstName;
    string lastName;
    string email;
    string password;
    Session[] sessions;
    TutorNStudent[] tutors;
	Review? review;
    
|};

public type TutorNStudent record {| 
    readonly string id;
    Tutor tutor;
    Student student;
|};
