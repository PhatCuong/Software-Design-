DELIMITER //
DROP PROCEDURE IF EXISTS DumpAcademicYear//
CREATE PROCEDURE DumpAcademicYear() BEGIN
SELECT
  AYearId
FROM
  AcademicYear;
END //
/*-------------------------------------------------------*/
DROP PROCEDURE IF EXISTS DumpClass//
CREATE PROCEDURE DumpClass() BEGIN
SELECT
  ClassId,
  Size,
  SemesterId,
  ModuleId
FROM
  Class
  LEFT JOIN ModuleInProgramInAcademicYear ON ClassModule = MPA_PK
  LEFT JOIN ProgramInFacultyInAcademicYear ON ProgramFacultyYear = PFA_PK
  LEFT JOIN FacultyInAcademicYear ON FacultyYear = FA_PK
  INNER JOIN Semester ON ClassSemester = SemesterPK
  INNER JOIN Module ON ClassModule = ModulePK;
END //
/*-------------------------------------------------------*/
DROP PROCEDURE IF EXISTS DumpFaculty//
CREATE PROCEDURE DumpFaculty() BEGIN
SELECT
  FacultyId,
  FacultyName
FROM
  Faculty;
END //
/*-------------------------------------------------------*/
DROP PROCEDURE IF EXISTS DumpFacultyInAcademicYear//
CREATE PROCEDURE DumpFacultyInAcademicYear() BEGIN
SELECT
  FacultyId,
  AYearId
FROM
  Faculty
  INNER JOIN FacultyInAcademicYear ON FacultyPK = FacultyFK
  INNER JOIN AcademicYear ON FalYear = AYearPK;
END //
/*-------------------------------------------------------*/
DROP PROCEDURE IF EXISTS DumpLecturer//
CREATE PROCEDURE DumpLecturer() BEGIN
SELECT
  LecturerId,
  LecturerName,
  UserName
FROM
  Lecturer
  INNER JOIN Users ON LecturerUser = UserPK;
END //
/*-------------------------------------------------------*/
DROP PROCEDURE IF EXISTS DumpModule//
CREATE PROCEDURE DumpModule() BEGIN
SELECT
  ModuleId,
  ModuleName
FROM
  Module;
END //
/*-------------------------------------------------------*/
DROP PROCEDURE IF EXISTS DumpModuleInProgramInAcademicYear//
CREATE PROCEDURE DumpModuleInProgramInAcademicYear() BEGIN
SELECT
  ModuleId,
  ProgramId,
  AYearId
FROM
  Module
  INNER JOIN ModuleInProgramInAcademicYear ON ModulePK = ModuleFK
  INNER JOIN ProgramInFacultyInAcademicYear ON ProgramFacultyYear = PFA_PK
  INNER JOIN FacultyInAcademicYear ON FacultyYear = FA_PK
  INNER JOIN AcademicYear ON FalYear = AYearPK
  INNER JOIN Program ON ProgramFK = ProgramPK;
END //
/*-------------------------------------------------------*/
DROP PROCEDURE IF EXISTS DumpProgram//
CREATE PROCEDURE DumpProgram() BEGIN
SELECT
  ProgramId,
  ProgramName
FROM
  Program;
END //
/*-------------------------------------------------------*/
DROP PROCEDURE IF EXISTS DumpProgramInFacultyInAcademicYear//
CREATE PROCEDURE DumpProgramInFacultyInAcademicYear() BEGIN
SELECT
  ProgramId,
  FacultyId,
  AYearId
FROM
  Program
  INNER JOIN ProgramInFacultyInAcademicYear ON ProgramPK = ProgramFK
  INNER JOIN FacultyInAcademicYear ON FacultyYear = FA_PK
  INNER JOIN AcademicYear ON FalYear = AYearPK
  INNER JOIN Faculty ON FacultyFK = FacultyPK;
END //
/*-------------------------------------------------------*/
DROP PROCEDURE IF EXISTS DumpQuestionnaire//
CREATE PROCEDURE DumpQuestionnaire() BEGIN
SELECT
  QuestionnairePK AS QuestionnaireId,
  LecturerId,
  ClassId,
  Gender + 0 AS Gender,
  Question0 + 0 AS Attendance,
  Question1 + 0 AS Question1,
  Question2 + 0 AS Question2,
  Question3 + 0 AS Question3,
  Question4 + 0 AS Question4,
  Question5 + 0 AS Question5,
  Question6 + 0 AS Question6,
  Question7 + 0 AS Question7,
  Question8 + 0 AS Question8,
  Question9 + 0 AS Question9,
  Question10 + 0 AS Question10,
  Question11 + 0 AS Question11,
  Question12 + 0 AS Question12,
  Question13 + 0 AS Question13,
  Question14 + 0 AS Question14,
  Question15 + 0 AS Question15,
  Question16 + 0 AS Question16,
  Question17 + 0 AS Question17,
  Comment
FROM
  Questionnaire
  INNER JOIN Teaching ON ClassAndLecturer = Teaching_PK
  INNER JOIN Lecturer ON LecturerT = LecturerPK
  INNER JOIN Class ON ClassT = ClassPK;
END //
/*-------------------------------------------------------*/
DROP PROCEDURE IF EXISTS DumpSemester//
CREATE PROCEDURE DumpSemester() BEGIN
SELECT
  SemesterId,
  AYearId
FROM
  Semester
  INNER JOIN AcademicYear ON SemYear = AYearPK;
END //
/*-------------------------------------------------------*/
DROP PROCEDURE IF EXISTS DumpTeaching//
CREATE PROCEDURE DumpTeaching() BEGIN
SELECT
  LecturerId,
  ClassId
FROM
  Teaching
  INNER JOIN Class ON ClassT = ClassPK
  INNER JOIN Lecturer ON LecturerT = LecturerPK;
END//
DELIMITER ;
