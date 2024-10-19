-- AUTO-GENERATED FILE.

-- This file is an auto-generated file by Ballerina persistence layer for model.
-- Please verify the generated scripts and execute them against the target DB server.

DROP TABLE IF EXISTS `TutorNStudent`;
DROP TABLE IF EXISTS `Review`;
DROP TABLE IF EXISTS `Document`;
DROP TABLE IF EXISTS `Session`;
DROP TABLE IF EXISTS `Tutor`;
DROP TABLE IF EXISTS `Booking`;
DROP TABLE IF EXISTS `Student`;
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

CREATE TABLE `Student` (
	`studentId` INT AUTO_INCREMENT,
	`firstName` VARCHAR(191) NOT NULL,
	`lastName` VARCHAR(191) NOT NULL,
	`email` VARCHAR(191) NOT NULL,
	`credentialsCredId` INT UNIQUE NOT NULL,
	FOREIGN KEY(`credentialsCredId`) REFERENCES `AuthCredentials`(`credId`),
	PRIMARY KEY(`studentId`)
);

CREATE TABLE `Booking` (
	`bookingId` INT AUTO_INCREMENT,
	`sessionSessionId` INT UNIQUE NOT NULL,
	FOREIGN KEY(`sessionSessionId`) REFERENCES `Session`(`sessionId`),
	`studentStudentId` INT NOT NULL,
	FOREIGN KEY(`studentStudentId`) REFERENCES `Student`(`studentId`),
	PRIMARY KEY(`bookingId`)
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
	`startingTime` DATETIME NOT NULL,
	`endingTime` DATETIME NOT NULL,
	`status` ENUM('SCHEDULED', 'BOOKED', 'CANCELLED', 'ENDED') NOT NULL,
	`eventId` VARCHAR(191) NOT NULL,
	`tutorTutorId` INT NOT NULL,
	FOREIGN KEY(`tutorTutorId`) REFERENCES `Tutor`(`tutorId`),
	PRIMARY KEY(`sessionId`)
);

CREATE TABLE `Document` (
	`id` INT AUTO_INCREMENT,
	`filepath` VARCHAR(191) NOT NULL,
	`title` VARCHAR(191) NOT NULL,
	`description` VARCHAR(191) NOT NULL,
	`category` ENUM('ASTRO', 'PHYSICS', 'CHEMISTRY', 'GEOMETRY', 'ENGLISH', 'FRENCH', 'GERMAN', 'BIOLOGY') NOT NULL,
	`tutorTutorId` INT UNIQUE NOT NULL,
	FOREIGN KEY(`tutorTutorId`) REFERENCES `Tutor`(`tutorId`),
	PRIMARY KEY(`id`)
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


CREATE UNIQUE INDEX `access_token` ON `AuthCredentials` (`accessToken`);
CREATE UNIQUE INDEX `tutor_email` ON `Tutor` (`email`);
CREATE UNIQUE INDEX `student_email` ON `Student` (`email`);
