DELIMITER //
DROP PROCEDURE IF EXISTS AddCredential//
CREATE PROCEDURE AddCredential (
  IN inUserName VARCHAR(20),
  IN inPassword VARCHAR(500),
  OUT statusCode INT
) BEGIN DECLARE Salt VARCHAR(20);
CASE
  WHEN inUserName IN (
    SELECT
      UserName
    FROM
      Users
  ) THEN
  SET
    statusCode = 491;
-- ACCOUNT already exists
    ELSE
  SET
    statusCode = 200;
-- SUCCESS
  SET
    Salt = LEFT(TO_BASE64(MD5(RAND())), 16);
  INSERT INTO
    Users (UserName)
  VALUES
    (inUserName);
  INSERT INTO
    Credentials (UserCredential, password_hash, password_salt)
  VALUES
    (
      LAST_INSERT_ID(),(SHA2(CONCAT(inPassword, Salt), 512)),
      Salt
    );
END CASE;
END//
DROP PROCEDURE IF EXISTS CheckCredential//
CREATE PROCEDURE CheckCredential (
  IN inUserName VARCHAR(20),
  IN inPassword VARCHAR(500),
  OUT Result BOOLEAN
) BEGIN CASE
  WHEN inUserName NOT IN (
    SELECT
      UserName
    FROM
      Users
  ) THEN
  SET
    Result = 0;
-- ACCOUNT do not exists
    WHEN inUserName IN (
      SELECT
        UserName
      FROM
        Users
    )
    AND (
      SHA2(
        CONCAT(
          inPassword,
          (
            SELECT
              password_salt
            FROM
              Credentials NATURAL
              JOIN Users
            WHERE
              UserName = inUserName
          )
        ),
        512
      )
    ) != (
      SELECT
        password_hash
      FROM
        Credentials NATURAL
        JOIN Users
      WHERE
        UserName = inUserName
    ) THEN
  SET
    Result = 0;
    ELSE
  SET
    Result = 1;
END CASE;
END//
DELIMITER ;
