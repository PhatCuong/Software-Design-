package com.vgu.sqm.questionnaire.resource;

import com.vgu.sqm.questionnaire.api.ResourceApi;
import com.vgu.sqm.questionnaire.utils.StringUtils;
import java.util.regex.Matcher;
import javax.json.Json;
import javax.json.JsonObject;
import javax.json.JsonObjectBuilder;
import javax.json.stream.JsonParsingException;

public class Module extends Resource {
  private String ModuleID;
  private String ModuleName;

  public static final String p_ModuleID = "ModuleID";
  public static final String p_ModuleName = "ModuleName";

  public Module(String ModuleID, String ModuleName) {
    this.ModuleID = ModuleID;
    this.ModuleName = ModuleName;
  }

  /**
   * Parse a JSON object and turn it into an Module object
   *
   * @param json The JSON object to be turned into a Module object
   * @return a Module object corresponding to the provided JSON object
   */
  public static Module jsonToResource(JsonObject json) throws MalformedResourceJsonException {
    try {
      String id = json.getJsonString(ResourceApi.p_ModuleID).getString();
      String name = json.getJsonString(ResourceApi.p_ModuleName).getString();
      if (!Module.checkParametersAreValid(id, name)) {
        throw new MalformedResourceJsonException(
            StringUtils.messageInvalidParameters(ResourceApi.p_ModuleID, ResourceApi.p_ModuleName));
      }

      return new Module(id, name);
    } catch (MalformedResourceJsonException e) {
      throw e;
    } catch (NullPointerException e) {
      throw new MalformedResourceJsonException(
          StringUtils.messageMissingParameters(ResourceApi.p_ModuleID, ResourceApi.p_ModuleName));
    } catch (JsonParsingException e) {
      throw new MalformedResourceJsonException();
    }
  }

  public String getModuleID() {
    return this.ModuleID;
  }

  public String getModuleName() {
    return this.ModuleName;
  }

  public JsonObject exportResourceJson() {
    JsonObjectBuilder builder = Json.createObjectBuilder();
    builder.add(Module.p_ModuleID, this.ModuleID);
    builder.add(Module.p_ModuleName, this.ModuleName);
    JsonObject obj = builder.build();
    return obj;
  }

  /** Checks that the provided parameters are valid */
  public static boolean checkParametersAreValid(String ModuleID, String ModuleName) {
    return Resource.isIdValid(ModuleID) && Resource.isNameValid(ModuleName);
  }
}
