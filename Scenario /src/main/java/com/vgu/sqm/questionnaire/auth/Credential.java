package com.vgu.sqm.questionnaire.auth;

import java.util.regex.Pattern;

public class Credential {
  public static final String p_Username = "username";
  public static final String p_Password = "password";
  private static final int minPasswordLength = 8;
  private static final int maxPasswordLength = 500;
  private static final String msg_invalidUsername =
      "Username must be 3-20 characters long and contain only letters, numbers, and the special characters: _ -";
  private static final String msg_invalidPassword =
      String.format("Password must be at least %d characters long", Credential.minPasswordLength);

  private String username;
  private String password;

  /**
   * Create a Credential object

   * @param username is the username
   * @param password is the password
   * @returns a Credential object if username and password are valid
   * @throws BadCredentialException if a credential is invalid (bad username/password)
   */
  public Credential(String username, String password) throws BadCredentialException {
    if (!isUsernameValid(username)) {
      throw new BadCredentialException(Credential.msg_invalidUsername);
    }

    if (!isPasswordValid(password)) {
      throw new BadCredentialException(Credential.msg_invalidPassword);
    }

    this.username = username;
    this.password = password;
  }

  public String getUsername() {
    return this.username;
  }

  public String getPassword() {
    return this.password;
  }

  /** Check whether a username is valid */
  public static boolean isUsernameValid(String username) {
    return Pattern.compile("[A-Za-z0-9_-]{3,20}").matcher(username).matches();
  }

  /** Check whether a password is valid */
  private static boolean isPasswordValid(String password) {
    return password.length() >= Credential.minPasswordLength
        && password.length() <= Credential.maxPasswordLength;
  }
}
