package com.vgu.sqm.questionnaire.resource;

public class MalformedResourceJsonException extends Exception {
  static final long serialVersionUID = 1L;
  private static final String baseMessage = "Malformed JSON request body";

  /** Throw a MalformedResourceJsonException with a message */
  public MalformedResourceJsonException(String message) {
    super(String.format("%s: %s", baseMessage, message));
  }

  /** Throws a generic MalformedResourceJsonException */
  public MalformedResourceJsonException() {
    super(baseMessage);
  }
}
