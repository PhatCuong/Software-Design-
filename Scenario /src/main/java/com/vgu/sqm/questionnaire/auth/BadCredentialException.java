package com.vgu.sqm.questionnaire.auth;

public class BadCredentialException extends Exception {
  public static final long serialVersionUID = 1L;

  /** Throws a generic BadCredentialException */
  public BadCredentialException() {
    super("Bad credential");
  }

  /** Throws a BadCredentialException with a message */
  public BadCredentialException(String message) {
    super(message);
  }
}
