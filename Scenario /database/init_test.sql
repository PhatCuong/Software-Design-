DROP DATABASE IF EXISTS vgu6_test;
CREATE DATABASE vgu6_test;
USE vgu6_test;

CREATE TABLE IF NOT EXISTS AcademicYear (
	AYearPK INT NOT NULL AUTO_INCREMENT,
    AYearId VARCHAR(10) NOT NULL,

    PRIMARY KEY (AYearPK),
    CONSTRAINT AcademicYear
    UNIQUE (AYearId)
    
);
CREATE TABLE IF NOT EXISTS Semester (
	SemesterPK INT NOT NULL AUTO_INCREMENT,
	SemesterId VARCHAR(10) NOT NULL,
    SemYear INT NOT NULL,

    PRIMARY KEY(SemesterPK),
	FOREIGN KEY (SemYear)
		REFERENCES AcademicYear (AYearPK)
        ON DELETE CASCADE,
	CONSTRAINT Semester
    UNIQUE (SemesterId)
);

CREATE TABLE IF NOT EXISTS Faculty (
	FacultyPK INT NOT NULL AUTO_INCREMENT,
    FacultyId VARCHAR(10) NOT NULL,
	FacultyName VARCHAR(100) NOT NULL,

    PRIMARY KEY (FacultyPK),
    CONSTRAINT Faculty
    UNIQUE (FacultyId)
);

CREATE TABLE IF NOT EXISTS FacultyInAcademicYear (
	FA_PK INT NOT NULL AUTO_INCREMENT,
	FacultyFK INT,
    FalYear INT,

    PRIMARY KEY(FA_PK),
	FOREIGN KEY (FacultyFK)
		REFERENCES Faculty (FacultyPK)
        ON DELETE CASCADE,
	FOREIGN KEY (FalYear)
		REFERENCES AcademicYear (AYearPK)
        ON DELETE CASCADE,
	CONSTRAINT FacultyInAcademicYear
    UNIQUE (FacultyFK,FalYear)
);

CREATE TABLE IF NOT EXISTS Program (
	ProgramPK INT NOT NULL AUTO_INCREMENT,
    ProgramId VARCHAR(10) NOT NULL,
    ProgramName VARCHAR(100) NOT NULL,

    PRIMARY KEY (ProgramPK),
	CONSTRAINT Program
    UNIQUE (ProgramId)
);

CREATE TABLE IF NOT EXISTS ProgramInFacultyInAcademicYear (
	PFA_PK INT NOT NULL AUTO_INCREMENT,
	ProgramFK INT,
    FacultyYear INT,
    PRIMARY KEY(PFA_PK),
	FOREIGN KEY (ProgramFK)
		REFERENCES Program (ProgramPK)
        ON DELETE CASCADE,
	FOREIGN KEY (FacultyYear)
		REFERENCES FacultyInAcademicYear (FA_PK)
        ON DELETE CASCADE,
	CONSTRAINT ProgramInFacultyInAcademicYear
		UNIQUE (ProgramFK,FacultyYear)
        
);

CREATE TABLE IF NOT EXISTS Module (
	ModulePK INT NOT NULL AUTO_INCREMENT,
    ModuleId VARCHAR(10) NOT NULL,
    ModuleName VARCHAR(100) NOT NULL,

	PRIMARY KEY (ModulePK),
    CONSTRAINT Module
    UNIQUE (ModuleId)
);

CREATE TABLE IF NOT EXISTS ModuleInProgramInAcademicYear (
    MPA_PK INT NOT NULL AUTO_INCREMENT,
	ModuleFK INT,
	ProgramFacultyYear INT,
    PRIMARY KEY(MPA_PK),
	FOREIGN KEY (ModuleFK)
		REFERENCES Module (ModulePK)
        ON DELETE CASCADE,
	FOREIGN KEY (ProgramFacultyYear)
		REFERENCES ProgramInFacultyInAcademicYear (PFA_PK)
        ON DELETE CASCADE,
	CONSTRAINT ModuleInProgramInAcademicYear
		UNIQUE (ModuleFK,ProgramFacultyYear)
);

CREATE TABLE IF NOT EXISTS Class (
	ClassPK INT NOT NULL AUTO_INCREMENT,
    ClassId VARCHAR(10) NOT NULL,
    Size INT NOT NULL,
    ClassSemester INT NOT NULL,
    ClassModule INT NOT NULL,

    PRIMARY KEY (ClassPK,ClassSemester,ClassModule),
    FOREIGN KEY (ClassSemester)
		REFERENCES Semester (SemesterPK)
        ON DELETE CASCADE,
	FOREIGN KEY (ClassModule)
		REFERENCES ModuleInProgramInAcademicYear (MPA_PK)
        ON DELETE CASCADE,
	CONSTRAINT Class
		UNIQUE (ClassId)
);

CREATE TABLE IF NOT EXISTS Users (
	UserPK INT NOT NULL AUTO_INCREMENT,
    UserName VARCHAR(20) NOT NULL,

    PRIMARY KEY (UserPK),
    CONSTRAINT Users
    UNIQUE (UserName)
);

CREATE TABLE IF NOT EXISTS Lecturer (
	LecturerPK INT NOT NULL AUTO_INCREMENT,
    LecturerId VARCHAR(10) NOT NULL,
    LecturerName VARCHAR(100) NOT NULL,
    LecturerUser INT NOT NULL,
	PRIMARY KEY (LecturerPK),
    FOREIGN KEY (LecturerUser)
    REFERENCES Users (UserPK)
    ON DELETE CASCADE,
    CONSTRAINT LecturerUserUnique
    UNIQUE (LecturerId,LecturerUser)
);

CREATE TABLE IF NOT EXISTS Teaching (
	Teaching_PK INT NOT NULL AUTO_INCREMENT,
    LecturerT INT,
    ClassT INT,

    PRIMARY KEY (Teaching_PK),
    FOREIGN KEY (LecturerT)
		REFERENCES Lecturer (LecturerPK)
        ON DELETE CASCADE,
	FOREIGN KEY (ClassT)
		REFERENCES Class (ClassPK)
        ON DELETE CASCADE,
	CONSTRAINT Teaching
    UNIQUE (LecturerT,ClassT)
);

CREATE TABLE IF NOT EXISTS Credentials (
	UserCredential INT NOT NULL,
    password_hash VARCHAR(128),
    password_salt VARCHAR(16),

    PRIMARY KEY (UserCredential),
        FOREIGN KEY (UserCredential)
		REFERENCES Users (UserPK)
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS ProgramCoordinator (
	CoordinatorPK INT NOT NULL AUTO_INCREMENT,
	CoordinatorUser INT NOT NULL,
    ProgramPK INT NOT NULL,
    CoordinatorName VARCHAR(100) NOT NULL,
	StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    PRIMARY KEY(CoordinatorPK),
	FOREIGN KEY (CoordinatorUser) 
    REFERENCES Users (UserPK)
    ON DELETE CASCADE,
	FOREIGN KEY (ProgramPK)
    REFERENCES Program (ProgramPK)
    ON DELETE CASCADE,
    CONSTRAINT ProgramCoordinatorUser
    UNIQUE (CoordinatorPK,CoordinatorUser)
);

CREATE TABLE IF NOT EXISTS Dean (
	DeanPK INT NOT NULL AUTO_INCREMENT,
	DeanUser INT NOT NULL,
    FacultyPK INT NOT NULL,
    DeanName VARCHAR(100) NOT NULL,
	StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    PRIMARY KEY(DeanPK),
	FOREIGN KEY (FacultyPK)
    REFERENCES Faculty (FacultyPK)
    ON DELETE CASCADE,
    FOREIGN KEY (DeanUser)
    REFERENCES Users (UserPK),
    CONSTRAINT DeanUserUnique
    UNIQUE (DeanPK,DeanUser)
);

CREATE TABLE IF NOT EXISTS Questionnaire (
	QuestionnairePK INT NOT NULL AUTO_INCREMENT,
    ClassAndLecturer INT NOT NULL,
    Gender ENUM('M','F','O') NOT NULL,
    Question0 ENUM('1','2','3','4','5') NOT NULL,
	Question1 ENUM('1','2','3','4','5','N/A') NOT NULL,
    Question2 ENUM('1','2','3','4','5','N/A') NOT NULL,
    Question3 ENUM('1','2','3','4','5','N/A') NOT NULL,
    Question4 ENUM('1','2','3','4','5','N/A') NOT NULL,
    Question5 ENUM('1','2','3','4','5') NOT NULL,
    Question6 ENUM('1','2','3','4','5') NOT NULL,
    Question7 ENUM('1','2','3','4','5') NOT NULL,
    Question8 ENUM('1','2','3','4','5','N/A') NOT NULL,
    Question9 ENUM('1','2','3','4','5','N/A') NOT NULL,
    Question10 ENUM('1','2','3','4','5','N/A') NOT NULL,
    Question11 ENUM('1','2','3','4','5','N/A') NOT NULL,
    Question12 ENUM('1','2','3','4','5','N/A') NOT NULL,
    Question13 ENUM('1','2','3','4','5','N/A') NOT NULL,
    Question14 ENUM('1','2','3','4','5','N/A') NOT NULL,
    Question15 ENUM('1','2','3','4','5','N/A') NOT NULL,
    Question16 ENUM('1','2','3','4','5','N/A') NOT NULL,
    Question17 ENUM('1','2','3','4','5','N/A') NOT NULL,
    Comment TEXT,
    PRIMARY KEY (QuestionnairePK,ClassAndLecturer),
    FOREIGN KEY (ClassAndLecturer)
		REFERENCES Teaching (Teaching_PK)
	ON DELETE CASCADE
);

/*Trigger to auto_increment QID based on LID-CID*/
DELIMITER $$

CREATE TRIGGER QID_AutoIncrement BEFORE INSERT ON Questionnaire
FOR EACH ROW BEGIN
    SELECT MAX(QuestionnairePK) INTO @auto_id
    FROM Questionnaire
    where ClassAndLecturer = NEW.ClassAndLecturer;
    SET NEW.questionnairePK = COALESCE(@AUTO_ID +1,1);

END $$

DELIMITER ;
DELIMITER //
DROP PROCEDURE IF EXISTS AddCredential //
CREATE PROCEDURE AddCredential (
    IN inUserName VARCHAR(20),
    IN inPassword VARCHAR(500),
    OUT statusCode INT
)
BEGIN
	DECLARE Salt VARCHAR(20);
    CASE
        WHEN inUserName IN (SELECT UserName FROM Users) THEN SET statusCode = 491; -- ACCOUNT already exists
        ELSE SET statusCode = 200;-- SUCCESS
		SET Salt = LEFT(TO_BASE64(MD5(RAND())), 16);
		INSERT INTO Users (UserName) VALUES (inUserName);
		INSERT INTO Credentials (UserCredential, password_hash, password_salt) VALUES (LAST_INSERT_ID(),(SHA2(CONCAT(inPassword, Salt), 512)), Salt);
    END CASE;
END //

DROP PROCEDURE IF EXISTS CheckCredential //
CREATE PROCEDURE CheckCredential (
    IN inUserName VARCHAR(20),
    IN inPassword VARCHAR(500),
    OUT Result BOOLEAN
)
BEGIN
    CASE
		WHEN inUserName NOT IN (SELECT UserName FROM Users) THEN SET Result = 0; -- ACCOUNT do not exists
		WHEN inUserName IN (SELECT UserName FROM Users)
        AND (SHA2(CONCAT(inPassword, (SELECT password_salt FROM Credentials NATURAL JOIN Users WHERE UserName = inUserName)), 512)) != (SELECT password_hash FROM Credentials NATURAL JOIN Users WHERE UserName = inUserName)
        THEN SET Result = 0;
        ELSE SET Result = 1;
    END CASE;
END //

DELIMITER ;
/*----------------------AddAcademicYear----------------------*/
-- Add [Academic Year] information into table <AcademicYear>
-- Input: AYear Id
-- Output: Status Code
/*------------------------------------------------------------*/
DELIMITER //
DROP PROCEDURE IF EXISTS AddAcademicYear //
CREATE PROCEDURE AddAcademicYear(
IN inAYearId VARCHAR(10),
OUT statusCode INT
)
BEGIN
	CASE
		WHEN inAYearId IS NULL THEN SET statusCode = 401; -- NON-EXISTENT/INVALID Academic Year Id
		WHEN inAYearId IN (SELECT AYearId FROM AcademicYear) THEN SET statusCode = 490;-- DUPLICATION ERROR
		ELSE SET statusCode = 200;-- SUCCESS
        INSERT INTO AcademicYear (AYearId)
		VALUES (inAYearId);
        END CASE;
END//
/*-----------------------AddSemester--------------------------*/
-- Add [Semester] information into table <Semester>
-- Input: Semester Id, AYear Id
-- Output: Status Code
/*---------------------------------  --------------------------*/
DROP PROCEDURE IF EXISTS AddSemester //
CREATE PROCEDURE AddSemester(
IN inSemesterId VARCHAR(10),
IN inAYearId VARCHAR(10),
OUT statusCode INT
)
BEGIN
	CASE
		WHEN inAYearId IS NULL OR inAYearId NOT IN (SELECT AYearId FROM AcademicYear) THEN SET statusCode = 401;-- NON-EXISTENT/INVALID Academic Year Id
        WHEN inSemesterId IS NULL THEN SET statusCode = 402;-- NON-EXISTENT/INVALID Semester Id
        WHEN inSemesterId IN (SELECT SemesterId FROM Semester) THEN SET statusCode = 490;-- DUPLICATION ERROR
        ELSE SET statusCode = 200;-- SUCCESS
        INSERT INTO Semester (SemesterId, SemYear)
		VALUES (inSemesterId ,(SELECT AYearPK FROM AcademicYear WHERE AYearId = inAYearId));
	END CASE;
END//
/*--------------------------AddFaculty--------------------------*/
-- Add [Faculty] information into table <Faculty>
-- Input: Faculty Id, Faculty Name
-- Output: Status Code
/*--------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS AddFaculty //
CREATE PROCEDURE AddFaculty(
IN inFacultyId VARCHAR(10),
IN inFacultyName VARCHAR(100),
OUT statusCode INT
)
BEGIN
	CASE
		WHEN inFacultyId IS NULL THEN SET statusCode = 413; -- NON-EXISTENT/INVALID Faculty Id
        WHEN inFacultyName IS NULL THEN SET statusCode = 413; -- NON-EXISTENT/INVALID Faculty Name
        WHEN inFacultyId IN (SELECT FacultyId FROM Faculty) THEN SET statusCode = 490;-- DUPLICATION ERROR
        ELSE SET statusCode = 200;-- SUCCESS
		INSERT INTO Faculty (FacultyId, FacultyName)
		VALUES (inFacultyId, inFacultyName);
	END CASE;
END//
/*-------------------------AddFacultyInAcademicYear----------------------------*/
-- Add the relation between [Faculty] & [AcademicYear] into table <FacultyInAcademicYear>
-- Input: Faculty Id, AYear Id
-- Output: Status Code
/*-----------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS AddFacultyInAcademicYear //
CREATE PROCEDURE AddFacultyInAcademicYear(
IN inFacultyId VARCHAR(10),
IN inAYearId VARCHAR(10),
OUT statusCode INT
)
BEGIN
	CASE
		WHEN inAYearId IS NULL OR inAYearId NOT IN (SELECT AYearId FROM AcademicYear) THEN SET statusCode = 401;-- NON-EXISTENT/INVALID Academic Year Id
        WHEN inFacultyId IS NULL OR inFacultyId NOT IN (SELECT FacultyId FROM Faculty) THEN SET statusCode = 413;-- NON-EXISTENT/INVALID Faculty Id
        WHEN ((SELECT AYearPK, FacultyPK 
        FROM AcademicYear
		NATURAL JOIN Faculty 
        WHERE FacultyId = inFacultyId AND AYearId = inAYearId))
        IN (SELECT FalYear,FacultyFK FROM FacultyInAcademicYear) THEN SET statusCode = 490;-- DUPLICATION ERROR
        ELSE SET statusCode = 200;-- SUCCESS
        INSERT INTO FacultyInAcademicYear (FacultyFK, FalYear)
		VALUES ((SELECT FacultyPK FROM Faculty WHERE FacultyId = inFacultyId),(SELECT AYearPK FROM AcademicYear WHERE AYearId = inAYearId));
        END CASE;
END//
/*-----------------------AddProgram-------------------------*/
-- Add [Program] information into table <Program>
-- Input: Program Id, Program Name
-- Output: Status Code
/*----------------------------------------------------------*/
DROP PROCEDURE IF EXISTS AddProgram //
CREATE PROCEDURE AddProgram(
IN inProgramId VARCHAR(10),
IN inProgramName VARCHAR(100),
OUT statusCode INT
)
BEGIN
	CASE
		WHEN inProgramId IS NULL THEN SET statusCode = 414;-- NON-EXISTENT/INVALID Program Id
        WHEN inProgramName IS NULL THEN SET statusCode = 404;-- NON-EXISTENT/INVALID Program Name
        WHEN inProgramId IN (SELECT ProgramId FROM Program) THEN SET statusCode = 490;-- DUPLICATION ERROR
		ELSE SET statusCode = 200;-- SUCCESS
		INSERT INTO Program (ProgramId, ProgramName)
		VALUES (inProgramId, inProgramName);
	END CASE;
END//
/*------------------------------------AddProgramInFacultyInAcademicYear-----------------------------------------*/
-- Add the relation between [Program] & [Faculty] & [AcademicYear] into table <ProgramInFacultyInAcademicYear>
-- Input: Program Id, Faculty Id, AYear Id
-- Output: Status Code
/*--------------------------------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS AddProgramInFacultyInAcademicYear //
CREATE PROCEDURE AddProgramInFacultyInAcademicYear(
IN inProgramId VARCHAR(10),
IN inFacultyId VARCHAR(10),
IN inAYearId VARCHAR(10),
OUT statusCode INT
)
BEGIN
	CASE
		WHEN inAYearId IS NULL OR inAYearId NOT IN (SELECT AYearId FROM AcademicYear INNER JOIN FacultyInAcademicYear ON AYearPK = FalYear) THEN SET statusCode = 401;-- NON-EXISTENT/INVALID Academic Year Id
        WHEN inFacultyId IS NULL OR inFacultyId NOT IN (SELECT FacultyId FROM Faculty INNER JOIN FacultyInAcademicYear ON FacultyPK = FacultyFK) THEN SET statusCode = 413;-- NON-EXISTENT/INVALID Faculty Id
        WHEN inProgramId IS NULL OR inProgramId NOT IN (SELECT ProgramId FROM Program) THEN SET statusCode = 414;-- NON-EXISTENT/INVALID Program Id
        WHEN ((SELECT ProgramPK,FA_PK
				FROM Program
                NATURAL JOIN FacultyInAcademicYear
				INNER JOIN Faculty ON FacultyFK = FacultyPK
				INNER JOIN AcademicYear ON FalYear = AYearPK
		WHERE ProgramId = inProgramId AND FacultyId = inFacultyId AND AYearId = inAYearId))
        IN (SELECT ProgramFK,FacultyYear FROM ProgramInFacultyInAcademicYear) THEN SET statusCode = 490;-- DUPLICATION ERROR
        ELSE SET statusCode = 200;-- SUCCESS
        INSERT INTO ProgramInFacultyInAcademicYear (ProgramFK, FacultyYear)
		SELECT ProgramPK, FA_PK
		FROM Program
        NATURAL JOIN FacultyInAcademicYear
		INNER JOIN Faculty ON FacultyFK = FacultyPK
	    INNER JOIN AcademicYear ON FalYear = AYearPK
		WHERE ProgramId = inProgramId AND FacultyId = inFacultyId AND AYearId = inAYearId;
	END CASE;
END//
/*---------------------AddLecturer------------------------*/
-- Add [Lecturer] information into the table <Lecturer>
-- Input: Lecturer Id, Lecturer Name, Username
-- Output: Status Code
/*---------------------------------------------------------*/
DROP PROCEDURE IF EXISTS AddLecturer //
CREATE PROCEDURE AddLecturer(
IN inLecturerId VARCHAR(10),
IN inLecturerName VARCHAR(100),
IN inUserName VARCHAR(20),
OUT statusCode INT
)
BEGIN
	CASE
        WHEN inLecturerId IN (SELECT LecturerId FROM Lecturer) THEN SET statusCode = 490; -- NON-EXISTENT/INVALID Lecturer Id
        WHEN inLecturerName IS NULL THEN SET statusCode = 406; -- NON-EXISTENT/INVALID Lecturer Name
        WHEN inUserName IS NULL OR inUserName NOT IN (SELECT UserName FROM Users) THEN SET statusCode = 420;-- NON-EXISTENT/INVALID Username
        ELSE SET statusCode = 200;-- SUCCESS
		INSERT INTO Lecturer (LecturerId, LecturerName,LecturerUser)
		VALUES (inLecturerId, inLecturerName,(SELECT UserPK FROM Users WHERE UserName = inUserName));
	END CASE;
END//
/*-------------------------AddModule-------------------------*/
-- Add [Module] information into the table <Module>
-- Input: Module Id, Module Name
-- Output: Status Code
/*-----------------------------------------------------------*/
DROP PROCEDURE IF EXISTS AddModule //
CREATE PROCEDURE AddModule(
IN inModuleId VARCHAR(10),
IN inModuleName VARCHAR(100),
OUT statusCode INT
)
BEGIN
	CASE
		WHEN inModuleId IS NULL THEN SET statusCode = 415;
        WHEN inModuleName IS NULL THEN SET statusCode = 405;
        WHEN inModuleId IN (SELECT ModuleId FROM Module) THEN SET statusCode = 490;-- DUPLICATION ERROR
		ELSE SET statusCode = 200;-- SUCCESS
		INSERT INTO Module (ModuleId, ModuleName)
		VALUES (inModuleId, inModuleName);
	END CASE;
END//
/*--------------------------------AddModuleInProgramInAcademicYear-------------------------------*/
-- Add the relation between [Module] & [Program] & [AcademicYear] into table <ModuleInProgramInAcademicYear>
-- Input: Module Id, Size, Program Id, AYear Id
-- Output: Status Code
/*-----------------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS AddModuleInProgramInAcademicYear //
CREATE PROCEDURE AddModuleInProgramInAcademicYear(
IN inModuleId VARCHAR(10),
IN inProgramId VARCHAR(10),
IN inAYearId VARCHAR(10),
OUT statusCode INT
)
BEGIN
	CASE
		WHEN inAYearId IS NULL OR inAYearId NOT IN (SELECT AYearId FROM AcademicYear INNER JOIN FacultyInAcademicYear ON AYearPK = FalYear INNER JOIN ProgramInFacultyInAcademicYear ON FA_PK = FacultyYear) THEN SET statusCode = 401;-- NON-EXISTENT/INVALID Academic Year Id
        WHEN inProgramId IS NULL OR inProgramId NOT IN (SELECT ProgramId FROM Program INNER JOIN ProgramInFacultyInAcademicYear ON ProgramPK = ProgramFK) THEN SET statusCode = 414;-- NON-EXISTENT/INVALID Program Id
        WHEN inModuleId IS NULL OR inModuleId NOT IN (SELECT ModuleId FROM Module) THEN SET statusCode = 415;-- NON-EXISTENT/INVALID Module Id
        WHEN (SELECT  ModulePK,PFA_PK
			FROM Module
            NATURAL JOIN ProgramInFacultyInAcademicYear
            INNER JOIN FacultyInAcademicYear ON FacultyYear = FA_PK
			INNER JOIN Program ON ProgramFK = ProgramPK
			INNER JOIN AcademicYear ON FalYear = AYearPK
			WHERE AYearId = inAYearId AND ProgramId = inProgramId AND ModuleId = inModuleId) IN (SELECT ModuleFK,ProgramFacultyYear FROM ModuleInProgramInAcademicYear) THEN SET statusCode = 490;-- DUPLICATION ERROR
        ELSE SET statusCode = 200;-- SUCCESS

        INSERT INTO ModuleInProgramInAcademicYear (ModuleFK, ProgramFacultyYear)
		SELECT  ModulePK,PFA_PK
			FROM Module
            NATURAL JOIN ProgramInFacultyInAcademicYear
            INNER JOIN FacultyInAcademicYear ON FacultyYear = FA_PK
			INNER JOIN Program ON ProgramFK = ProgramPK
			INNER JOIN AcademicYear ON FalYear = AYearPK
		WHERE ModuleId = inModuleId AND ProgramId = inProgramId AND AYearId = inAYearId;
        END CASE;
END//
/*---------------------AddClass----------------------*/
-- Add Class information into table <Class>
-- Input: Class Id, Size, Semester Id, Module Id
-- Output: Status Code
/*---------------------------------------------------*/
DROP PROCEDURE IF EXISTS AddClass //
CREATE PROCEDURE AddClass(
IN inClassId VARCHAR(10),
IN inSize INT,
IN inSemesterId VARCHAR(10),
IN inModuleId VARCHAR(10),
OUT statusCode INT
)
BEGIN
	CASE
		WHEN inClassId IS NULL THEN SET statusCode = 407; --  NON-EXISTENT/INVALID Class Id
        WHEN inSize IS NULL THEN SET statusCode = 427; -- NON-EXISTENT/INVALID Class Size
		WHEN inModuleId IS NULL OR inModuleId NOT IN (SELECT ModuleId FROM Module INNER JOIN ModuleInProgramInAcademicYear ON ModulePK = ModuleFK) THEN SET statusCode = 415;-- NON-EXISTENT/INVALID Module Id
        WHEN inSemesterId IS NULL OR inSemesterId NOT IN (SELECT SemesterId FROM Semester) THEN SET statusCode = 402;-- NON-EXISTENT/INVALID Semester Id
        WHEN inClassId IN (SELECT ClassId FROM Class) THEN SET statusCode = 490;-- DUPLICATION ERROR
        ELSE SET statusCode = 200;-- SUCCESS
		INSERT INTO Class (ClassId, Size, ClassSemester, ClassModule)
		VALUES (inClassId, inSize,
        (SELECT SemesterPK FROM Semester WHERE SemesterId = inSemesterId),
        (SELECT MPA_PK FROM ModuleInProgramInAcademicYear INNER JOIN Module ON ModuleFK = ModulePK WHERE ModuleId = inModuleId));
	END CASE;
END//
/*-----------------------AddTeaching----------------------*/
-- Add the relation between [Lecturer] & [Class] into table <Teaching>
-- Input: LecturerId, ClassId
-- Output: Status Code
/*--------------------------------------------------------*/
DROP PROCEDURE IF EXISTS AddTeaching //
CREATE PROCEDURE AddTeaching(
IN inLecturerId VARCHAR(10),
IN inClassId VARCHAR(10),
OUT statusCode INT
)
BEGIN
	CASE
		WHEN inLecturerId IS NULL OR inLecturerId NOT IN (SELECT LecturerId FROM Lecturer) THEN SET statusCode = 416;-- NON-EXISTENT/INVALID Lecturer Id
        WHEN inClassId IS NULL OR inClassId NOT IN (SELECT ClassId FROM Class) THEN SET statusCode = 407;-- NON-EXISTENT/INVALID Class Id
        WHEN((SELECT LecturerPK, ClassPK
        FROM Lecturer,Class
        WHERE LecturerId = inLecturerId AND ClassId = inClassId))
		IN ( SELECT LecturerT,ClassT FROM Teaching) THEN SET statusCode = 490;-- DUPLICATION ERROR
		ELSE SET statusCode = 200;-- SUCCESS

		INSERT INTO Teaching (LecturerT,ClassT)
		VALUES ((SELECT LecturerPK FROM Lecturer WHERE LecturerId = inLecturerId),
        (SELECT ClassPK FROM Class WHERE ClassId = inClassId));
	END CASE;
END//
/*---------------------AddQuestionnaire----------------------*/
-- Add [questionnaire] content into table <questionnaire>
-- Input: LecturerId, ClassId, Gender, Q1 - Q17, comment
-- Output: Status Code
/*-----------------------------------------------------------*/
DROP PROCEDURE IF EXISTS AddQuestionnaire //
CREATE PROCEDURE AddQuestionnaire(
IN inLecturerId VARCHAR(10),
IN inClassId VARCHAR(10),
IN inGender ENUM('M','F','O'),
IN inQuestion0 ENUM('1','2','3','4','5'),
IN inQuestion1 ENUM('1','2','3','4','5','N/A'),
IN inQuestion2 ENUM('1','2','3','4','5','N/A'),
IN inQuestion3 ENUM('1','2','3','4','5','N/A'),
IN inQuestion4 ENUM('1','2','3','4','5','N/A'),
IN inQuestion5 ENUM('1','2','3','4','5'),
IN inQuestion6 ENUM('1','2','3','4','5'),
IN inQuestion7 ENUM('1','2','3','4','5'),
IN inQuestion8 ENUM('1','2','3','4','5','N/A'),
IN inQuestion9 ENUM('1','2','3','4','5','N/A'),
IN inQuestion10 ENUM('1','2','3','4','5','N/A'),
IN inQuestion11 ENUM('1','2','3','4','5','N/A'),
IN inQuestion12 ENUM('1','2','3','4','5','N/A'),
IN inQuestion13 ENUM('1','2','3','4','5','N/A'),
IN inQuestion14 ENUM('1','2','3','4','5','N/A'),
IN inQuestion15 ENUM('1','2','3','4','5','N/A'),
IN inQuestion16 ENUM('1','2','3','4','5','N/A'),
IN inQuestion17 ENUM('1','2','3','4','5','N/A'),
IN inComment TEXT,
OUT statusCode INT
)
BEGIN
	CASE
		WHEN inLecturerId IS NULL OR inLecturerId NOT IN (SELECT LecturerId FROM Lecturer INNER JOIN Teaching ON LecturerPK = LecturerT) THEN SET statusCode = 416;-- NON-EXISTENT/INVALID Lecturer Id
		WHEN inClassId IS NULL OR inClassId NOT IN (SELECT ClassId FROM Class INNER JOIN Teaching ON ClassPK = ClassT) THEN SET statusCode = 407;-- NON-EXISTENT/INVALID Class Id
        ELSE SET statusCode = 200;-- SUCCESS
        INSERT INTO Questionnaire (ClassAndLecturer,Gender, Question0, Question1, Question2, Question3, Question4, Question5, Question6, Question7, Question8, Question9, Question10, Question11, Question12, Question13, Question14, Question15, Question16, Question17, Comment)
        SELECT Teaching_PK,inGender, inQuestion0, inQuestion1, inQuestion2, inQuestion3, inQuestion4, inQuestion5, inQuestion6, inQuestion7, inQuestion8, inQuestion9, inQuestion10, inQuestion11, inQuestion12, inQuestion13, inQuestion14, inQuestion15, inQuestion16, inQuestion17, inComment
        FROM Teaching
        INNER JOIN Lecturer ON LecturerT = LecturerPK
        INNER JOIN Class ON ClassT = ClassPK
        WHERE LecturerId = inLecturerId AND ClassId = inClassId;
	END CASE;
END//

DELIMITER ;
/*--------------------END--------------------------*//*----------------------DeleteQuestionnaire----------------------*/
-- Remove [Questionnaire] content from table <Questionnaire>
-- Input: Lecturer Id, ClassId, Questionnaire PK
-- Output: Status Code
/*----------------------------------------------------------------*/
DELIMITER //
DROP PROCEDURE IF EXISTS DeleteQuestionnaire //
CREATE PROCEDURE DeleteQuestionnaire(
IN inLecturerId VARCHAR(10),
IN inClassId VARCHAR(10),
IN inQuestionnairePK INT,
OUT statusCode INT
)
BEGIN
	CASE
		WHEN inLecturerId IS NULL OR inLecturerId NOT IN (SELECT LecturerId FROM Lecturer INNER JOIN TEACHING ON LecturerPK = LecturerT INNER JOIN Questionnaire ON Teaching_PK = ClassAndLecturer) THEN SET statusCode = 416;-- NON-EXISTENT/INVALID LecturerId
        WHEN inClassId IS NULL OR inClassId NOT IN (SELECT ClassId FROM Class INNER JOIN TEACHING ON ClassPK = ClassT INNER JOIN Questionnaire ON Teaching_PK = ClassAndLecturer) THEN SET statusCode = 407;-- NON-EXISTENT/INVALID Class Id
        WHEN inQuestionnairePK IS NULL OR inQuestionnairePK NOT IN ( SELECT QuestionnairePK FROM Questionnaire ) THEN SET statusCode = 418;-- NON-EXISTENT/INVALID Questionnaire
        ELSE SET statusCode = 200;-- SUCCESS
        DELETE FROM Questionnaire
        WHERE inQuestionnairePK = QuestionnairePK
        AND (ClassAndLecturer) IN (SELECT Teaching_PK
										FROM Teaching
										INNER JOIN Class ON ClassT = ClassPK
                                        INNER JOIN Lecturer ON LecturerT = LecturerPK
                                        WHERE LecturerId = inLecturerId AND ClassId = inClassId);
        END CASE;
END//
DELIMITER ;

/*----------------------------DeleteTeaching-------------------------*/
-- Remove the relation between [Lecturer] & [Class] from table <Teaching>
-- Input: Lecturer Id, Class Id
-- Output: Status Code
/*-------------------------------------------------------------------*/
DELIMITER //
DROP PROCEDURE IF EXISTS DeleteTeaching //
CREATE PROCEDURE DeleteTeaching(
IN inLecturerId VARCHAR(10),
IN inClassId VARCHAR(10),
OUT statusCode INT
)
BEGIN
	CASE
		WHEN inLecturerId IS NULL OR inLecturerId NOT IN (SELECT LecturerId FROM Lecturer INNER JOIN TEACHING ON LecturerPK = LecturerT) THEN SET statusCode = 416;-- NON-EXISTENT/INVALID Lecturer Id
        WHEN inClassId IS NULL OR inClassId NOT IN (SELECT ClassId FROM Class INNER JOIN TEACHING ON ClassPK = ClassT) THEN SET statusCode = 407;-- NON-EXISTENT/INVALID Class Id
        WHEN (SELECT Teaching_PK 
				FROM Teaching 
				INNER JOIN Lecturer ON LecturerT = LecturerPK
                INNER JOIN Class ON ClassT = ClassPK
                WHERE LecturerId = inLecturerId and ClassId = inClassId) IN (SELECT ClassAndLecturer FROM Questionnaire) THEN SET statusCode = 495;-- DELETE VIOLATION
        ELSE SET statusCode = 200;-- SUCCESS
        DELETE FROM Teaching
		WHERE (LecturerT, ClassT) IN (SELECT LecturerPK, ClassPK 
										FROM Class NATURAL JOIN Lecturer
                                        WHERE LecturerId = inLecturerId AND ClassId = inClassId);
        END CASE;
END//
DELIMITER ;

/*---------------------------DeleteLecturer--------------------------*/
-- Remove [Lecturer] information from table <Lecturer>
-- Input: Lecturer Id
-- Output: Status Code
/*-------------------------------------------------------------------*/
DELIMITER //
DROP PROCEDURE IF EXISTS DeleteLecturer //
CREATE PROCEDURE DeleteLecturer(
IN inLecturerId VARCHAR(10),
OUT statusCode INT
)
BEGIN
	CASE
		WHEN inLecturerId IS NULL OR inLecturerId NOT IN (SELECT LecturerId FROM Lecturer) THEN SET statusCode = 416;-- NON-EXISTENT/INVALID Lecturer Id
        WHEN inLecturerId IN (SELECT LecturerId FROM Lecturer INNER JOIN Teaching ON LecturerPK = LecturerT) THEN SET statusCode = 495;-- DELETE VIOLATION
        ELSE SET statusCode = 200;-- SUCCESS
        DELETE FROM Lecturer
        WHERE LecturerId = inLecturerId;
        END CASE;
END//
DELIMITER ;

/*---------------------------DeleteClass--------------------------*/
-- Remove [Class] information from table <Class>
-- Input: Class Id
-- Output: Status Code
/*-------------------------------------------------------------------*/
DELIMITER //
DROP PROCEDURE IF EXISTS DeleteClass //
CREATE PROCEDURE DeleteClass(
IN inClassId VARCHAR(10),
OUT statusCode INT
)
BEGIN
	CASE
        WHEN inClassId IS NULL OR inClassId NOT IN ( SELECT ClassId FROM Class) THEN SET statusCode = 407;-- NON-EXISTENT/INVALID Class Id
        WHEN inClassId IN (SELECT ClassId FROM Class INNER JOIN Teaching ON ClassPK = ClassT) THEN SET statusCode = 495;-- DELETE VIOLATION
        ELSE SET statusCode = 200;-- SUCCESS
        DELETE FROM Class
        WHERE ClassId = inClassId;
        END CASE;
END//
DELIMITER ;

/*----------------------------DeleteModuleInProgramInAcademicYear-------------------------*/
-- Remove the relation between [Module] & [Program] & [AcademicYear] from table <ModuleInProgramInAcademicYear>
-- Input: Module Id, AYear Id
-- Output: Status Code
/*-----------------------------------------------------------------------------------------*/
DELIMITER //
DROP PROCEDURE IF EXISTS DeleteModuleInProgramInAcademicYear //
CREATE PROCEDURE DeleteModuleInProgramInAcademicYear(
IN inModuleId VARCHAR(10),
IN inAYearId VARCHAR(10),
OUT statusCode INT
)
BEGIN
	CASE
		WHEN inModuleId IS NULL OR inModuleId NOT IN (SELECT ModuleId FROM Module INNER JOIN ModuleInProgramInAcademicYear ON ModulePK = ModuleFK) THEN SET statusCode = 415;-- NON-EXISTENT/INVALID Module Id
        WHEN inAYearId IS NULL OR inAYearId NOT IN (SELECT AYearId 
        FROM AcademicYear 
        INNER JOIN FacultyInAcademicYear ON AYearPK = FalYear 
        INNER JOIN ProgramInFacultyInAcademicYear ON FA_PK = FacultyYear 
        INNER JOIN ModuleInProgramInAcademicYear ON PFA_PK = ProgramFacultyYear) THEN SET statusCode = 401;-- NON-EXISTENT/INVALID Academic Year Id
        WHEN (SELECT MPA_PK 
        FROM ModuleInProgramInAcademicYear  
        INNER JOIN Module ON ModuleFK = ModulePK 
        INNER JOIN ProgramInFacultyInAcademicYear ON ProgramFacultyYear = PFA_PK 
        INNER JOIN FacultyInAcademicYear ON FacultyYear = FA_PK 
        INNER JOIN AcademicYear ON FalYear = AYearPK
        WHERE ModuleId = ModuleId AND AYearId = inAYearId) IN (SELECT ClassModule FROM Class) THEN SET statusCode = 495;-- DELETE VIOLATION
        ELSE SET statusCode = 200;-- SUCCESS
        DELETE FROM ModuleInProgramInAcademicYear
        WHERE (ModuleFK, ProgramFacultyYear) IN (SELECT ModulePK, PFA_PK
												 FROM Module
									             INNER JOIN ProgramInFacultyInAcademicYear
												 INNER JOIN FacultyInAcademicYear ON FacultyYear = FA_PK
									             INNER JOIN AcademicYear ON FalYear = AYearPK
                                                 WHERE ModuleId = inModuleId AND AYearId = inAYearId);
        END CASE;
END//
DELIMITER ;

/*---------------------------DeleteModule--------------------------*/
-- Remove [Module] information from table <Module>
-- Input: Module Id
-- Output: Status Code
/*-------------------------------------------------------------------*/
DELIMITER //
DROP PROCEDURE IF EXISTS DeleteModule //
CREATE PROCEDURE DeleteModule(
IN inModuleId VARCHAR(10),
OUT statusCode INT
)
BEGIN
	CASE
        WHEN inModuleId IS NULL OR inModuleId NOT IN (SELECT ModuleId FROM Module) THEN SET statusCode = 415;-- NON-EXISTENT/INVALID Module Id
        WHEN inModuleId IN (SELECT ModuleId FROM Module INNER JOIN ModuleInProgramInAcademicYear ON ModulePK = ModuleFK) THEN SET statusCode = 495;-- DELETE VIOLATION
        ELSE SET statusCode = 200;-- SUCCESS
        DELETE FROM Module
        WHERE ModuleId = inModuleId;
        END CASE;
END//
DELIMITER ;

/*---------------------------DeleteProgramInFacultyInAcademicYear--------------------------*/
-- Remove the relation between [Program] & [Faculty] & [AcademicYear] from table <ProgramInFacultyInAcademicYear>
-- Input: Program Id, AYear Id
-- Output: Status Code
/*------------------------------------------------------------------------------------------*/
DELIMITER //
DROP PROCEDURE IF EXISTS DeleteProgramInFacultyInAcademicYear //
CREATE PROCEDURE DeleteProgramInFacultyInAcademicYear(
IN inProgramId VARCHAR(10),
IN inAYearId VARCHAR(10),
OUT statusCode INT
)
BEGIN
	CASE
        WHEN inProgramId IS NULL OR inProgramId NOT IN ( SELECT ProgramId FROM Program INNER JOIN ProgramInFacultyInAcademicYear ON ProgramPK = ProgramFK) THEN SET statusCode = 414; -- NON-EXISTENT/INVALID Program Id
        WHEN inAYearId IS NULL OR inAYearId NOT IN ( SELECT AYearId FROM AcademicYear INNER JOIN FacultyInAcademicYear ON AYearPK = FalYear INNER JOIN ProgramInFacultyInAcademicYear ON FA_PK = FacultyYear) THEN SET statusCode = 401; -- NON-EXISTENT/INVALID Academic Year Id
        WHEN (SELECT PFA_PK 
        FROM ProgramInFacultyInAcademicYear
        INNER JOIN Program ON ProgramFK = ProgramPK
        INNER JOIN FacultyInAcademicYear ON FacultyYear = FA_PK 
        INNER JOIN AcademicYear ON FalYear = AYearPK
        WHERE ProgramId = ProgramId AND AYearId = inAYearId) 
        IN (SELECT ProgramFacultyYear FROM ModuleInProgramInAcademicYear) THEN SET statusCode = 495;-- DELETE VIOLATION
        ELSE SET statusCode = 200;-- SUCCESS
        DELETE FROM ProgramInFacultyInAcademicYear
        WHERE (ProgramFK, FacultyYear) IN (SELECT ProgramPK, FA_PK 
										FROM Program 
                                        INNER JOIN FacultyInAcademicYear 
                                        INNER JOIN AcademicYear ON FalYear = AYearPK
                                        WHERE ProgramId = inProgramId AND AYearId = inAYearId);
        END CASE;
END//
DELIMITER ;

/*---------------------------DeleteProgram--------------------------*/
-- Remove [Program] information from table <Program>
-- Input: Program Id
-- Output: Status Code
/*-------------------------------------------------------------------*/
DELIMITER //
DROP PROCEDURE IF EXISTS DeleteProgram //
CREATE PROCEDURE DeleteProgram(
IN inProgramId VARCHAR(10),
OUT statusCode INT
)
BEGIN
	CASE
        WHEN inProgramId IS NULL OR inProgramId NOT IN (SELECT ProgramId FROM Program) THEN SET statusCode = 414; -- NON-EXISTENT/INVALID Program Id
        WHEN inProgramId IN ( SELECT ProgramId FROM Program INNER JOIN ProgramInFacultyInAcademicYear ON ProgramPK = ProgramFK) THEN SET statusCode = 495;-- DELETE VIOLATION
        ELSE SET statusCode = 200;-- SUCCESS
        DELETE FROM Program 
        WHERE ProgramId = inProgramId;
        END CASE;
END//
DELIMITER ;

/*---------------------------DeleteFacultyInAcademicYear--------------------------*/
-- Remove the relation between [Faculty] & [AcademicYear] from table <FacultyInAcademicYear>
-- Input: Faculty Id, AYear Id
-- Output: Status Code
/*------------------------------------------------------------------------------------------*/
DELIMITER //
DROP PROCEDURE IF EXISTS DeleteFacultyInAcademicYear //
CREATE PROCEDURE DeleteFacultyInAcademicYear(
IN inFacultyId VARCHAR(10),
IN inAYearId VARCHAR(10),
OUT statusCode INT
)
BEGIN
	CASE
        WHEN inFacultyId IS NULL OR inFacultyId NOT IN ( SELECT FacultyId FROM Faculty INNER JOIN FacultyInAcademicYear ON FacultyPK = FacultyFK ) THEN SET statusCode = 413;-- NON-EXISTENT/INVALID Faculty Id
        WHEN inAYearId IS NULL OR inAYearId NOT IN ( SELECT AYearId FROM AcademicYear INNER JOIN FacultyInAcademicYear ON AYearPK = FalYear ) THEN SET statusCode = 401;-- NON-EXISTENT/INVALID Academic Year Id
        WHEN (SELECT FA_PK FROM FacultyInAcademicYear
              INNER JOIN Faculty ON FacultyFK = FacultyPK
              INNER JOIN AcademicYear ON FalYear = AYearPK
              WHERE FacultyId = inFacultyId AND AYearId = inAYearId) IN (SELECT FacultyYear FROM ProgramInFacultyInAcademicYear) THEN SET statusCode = 495;-- DELETE VIOLATION
        ELSE SET statusCode = 200;-- SUCCESS
        DELETE FROM FacultyInAcademicYear
        WHERE (FacultyFK, FalYear) IN (SELECT FacultyPK, AYearPK
										FROM Faculty
                                        INNER JOIN AcademicYear
                                        WHERE FacultyId = inFacultyId AND AYearId = inAYearId);
        END CASE;
END//
DELIMITER ;

/*---------------------------DeleteFaculty--------------------------*/
-- Remove [Faculty] information from table <Faculty>
-- Input: Faculty Id
-- Output: Status Code
/*-------------------------------------------------------------------*/
DELIMITER //
DROP PROCEDURE IF EXISTS DeleteFaculty //
CREATE PROCEDURE DeleteFaculty(
IN inFacultyId VARCHAR(10),
OUT statusCode INT
)
BEGIN
	CASE
        WHEN inFacultyId IS NULL OR inFacultyId NOT IN ( SELECT FacultyId FROM Faculty ) THEN SET statusCode = 413;-- NON-EXISTENT/INVALID Faculty Id
        WHEN inFacultyId IN ( SELECT FacultyId FROM Faculty INNER JOIN FacultyInAcademicYear ON FacultyPK = FacultyFK) THEN SET statusCode = 495;-- DELETE VIOLATION
        ELSE SET statusCode = 200;-- SUCCESS
        DELETE FROM Faculty
        WHERE FacultyId = inFacultyId;
        END CASE;
END//
DELIMITER ;

/*---------------------------DeleteSemester--------------------------*/
-- Remove [Semester] information from table <Semester>
-- Input: Semester Id
-- Output: Status Code
/*-------------------------------------------------------------------*/
DELIMITER //
DROP PROCEDURE IF EXISTS DeleteSemester //
CREATE PROCEDURE DeleteSemester(
IN inSemesterId VARCHAR(10),
OUT statusCode INT
)
BEGIN
	CASE
        WHEN inSemesterId IS NULL OR inSemesterId NOT IN ( SELECT SemesterId FROM Semester ) THEN SET statusCode = 402;-- NON-EXISTENT/INVALID Semester Id
        WHEN inSemesterId IN ( SELECT SemesterId FROM Semester INNER JOIN Class ON SemesterPK = ClassSemester ) THEN SET statusCode = 495;-- DELETE VIOLATION
        ELSE SET statusCode = 200;-- SUCCESS
        DELETE FROM Semester
        WHERE SemesterId = inSemesterId;
        END CASE;
END//
DELIMITER ;

/*---------------------------DeleteAcademicYear--------------------------*/
-- Remove [AcademicYear] information from table <AcademicYear>
-- Input: AYear Id
-- Output: Status Code
/*-----------------------------------------------------------------------*/
DELIMITER //
DROP PROCEDURE IF EXISTS DeleteAcademicYear //
CREATE PROCEDURE DeleteAcademicYear(
IN inAYearId VARCHAR(10),
OUT statusCode INT
)
BEGIN
	CASE
        WHEN inAYearId IS NULL OR inAYearId NOT IN ( SELECT AYearId FROM AcademicYear ) THEN SET statusCode = 401;-- NON-EXISTENT/INVALID Academic Year Id
        WHEN inAYearId IN ( SELECT AYearId FROM AcademicYear INNER JOIN Semester ON AYearPK = SemYear ) THEN SET statusCode = 495;-- DELETE VIOLATION
        WHEN inAYearId IN ( SELECT AYearId FROM AcademicYear INNER JOIN FacultyInAcademicYear ON AYearPK = FalYear ) THEN SET statusCode = 495;-- DELETE VIOLATION
        ELSE SET statusCode = 200;-- SUCCESS
        DELETE FROM AcademicYear
        WHERE AYearId = inAYearId;
        END CASE;
END//
DELIMITER ;
/*-----------------------------------END-------------------------------*/DELIMITER //
DROP PROCEDURE IF EXISTS DumpAcademicYear //
CREATE PROCEDURE DumpAcademicYear()
BEGIN
        SELECT AYearId
        FROM AcademicYear;
END//
/*-------------------------------------------------------*/
DROP PROCEDURE IF EXISTS DumpClass //
CREATE PROCEDURE DumpClass()
BEGIN
        SELECT ClassId,Size,SemesterId,ModuleId
        FROM Class
        LEFT JOIN ModuleInProgramInAcademicYear ON ClassModule = MPA_PK
        LEFT JOIN ProgramInFacultyInAcademicYear ON ProgramFacultyYear = PFA_PK
        LEFT JOIN FacultyInAcademicYear ON FacultyYear = FA_PK
        INNER JOIN Semester ON ClassSemester = SemesterPK
        INNER JOIN Module ON ClassModule = ModulePK;
END//
/*-------------------------------------------------------*/
DROP PROCEDURE IF EXISTS DumpFaculty //
CREATE PROCEDURE DumpFaculty()
BEGIN
        SELECT FacultyId, FacultyName
        FROM Faculty;
END//
/*-------------------------------------------------------*/
DROP PROCEDURE IF EXISTS DumpFacultyInAcademicYear //
CREATE PROCEDURE DumpFacultyInAcademicYear()
BEGIN
        SELECT FacultyId,AYearId
        FROM Faculty
        INNER JOIN FacultyInAcademicYear ON FacultyPK = FacultyFK
        INNER JOIN AcademicYear ON FalYear = AYearPK;
END//
/*-------------------------------------------------------*/
DROP PROCEDURE IF EXISTS DumpLecturer //
CREATE PROCEDURE DumpLecturer()
BEGIN
        SELECT LecturerId,LecturerName,UserName
        FROM Lecturer
		INNER JOIN Users ON LecturerUser = UserPK;
END//
/*-------------------------------------------------------*/
DROP PROCEDURE IF EXISTS DumpModule //
CREATE PROCEDURE DumpModule()
BEGIN
        SELECT ModuleId, ModuleName
        FROM Module;
END//
/*-------------------------------------------------------*/
DROP PROCEDURE IF EXISTS DumpModuleInProgramInAcademicYear //
CREATE PROCEDURE DumpModuleInProgramInAcademicYear()
BEGIN
        SELECT ModuleId, ProgramId, AYearId
        FROM Module
        INNER JOIN ModuleInProgramInAcademicYear ON ModulePK = ModuleFK
        INNER JOIN ProgramInFacultyInAcademicYear ON ProgramFacultyYear = PFA_PK
        INNER JOIN FacultyInAcademicYear ON FacultyYear = FA_PK
        INNER JOIN AcademicYear ON FalYear = AYearPK
        INNER JOIN Program ON ProgramFK = ProgramPK;
END//
/*-------------------------------------------------------*/
DROP PROCEDURE IF EXISTS DumpProgram //
CREATE PROCEDURE DumpProgram()
BEGIN
        SELECT ProgramId, ProgramName
        FROM Program;
END//
/*-------------------------------------------------------*/
DROP PROCEDURE IF EXISTS DumpProgramInFacultyInAcademicYear //
CREATE PROCEDURE DumpProgramInFacultyInAcademicYear()
BEGIN
        SELECT ProgramId, FacultyId, AYearId
        FROM Program
        INNER JOIN ProgramInFacultyInAcademicYear ON ProgramPK = ProgramFK
        INNER JOIN FacultyInAcademicYear ON FacultyYear = FA_PK
        INNER JOIN AcademicYear ON FalYear = AYearPK
        INNER JOIN Faculty ON FacultyFK = FacultyPK;
END//
/*-------------------------------------------------------*/
DROP PROCEDURE IF EXISTS DumpQuestionnaire //
CREATE PROCEDURE DumpQuestionnaire()
BEGIN
        SELECT QuestionnairePK AS QuestionnaireId,LecturerId,ClassId,
        Gender+0 AS Gender,
        Question0+0 AS Attendance,
        Question1+0 AS Question1,
        Question2+0 AS Question2,
        Question3+0 AS Question3,
        Question4+0 AS Question4,
        Question5+0 AS Question5,
        Question6+0 AS Question6,
        Question7+0 AS Question7,
        Question8+0 AS Question8,
        Question9+0 AS Question9,
        Question10+0 AS Question10,
        Question11+0 AS Question11,
        Question12+0 AS Question12,
        Question13+0 AS Question13,
        Question14+0 AS Question14,
        Question15+0 AS Question15,
        Question16+0 AS Question16,
        Question17+0 AS Question17,
        Comment
        FROM Questionnaire
        INNER JOIN Teaching ON ClassAndLecturer = Teaching_PK
        INNER JOIN Lecturer ON LecturerT = LecturerPK
        INNER JOIN Class ON ClassT = ClassPK;
END//
/*-------------------------------------------------------*/
DROP PROCEDURE IF EXISTS DumpSemester //
CREATE PROCEDURE DumpSemester()
BEGIN
        SELECT SemesterId, AYearId
        FROM Semester
        INNER JOIN AcademicYear ON SemYear = AYearPK;
END//
/*-------------------------------------------------------*/
DROP PROCEDURE IF EXISTS DumpTeaching //
CREATE PROCEDURE DumpTeaching()
BEGIN
        SELECT LecturerId, ClassId
        FROM Teaching
        INNER JOIN Class ON ClassT = ClassPK
        INNER JOIN Lecturer ON LecturerT = LecturerPK;
END//
DELIMITER ;
DELIMITER //
DROP PROCEDURE IF EXISTS GetFaculties //
CREATE PROCEDURE GetFaculties(
IN inAYearId VARCHAR(10),
OUT statusCode INT
)
BEGIN
	CASE
		WHEN inAYearId NOT IN (SELECT AYearId FROM AcademicYear) THEN SET statusCode = 401; -- NON-EXISTENT/INVALID AcademicYear Id
        ELSE SET statusCode = 200;-- SUCCESS
        SELECT FacultyId,FacultyName
		FROM Faculty
        INNER JOIN FacultyInAcademicYear ON FacultyPK = FacultyFK
        INNER JOIN AcademicYear ON FalYear = AYearPK
        WHERE AYearId = inAYearId;
		END CASE;         
END//

DROP PROCEDURE IF EXISTS GetPrograms //
CREATE PROCEDURE GetPrograms(
IN inAYearId VARCHAR(10),
IN inFacultyId VARCHAR(10),
OUT statusCode INT
)
BEGIN
	CASE
		WHEN inAYearId NOT IN (SELECT AYearId FROM AcademicYear) THEN SET statusCode = 401; -- NON-EXISTENT/INVALID AcademicYear Id
		WHEN inFacultyId NOT IN (SELECT FacultyId FROM Faculty) THEN SET statusCode = 413; -- NON-EXISTENT/INVALID Faculty Id
        ELSE SET statusCode = 200;-- SUCCESS
        SELECT ProgramId,ProgramName
		FROM Program
		INNER JOIN ProgramInFacultyInAcademicYear ON ProgramPK = ProgramFK
        INNER JOIN FacultyInAcademicYear ON FacultyYear = FA_PK
        INNER JOIN Faculty ON FacultyFK = FacultyPK
        INNER JOIN AcademicYear ON FalYear = AYearPK
        WHERE AYearId = inAYearId AND FacultyId = inFacultyId;
		END CASE;         
END//

DROP PROCEDURE IF EXISTS GetModules //
CREATE PROCEDURE GetModules(
IN inAYearId VARCHAR(10),
IN inProgramId VARCHAR(10),
OUT statusCode INT
)
BEGIN
	CASE
		WHEN inAYearId NOT IN (SELECT AYearId FROM AcademicYear) THEN SET statusCode = 401; -- NON-EXISTENT/INVALID AcademicYear Id
		WHEN inProgramId NOT IN (SELECT ProgramId FROM Program) THEN SET statusCode = 414; -- NON-EXISTENT/INVALID Program Id
        ELSE SET statusCode = 200;-- SUCCESS
        SELECT ModuleId,ModuleName
		FROM Module
         INNER JOIN ModuleInProgramInAcademicYear ON ModulePK = ModuleFK
         INNER JOIN ProgramInFacultyInAcademicYear ON ProgramFacultyYear = PFA_PK
         INNER JOIN FacultyInAcademicYear ON FacultyYear = FA_PK
         INNER JOIN Program ON ProgramFK = ProgramPK
         INNER JOIN AcademicYear ON FalYear = AYearPK
        WHERE AYearId = inAYearId AND ProgramId = inProgramId;
		END CASE;         
END//

DROP PROCEDURE IF EXISTS GetClasses //
CREATE PROCEDURE GetClasses(
IN inSemesterId VARCHAR(10),
IN inProgramId VARCHAR(10),
IN inModuleId VARCHAR(10),
OUT statusCode INT
)
BEGIN
	CASE
		WHEN inSemesterId NOT IN (SELECT SemesterId FROM Semester) THEN SET statusCode = 402; -- NON-EXISTENT/INVALID Semester Id
		WHEN inProgramId NOT IN (SELECT ProgramId FROM Program) THEN SET statusCode = 414; -- NON-EXISTENT/INVALID Program Id
		WHEN inModuleId NOT IN (SELECT ModuleId FROM Module) THEN SET statusCode = 415; -- NON-EXISTENT/INVALID Module Id
        ELSE SET statusCode = 200;-- SUCCESS
        SELECT ClassId
		FROM Class
		INNER JOIN ModuleInProgramInAcademicYear ON ClassModule = MPA_PK
        INNER JOIN ProgramInFacultyInAcademicYear ON ProgramFacultyYear = PFA_PK
        INNER JOIN FacultyInAcademicYear ON FacultyYear = FA_PK
        INNER JOIN Module ON ModuleFK = ModulePK
        INNER JOIN Program ON ProgramFK = ProgramPK
        INNER JOIN Semester ON ClassSemester = SemesterPK
        WHERE SemesterId = inSemesterId AND ProgramId = inProgramId AND ModuleId = inModuleId;
		END CASE;         
END//

DROP PROCEDURE IF EXISTS GetLecturers //
CREATE PROCEDURE GetLecturers(
IN inClassId VARCHAR(10),
OUT statusCode INT
)
BEGIN
	CASE
		WHEN inClassId NOT IN (SELECT ClassId FROM Class) THEN SET statusCode = 407; -- NON-EXISTENT/INVALID Class Id
        ELSE SET statusCode = 200;-- SUCCESS
        SELECT LecturerId,UserName
		FROM Lecturer
        INNER JOIN Teaching ON LecturerPK = LecturerT
        INNER JOIN Class ON ClassT = ClassPK
        INNER JOIN Users ON LecturerUser = UserPK
        WHERE ClassId = inClassId;
		END CASE;         
END//
DELIMITER ;
DELIMITER //
DROP PROCEDURE IF EXISTS GetClassOptions //
CREATE PROCEDURE GetClassOptions(
IN inCLassId VARCHAR(10),
OUT statusCode INT
)
BEGIN
	CASE
		WHEN inCLassId NOT IN (SELECT ClassId FROM Class) THEN SET statusCode = 407; -- NON-EXISTENT/INVALID ClassID
        ELSE SET statusCode = 200;-- SUCCESS
        SELECT AYearId, SemesterId, FacultyName, ProgramName, LecturerName, ClassId
        FROM Class
					INNER JOIN Teaching ON ClassT = ClassPK
					INNER JOIN Lecturer ON LecturerT = LecturerPK
					INNER JOIN ModuleInProgramInAcademicYear ON ClassModule = MPA_PK
					INNER JOIN ProgramInFacultyInAcademicYear ON ProgramFacultyYear = PFA_PK
					INNER JOIN FacultyInAcademicYear ON FA_PK = FacultyYear
					INNER JOIN Module ON ModuleFK = ModulePK
					INNER JOIN Program ON ProgramFK = ProgramPK
					INNER JOIN Semester ON ClassSemester = SemesterPK
					INNER JOIN AcademicYear ON FalYear = AYearPK AND SemYear = AYearPK
					INNER JOIN Faculty ON FacultyFK = FacultyPK
		WHERE ClassId = inClassId;
		END CASE;
END//
DELIMITER ;DELIMITER //

DROP PROCEDURE IF EXISTS GetComments //
CREATE PROCEDURE GetComments(
  IN inClassId VARCHAR(10),
  IN inLecturerId VARCHAR(10),
  OUT statusCode INT
)
BEGIN
  CASE
		WHEN inCLassId NOT IN (SELECT ClassId FROM Class) THEN SET statusCode = 407; -- NON-EXISTENT/INVALID Class Id
    WHEN inLecturerId NOT IN (SELECT LecturerId FROM Lecturer) THEN SET statusCode = 416; -- NON-EXISTENT/INVALID Lecturer Id
    ELSE SET statusCode = 200;-- SUCCESS
      SELECT Comment AS comments
      FROM Questionnaire
      INNER JOIN Teaching ON ClassAndLecturer = Teaching_PK  
      INNER JOIN Class ON ClassT = ClassPK
      INNER JOIN Lecturer ON LecturerT = LecturerPK
      WHERE inClassId = ClassId AND inLecturerId = LecturerId AND Comment IS NOT NULL;
  END CASE;
END //

DELIMITER ;
DELIMITER //

DROP PROCEDURE IF EXISTS GetQuestionnaireCount //

CREATE PROCEDURE GetQuestionnaireCount(
IN inAYearId VARCHAR(10),
IN inSemesterId  VARCHAR(10),
IN inFacultyId VARCHAR(10),
IN inProgramId VARCHAR(10),
IN inModuleId VARCHAR(10),
IN inClassId VARCHAR(10),
IN inLecturerId VARCHAR(10),
IN inQuestion ENUM ('Gender', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17'),
OUT statusCode INT
)
BEGIN
		CASE
			WHEN inAYearId IS NOT NULL AND inAYearId NOT IN (SELECT AYearId FROM AcademicYear) 		THEN SET statusCode = 401;-- NON-EXISTENT/INVALID AcademicYear Id
            WHEN inSemesterId NOT IN (SELECT SemesterId FROM Semester) 								THEN SET statusCode = 402; -- NON-EXISTENT/INVALID Semester Id
			WHEN inFacultyId IS NOT NULL AND inFacultyId NOT IN (SELECT FacultyId FROM Faculty) 	THEN SET statusCode = 413;-- NON-EXISTENT/INVALID Faculty Id
			WHEN inProgramId IS NOT NULL AND inProgramId NOT IN (SELECT inProgramId FROM Program) 	THEN SET statusCode = 414;-- NON-EXISTENT/INVALID Program Id
			WHEN inModuleId IS NOT NULL AND inModuleId NOT IN (SELECT ModuleId FROM Module) 		THEN SET statusCode = 415;-- NON-EXISTENT/INVALID Module Id
            WHEN inClassId IS NOT NULL AND inClassId NOT IN (SELECT ClassId FROM Class) 			THEN SET statusCode = 407; -- NON-EXISTENT/INVALID Class Id
			WHEN inLecturerId IS NOT NULL AND inLecturerId NOT IN (SELECT LecturerId FROM Lecturer) THEN SET statusCode = 416;-- NON-EXISTENT/INVALID Lecturer Id
			ELSE SET statusCode = 200;-- SUCCESS
            SELECT 
				(CASE inQuestion
					WHEN 'Gender' THEN Gender
                    WHEN '0' THEN Question0
                    WHEN '1' THEN Question1
                    WHEN '2' THEN Question2
                    WHEN '3' THEN Question3
                    WHEN '4' THEN Question4
                    WHEN '5' THEN Question5
                    WHEN '6' THEN Question6
                    WHEN '7' THEN Question7
                    WHEN '8' THEN Question8
                    WHEN '9' THEN Question9
                    WHEN '10' THEN Question10
                    WHEN '11' THEN Question11
                    WHEN '12' THEN Question12
                    WHEN '13' THEN Question13
                    WHEN '14' THEN Question14
                    WHEN '15' THEN Question15
                    WHEN '16' THEN Question16
                    WHEN '17' THEN Question17
				END) AS ValuesCount,
                   Count(QuestionnairePK) AS Count
				FROM Questionnaire
                INNER JOIN Teaching ON Teaching_PK = ClassAndLecturer
                INNER JOIN Class ON ClassT = ClassPK
				INNER JOIN Lecturer ON LecturerT = LecturerPK
                INNER JOIN ModuleInProgramInAcademicYear ON ClassModule = MPA_PK
				INNER JOIN ProgramInFacultyInAcademicYear ON ProgramFacultyYear = PFA_PK
                INNER JOIN FacultyInAcademicYear ON FA_PK = FacultyYear
                INNER JOIN Module ON ModuleFK = ModulePK
                INNER JOIN Program ON ProgramFK = ProgramPK
                INNER JOIN AcademicYear ON FalYear = AYearPK
                INNER JOIN Faculty ON FacultyFK = FacultyPK
                INNER JOIN Semester ON ClassSemester = SemesterPK
				WHERE AYearId = COALESCE(inAYearId, AYearId)
                AND SemesterId = COALESCE(inSemesterId,SemesterId)
				AND FacultyId = COALESCE(inFacultyId, FacultyId)
				AND ProgramId = COALESCE(inProgramId, ProgramId)
                AND ModuleId = COALESCE(inModuleId, ModuleId)
                AND ClassId = COALESCE(inClassId, ClassId)
                AND LecturerId = COALESCE(inLecturerId, LecturerId)
                GROUP BY(CASE inQuestion
					WHEN 'Gender' THEN Gender
                    WHEN '0' THEN Question0
                    WHEN '1' THEN Question1
                    WHEN '2' THEN Question2
                    WHEN '3' THEN Question3
                    WHEN '4' THEN Question4
                    WHEN '5' THEN Question5
                    WHEN '6' THEN Question6
                    WHEN '7' THEN Question7
                    WHEN '8' THEN Question8
                    WHEN '9' THEN Question9
                    WHEN '10' THEN Question10
                    WHEN '11' THEN Question11
                    WHEN '12' THEN Question12
                    WHEN '13' THEN Question13
                    WHEN '14' THEN Question14
                    WHEN '15' THEN Question15
                    WHEN '16' THEN Question16
                    WHEN '17' THEN Question17
				END)
                ORDER BY (CASE inQuestion
					WHEN 'Gender' THEN Gender
                    WHEN '0' THEN Question0
                    WHEN '1' THEN Question1
                    WHEN '2' THEN Question2
                    WHEN '3' THEN Question3
                    WHEN '4' THEN Question4
                    WHEN '5' THEN Question5
                    WHEN '6' THEN Question6
                    WHEN '7' THEN Question7
                    WHEN '8' THEN Question8
                    WHEN '9' THEN Question9
                    WHEN '10' THEN Question10
                    WHEN '11' THEN Question11
                    WHEN '12' THEN Question12
                    WHEN '13' THEN Question13
                    WHEN '14' THEN Question14
                    WHEN '15' THEN Question15
                    WHEN '16' THEN Question16
                    WHEN '17' THEN Question17
				END) ASC;
			END CASE;
END//
DELIMITER ;
DELIMITER //

DROP PROCEDURE IF EXISTS GetTotalClassesSize  //
CREATE PROCEDURE GetTotalClassesSize (
	IN inAYearId VARCHAR(10),
    IN inSemesterId  VARCHAR(10),
	IN inFacultyId  VARCHAR(10),
    IN inProgramId  VARCHAR(10),
    IN inModuleId  VARCHAR(10),
    IN inLecturerId  VARCHAR(10),
    IN inClassId VARCHAR(10),
    OUT statusCode INT
)
BEGIN
	CASE
		WHEN inAYearId NOT IN (SELECT AYearId FROM AcademicYear) 			THEN SET statusCode = 401; -- NON-EXISTENT/INVALID Academic Year Id
		WHEN inSemesterId NOT IN (SELECT SemesterId FROM Semester) 			THEN SET statusCode = 402; -- NON-EXISTENT/INVALID Semester Id
		WHEN inFacultyId NOT IN (SELECT FacultyId FROM Faculty) 			THEN SET statusCode = 413; -- NON-EXISTENT/INVALID Faculty Id
		WHEN inProgramId NOT IN (SELECT ProgramId FROM Program) 			THEN SET statusCode = 414; -- NON-EXISTENT/INVALID Program Id
		WHEN inModuleId NOT IN (SELECT ModuleId FROM Module) 				THEN SET statusCode = 415; -- NON-EXISTENT/INVALID Module Id
		WHEN inLecturerId NOT IN (SELECT LecturerId FROM Lecturer) 			THEN SET statusCode = 416; -- NON-EXISTENT/INVALID Lecturer Id
        WHEN inClassId NOT IN (SELECT ClassId FROM Class) 					THEN SET statusCode = 407; -- NON-EXISTENT/INVALID Class Id
		ELSE SET statusCode = 200;-- SUCCESS

        SELECT COALESCE(SUM(Size),0) AS TotalClassesSize
		FROM Class
		INNER JOIN Teaching ON ClassT = ClassPK
		INNER JOIN Lecturer ON LecturerT = LecturerPK
        INNER JOIN ModuleInProgramInAcademicYear ON ClassModule = MPA_PK
		INNER JOIN ProgramInFacultyInAcademicYear ON ProgramFacultyYear = PFA_PK
		INNER JOIN FacultyInAcademicYear ON FA_PK = FacultyYear
		INNER JOIN Module ON ModuleFK = ModulePK
		INNER JOIN Program ON ProgramFK = ProgramPK
        INNER JOIN Semester ON ClassSemester = SemesterPK
		INNER JOIN AcademicYear ON FalYear = AYearPK AND SemYear = AYearPK
		INNER JOIN Faculty ON FacultyFK = FacultyPK
        WHERE AYearId = COALESCE(inAYearId, AYearId) 
				AND SemesterId = COALESCE(inSemesterId,SemesterId)
				AND FacultyId = COALESCE(inFacultyId, FacultyId)
				AND ProgramId = COALESCE(inProgramId, ProgramId)
                AND ModuleId = COALESCE(inModuleId, ModuleId)
                AND ClassId = COALESCE(inClassId, ClassId)
                AND LecturerId = COALESCE(inLecturerId, LecturerId);
	END CASE;
END//

DELIMITER ;