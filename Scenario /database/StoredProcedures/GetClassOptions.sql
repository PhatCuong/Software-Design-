DELIMITER //
DROP PROCEDURE IF EXISTS GetClassOptions//
CREATE PROCEDURE GetClassOptions(IN inCLassId VARCHAR(10), OUT statusCode INT) BEGIN CASE
  WHEN inCLassId NOT IN (
    SELECT
      ClassId
    FROM
      Class
  ) THEN
  SET
    statusCode = 407;
-- NON-EXISTENT/INVALID ClassID
    ELSE
  SET
    statusCode = 200;
-- SUCCESS
  SELECT
    AYearId,
    SemesterId,
    FacultyName,
    ProgramName,
    LecturerName,
    ClassId
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
    ClassId = inClassId;
END CASE;
END//
DELIMITER ;
