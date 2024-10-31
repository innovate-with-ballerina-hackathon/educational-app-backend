
DELETE FROM `TutorNStudent`;
DELETE FROM `Review`;
DELETE FROM `Booking`;
DELETE FROM `Session`;
DELETE FROM `Document`;
DELETE FROM `Tutor`;
DELETE FROM `Student`;
DELETE FROM `Subject`;
DELETE FROM `AuthCredentials`;

INSERT INTO `Subject` (`name`) VALUES
('Mathematics'),
('Physics'),
('Biology'),
('English'),
('Chemistry');

INSERT INTO `AuthCredentials` (`userRole`, `accessToken`, `refreshToken`, `idToken`) VALUES 
('student', 'access_token_student_1', 'refresh_token_student_1', 'id_token_student_1'), 
('tutor', 'access_token_tutor_1', 'refresh_token_tutor_1', 'id_token_tutor_1'), 
('tutor', 'access_token_tutor_2', 'refresh_token_tutor_2', 'id_token_tutor_2'),
('student', 'access_token_student_4', 'refresh_token_student_4', 'id_token_student_4');

INSERT INTO `Student` (`firstName`, `lastName`, `email`, `subscribedCategory`, `credentialsCredId`) VALUES
('Alice', 'Smith', 'alice@example.com', 'MATHS', 1),
('Bob', 'Brown', 'bob@example.com', 'NOT_SPECIFIED', 4);

INSERT INTO `Tutor` (`firstName`, `lastName`, `email`, `experienceYears`, `price`, `credentialsCredId`, `subjectSubjectId`) VALUES
('Charlie', 'Johnson', 'charlie@example.com', 5, 50, 2, 1),
('David', 'Lee', 'david@example.com', 3, 40, 3, 2);

INSERT INTO `Session` (`startingTime`, `endingTime`, `status`, `eventId`, `timeZoneOffset`, `utcOffset`, `tutorTutorId`) VALUES
('2024-11-01 10:00:00', '2024-11-01 12:00:00', 'SCHEDULED', 'event_123', 'Asia/Colombo', '+05:30', 1),
('2024-11-02 14:00:00', '2024-11-02 16:00:00', 'BOOKED', 'event_456', 'Asia/Colombo', '+05:30', 2);

INSERT INTO `Booking` (`sessionSessionId`, `studentStudentId`) VALUES 
(1, 2), 
(2, 1);

INSERT INTO `Document` (`fileName`, `title`, `description`, `category`, `tutorTutorId`) VALUES
('doc_math.pdf', 'Maths Basics', 'Introduction to basic maths concepts', 'MATHS', 1),
('doc_physics.pdf', 'Physics Fundamentals', 'Core concepts in physics', 'PHYSICS', 2);

INSERT INTO `Review` (`review`, `starRating`, `studentStudentId`, `tutorTutorId`) VALUES 
('Great tutor, explained everything clearly!', 5, 1, 1), 
('Very patient and knowledgeable.', 4, 2, 2);

INSERT INTO `TutorNStudent` (`tutorTutorId`, `studentStudentId`) VALUES 
(2, 1), 
(1, 2);
