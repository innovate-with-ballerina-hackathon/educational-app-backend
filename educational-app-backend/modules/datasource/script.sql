-- AUTO-GENERATED FILE.

-- This file is an auto-generated file by Ballerina persistence layer for model.
-- Please verify the generated scripts and execute them against the target DB server.

DROP TABLE IF EXISTS `TutorNStudent`;
DROP TABLE IF EXISTS `Review`;
DROP TABLE IF EXISTS `Payment`;
DROP TABLE IF EXISTS `Session`;
DROP TABLE IF EXISTS `Tutor`;
DROP TABLE IF EXISTS `QuizTaken`;
DROP TABLE IF EXISTS `Option`;
DROP TABLE IF EXISTS `Question`;
DROP TABLE IF EXISTS `Student`;
DROP TABLE IF EXISTS `Quiz`;
DROP TABLE IF EXISTS `AuthCredentials`;
DROP TABLE IF EXISTS `Subject`;

CREATE TABLE `Subject` (
	`subjectId` INT AUTO_INCREMENT,
	`name` VARCHAR(191) NOT NULL,
	PRIMARY KEY(`subjectId`)
);

CREATE TABLE `AuthCredentials` (
	`credId` INT AUTO_INCREMENT,
	`userRole` VARCHAR(191) NOT NULL,
	`accessToken` VARCHAR(255) NOT NULL,
	`refreshToken` VARCHAR(255) NOT NULL,
	`idToken` VARCHAR(1024) NOT NULL,
	PRIMARY KEY(`credId`)
);

CREATE TABLE `Quiz` (
	`quizId` INT AUTO_INCREMENT,
	PRIMARY KEY(`quizId`)
);

CREATE TABLE `Student` (
	`studentId` INT AUTO_INCREMENT,
	`firstName` VARCHAR(191) NOT NULL,
	`lastName` VARCHAR(191) NOT NULL,
	`email` VARCHAR(191) NOT NULL,
	`credentialsCredId` INT UNIQUE NOT NULL,
	FOREIGN KEY(`credentialsCredId`) REFERENCES `AuthCredentials`(`credId`),
	PRIMARY KEY(`studentId`)
);

CREATE TABLE `Question` (
	`questionId` INT AUTO_INCREMENT,
	`questionText` VARCHAR(191) NOT NULL,
	`quizQuizId` INT NOT NULL,
	FOREIGN KEY(`quizQuizId`) REFERENCES `Quiz`(`quizId`),
	PRIMARY KEY(`questionId`)
);

CREATE TABLE `Option` (
	`optionId` INT AUTO_INCREMENT,
	`text` VARCHAR(191) NOT NULL,
	`isCorrect` BOOLEAN NOT NULL,
	`questionQuestionId` INT NOT NULL,
	FOREIGN KEY(`questionQuestionId`) REFERENCES `Question`(`questionId`),
	PRIMARY KEY(`optionId`)
);

CREATE TABLE `QuizTaken` (
	`studentId` VARCHAR(191) NOT NULL,
	`quizId` VARCHAR(191) NOT NULL,
	`score` INT NOT NULL,
	`submisstedDate` VARCHAR(191) NOT NULL,
	`quizQuizId` INT UNIQUE NOT NULL,
	FOREIGN KEY(`quizQuizId`) REFERENCES `Quiz`(`quizId`),
	PRIMARY KEY(`studentId`,`quizId`)
);



CREATE TABLE `Tutor` (
	`tutorId` INT AUTO_INCREMENT,
	`firstName` VARCHAR(191) NOT NULL,
	`lastName` VARCHAR(191) NOT NULL,
	`email` VARCHAR(191) NOT NULL,
	`experienceYears` INT,
	`price` INT,
	`credentialsCredId` INT UNIQUE NOT NULL,
	FOREIGN KEY(`credentialsCredId`) REFERENCES `AuthCredentials`(`credId`),
	`subjectSubjectId` INT NOT NULL,
	FOREIGN KEY(`subjectSubjectId`) REFERENCES `Subject`(`subjectId`),
	PRIMARY KEY(`tutorId`)
);

CREATE TABLE `Session` (
	`sessionId` INT AUTO_INCREMENT,
	`sessionTime` DATETIME NOT NULL,
	`duration` INT NOT NULL,
	`status` ENUM('SCHEDULED', 'CANCELLED', 'STARTED', 'ENDED') NOT NULL,
	`isBooked` BOOLEAN NOT NULL,
	`tutorTutorId` INT NOT NULL,
	FOREIGN KEY(`tutorTutorId`) REFERENCES `Tutor`(`tutorId`),
	`studentStudentId` INT NOT NULL,
	FOREIGN KEY(`studentStudentId`) REFERENCES `Student`(`studentId`),
	PRIMARY KEY(`sessionId`)
);

CREATE TABLE `Payment` (
	`paymentId` INT AUTO_INCREMENT,
	`amount` INT NOT NULL,
	`status` ENUM('PENDING', 'PAID') NOT NULL,
	`paymentMethod` VARCHAR(191) NOT NULL,
	`transactionDate` VARCHAR(191) NOT NULL,
	`sessionSessionId` INT UNIQUE NOT NULL,
	FOREIGN KEY(`sessionSessionId`) REFERENCES `Session`(`sessionId`),
	PRIMARY KEY(`paymentId`)
);

CREATE TABLE `Review` (
	`reviewId` INT AUTO_INCREMENT,
	`review` VARCHAR(191) NOT NULL,
	`starRating` INT NOT NULL,
	`studentStudentId` INT UNIQUE NOT NULL,
	FOREIGN KEY(`studentStudentId`) REFERENCES `Student`(`studentId`),
	`tutorTutorId` INT NOT NULL,
	FOREIGN KEY(`tutorTutorId`) REFERENCES `Tutor`(`tutorId`),
	PRIMARY KEY(`reviewId`)
);

CREATE TABLE `TutorNStudent` (
	`id` INT AUTO_INCREMENT,
	`tutorTutorId` INT NOT NULL,
	FOREIGN KEY(`tutorTutorId`) REFERENCES `Tutor`(`tutorId`),
	`studentStudentId` INT NOT NULL,
	FOREIGN KEY(`studentStudentId`) REFERENCES `Student`(`studentId`),
	PRIMARY KEY(`id`)
);


CREATE UNIQUE INDEX `tutor_email` ON `Tutor` (`email`);
CREATE UNIQUE INDEX `student_email` ON `Student` (`email`);
