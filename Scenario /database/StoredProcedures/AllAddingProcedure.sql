/*----------------------AddAcademicYear----------------------*/
-- Add [Academic Year] information into table <AcademicYear>
-- Input: AYear Id
-- Output: Status Code
/*------------------------------------------------------------*/
DELIMITER //
DROP PROCEDURE IF EXISTS AddAcademicYear//
CREATE PROCEDURE AddAcademicYear(IN inAYearId VARCHAR(10), OUT statusCode INT) BEGIN CASE
  WHEN inAYearId IS NULL THEN
  SET
    statusCode = 401;
-- NON-EXISTENT/INVALID Academic Year Id
    WHEN inAYearId IN (
      SELECT
        AYearId
      FROM
        AcademicYear
    ) THEN
  SET
    statusCode = 490;
-- DUPLICATION ERROR
    ELSE
  SET
    statusCode = 200;
-- SUCCESS
  INSERT INTO
    AcademicYear (AYearId)
  VALUES
    (inAYearId);
END CASE;
END //
/*-----------------------AddSemester--------------------------*/
-- Add [Semester] information into table <Semester>
-- Input: Semester Id, AYear Id
-- Output: Status Code
/*---------------------------------  --------------------------*/
DROP PROCEDURE IF EXISTS AddSemester//
CREATE PROCEDURE AddSemester(
  IN inSemesterId VARCHAR(10),
  IN inAYearId VARCHAR(10),
  OUT statusCode INT
) BEGIN CASE
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
    WHEN inSemesterId IS NULL THEN
  SET
    statusCode = 402;
-- NON-EXISTENT/INVALID Semester Id
    WHEN inSemesterId IN (
      SELECT
        SemesterId
      FROM
        Semester
    ) THEN
  SET
    statusCode = 490;
-- DUPLICATION ERROR
    ELSE
  SET
    statusCode = 200;
-- SUCCESS
  INSERT INTO
    Semester (SemesterId, SemYear)
  VALUES
    (
      inSemesterId,(
        SELECT
          AYearPK
        FROM
          AcademicYear
        WHERE
          AYearId = inAYearId
      )
    );
END CASE;
END //
/*--------------------------AddFaculty--------------------------*/
-- Add [Faculty] information into table <Faculty>
-- Input: Faculty Id, Faculty Name
-- Output: Status Code
/*--------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS AddFaculty//
CREATE PROCEDURE AddFaculty(
  IN inFacultyId VARCHAR(10),
  IN inFacultyName VARCHAR(100),
  OUT statusCode INT
) BEGIN CASE
  WHEN inFacultyId IS NULL THEN
  SET
    statusCode = 413;
-- NON-EXISTENT/INVALID Faculty Id
    WHEN inFacultyName IS NULL THEN
  SET
    statusCode = 403;
-- NON-EXISTENT/INVALID Faculty Name
    WHEN inFacultyId IN (
      SELECT
        FacultyId
      FROM
        Faculty
    ) THEN
  SET
    statusCode = 490;
-- DUPLICATION ERROR
    ELSE
  SET
    statusCode = 200;
-- SUCCESS
  INSERT INTO
    Faculty (FacultyId, FacultyName)
  VALUES
    (inFacultyId, inFacultyName);
END CASE;
END //
/*-------------------------AddFacultyInAcademicYear----------------------------*/
-- Add the relation between [Faculty] & [AcademicYear] into table <FacultyInAcademicYear>
-- Input: Faculty Id, AYear Id
-- Output: Status Code
/*-----------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS AddFacultyInAcademicYear//
CREATE PROCEDURE AddFacultyInAcademicYear(
  IN inFacultyId VARCHAR(10),
  IN inAYearId VARCHAR(10),
  OUT statusCode INT
) BEGIN CASE
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
    WHEN (
      (
        SELECT
          AYearPK,
          FacultyPK
        FROM
          AcademicYear NATURAL
          JOIN Faculty
        WHERE
          FacultyId = inFacultyId
          AND AYearId = inAYearId
      )
    ) IN (
      SELECT
        FalYear,
        FacultyFK
      FROM
        FacultyInAcademicYear
    ) THEN
  SET
    statusCode = 490;
-- DUPLICATION ERROR
    ELSE
  SET
    statusCode = 200;
-- SUCCESS
  INSERT INTO
    FacultyInAcademicYear (FacultyFK, FalYear)
  VALUES
    (
      (
        SELECT
          FacultyPK
        FROM
          Faculty
        WHERE
          FacultyId = inFacultyId
      ),(
        SELECT
          AYearPK
        FROM
          AcademicYear
        WHERE
          AYearId = inAYearId
      )
    );
END CASE;
END //
/*-----------------------AddProgram-------------------------*/
-- Add [Program] information into table <Program>
-- Input: Program Id, Program Name
-- Output: Status Code
/*----------------------------------------------------------*/
DROP PROCEDURE IF EXISTS AddProgram//
CREATE PROCEDURE AddProgram(
  IN inProgramId VARCHAR(10),
  IN inProgramName VARCHAR(100),
  OUT statusCode INT
) BEGIN CASE
  WHEN inProgramId IS NULL THEN
  SET
    statusCode = 414;
-- NON-EXISTENT/INVALID Program Id
    WHEN inProgramName IS NULL THEN
  SET
    statusCode = 404;
-- NON-EXISTENT/INVALID Program Name
    WHEN inProgramId IN (
      SELECT
        ProgramId
      FROM
        Program
    ) THEN
  SET
    statusCode = 490;
-- DUPLICATION ERROR
    ELSE
  SET
    statusCode = 200;
-- SUCCESS
  INSERT INTO
    Program (ProgramId, ProgramName)
  VALUES
    (inProgramId, inProgramName);
END CASE;
END //
/*------------------------------------AddProgramInFacultyInAcademicYear-----------------------------------------*/
-- Add the relation between [Program] & [Faculty] & [AcademicYear] into table <ProgramInFacultyInAcademicYear>
-- Input: Program Id, Faculty Id, AYear Id
-- Output: Status Code
/*--------------------------------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS AddProgramInFacultyInAcademicYear//
CREATE PROCEDURE AddProgramInFacultyInAcademicYear(
  IN inProgramId VARCHAR(10),
  IN inFacultyId VARCHAR(10),
  IN inAYearId VARCHAR(10),
  OUT statusCode INT
) BEGIN CASE
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
    WHEN (
      (
        SELECT
          ProgramPK,
          FA_PK
        FROM
          Program NATURAL
          JOIN FacultyInAcademicYear
          INNER JOIN Faculty ON FacultyFK = FacultyPK
          INNER JOIN AcademicYear ON FalYear = AYearPK
        WHERE
          ProgramId = inProgramId
          AND FacultyId = inFacultyId
          AND AYearId = inAYearId
      )
    ) IN (
      SELECT
        ProgramFK,
        FacultyYear
      FROM
        ProgramInFacultyInAcademicYear
    ) THEN
  SET
    statusCode = 490;
-- DUPLICATION ERROR
    ELSE
  SET
    statusCode = 200;
-- SUCCESS
  INSERT INTO
    ProgramInFacultyInAcademicYear (ProgramFK, FacultyYear)
  SELECT
    ProgramPK,
    FA_PK
  FROM
    Program NATURAL
    JOIN FacultyInAcademicYear
    INNER JOIN Faculty ON FacultyFK = FacultyPK
    INNER JOIN AcademicYear ON FalYear = AYearPK
  WHERE
    ProgramId = inProgramId
    AND FacultyId = inFacultyId
    AND AYearId = inAYearId;
END CASE;
END //
/*---------------------AddLecturer------------------------*/
-- Add [Lecturer] information into the table <Lecturer>
-- Input: Lecturer Id, Lecturer Name, Username
-- Output: Status Code
/*---------------------------------------------------------*/
DROP PROCEDURE IF EXISTS AddLecturer//
CREATE PROCEDURE AddLecturer(
  IN inLecturerId VARCHAR(10),
  IN inLecturerName VARCHAR(100),
  IN inUserName VARCHAR(20),
  OUT statusCode INT
) BEGIN CASE
  WHEN inLecturerId IS NULL THEN
  SET
    statusCode = 416;
-- NON-EXISTENT/INVALID LecturerId
    WHEN inLecturerId IN (
      SELECT
        LecturerId
      FROM
        Lecturer
    ) THEN
  SET
    statusCode = 490;
-- DUPLICATION ERROR
    WHEN inLecturerName IS NULL THEN
  SET
    statusCode = 406;
-- NON-EXISTENT/INVALID Lecturer Name
    WHEN inUserName IS NULL
    OR inUserName NOT IN (
      SELECT
        UserName
      FROM
        Users
    ) THEN
  SET
    statusCode = 420;
-- NON-EXISTENT/INVALID Username
    ELSE
  SET
    statusCode = 200;
-- SUCCESS
  INSERT INTO
    Lecturer (LecturerId, LecturerName, LecturerUser)
  VALUES
    (
      inLecturerId,
      inLecturerName,(
        SELECT
          UserPK
        FROM
          Users
        WHERE
          UserName = inUserName
      )
    );
END CASE;
END //
/*-------------------------AddModule-------------------------*/
-- Add [Module] information into the table <Module>
-- Input: Module Id, Module Name
-- Output: Status Code
/*-----------------------------------------------------------*/
DROP PROCEDURE IF EXISTS AddModule//
CREATE PROCEDURE AddModule(
  IN inModuleId VARCHAR(10),
  IN inModuleName VARCHAR(100),
  OUT statusCode INT
) BEGIN CASE
  WHEN inModuleId IS NULL THEN
  SET
    statusCode = 415;
    WHEN inModuleName IS NULL THEN
  SET
    statusCode = 405;
    WHEN inModuleId IN (
      SELECT
        ModuleId
      FROM
        Module
    ) THEN
  SET
    statusCode = 490;
-- DUPLICATION ERROR
    ELSE
  SET
    statusCode = 200;
-- SUCCESS
  INSERT INTO
    Module (ModuleId, ModuleName)
  VALUES
    (inModuleId, inModuleName);
END CASE;
END //
/*--------------------------------AddModuleInProgramInAcademicYear-------------------------------*/
-- Add the relation between [Module] & [Program] & [AcademicYear] into table <ModuleInProgramInAcademicYear>
-- Input: Module Id, Size, Program Id, AYear Id
-- Output: Status Code
/*-----------------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS AddModuleInProgramInAcademicYear//
CREATE PROCEDURE AddModuleInProgramInAcademicYear(
  IN inModuleId VARCHAR(10),
  IN inProgramId VARCHAR(10),
  IN inAYearId VARCHAR(10),
  OUT statusCode INT
) BEGIN CASE
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
    WHEN (
      SELECT
        ModulePK,
        PFA_PK
      FROM
        Module NATURAL
        JOIN ProgramInFacultyInAcademicYear
        INNER JOIN FacultyInAcademicYear ON FacultyYear = FA_PK
        INNER JOIN Program ON ProgramFK = ProgramPK
        INNER JOIN AcademicYear ON FalYear = AYearPK
      WHERE
        AYearId = inAYearId
        AND ProgramId = inProgramId
        AND ModuleId = inModuleId
    ) IN (
      SELECT
        ModuleFK,
        ProgramFacultyYear
      FROM
        ModuleInProgramInAcademicYear
    ) THEN
  SET
    statusCode = 490;
-- DUPLICATION ERROR
    ELSE
  SET
    statusCode = 200;
-- SUCCESS
  INSERT INTO
    ModuleInProgramInAcademicYear (ModuleFK, ProgramFacultyYear)
  SELECT
    ModulePK,
    PFA_PK
  FROM
    Module NATURAL
    JOIN ProgramInFacultyInAcademicYear
    INNER JOIN FacultyInAcademicYear ON FacultyYear = FA_PK
    INNER JOIN Program ON ProgramFK = ProgramPK
    INNER JOIN AcademicYear ON FalYear = AYearPK
  WHERE
    ModuleId = inModuleId
    AND ProgramId = inProgramId
    AND AYearId = inAYearId;
END CASE;
END //
/*---------------------AddClass----------------------*/
-- Add Class information into table <Class>
-- Input: Class Id, Size, Semester Id, Module Id
-- Output: Status Code
/*---------------------------------------------------*/
DROP PROCEDURE IF EXISTS AddClass//
CREATE PROCEDURE AddClass(
  IN inClassId VARCHAR(10),
  IN inSize INT,
  IN inSemesterId VARCHAR(10),
  IN inModuleId VARCHAR(10),
  OUT statusCode INT
) BEGIN CASE
  WHEN inClassId IS NULL THEN
  SET
    statusCode = 407;
--  NON-EXISTENT/INVALID Class Id
    WHEN inSize IS NULL THEN
  SET
    statusCode = 427;
-- NON-EXISTENT/INVALID Class Size
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
    WHEN inClassId IN (
      SELECT
        ClassId
      FROM
        Class
    ) THEN
  SET
    statusCode = 490;
-- DUPLICATION ERROR
    ELSE
  SET
    statusCode = 200;
-- SUCCESS
  INSERT INTO
    Class (ClassId, Size, ClassSemester, ClassModule)
  VALUES
    (
      inClassId,
      inSize,
      (
        SELECT
          SemesterPK
        FROM
          Semester
        WHERE
          SemesterId = inSemesterId
      ),
      (
        SELECT
          MPA_PK
        FROM
          ModuleInProgramInAcademicYear
          INNER JOIN Module ON ModuleFK = ModulePK
        WHERE
          ModuleId = inModuleId
      )
    );
END CASE;
END //
/*-----------------------AddTeaching----------------------*/
-- Add the relation between [Lecturer] & [Class] into table <Teaching>
-- Input: LecturerId, ClassId
-- Output: Status Code
/*--------------------------------------------------------*/
DROP PROCEDURE IF EXISTS AddTeaching//
CREATE PROCEDURE AddTeaching(
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
    ) THEN
  SET
    statusCode = 407;
-- NON-EXISTENT/INVALID Class Id
    WHEN(
      (
        SELECT
          LecturerPK,
          ClassPK
        FROM
          Lecturer,
          Class
        WHERE
          LecturerId = inLecturerId
          AND ClassId = inClassId
      )
    ) IN (
      SELECT
        LecturerT,
        ClassT
      FROM
        Teaching
    ) THEN
  SET
    statusCode = 490;
-- DUPLICATION ERROR
    ELSE
  SET
    statusCode = 200;
-- SUCCESS
  INSERT INTO
    Teaching (LecturerT, ClassT)
  VALUES
    (
      (
        SELECT
          LecturerPK
        FROM
          Lecturer
        WHERE
          LecturerId = inLecturerId
      ),
      (
        SELECT
          ClassPK
        FROM
          Class
        WHERE
          ClassId = inClassId
      )
    );
END CASE;
END //
/*---------------------AddQuestionnaire----------------------*/
-- Add [questionnaire] content into table <questionnaire>
-- Input: LecturerId, ClassId, Gender, Q1 - Q17, comment
-- Output: Status Code
/*-----------------------------------------------------------*/
DROP PROCEDURE IF EXISTS AddQuestionnaire//
CREATE PROCEDURE AddQuestionnaire(
  IN inLecturerId VARCHAR(10),
  IN inClassId VARCHAR(10),
  IN inGender ENUM('M', 'F', 'O'),
  IN inQuestion0 ENUM('1', '2', '3', '4', '5'),
  IN inQuestion1 ENUM('1', '2', '3', '4', '5', 'N/A'),
  IN inQuestion2 ENUM('1', '2', '3', '4', '5', 'N/A'),
  IN inQuestion3 ENUM('1', '2', '3', '4', '5', 'N/A'),
  IN inQuestion4 ENUM('1', '2', '3', '4', '5', 'N/A'),
  IN inQuestion5 ENUM('1', '2', '3', '4', '5'),
  IN inQuestion6 ENUM('1', '2', '3', '4', '5'),
  IN inQuestion7 ENUM('1', '2', '3', '4', '5'),
  IN inQuestion8 ENUM('1', '2', '3', '4', '5', 'N/A'),
  IN inQuestion9 ENUM('1', '2', '3', '4', '5', 'N/A'),
  IN inQuestion10 ENUM('1', '2', '3', '4', '5', 'N/A'),
  IN inQuestion11 ENUM('1', '2', '3', '4', '5', 'N/A'),
  IN inQuestion12 ENUM('1', '2', '3', '4', '5', 'N/A'),
  IN inQuestion13 ENUM('1', '2', '3', '4', '5', 'N/A'),
  IN inQuestion14 ENUM('1', '2', '3', '4', '5', 'N/A'),
  IN inQuestion15 ENUM('1', '2', '3', '4', '5', 'N/A'),
  IN inQuestion16 ENUM('1', '2', '3', '4', '5', 'N/A'),
  IN inQuestion17 ENUM('1', '2', '3', '4', '5', 'N/A'),
  IN inComment TEXT,
  OUT statusCode INT
) BEGIN CASE
  WHEN inLecturerId IS NULL
  OR inLecturerId NOT IN (
    SELECT
      LecturerId
    FROM
      Lecturer
      INNER JOIN Teaching ON LecturerPK = LecturerT
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
        INNER JOIN Teaching ON ClassPK = ClassT
    ) THEN
  SET
    statusCode = 407;
-- NON-EXISTENT/INVALID Class Id
    ELSE
  SET
    statusCode = 200;
-- SUCCESS
  INSERT INTO
    Questionnaire (
      ClassAndLecturer,
      Gender,
      Question0,
      Question1,
      Question2,
      Question3,
      Question4,
      Question5,
      Question6,
      Question7,
      Question8,
      Question9,
      Question10,
      Question11,
      Question12,
      Question13,
      Question14,
      Question15,
      Question16,
      Question17,
      Comment
    )
  SELECT
    Teaching_PK,
    inGender,
    inQuestion0,
    inQuestion1,
    inQuestion2,
    inQuestion3,
    inQuestion4,
    inQuestion5,
    inQuestion6,
    inQuestion7,
    inQuestion8,
    inQuestion9,
    inQuestion10,
    inQuestion11,
    inQuestion12,
    inQuestion13,
    inQuestion14,
    inQuestion15,
    inQuestion16,
    inQuestion17,
    inComment
  FROM
    Teaching
    INNER JOIN Lecturer ON LecturerT = LecturerPK
    INNER JOIN Class ON ClassT = ClassPK
  WHERE
    LecturerId = inLecturerId
    AND ClassId = inClassId;
END CASE;
END//
DELIMITER ;
/*--------------------END--------------------------*/
