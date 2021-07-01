package com.vgu.sqm.questionnaire.resource;

import com.vgu.sqm.questionnaire.api.ResourceApi;
import com.vgu.sqm.questionnaire.utils.StringUtils;
import java.util.regex.Matcher;
import javax.json.Json;
import javax.json.JsonObject;
import javax.json.JsonObjectBuilder;
import javax.json.stream.JsonParsingException;

public class Class extends Resource {
  private String ClassID;
  private int Size;
  private String SemesterID;
  private String ModuleID;

  public static final String p_ClassID = "ClassID";
  public static final String p_SemesterID = "SemesterID";
  public static final String p_ModuleID = "ModuleID";
  public static final String p_Size = "Size";

  public Class(String ClassID, int Size, String SemesterID, String ModuleID) {
    this.ClassID = ClassID;
    this.Size = Size;
    this.SemesterID = SemesterID;
    this.ModuleID = ModuleID;
  }

  /**
   * Parse a JSON object and turn it into an Class object
   *
   * @param json The JSON object to be turned into a Class object
   * @return a Class object corresponding to the provided JSON object
   */
  public static Class jsonToResource(JsonObject json) throws MalformedResourceJsonException {
    try {
      String ClassID = json.getJsonString(ResourceApi.p_ClassID).getString();
      int Size = json.getJsonNumber(ResourceApi.p_Size).intValue();
      String SemesterID = json.getJsonString(ResourceApi.p_SemesterID).getString();
      String ModuleID = json.getJsonString(ResourceApi.p_ModuleID).getString();
      if (!Class.checkParametersAreValid(ClassID, Size, SemesterID, ModuleID)) {
        throw new MalformedResourceJsonException(
            StringUtils.messageInvalidParameters(ResourceApi.p_ClassID, ResourceApi.p_Size,
                ResourceApi.p_SemesterID, ResourceApi.p_ModuleID));
      }

      return new Class(ClassID, Size, SemesterID, ModuleID);
    } catch (MalformedResourceJsonException e) {
      throw e;
    } catch (NullPointerException e) {
      throw new MalformedResourceJsonException(StringUtils.messageMissingParameters(
          ResourceApi.p_ClassID, ResourceApi.p_SemesterID, ResourceApi.p_ModuleID));
    } catch (ClassCastException e) {
      throw new MalformedResourceJsonException(
          String.format("%s must be an integer", ResourceApi.p_Size));
    } catch (JsonParsingException e) {
      throw new MalformedResourceJsonException();
    }
  }

  public String getClassID() {
    return this.ClassID;
  }

  public int getSize() {
    return this.Size;
  }

  public String getSemesterID() {
    return this.SemesterID;
  }

  public String getModuleID() {
    return this.ModuleID;
  }

  public JsonObject exportResourceJson() {
    JsonObjectBuilder builder = Json.createObjectBuilder();
    builder.add(Class.p_ClassID, this.ClassID);
    builder.add(Class.p_Size, this.Size);
    builder.add(Class.p_SemesterID, this.SemesterID);
    builder.add(Class.p_ModuleID, this.ModuleID);
    JsonObject obj = builder.build();
    return obj;
  }

  /** Checks that the provided parameters are valid */
  public static boolean checkParametersAreValid(
      String ClassID, int Size, String SemesterID, String ModuleID) {
    return Resource.isIdValid(ClassID) && Resource.isIdValid(SemesterID)
        && Resource.isIdValid(ModuleID) && Size > 0;
  }
}
