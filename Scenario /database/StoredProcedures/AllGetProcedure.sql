DELIMITER //
DROP PROCEDURE IF EXISTS GetFaculties//
CREATE PROCEDURE GetFaculties(IN inAYearId VARCHAR(10), OUT statusCode INT) BEGIN CASE
  WHEN inAYearId NOT IN (
    SELECT
      AYearId
    FROM
      AcademicYear
  ) THEN
  SET
    statusCode = 401;
-- NON-EXISTENT/INVALID AcademicYear Id
    ELSE
  SET
    statusCode = 200;
-- SUCCESS
  SELECT
    FacultyId,
    FacultyName
  FROM
    Faculty
    INNER JOIN FacultyInAcademicYear ON FacultyPK = FacultyFK
    INNER JOIN AcademicYear ON FalYear = AYearPK
  WHERE
    AYearId = inAYearId;
END CASE;
END//
DROP PROCEDURE IF EXISTS GetPrograms//
CREATE PROCEDURE GetPrograms(
  IN inAYearId VARCHAR(10),
  IN inFacultyId VARCHAR(10),
  OUT statusCode INT
) BEGIN CASE
  WHEN inAYearId NOT IN (
    SELECT
      AYearId
    FROM
      AcademicYear
  ) THEN
  SET
    statusCode = 401;
-- NON-EXISTENT/INVALID AcademicYear Id
    WHEN inFacultyId NOT IN (
      SELECT
        FacultyId
      FROM
        Faculty
    ) THEN
  SET
    statusCode = 413;
-- NON-EXISTENT/INVALID Faculty Id
    ELSE
  SET
    statusCode = 200;
-- SUCCESS
  SELECT
    ProgramId,
    ProgramName
  FROM
    Program
    INNER JOIN ProgramInFacultyInAcademicYear ON ProgramPK = ProgramFK
    INNER JOIN FacultyInAcademicYear ON FacultyYear = FA_PK
    INNER JOIN Faculty ON FacultyFK = FacultyPK
    INNER JOIN AcademicYear ON FalYear = AYearPK
  WHERE
    AYearId = inAYearId
    AND FacultyId = inFacultyId;
END CASE;
END//
DROP PROCEDURE IF EXISTS GetModules//
CREATE PROCEDURE GetModules(
  IN inAYearId VARCHAR(10),
  IN inProgramId VARCHAR(10),
  OUT statusCode INT
) BEGIN CASE
  WHEN inAYearId NOT IN (
    SELECT
      AYearId
    FROM
      AcademicYear
  ) THEN
  SET
    statusCode = 401;
-- NON-EXISTENT/INVALID AcademicYear Id
    WHEN inProgramId NOT IN (
      SELECT
        ProgramId
      FROM
        Program
    ) THEN
  SET
    statusCode = 414;
-- NON-EXISTENT/INVALID Program Id
    ELSE
  SET
    statusCode = 200;
-- SUCCESS
  SELECT
    ModuleId,
    ModuleName
  FROM
    Module
    INNER JOIN ModuleInProgramInAcademicYear ON ModulePK = ModuleFK
    INNER JOIN ProgramInFacultyInAcademicYear ON ProgramFacultyYear = PFA_PK
    INNER JOIN FacultyInAcademicYear ON FacultyYear = FA_PK
    INNER JOIN Program ON ProgramFK = ProgramPK
    INNER JOIN AcademicYear ON FalYear = AYearPK
  WHERE
    AYearId = inAYearId
    AND ProgramId = inProgramId;
END CASE;
END//
DROP PROCEDURE IF EXISTS GetClasses//
CREATE PROCEDURE GetClasses(
  IN inSemesterId VARCHAR(10),
  IN inProgramId VARCHAR(10),
  IN inModuleId VARCHAR(10),
  OUT statusCode INT
) BEGIN CASE
  WHEN inSemesterId NOT IN (
    SELECT
      SemesterId
    FROM
      Semester
  ) THEN
  SET
    statusCode = 402;
-- NON-EXISTENT/INVALID Semester Id
    WHEN inProgramId NOT IN (
      SELECT
        ProgramId
      FROM
        Program
    ) THEN
  SET
    statusCode = 414;
-- NON-EXISTENT/INVALID Program Id
    WHEN inModuleId NOT IN (
      SELECT
        ModuleId
      FROM
        Module
    ) THEN
  SET
    statusCode = 415;
-- NON-EXISTENT/INVALID Module Id
    ELSE
  SET
    statusCode = 200;
-- SUCCESS
  SELECT
    ClassId
  FROM
    Class
    INNER JOIN ModuleInProgramInAcademicYear ON ClassModule = MPA_PK
    INNER JOIN ProgramInFacultyInAcademicYear ON ProgramFacultyYear = PFA_PK
    INNER JOIN FacultyInAcademicYear ON FacultyYear = FA_PK
    INNER JOIN Module ON ModuleFK = ModulePK
    INNER JOIN Program ON ProgramFK = ProgramPK
    INNER JOIN Semester ON ClassSemester = SemesterPK
  WHERE
    SemesterId = inSemesterId
    AND ProgramId = inProgramId
    AND ModuleId = inModuleId;
END CASE;
END//
DROP PROCEDURE IF EXISTS GetLecturers//
CREATE PROCEDURE GetLecturers(IN inClassId VARCHAR(10), OUT statusCode INT) BEGIN CASE
  WHEN inClassId NOT IN (
    SELECT
      ClassId
    FROM
      Class
  ) THEN
  SET
    statusCode = 407;
-- NON-EXISTENT/INVALID Class Id
    ELSE
  SET
    statusCode = 200;
-- SUCCESS
  SELECT
    LecturerId,
    UserName
  FROM
    Lecturer
    INNER JOIN Teaching ON LecturerPK = LecturerT
    INNER JOIN Class ON ClassT = ClassPK
    INNER JOIN Users ON LecturerUser = UserPK
  WHERE
    ClassId = inClassId;
END CASE;
END//
DELIMITER ;
