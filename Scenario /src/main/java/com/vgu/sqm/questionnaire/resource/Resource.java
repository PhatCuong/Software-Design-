package com.vgu.sqm.questionnaire.resource;

import java.util.regex.Pattern;
import javax.json.JsonObject;

public abstract class Resource {
  /**
   * Gets the JSON form of the Resource object
   *
   * @return the JSON object representing the Resource object
   */
  public abstract JsonObject exportResourceJson();

  /** Check whether a resource ID is valid */
  public static boolean isIdValid(String id) {
    return Pattern.compile("[A-Za-z0-9_-]{1,10}").matcher(id).matches();
  }

  /** Check whether a resource name is valid */
  public static boolean isNameValid(String name) {
    return name.length() > 0 && name.length() <= 100 && !name.isBlank();
  }

  /** Check whether a resource ID is valid but null is ignored and returned as true */
  public static boolean isIdValidAllowNull(String id) {
    if (id == null) {
      return true;
    }
    return isIdValid(id);
  }

  /** Check the validity of an array of resource IDs */
  public static boolean areIdsValid(String... ids) {
    for (String id : ids) {
      if (!isIdValid(id)) {
        return false;
      }
    }
    return true;
  }

  /** Check the validity of an array of resource IDs but null is ignored and returned as true */
  public static boolean areIdsValidAllowNull(String... ids) {
    for (String id : ids) {
      if (!isIdValidAllowNull(id)) {
        return false;
      }
    }
    return true;
  }
}
