package com.vgu.sqm.questionnaire.resource;

import com.vgu.sqm.questionnaire.api.ResourceApi;
import com.vgu.sqm.questionnaire.utils.StringUtils;
import java.util.regex.Matcher;
import javax.json.Json;
import javax.json.JsonObject;
import javax.json.JsonObjectBuilder;
import javax.json.stream.JsonParsingException;

public class Teaching extends Resource {
  private String LecturerID;
  private String ClassID;

  public static final String p_LecturerID = "LecturerID";
  public static final String p_ClassID = "ClassID";

  public Teaching(String LecturerID, String ClassID) {
    this.LecturerID = LecturerID;
    this.ClassID = ClassID;
  }

  /**
   * Parse a JSON object and turn it into an Teaching object
   *
   * @param json The JSON object to be turned into a Teaching object
   * @return a Faculty object corresponding to the provided JSON object
   */
  public static Teaching jsonToResource(JsonObject json) throws MalformedResourceJsonException {
    try {
      String LectureID = json.getJsonString(ResourceApi.p_LecturerID).getString();
      String ClassID = json.getJsonString(ResourceApi.p_ClassID).getString();
      if (!Teaching.checkParametersAreValid(LectureID, ClassID)) {
        throw new MalformedResourceJsonException(
            StringUtils.messageInvalidParameters(ResourceApi.p_LecturerID, ResourceApi.p_ClassID));
      }

      return new Teaching(LectureID, ClassID);
    } catch (MalformedResourceJsonException e) {
      throw e;
    } catch (NullPointerException e) {
      throw new MalformedResourceJsonException(
          StringUtils.messageMissingParameters(ResourceApi.p_LecturerID, ResourceApi.p_ClassID));
    } catch (JsonParsingException e) {
      throw new MalformedResourceJsonException();
    }
  }

  public String getLecturerID() {
    return this.LecturerID;
  }

  public String getClassID() {
    return this.ClassID;
  }

  public JsonObject exportResourceJson() {
    JsonObjectBuilder builder = Json.createObjectBuilder();
    builder.add(Teaching.p_LecturerID, this.LecturerID);
    builder.add(Teaching.p_ClassID, this.ClassID);
    JsonObject obj = builder.build();
    return obj;
  }

  /** Checks that the provided parameters are valid */
  public static boolean checkParametersAreValid(String LecturerID, String ClassID) {
    return Resource.isIdValid(LecturerID) && Resource.isIdValid(ClassID);
  }
}
