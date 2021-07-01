package com.vgu.sqm.questionnaire.auth;

import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.Keys;
import java.security.Key;
import java.util.Calendar;
import java.util.Date;

public class JwtHandler {
  // HS512 key
  private static final Key key = Keys.secretKeyFor(SignatureAlgorithm.HS512);
  // JWT life time
  private static final int jwtLifeTime = 1;

  /**
   * Gets a JWT token for a user as a login token
   * @param username is the user to be signed/authenticated
   * @returns a signed JWT authenticating the provided user
   */
  public static String signUser(String username) {
    Date now = new Date();
    Calendar expiration = Calendar.getInstance();
    expiration.setTime(now);
    expiration.add(Calendar.HOUR_OF_DAY, JwtHandler.jwtLifeTime);

    return Jwts.builder()
        .setSubject(username)
        .setIssuedAt(now)
        .setExpiration(expiration.getTime())
        .signWith(key)
        .compact();
  }
}
