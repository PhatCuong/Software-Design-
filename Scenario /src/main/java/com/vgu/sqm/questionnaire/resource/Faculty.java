package com.vgu.sqm.questionnaire.resource;

import com.vgu.sqm.questionnaire.api.ResourceApi;
import com.vgu.sqm.questionnaire.utils.StringUtils;
import java.util.regex.Matcher;
import javax.json.Json;
import javax.json.JsonObject;
import javax.json.JsonObjectBuilder;
import javax.json.stream.JsonParsingException;

public class Faculty extends Resource {
  private String FacultyID;
  private String FacultyName;

  public static final String p_FacultyID = "FacultyID";
  public static final String p_FacultyName = "FacultyName";

  public Faculty(String FacultyID, String FacultyName) {
    this.FacultyID = FacultyID;
    this.FacultyName = FacultyName;
  }

  /**
   * Parse a JSON object and turn it into an Faculty object
   *
   * @param json The JSON object to be turned into a Faculty object
   * @return a Faculty object corresponding to the provided JSON object
   */
  public static Faculty jsonToResource(JsonObject json) throws MalformedResourceJsonException {
    try {
      String id = json.getJsonString(ResourceApi.p_FacultyID).getString();
      String name = json.getJsonString(ResourceApi.p_FacultyName).getString();
      if (!Faculty.checkParametersAreValid(id, name)) {
        throw new MalformedResourceJsonException(StringUtils.messageInvalidParameters(
            ResourceApi.p_FacultyID, ResourceApi.p_FacultyName));
      }

      return new Faculty(id, name);
    } catch (MalformedResourceJsonException e) {
      throw e;
    } catch (NullPointerException e) {
      throw new MalformedResourceJsonException(
          StringUtils.messageMissingParameters(ResourceApi.p_FacultyID, ResourceApi.p_FacultyName));
    } catch (JsonParsingException e) {
      throw new MalformedResourceJsonException();
    }
  }

  public String getFacultyID() {
    return this.FacultyID;
  }

  public String getFacultyName() {
    return this.FacultyName;
  }

  public JsonObject exportResourceJson() {
    JsonObjectBuilder builder = Json.createObjectBuilder();
    builder.add(Faculty.p_FacultyID, this.FacultyID);
    builder.add(Faculty.p_FacultyName, this.FacultyName);
    JsonObject obj = builder.build();
    return obj;
  }

  /** Checks that the provided parameters are valid */
  public static boolean checkParametersAreValid(String FacultyID, String FacultyName) {
    return Resource.isIdValid(FacultyID) && Resource.isNameValid(FacultyName);
  }
}
