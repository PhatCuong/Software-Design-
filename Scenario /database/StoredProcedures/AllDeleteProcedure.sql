/*----------------------DeleteQuestionnaire----------------------*/
-- Remove [Questionnaire] content from table <Questionnaire>
-- Input: Lecturer Id, ClassId, Questionnaire PK
-- Output: Status Code
/*----------------------------------------------------------------*/
DELIMITER //
DROP PROCEDURE IF EXISTS DeleteQuestionnaire//
CREATE PROCEDURE DeleteQuestionnaire(
  IN inLecturerId VARCHAR(10),
  IN inClassId VARCHAR(10),
  IN inQuestionnairePK INT,
  OUT statusCode INT
) BEGIN CASE
  WHEN inLecturerId IS NULL
  OR inLecturerId NOT IN (
    SELECT
      LecturerId
    FROM
      Lecturer
      INNER JOIN TEACHING ON LecturerPK = LecturerT
      INNER JOIN Questionnaire ON Teaching_PK = ClassAndLecturer
  ) THEN
  SET
    statusCode = 416;
-- NON-EXISTENT/INVALID LecturerId
    WHEN inClassId IS NULL
    OR inClassId NOT IN (
      SELECT
        ClassId
      FROM
        Class
        INNER JOIN TEACHING ON ClassPK = ClassT
        INNER JOIN Questionnaire ON Teaching_PK = ClassAndLecturer
    ) THEN
  SET
    statusCode = 407;
-- NON-EXISTENT/INVALID Class Id
    WHEN inQuestionnairePK IS NULL
    OR inQuestionnairePK NOT IN (
      SELECT
        QuestionnairePK
      FROM
        Questionnaire
    ) THEN
  SET
    statusCode = 418;
-- NON-EXISTENT/INVALID Questionnaire
    ELSE
  SET
    statusCode = 200;
-- SUCCESS
  DELETE FROM
    Questionnaire
  WHERE
    inQuestionnairePK = QuestionnairePK
    AND (ClassAndLecturer) IN (
      SELECT
        Teaching_PK
      FROM
        Teaching
        INNER JOIN Class ON ClassT = ClassPK
        INNER JOIN Lecturer ON LecturerT = LecturerPK
      WHERE
        LecturerId = inLecturerId
        AND ClassId = inClassId
    );
END CASE;
END//
DELIMITER ;
/*----------------------------DeleteTeaching-------------------------*/
-- Remove the relation between [Lecturer] & [Class] from table <Teaching>
-- Input: Lecturer Id, Class Id
-- Output: Status Code
/*-------------------------------------------------------------------*/
DELIMITER //
DROP PROCEDURE IF EXISTS DeleteTeaching//
CREATE PROCEDURE DeleteTeaching(
  IN inLecturerId VARCHAR(10),
  IN inClassId VARCHAR(10),
  OUT statusCode INT
) BEGIN CASE
  WHEN inLecturerId IS NULL
  OR inLecturerId NOT IN (
    SELECT
      LecturerId
    FROM
      Lecturer
      INNER JOIN TEACHING ON LecturerPK = LecturerT
  ) THEN
  SET
    statusCode = 416;
-- NON-EXISTENT/INVALID Lecturer Id
    WHEN inClassId IS NULL
    OR inClassId NOT IN (
      SELECT
        ClassId
      FROM
        Class
        INNER JOIN TEACHING ON ClassPK = ClassT
    ) THEN
  SET
    statusCode = 407;
-- NON-EXISTENT/INVALID Class Id
    WHEN (
      SELECT
        Teaching_PK
      FROM
        Teaching
        INNER JOIN Lecturer ON LecturerT = LecturerPK
        INNER JOIN Class ON ClassT = ClassPK
      WHERE
        LecturerId = inLecturerId
        and ClassId = inClassId
    ) IN (
      SELECT
        ClassAndLecturer
      FROM
        Questionnaire
    ) THEN
  SET
    statusCode = 495;
-- DELETE VIOLATION
    ELSE
  SET
    statusCode = 200;
-- SUCCESS
  DELETE FROM
    Teaching
  WHERE
    (LecturerT, ClassT) IN (
      SELECT
        LecturerPK,
        ClassPK
      FROM
        Class NATURAL
        JOIN Lecturer
      WHERE
        LecturerId = inLecturerId
        AND ClassId = inClassId
    );
END CASE;
END//
DELIMITER ;
/*---------------------------DeleteLecturer--------------------------*/
-- Remove [Lecturer] information from table <Lecturer>
-- Input: Lecturer Id
-- Output: Status Code
/*-------------------------------------------------------------------*/
DELIMITER //
DROP PROCEDURE IF EXISTS DeleteLecturer//
CREATE PROCEDURE DeleteLecturer(
  IN inLecturerId VARCHAR(10),
  OUT statusCode INT
) BEGIN CASE
  WHEN inLecturerId IS NULL
  OR inLecturerId NOT IN (
    SELECT
      LecturerId
    FROM
      Lecturer
  ) THEN
  SET
    statusCode = 416;
-- NON-EXISTENT/INVALID Lecturer Id
    WHEN inLecturerId IN (
      SELECT
        LecturerId
      FROM
        Lecturer
        INNER JOIN Teaching ON LecturerPK = LecturerT
    ) THEN
  SET
    statusCode = 495;
-- DELETE VIOLATION
    ELSE
  SET
    statusCode = 200;
-- SUCCESS
  DELETE FROM
    Lecturer
  WHERE
    LecturerId = inLecturerId;
END CASE;
END//
DELIMITER ;
/*---------------------------DeleteClass--------------------------*/
-- Remove [Class] information from table <Class>
-- Input: Class Id
-- Output: Status Code
/*-------------------------------------------------------------------*/
DELIMITER //
DROP PROCEDURE IF EXISTS DeleteClass//
CREATE PROCEDURE DeleteClass(IN inClassId VARCHAR(10), OUT statusCode INT) BEGIN CASE
  WHEN inClassId IS NULL
  OR inClassId NOT IN (
    SELECT
      ClassId
    FROM
      Class
  ) THEN
  SET
    statusCode = 407;
-- NON-EXISTENT/INVALID Class Id
    WHEN inClassId IN (
      SELECT
        ClassId
      FROM
        Class
        INNER JOIN Teaching ON ClassPK = ClassT
    ) THEN
  SET
    statusCode = 495;
-- DELETE VIOLATION
    ELSE
  SET
    statusCode = 200;
-- SUCCESS
  DELETE FROM
    Class
  WHERE
    ClassId = inClassId;
END CASE;
END//
DELIMITER ;
/*----------------------------DeleteModuleInProgramInAcademicYear-------------------------*/
-- Remove the relation between [Module] & [Program] & [AcademicYear] from table <ModuleInProgramInAcademicYear>
-- Input: Module Id, Program Id, AYear Id
-- Output: Status Code
/*-----------------------------------------------------------------------------------------*/
DELIMITER //
DROP PROCEDURE IF EXISTS DeleteModuleInProgramInAcademicYear//
CREATE PROCEDURE DeleteModuleInProgramInAcademicYear(
  IN inModuleId VARCHAR(10),
  IN inProgramId VARCHAR(10),
  IN inAYearId VARCHAR(10),
  OUT statusCode INT
) BEGIN CASE
  WHEN inModuleId IS NULL
  OR inModuleId NOT IN (
    SELECT
      ModuleId
    FROM
      Module
      INNER JOIN ModuleInProgramInAcademicYear ON ModulePK = ModuleFK
  ) THEN
  SET
    statusCode = 415;
-- NON-EXISTENT/INVALID Module Id
    WHEN inProgramId IS NULL
    OR inProgramId NOT IN (
      SELECT
        ProgramId
      FROM
        Program
        INNER JOIN ProgramInFacultyInAcademicYear ON ProgramPK = ProgramFK
        INNER JOIN ModuleInProgramInAcademicYear ON PFA_PK = ProgramFacultyYear
    ) THEN
  SET
    statusCode = 414;
-- NON-EXISTENT/INVALID Program Id
    WHEN inAYearId IS NULL
    OR inAYearId NOT IN (
      SELECT
        AYearId
      FROM
        AcademicYear
        INNER JOIN FacultyInAcademicYear ON AYearPK = FalYear
        INNER JOIN ProgramInFacultyInAcademicYear ON FA_PK = FacultyYear
        INNER JOIN ModuleInProgramInAcademicYear ON PFA_PK = ProgramFacultyYear
    ) THEN
  SET
    statusCode = 401;
-- NON-EXISTENT/INVALID Academic Year Id
    WHEN (
      SELECT
        MPA_PK
      FROM
        ModuleInProgramInAcademicYear
        INNER JOIN Module ON ModuleFK = ModulePK
        INNER JOIN ProgramInFacultyInAcademicYear ON ProgramFacultyYear = PFA_PK
        INNER JOIN Program ON ProgramPK = ProgramFK
        INNER JOIN FacultyInAcademicYear ON FacultyYear = FA_PK
        INNER JOIN AcademicYear ON FalYear = AYearPK
      WHERE
        ModuleId = inModuleId
        AND ProgramId = inProgramId
        AND AYearId = inAYearId
    ) IN (
      SELECT
        ClassModule
      FROM
        Class
    ) THEN
  SET
    statusCode = 495;
-- DELETE VIOLATION
    ELSE
  SET
    statusCode = 200;
-- SUCCESS
  DELETE FROM
    ModuleInProgramInAcademicYear
  WHERE
    (ModuleFK, ProgramFacultyYear) IN (
      SELECT
        ModulePK,
        PFA_PK
      FROM
        Module
        INNER JOIN ProgramInFacultyInAcademicYear
        INNER JOIN Program ON ProgramPK = ProgramFK
        INNER JOIN FacultyInAcademicYear ON FacultyYear = FA_PK
        INNER JOIN AcademicYear ON FalYear = AYearPK
      WHERE
        ModuleId = inModuleId
        AND AYearId = inAYearId
        AND ProgramId = inProgramId
    );
END CASE;
END//
DELIMITER ;
/*---------------------------DeleteModule--------------------------*/
-- Remove [Module] information from table <Module>
-- Input: Module Id
-- Output: Status Code
/*-------------------------------------------------------------------*/
DELIMITER //
DROP PROCEDURE IF EXISTS DeleteModule//
CREATE PROCEDURE DeleteModule(IN inModuleId VARCHAR(10), OUT statusCode INT) BEGIN CASE
  WHEN inModuleId IS NULL
  OR inModuleId NOT IN (
    SELECT
      ModuleId
    FROM
      Module
  ) THEN
  SET
    statusCode = 415;
-- NON-EXISTENT/INVALID Module Id
    WHEN inModuleId IN (
      SELECT
        ModuleId
      FROM
        Module
        INNER JOIN ModuleInProgramInAcademicYear ON ModulePK = ModuleFK
    ) THEN
  SET
    statusCode = 495;
-- DELETE VIOLATION
    ELSE
  SET
    statusCode = 200;
-- SUCCESS
  DELETE FROM
    Module
  WHERE
    ModuleId = inModuleId;
END CASE;
END//
DELIMITER ;
/*---------------------------DeleteProgramInFacultyInAcademicYear--------------------------*/
-- Remove the relation between [Program] & [Faculty] & [AcademicYear] from table <ProgramInFacultyInAcademicYear>
-- Input: Program Id, AYear Id
-- Output: Status Code
/*------------------------------------------------------------------------------------------*/
DELIMITER //
DROP PROCEDURE IF EXISTS DeleteProgramInFacultyInAcademicYear//
CREATE PROCEDURE DeleteProgramInFacultyInAcademicYear(
  IN inProgramId VARCHAR(10),
  IN inAYearId VARCHAR(10),
  OUT statusCode INT
) BEGIN CASE
  WHEN inProgramId IS NULL
  OR inProgramId NOT IN (
    SELECT
      ProgramId
    FROM
      Program
      INNER JOIN ProgramInFacultyInAcademicYear ON ProgramPK = ProgramFK
  ) THEN
  SET
    statusCode = 414;
-- NON-EXISTENT/INVALID Program Id
    WHEN inAYearId IS NULL
    OR inAYearId NOT IN (
      SELECT
        AYearId
      FROM
        AcademicYear
        INNER JOIN FacultyInAcademicYear ON AYearPK = FalYear
        INNER JOIN ProgramInFacultyInAcademicYear ON FA_PK = FacultyYear
    ) THEN
  SET
    statusCode = 401;
-- NON-EXISTENT/INVALID Academic Year Id
    WHEN (
      SELECT
        PFA_PK
      FROM
        ProgramInFacultyInAcademicYear
        INNER JOIN Program ON ProgramFK = ProgramPK
        INNER JOIN FacultyInAcademicYear ON FacultyYear = FA_PK
        INNER JOIN AcademicYear ON FalYear = AYearPK
      WHERE
        ProgramId = inProgramId
        AND AYearId = inAYearId
    ) IN (
      SELECT
        ProgramFacultyYear
      FROM
        ModuleInProgramInAcademicYear
    ) THEN
  SET
    statusCode = 495;
-- DELETE VIOLATION
    ELSE
  SET
    statusCode = 200;
-- SUCCESS
  DELETE FROM
    ProgramInFacultyInAcademicYear
  WHERE
    (ProgramFK, FacultyYear) IN (
      SELECT
        ProgramPK,
        FA_PK
      FROM
        Program
        INNER JOIN FacultyInAcademicYear
        INNER JOIN AcademicYear ON FalYear = AYearPK
      WHERE
        ProgramId = inProgramId
        AND AYearId = inAYearId
    );
END CASE;
END//
DELIMITER ;
/*---------------------------DeleteProgram--------------------------*/
-- Remove [Program] information from table <Program>
-- Input: Program Id
-- Output: Status Code
/*-------------------------------------------------------------------*/
DELIMITER //
DROP PROCEDURE IF EXISTS DeleteProgram//
CREATE PROCEDURE DeleteProgram(IN inProgramId VARCHAR(10), OUT statusCode INT) BEGIN CASE
  WHEN inProgramId IS NULL
  OR inProgramId NOT IN (
    SELECT
      ProgramId
    FROM
      Program
  ) THEN
  SET
    statusCode = 414;
-- NON-EXISTENT/INVALID Program Id
    WHEN inProgramId IN (
      SELECT
        ProgramId
      FROM
        Program
        INNER JOIN ProgramInFacultyInAcademicYear ON ProgramPK = ProgramFK
    ) THEN
  SET
    statusCode = 495;
-- DELETE VIOLATION
    ELSE
  SET
    statusCode = 200;
-- SUCCESS
  DELETE FROM
    Program
  WHERE
    ProgramId = inProgramId;
END CASE;
END//
DELIMITER ;
/*---------------------------DeleteFacultyInAcademicYear--------------------------*/
-- Remove the relation between [Faculty] & [AcademicYear] from table <FacultyInAcademicYear>
-- Input: Faculty Id, AYear Id
-- Output: Status Code
/*------------------------------------------------------------------------------------------*/
DELIMITER //
DROP PROCEDURE IF EXISTS DeleteFacultyInAcademicYear//
CREATE PROCEDURE DeleteFacultyInAcademicYear(
  IN inFacultyId VARCHAR(10),
  IN inAYearId VARCHAR(10),
  OUT statusCode INT
) BEGIN CASE
  WHEN inFacultyId IS NULL
  OR inFacultyId NOT IN (
    SELECT
      FacultyId
    FROM
      Faculty
      INNER JOIN FacultyInAcademicYear ON FacultyPK = FacultyFK
  ) THEN
  SET
    statusCode = 413;
-- NON-EXISTENT/INVALID Faculty Id
    WHEN inAYearId IS NULL
    OR inAYearId NOT IN (
      SELECT
        AYearId
      FROM
        AcademicYear
        INNER JOIN FacultyInAcademicYear ON AYearPK = FalYear
    ) THEN
  SET
    statusCode = 401;
-- NON-EXISTENT/INVALID Academic Year Id
    WHEN (
      SELECT
        FA_PK
      FROM
        FacultyInAcademicYear
        INNER JOIN Faculty ON FacultyFK = FacultyPK
        INNER JOIN AcademicYear ON FalYear = AYearPK
      WHERE
        FacultyId = inFacultyId
        AND AYearId = inAYearId
    ) IN (
      SELECT
        FacultyYear
      FROM
        ProgramInFacultyInAcademicYear
    ) THEN
  SET
    statusCode = 495;
-- DELETE VIOLATION
    ELSE
  SET
    statusCode = 200;
-- SUCCESS
  DELETE FROM
    FacultyInAcademicYear
  WHERE
    (FacultyFK, FalYear) IN (
      SELECT
        FacultyPK,
        AYearPK
      FROM
        Faculty
        INNER JOIN AcademicYear
      WHERE
        FacultyId = inFacultyId
        AND AYearId = inAYearId
    );
END CASE;
END//
DELIMITER ;
/*---------------------------DeleteFaculty--------------------------*/
-- Remove [Faculty] information from table <Faculty>
-- Input: Faculty Id
-- Output: Status Code
/*-------------------------------------------------------------------*/
DELIMITER //
DROP PROCEDURE IF EXISTS DeleteFaculty//
CREATE PROCEDURE DeleteFaculty(IN inFacultyId VARCHAR(10), OUT statusCode INT) BEGIN CASE
  WHEN inFacultyId IS NULL
  OR inFacultyId NOT IN (
    SELECT
      FacultyId
    FROM
      Faculty
  ) THEN
  SET
    statusCode = 413;
-- NON-EXISTENT/INVALID Faculty Id
    WHEN inFacultyId IN (
      SELECT
        FacultyId
      FROM
        Faculty
        INNER JOIN FacultyInAcademicYear ON FacultyPK = FacultyFK
    ) THEN
  SET
    statusCode = 495;
-- DELETE VIOLATION
    ELSE
  SET
    statusCode = 200;
-- SUCCESS
  DELETE FROM
    Faculty
  WHERE
    FacultyId = inFacultyId;
END CASE;
END//
DELIMITER ;
/*---------------------------DeleteSemester--------------------------*/
-- Remove [Semester] information from table <Semester>
-- Input: Semester Id
-- Output: Status Code
/*-------------------------------------------------------------------*/
DELIMITER //
DROP PROCEDURE IF EXISTS DeleteSemester//
CREATE PROCEDURE DeleteSemester(
  IN inSemesterId VARCHAR(10),
  OUT statusCode INT
) BEGIN CASE
  WHEN inSemesterId IS NULL
  OR inSemesterId NOT IN (
    SELECT
      SemesterId
    FROM
      Semester
  ) THEN
  SET
    statusCode = 402;
-- NON-EXISTENT/INVALID Semester Id
    WHEN inSemesterId IN (
      SELECT
        SemesterId
      FROM
        Semester
        INNER JOIN Class ON SemesterPK = ClassSemester
    ) THEN
  SET
    statusCode = 495;
-- DELETE VIOLATION
    ELSE
  SET
    statusCode = 200;
-- SUCCESS
  DELETE FROM
    Semester
  WHERE
    SemesterId = inSemesterId;
END CASE;
END//
DELIMITER ;
/*---------------------------DeleteAcademicYear--------------------------*/
-- Remove [AcademicYear] information from table <AcademicYear>
-- Input: AYear Id
-- Output: Status Code
/*-----------------------------------------------------------------------*/
DELIMITER //
DROP PROCEDURE IF EXISTS DeleteAcademicYear//
CREATE PROCEDURE DeleteAcademicYear(IN inAYearId VARCHAR(10), OUT statusCode INT) BEGIN CASE
  WHEN inAYearId IS NULL
  OR inAYearId NOT IN (
    SELECT
      AYearId
    FROM
      AcademicYear
  ) THEN
  SET
    statusCode = 401;
-- NON-EXISTENT/INVALID Academic Year Id
    WHEN inAYearId IN (
      SELECT
        AYearId
      FROM
        AcademicYear
        INNER JOIN Semester ON AYearPK = SemYear
    ) THEN
  SET
    statusCode = 495;
-- DELETE VIOLATION
    WHEN inAYearId IN (
      SELECT
        AYearId
      FROM
        AcademicYear
        INNER JOIN FacultyInAcademicYear ON AYearPK = FalYear
    ) THEN
  SET
    statusCode = 495;
-- DELETE VIOLATION
    ELSE
  SET
    statusCode = 200;
-- SUCCESS
  DELETE FROM
    AcademicYear
  WHERE
    AYearId = inAYearId;
END CASE;
END//
DELIMITER ;
/*-----------------------------------END-------------------------------*/
