package com.vgu.sqm.questionnaire.resource;

import com.vgu.sqm.questionnaire.api.ResourceApi;
import com.vgu.sqm.questionnaire.auth.Credential;
import com.vgu.sqm.questionnaire.utils.StringUtils;
import java.util.regex.Matcher;
import javax.json.Json;
import javax.json.JsonObject;
import javax.json.JsonObjectBuilder;
import javax.json.stream.JsonParsingException;

public class Lecturer extends Resource {
  private String LecturerID;
  private String Username;

  public static final String p_LecturerID = "LecturerID";
  public static final String p_Username = "Username";

  public Lecturer(String LecturerID, String Username) {
    this.LecturerID = LecturerID;
    this.Username = Username;
  }

  /**
   * Parse a JSON object and turn it into an Lecturer object
   *
   * @param json The JSON object to be turned into a Lecturer object
   * @return a Lecturer object corresponding to the provided JSON object
   */
  public static Lecturer jsonToResource(JsonObject json) throws MalformedResourceJsonException {
    try {
      String id = json.getJsonString(ResourceApi.p_LecturerID).getString();
      String name = json.getJsonString(Credential.p_Username).getString();
      if (!Lecturer.checkParametersAreValid(id, name)) {
        throw new MalformedResourceJsonException(
            StringUtils.messageInvalidParameters(ResourceApi.p_LecturerID, Credential.p_Username));
      }

      return new Lecturer(id, name);
    } catch (MalformedResourceJsonException e) {
      throw e;
    } catch (NullPointerException e) {
      throw new MalformedResourceJsonException(
          StringUtils.messageMissingParameters(ResourceApi.p_LecturerID, Credential.p_Username));
    } catch (JsonParsingException e) {
      throw new MalformedResourceJsonException();
    }
  }

  public String getLecturerID() {
    return this.LecturerID;
  }

  public String getUsername() {
    return this.Username;
  }

  public JsonObject exportResourceJson() {
    JsonObjectBuilder builder = Json.createObjectBuilder();
    builder.add(Lecturer.p_LecturerID, this.LecturerID);
    builder.add(Lecturer.p_Username, this.Username);
    JsonObject obj = builder.build();
    return obj;
  }

  /** Checks that the provided parameters are valid */
  public static boolean checkParametersAreValid(String LecturerID, String Username) {
    return Resource.isIdValid(LecturerID) && Resource.isNameValid(Username);
  }
}
