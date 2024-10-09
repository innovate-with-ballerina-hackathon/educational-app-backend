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
DROP TABLE IF EXISTS `Quiz`;
DROP TABLE IF EXISTS `Student`;
DROP TABLE IF EXISTS `Subject`;

CREATE TABLE `Subject` (
	`subjectId` VARCHAR(191) NOT NULL,
	`name` VARCHAR(191) NOT NULL,
	PRIMARY KEY(`subjectId`)
);

CREATE TABLE `Student` (
	`studentId` VARCHAR(191) NOT NULL,
	`firstName` VARCHAR(191) NOT NULL,
	`lastName` VARCHAR(191) NOT NULL,
	`email` VARCHAR(191) NOT NULL,
	`password` VARCHAR(191) NOT NULL,
	PRIMARY KEY(`studentId`)
);

CREATE TABLE `Quiz` (
	`quizId` VARCHAR(191) NOT NULL,
	PRIMARY KEY(`quizId`)
);

CREATE TABLE `Question` (
	`questionId` VARCHAR(191) NOT NULL,
	`questionText` VARCHAR(191) NOT NULL,
	`quizQuizId` VARCHAR(191) NOT NULL,
	FOREIGN KEY(`quizQuizId`) REFERENCES `Quiz`(`quizId`),
	PRIMARY KEY(`questionId`)
);

CREATE TABLE `Option` (
	`optionId` VARCHAR(191) NOT NULL,
	`text` VARCHAR(191) NOT NULL,
	`isCorrect` BOOLEAN NOT NULL,
	`questionQuestionId` VARCHAR(191) NOT NULL,
	FOREIGN KEY(`questionQuestionId`) REFERENCES `Question`(`questionId`),
	PRIMARY KEY(`optionId`)
);

CREATE TABLE `QuizTaken` (
	`studentId` VARCHAR(191) NOT NULL,
	`quizId` VARCHAR(191) NOT NULL,
	`score` INT NOT NULL,
	`submisstedDate` VARCHAR(191) NOT NULL,
	`quizQuizId` VARCHAR(191) UNIQUE NOT NULL,
	FOREIGN KEY(`quizQuizId`) REFERENCES `Quiz`(`quizId`),
	PRIMARY KEY(`studentId`,`quizId`)
);


CREATE TABLE `Tutor` (
	`tutorId` VARCHAR(191) NOT NULL,
	`firstName` VARCHAR(191) NOT NULL,
	`lastName` VARCHAR(191) NOT NULL,
	`email` VARCHAR(191) NOT NULL,
	`password` VARCHAR(191) NOT NULL,
	`experienceYears` INT NOT NULL,
	`price` INT NOT NULL,
	`subjectsSubjectId` VARCHAR(191) NOT NULL,
	FOREIGN KEY(`subjectsSubjectId`) REFERENCES `Subject`(`subjectId`),
	PRIMARY KEY(`tutorId`)
);

CREATE TABLE `Session` (
	`sessionId` VARCHAR(191) NOT NULL,
	`sessionTime` DATETIME NOT NULL,
	`duration` INT NOT NULL,
	`status` ENUM('SCHEDULED', 'CANCELLED', 'STARTED', 'ENDED') NOT NULL,
	`isBooked` BOOLEAN NOT NULL,
	`tutorTutorId` VARCHAR(191) NOT NULL,
	FOREIGN KEY(`tutorTutorId`) REFERENCES `Tutor`(`tutorId`),
	`studentStudentId` VARCHAR(191) NOT NULL,
	FOREIGN KEY(`studentStudentId`) REFERENCES `Student`(`studentId`),
	PRIMARY KEY(`sessionId`)
);

CREATE TABLE `Payment` (
	`paymentId` VARCHAR(191) NOT NULL,
	`amount` INT NOT NULL,
	`status` ENUM('PENDING', 'PAID') NOT NULL,
	`paymentMethod` VARCHAR(191) NOT NULL,
	`transactionDate` VARCHAR(191) NOT NULL,
	`sessionSessionId` VARCHAR(191) UNIQUE NOT NULL,
	FOREIGN KEY(`sessionSessionId`) REFERENCES `Session`(`sessionId`),
	PRIMARY KEY(`paymentId`)
);




CREATE TABLE `Review` (
	`reviewId` VARCHAR(191) NOT NULL,
	`review` VARCHAR(191) NOT NULL,
	`starRating` INT NOT NULL,
	`studentStudentId` VARCHAR(191) UNIQUE NOT NULL,
	FOREIGN KEY(`studentStudentId`) REFERENCES `Student`(`studentId`),
	`tutorTutorId` VARCHAR(191) NOT NULL,
	FOREIGN KEY(`tutorTutorId`) REFERENCES `Tutor`(`tutorId`),
	PRIMARY KEY(`reviewId`)
);

CREATE TABLE `TutorNStudent` (
	`id` VARCHAR(191) NOT NULL,
	`tutorTutorId` VARCHAR(191) NOT NULL,
	FOREIGN KEY(`tutorTutorId`) REFERENCES `Tutor`(`tutorId`),
	`studentStudentId` VARCHAR(191) NOT NULL,
	FOREIGN KEY(`studentStudentId`) REFERENCES `Student`(`studentId`),
	PRIMARY KEY(`id`)
);


