package com.vgu.sqm.questionnaire.utils;

public class StringUtils {
  public static String messageInvalidParameters(String... params) {
    return "One or more parameters is invalid: " + String.join(", ", params);
  }

  public static String messageMissingParameters(String... params) {
    return "One or more parameters is missing: " + String.join(", ", params);
  }
}
