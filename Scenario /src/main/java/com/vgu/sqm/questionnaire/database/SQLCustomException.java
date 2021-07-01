package com.vgu.sqm.questionnaire.database;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

/**
 * Custom SQL Exceptions
 */
public class SQLCustomException extends Exception {
  public static final Map<Integer, String> errors;

  static {
    errors = new HashMap<Integer, String>();
    // Declare all the errors here
    errors.put(401, "Non-existent Academic Year ID");
    errors.put(402, "Non-existent Semester ID");
    errors.put(403, "Non-existent Faculty name");
    errors.put(404, "Non-existent Program name");
    errors.put(405, "Non-existent Module name");
    errors.put(406, "Non-existent Lecturer name");
    errors.put(407, "Non-existent Class ID");
    errors.put(408, "Non-existent Questionnaire ID");
    errors.put(413, "Non-existent Faculty ID");
    errors.put(414, "Non-existent Program ID");
    errors.put(415, "Non-existent Module ID");
    errors.put(416, "Non-existent Lecturer ID");
    errors.put(418, "Non-existent Questionnaire ID");
    errors.put(420, "Non-existent Username");
    errors.put(427, "Non-existent Class Size");
    errors.put(490, "Duplication Error");
    errors.put(491, "Account already exists");
    errors.put(495, "Delete violation");
  }

  /**
   * Throws an error corresponding to the supplied error code
   */
  public SQLCustomException(int code) {
    super(constructMessage(code));
  }

  /**
   * Gets the error message from the error code
   */
  private static String constructMessage(int code) {
    if (!errors.containsKey(code)) {
      return String.format("Unknown error code: %s", code);
    }

    return errors.get(code);
  }
}
