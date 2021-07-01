DELIMITER //
DROP PROCEDURE IF EXISTS GetTotalClassesSize//
CREATE PROCEDURE GetTotalClassesSize (
  IN inAYearId VARCHAR(10),
  IN inSemesterId VARCHAR(10),
  IN inFacultyId VARCHAR(10),
  IN inProgramId VARCHAR(10),
  IN inModuleId VARCHAR(10),
  IN inLecturerId VARCHAR(10),
  IN inClassId VARCHAR(10),
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
-- NON-EXISTENT/INVALID Academic Year Id
    WHEN inSemesterId NOT IN (
      SELECT
        SemesterId
      FROM
        Semester
    ) THEN
  SET
    statusCode = 402;
-- NON-EXISTENT/INVALID Semester Id
    WHEN inFacultyId NOT IN (
      SELECT
        FacultyId
      FROM
        Faculty
    ) THEN
  SET
    statusCode = 413;
-- NON-EXISTENT/INVALID Faculty Id
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
    WHEN inLecturerId NOT IN (
      SELECT
        LecturerId
      FROM
        Lecturer
    ) THEN
  SET
    statusCode = 416;
-- NON-EXISTENT/INVALID Lecturer Id
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
    COALESCE(SUM(Size), 0) AS TotalClassesSize
  FROM
    Class
    INNER JOIN Teaching ON ClassT = ClassPK
    INNER JOIN Lecturer ON LecturerT = LecturerPK
    INNER JOIN ModuleInProgramInAcademicYear ON ClassModule = MPA_PK
    INNER JOIN ProgramInFacultyInAcademicYear ON ProgramFacultyYear = PFA_PK
    INNER JOIN FacultyInAcademicYear ON FA_PK = FacultyYear
    INNER JOIN Module ON ModuleFK = ModulePK
    INNER JOIN Program ON ProgramFK = ProgramPK
    INNER JOIN Semester ON ClassSemester = SemesterPK
    INNER JOIN AcademicYear ON FalYear = AYearPK
    AND SemYear = AYearPK
    INNER JOIN Faculty ON FacultyFK = FacultyPK
  WHERE
    AYearId = COALESCE(inAYearId, AYearId)
    AND SemesterId = COALESCE(inSemesterId, SemesterId)
    AND FacultyId = COALESCE(inFacultyId, FacultyId)
    AND ProgramId = COALESCE(inProgramId, ProgramId)
    AND ModuleId = COALESCE(inModuleId, ModuleId)
    AND ClassId = COALESCE(inClassId, ClassId)
    AND LecturerId = COALESCE(inLecturerId, LecturerId);
END CASE;
END//
DELIMITER ;
