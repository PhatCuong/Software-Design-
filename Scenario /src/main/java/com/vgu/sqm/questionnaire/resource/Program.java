package com.vgu.sqm.questionnaire.resource;

import com.vgu.sqm.questionnaire.api.ResourceApi;
import com.vgu.sqm.questionnaire.utils.StringUtils;
import java.util.regex.Matcher;
import javax.json.Json;
import javax.json.JsonObject;
import javax.json.JsonObjectBuilder;
import javax.json.stream.JsonParsingException;

public class Program extends Resource {
  private String ProgramID;
  private String ProgramName;

  public static final String p_ProgramID = "ProgramID";
  public static final String p_ProgramName = "ProgramName";

  public Program(String ProgramID, String ProgramName) {
    this.ProgramID = ProgramID;
    this.ProgramName = ProgramName;
  }

  /**
   * Parse a JSON object and turn it into an Program object
   *
   * @param json The JSON object to be turned into a Program object
   * @return a Program object corresponding to the provided JSON object
   */
  public static Program jsonToResource(JsonObject json) throws MalformedResourceJsonException {
    try {
      String id = json.getJsonString(ResourceApi.p_ProgramID).getString();
      String name = json.getJsonString(ResourceApi.p_ProgramName).getString();
      if (!Program.checkParametersAreValid(id, name)) {
        throw new MalformedResourceJsonException(StringUtils.messageInvalidParameters(
            ResourceApi.p_ProgramID, ResourceApi.p_ProgramName));
      }

      return new Program(id, name);
    } catch (MalformedResourceJsonException e) {
      throw e;
    } catch (NullPointerException e) {
      throw new MalformedResourceJsonException(
          StringUtils.messageMissingParameters(ResourceApi.p_ProgramID, ResourceApi.p_ProgramName));
    } catch (JsonParsingException e) {
      throw new MalformedResourceJsonException();
    }
  }

  public String getProgramID() {
    return this.ProgramID;
  }

  public String getProgramName() {
    return this.ProgramName;
  }

  public JsonObject exportResourceJson() {
    JsonObjectBuilder builder = Json.createObjectBuilder();
    builder.add(Program.p_ProgramID, this.ProgramID);
    builder.add(Program.p_ProgramName, this.ProgramName);
    JsonObject obj = builder.build();
    return obj;
  }

  /** Checks that the provided parameters are valid */
  public static boolean checkParametersAreValid(String ProgramID, String ProgramName) {
    return Resource.isIdValid(ProgramID) && Resource.isNameValid(ProgramName);
  }
}
