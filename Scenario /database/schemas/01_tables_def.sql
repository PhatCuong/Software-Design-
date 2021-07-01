CREATE TABLE IF NOT EXISTS AcademicYear (
  AYearPK INT NOT NULL AUTO_INCREMENT,
  AYearId VARCHAR(10) NOT NULL,
  PRIMARY KEY (AYearPK),
  CONSTRAINT AcademicYear UNIQUE (AYearId)
);
CREATE TABLE IF NOT EXISTS Semester (
  SemesterPK INT NOT NULL AUTO_INCREMENT,
  SemesterId VARCHAR(10) NOT NULL,
  SemYear INT NOT NULL,
  PRIMARY KEY(SemesterPK),
  FOREIGN KEY (SemYear) REFERENCES AcademicYear (AYearPK) ON DELETE CASCADE,
  CONSTRAINT Semester UNIQUE (SemesterId)
);
CREATE TABLE IF NOT EXISTS Faculty (
  FacultyPK INT NOT NULL AUTO_INCREMENT,
  FacultyId VARCHAR(10) NOT NULL,
  FacultyName VARCHAR(100) NOT NULL,
  PRIMARY KEY (FacultyPK),
  CONSTRAINT Faculty UNIQUE (FacultyId)
);
CREATE TABLE IF NOT EXISTS FacultyInAcademicYear (
  FA_PK INT NOT NULL AUTO_INCREMENT,
  FacultyFK INT,
  FalYear INT,
  PRIMARY KEY(FA_PK),
  FOREIGN KEY (FacultyFK) REFERENCES Faculty (FacultyPK) ON DELETE CASCADE,
  FOREIGN KEY (FalYear) REFERENCES AcademicYear (AYearPK) ON DELETE CASCADE,
  CONSTRAINT FacultyInAcademicYear UNIQUE (FacultyFK, FalYear)
);
CREATE TABLE IF NOT EXISTS Program (
  ProgramPK INT NOT NULL AUTO_INCREMENT,
  ProgramId VARCHAR(10) NOT NULL,
  ProgramName VARCHAR(100) NOT NULL,
  PRIMARY KEY (ProgramPK),
  CONSTRAINT Program UNIQUE (ProgramId)
);
CREATE TABLE IF NOT EXISTS ProgramInFacultyInAcademicYear (
  PFA_PK INT NOT NULL AUTO_INCREMENT,
  ProgramFK INT,
  FacultyYear INT,
  PRIMARY KEY(PFA_PK),
  FOREIGN KEY (ProgramFK) REFERENCES Program (ProgramPK) ON DELETE CASCADE,
  FOREIGN KEY (FacultyYear) REFERENCES FacultyInAcademicYear (FA_PK) ON DELETE CASCADE,
  CONSTRAINT ProgramInFacultyInAcademicYear UNIQUE (ProgramFK, FacultyYear)
);
CREATE TABLE IF NOT EXISTS Module (
  ModulePK INT NOT NULL AUTO_INCREMENT,
  ModuleId VARCHAR(10) NOT NULL,
  ModuleName VARCHAR(100) NOT NULL,
  PRIMARY KEY (ModulePK),
  CONSTRAINT Module UNIQUE (ModuleId)
);
CREATE TABLE IF NOT EXISTS ModuleInProgramInAcademicYear (
  MPA_PK INT NOT NULL AUTO_INCREMENT,
  ModuleFK INT,
  ProgramFacultyYear INT,
  PRIMARY KEY(MPA_PK),
  FOREIGN KEY (ModuleFK) REFERENCES Module (ModulePK) ON DELETE CASCADE,
  FOREIGN KEY (ProgramFacultyYear) REFERENCES ProgramInFacultyInAcademicYear (PFA_PK) ON DELETE CASCADE,
  CONSTRAINT ModuleInProgramInAcademicYear UNIQUE (ModuleFK, ProgramFacultyYear)
);
CREATE TABLE IF NOT EXISTS Class (
  ClassPK INT NOT NULL AUTO_INCREMENT,
  ClassId VARCHAR(10) NOT NULL,
  Size INT NOT NULL,
  ClassSemester INT NOT NULL,
  ClassModule INT NOT NULL,
  PRIMARY KEY (ClassPK, ClassSemester, ClassModule),
  FOREIGN KEY (ClassSemester) REFERENCES Semester (SemesterPK) ON DELETE CASCADE,
  FOREIGN KEY (ClassModule) REFERENCES ModuleInProgramInAcademicYear (MPA_PK) ON DELETE CASCADE,
  CONSTRAINT Class UNIQUE (ClassId)
);
CREATE TABLE IF NOT EXISTS Users (
  UserPK INT NOT NULL AUTO_INCREMENT,
  UserName VARCHAR(20) NOT NULL,
  PRIMARY KEY (UserPK),
  CONSTRAINT Users UNIQUE (UserName)
);
CREATE TABLE IF NOT EXISTS Lecturer (
  LecturerPK INT NOT NULL AUTO_INCREMENT,
  LecturerId VARCHAR(10) NOT NULL,
  LecturerName VARCHAR(100) NOT NULL,
  LecturerUser INT NOT NULL,
  PRIMARY KEY (LecturerPK),
  FOREIGN KEY (LecturerUser) REFERENCES Users (UserPK) ON DELETE CASCADE,
  CONSTRAINT LecturerUserUnique UNIQUE (LecturerId, LecturerUser)
);
CREATE TABLE IF NOT EXISTS Teaching (
  Teaching_PK INT NOT NULL AUTO_INCREMENT,
  LecturerT INT,
  ClassT INT,
  PRIMARY KEY (Teaching_PK),
  FOREIGN KEY (LecturerT) REFERENCES Lecturer (LecturerPK) ON DELETE CASCADE,
  FOREIGN KEY (ClassT) REFERENCES Class (ClassPK) ON DELETE CASCADE,
  CONSTRAINT Teaching UNIQUE (LecturerT, ClassT)
);
CREATE TABLE IF NOT EXISTS Credentials (
  UserCredential INT NOT NULL,
  password_hash VARCHAR(128),
  password_salt VARCHAR(16),
  PRIMARY KEY (UserCredential),
  FOREIGN KEY (UserCredential) REFERENCES Users (UserPK) ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS ProgramCoordinator (
  CoordinatorPK INT NOT NULL AUTO_INCREMENT,
  CoordinatorUser INT NOT NULL,
  ProgramPK INT NOT NULL,
  CoordinatorName VARCHAR(100) NOT NULL,
  StartDate DATE NOT NULL,
  EndDate DATE NOT NULL,
  PRIMARY KEY(CoordinatorPK),
  FOREIGN KEY (CoordinatorUser) REFERENCES Users (UserPK) ON DELETE CASCADE,
  FOREIGN KEY (ProgramPK) REFERENCES Program (ProgramPK) ON DELETE CASCADE,
  CONSTRAINT ProgramCoordinatorUser UNIQUE (CoordinatorPK, CoordinatorUser)
);
CREATE TABLE IF NOT EXISTS Dean (
  DeanPK INT NOT NULL AUTO_INCREMENT,
  DeanUser INT NOT NULL,
  FacultyPK INT NOT NULL,
  DeanName VARCHAR(100) NOT NULL,
  StartDate DATE NOT NULL,
  EndDate DATE NOT NULL,
  PRIMARY KEY(DeanPK),
  FOREIGN KEY (FacultyPK) REFERENCES Faculty (FacultyPK) ON DELETE CASCADE,
  FOREIGN KEY (DeanUser) REFERENCES Users (UserPK),
  CONSTRAINT DeanUserUnique UNIQUE (DeanPK, DeanUser)
);
CREATE TABLE IF NOT EXISTS Questionnaire (
  QuestionnairePK INT NOT NULL AUTO_INCREMENT,
  ClassAndLecturer INT NOT NULL,
  Gender ENUM('M', 'F', 'O') NOT NULL,
  Question0 ENUM('1', '2', '3', '4', '5') NOT NULL,
  Question1 ENUM('1', '2', '3', '4', '5', 'N/A') NOT NULL,
  Question2 ENUM('1', '2', '3', '4', '5', 'N/A') NOT NULL,
  Question3 ENUM('1', '2', '3', '4', '5', 'N/A') NOT NULL,
  Question4 ENUM('1', '2', '3', '4', '5', 'N/A') NOT NULL,
  Question5 ENUM('1', '2', '3', '4', '5') NOT NULL,
  Question6 ENUM('1', '2', '3', '4', '5') NOT NULL,
  Question7 ENUM('1', '2', '3', '4', '5') NOT NULL,
  Question8 ENUM('1', '2', '3', '4', '5', 'N/A') NOT NULL,
  Question9 ENUM('1', '2', '3', '4', '5', 'N/A') NOT NULL,
  Question10 ENUM('1', '2', '3', '4', '5', 'N/A') NOT NULL,
  Question11 ENUM('1', '2', '3', '4', '5', 'N/A') NOT NULL,
  Question12 ENUM('1', '2', '3', '4', '5', 'N/A') NOT NULL,
  Question13 ENUM('1', '2', '3', '4', '5', 'N/A') NOT NULL,
  Question14 ENUM('1', '2', '3', '4', '5', 'N/A') NOT NULL,
  Question15 ENUM('1', '2', '3', '4', '5', 'N/A') NOT NULL,
  Question16 ENUM('1', '2', '3', '4', '5', 'N/A') NOT NULL,
  Question17 ENUM('1', '2', '3', '4', '5', 'N/A') NOT NULL,
  Comment TEXT,
  PRIMARY KEY (QuestionnairePK, ClassAndLecturer),
  FOREIGN KEY (ClassAndLecturer) REFERENCES Teaching (Teaching_PK) ON DELETE CASCADE
);
/*Trigger to auto_increment QID based on LID-CID*/
DELIMITER //
CREATE TRIGGER QID_AutoIncrement BEFORE
INSERT
  ON Questionnaire FOR EACH ROW BEGIN
SELECT
  MAX(QuestionnairePK) INTO @auto_id
FROM
  Questionnaire
where
  ClassAndLecturer = NEW.ClassAndLecturer;
SET
  NEW.questionnairePK = COALESCE(@AUTO_ID + 1, 1);
END//
DELIMITER ;
