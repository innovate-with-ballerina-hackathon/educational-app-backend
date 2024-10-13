
DELETE FROM `TutorNStudent`;
DELETE FROM `Review`;
DELETE FROM `Payment`;
DELETE FROM `Session`;
DELETE FROM `Tutor`;
DELETE FROM `QuizTaken`;
DELETE FROM `Option`;
DELETE FROM `Question`;
DELETE FROM `Quiz`;
DELETE FROM `Student`;
DELETE FROM `Subject`;


INSERT INTO `Subject` (`name`) VALUES
('Mathematics'),
('Physics'),
('Biology'),
('English'),
('Chemistry');


INSERT INTO `Student` (`studentId`, `firstName`, `lastName`, `email`, `password`) VALUES 
('STU001', 'John', 'Doe', 'john.doe@example.com', 'password123'),
('STU002', 'Jane', 'Smith', 'jane.smith@example.com', 'password456'),
('STU003', 'Alice', 'Johnson', 'alice.johnson@example.com', 'password789'),
('STU004', 'Bob', 'Williams', 'bob.williams@example.com', 'password321');


INSERT INTO `Quiz` (`quizId`) VALUES 
('QUIZ001'),
('QUIZ002'),
('QUIZ003'),
('QUIZ004');


INSERT INTO `Question` (`questionId`, `questionText`, `quizQuizId`) VALUES 
('QST001', 'What is 2 + 2?', 'QUIZ001'),
('QST002', 'What is the capital of France?', 'QUIZ002'),
('QST003', 'What is H2O commonly known as?', 'QUIZ003'),
('QST004', 'What is the square root of 16?', 'QUIZ004');


INSERT INTO `Option` (`optionId`, `text`, `isCorrect`, `questionQuestionId`) VALUES 
('OPT001', '3', FALSE, 'QST001'),
('OPT002', '4', TRUE, 'QST001'),
('OPT003', 'London', FALSE, 'QST002'),
('OPT004', 'Paris', TRUE, 'QST002'),
('OPT005', 'Water', TRUE, 'QST003'),
('OPT006', 'Oxygen', FALSE, 'QST003');

INSERT INTO `QuizTaken` (`studentId`, `quizId`, `score`, `submisstedDate`, `quizQuizId`) VALUES 
('STU001', 'QUIZ001', 80, '2024-10-01', 'QUIZ001'),
('STU002', 'QUIZ002', 90, '2024-10-02', 'QUIZ002'),
('STU003', 'QUIZ003', 70, '2024-10-03', 'QUIZ003');


INSERT INTO `Tutor` (`tutorId`, `firstName`, `lastName`, `email`, `password`, `experienceYears`, `price`, `subjectsSubjectId`) VALUES 
('TUT001', 'Michael', 'Brown', 'michael.brown@example.com', 'tutorpass123', 5, 30, 'SUB001'),
('TUT002', 'Emily', 'Davis', 'emily.davis@example.com', 'tutorpass456', 3, 25, 'SUB002'),
('TUT003', 'David', 'Wilson', 'david.wilson@example.com', 'tutorpass789', 10, 40, 'SUB003');

INSERT INTO `Session` (`sessionId`, `sessionTime`, `duration`, `status`, `isBooked`, `tutorTutorId`, `studentStudentId`) VALUES 
('SES001', '2024-10-05 10:00:00', 60, 'ENDED', TRUE, 'TUT001', 'STU001'),
('SES002', '2024-10-06 14:00:00', 60, 'SCHEDULED', FALSE, 'TUT002', 'STU002'),
('SES003', '2024-10-07 16:00:00', 60, 'ENDED', TRUE, 'TUT003', 'STU003');

INSERT INTO `Payment` (`paymentId`, `amount`, `status`, `paymentMethod`, `transactionDate`, `sessionSessionId`) VALUES 
('PAY001', 30, 'PAID', 'Credit Card', '2024-10-01', 'SES001'),
('PAY002', 25, 'PENDING', 'PayPal', '2024-10-02', 'SES002'),
('PAY003', 40, 'PAID', 'Debit Card', '2024-10-03', 'SES003');

INSERT INTO `Review` (`reviewId`, `review`, `starRating`, `studentStudentId`, `tutorTutorId`) VALUES 
('REV001', 'Great tutor!', 5, 'STU001', 'TUT001'),
('REV002', 'Very helpful.', 4, 'STU002', 'TUT002'),
('REV003', 'Learned a lot!', 5, 'STU003', 'TUT003');

INSERT INTO `TutorNStudent` (`id`, `tutorTutorId`, `studentStudentId`) VALUES 
('TNS001', 'TUT001', 'STU001'),
('TNS002', 'TUT002', 'STU002'),
('TNS003', 'TUT003', 'STU003');
