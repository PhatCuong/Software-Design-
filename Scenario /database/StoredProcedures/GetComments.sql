DELIMITER //
DROP PROCEDURE IF EXISTS GetComments//
CREATE PROCEDURE GetComments(
  IN inClassId VARCHAR(10),
  IN inLecturerId VARCHAR(10),
  OUT statusCode INT
) BEGIN CASE
  WHEN inCLassId NOT IN (
    SELECT
      ClassId
    FROM
      Class
  ) THEN
  SET
    statusCode = 407;
-- NON-EXISTENT/INVALID Class Id
    WHEN inLecturerId NOT IN (
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
    Comment AS comments
  FROM
    Questionnaire
    INNER JOIN Teaching ON ClassAndLecturer = Teaching_PK
    INNER JOIN Class ON ClassT = ClassPK
    INNER JOIN Lecturer ON LecturerT = LecturerPK
  WHERE
    inClassId = ClassId
    AND inLecturerId = LecturerId
    AND Comment IS NOT NULL;
END CASE;
END//
DELIMITER ;
