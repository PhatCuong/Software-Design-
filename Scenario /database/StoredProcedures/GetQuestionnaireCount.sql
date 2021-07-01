DELIMITER //
DROP PROCEDURE IF EXISTS GetQuestionnaireCount//
CREATE PROCEDURE GetQuestionnaireCount(
  IN inAYearId VARCHAR(10),
  IN inSemesterId VARCHAR(10),
  IN inFacultyId VARCHAR(10),
  IN inProgramId VARCHAR(10),
  IN inModuleId VARCHAR(10),
  IN inClassId VARCHAR(10),
  IN inLecturerId VARCHAR(10),
  IN inQuestion ENUM (
    'Gender',
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17'
  ),
  OUT statusCode INT
) BEGIN CASE
  WHEN inAYearId IS NOT NULL
  AND inAYearId NOT IN (
    SELECT
      AYearId
    FROM
      AcademicYear
  ) THEN
  SET
    statusCode = 401;
-- NON-EXISTENT/INVALID AcademicYear Id
    WHEN inSemesterId NOT IN (
      SELECT
        SemesterId
      FROM
        Semester
    ) THEN
  SET
    statusCode = 402;
-- NON-EXISTENT/INVALID Semester Id
    WHEN inFacultyId IS NOT NULL
    AND inFacultyId NOT IN (
      SELECT
        FacultyId
      FROM
        Faculty
    ) THEN
  SET
    statusCode = 413;
-- NON-EXISTENT/INVALID Faculty Id
    WHEN inProgramId IS NOT NULL
    AND inProgramId NOT IN (
      SELECT
        ProgramId
      FROM
        Program
    ) THEN
  SET
    statusCode = 414;
-- NON-EXISTENT/INVALID Program Id
    WHEN inModuleId IS NOT NULL
    AND inModuleId NOT IN (
      SELECT
        ModuleId
      FROM
        Module
    ) THEN
  SET
    statusCode = 415;
-- NON-EXISTENT/INVALID Module Id
    WHEN inClassId IS NOT NULL
    AND inClassId NOT IN (
      SELECT
        ClassId
      FROM
        Class
    ) THEN
  SET
    statusCode = 407;
-- NON-EXISTENT/INVALID Class Id
    WHEN inLecturerId IS NOT NULL
    AND inLecturerId NOT IN (
      SELECT
        LecturerId
      FROM
        Lecturer
    ) THEN
  SET
    statusCode = 416;
-- NON-EXISTENT/INVALID Lecturer Id
    ELSE
  SET
    statusCode = 200;
-- SUCCESS
  SELECT
    (
      CASE
        inQuestion
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
      END
    ) AS ValuesCount,
    Count(QuestionnairePK) AS Count
  FROM
    Questionnaire
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
  WHERE
    AYearId = COALESCE(inAYearId, AYearId)
    AND SemesterId = COALESCE(inSemesterId, SemesterId)
    AND FacultyId = COALESCE(inFacultyId, FacultyId)
    AND ProgramId = COALESCE(inProgramId, ProgramId)
    AND ModuleId = COALESCE(inModuleId, ModuleId)
    AND ClassId = COALESCE(inClassId, ClassId)
    AND LecturerId = COALESCE(inLecturerId, LecturerId)
  GROUP BY(
      CASE
        inQuestion
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
      END
    )
  ORDER BY
    (
      CASE
        inQuestion
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
      END
    ) ASC;
END CASE;
END//
DELIMITER ;
