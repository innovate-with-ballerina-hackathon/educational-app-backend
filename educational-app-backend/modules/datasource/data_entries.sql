
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


INSERT INTO `AuthCredentials` (`userRole`, `accessToken`, `refreshToken`, `idToken`) VALUES 
('student', 'access_token_student_1', 'refresh_token_student_1', 'id_token_student_1'), 
('tutor', 'access_token_tutor_1', 'refresh_token_tutor_1', 'id_token_tutor_1'), 
('tutor', 'access_token_tutor_2', 'refresh_token_tutor_2', 'id_token_tutor_2'),
('student', 'access_token_student_4', 'refresh_token_student_4', 'id_token_student_4');

INSERT INTO `Student` (`firstName`, `lastName`, `email`, `credentialsCredId`) VALUES 
('John', 'Doe', 'john.doe@gmail.com', 1), 
('Jane', 'Smith', 'jane.smith@yahoo.com', 4);

INSERT INTO `Tutor` (`firstName`, `lastName`, `email`, `experienceYears`, `price`, `credentialsCredId`, `subjectSubjectId`) VALUES 
('Emily', 'Johnson', 'emily.johnson@tutor.com', 5, 30, 2, 1), 
('Michael', 'Brown', 'michael.brown@tutor.com', 8, 40, 3, 2);

INSERT INTO `Session` (`startingTime`, `endingTime`, `status`, `eventId`, `tutorTutorId`) VALUES 
('2024-10-20 10:00:00', '2024-10-20 11:00:00', 'SCHEDULED', 'event_12345', 1), 
('2024-10-21 14:00:00', '2024-10-21 15:00:00', 'BOOKED', 'event_67890', 2);

INSERT INTO `Booking` (`sessionSessionId`, `studentStudentId`) VALUES 
(1, 1), 
(2, 2);

INSERT INTO `Document` (`filepath`, `title`, `description`, `category`, `tutorTutorId`) VALUES 
('/docs/math_intro.pdf', 'Introduction to Mathematics', 'Basics of Algebra and Geometry', 'GEOMETRY', 1), 
('/docs/physics_mechanics.pdf', 'Mechanics in Physics', 'Understanding motion and forces', 'PHYSICS', 2);

INSERT INTO `Review` (`review`, `starRating`, `studentStudentId`, `tutorTutorId`) VALUES 
('Great tutor, explained everything clearly!', 5, 1, 1), 
('Very patient and knowledgeable.', 4, 2, 2);

INSERT INTO `TutorNStudent` (`tutorTutorId`, `studentStudentId`) VALUES 
(1, 1), 
(2, 2);
