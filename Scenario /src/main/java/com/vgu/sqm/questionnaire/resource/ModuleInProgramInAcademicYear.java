package com.vgu.sqm.questionnaire.resource;

import com.vgu.sqm.questionnaire.api.ResourceApi;
import com.vgu.sqm.questionnaire.utils.StringUtils;
import java.util.regex.Matcher;
import javax.json.Json;
import javax.json.JsonObject;
import javax.json.JsonObjectBuilder;
import javax.json.stream.JsonParsingException;

public class ModuleInProgramInAcademicYear extends Resource {
  private String ModuleID;
  private String ProgramID;
  private String AYearID;

  public static final String p_ModuleID = "ModuleID";
  public static final String p_ProgramID = "ProgramID";
  public static final String p_AcademicYearID = "AYearID";

  public ModuleInProgramInAcademicYear(String ProgramID, String ModuleID, String AYearID) {
    this.ModuleID = ModuleID;
    this.ProgramID = ProgramID;
    this.AYearID = AYearID;
  }

  /**
   * Parse a JSON object and turn it into an ModuleInProgramInAcademicYear object
   *
   * @param json The JSON object to be turned into a ModuleInProgramInAcademicYear object
   * @return a ModuleInProgramInAcademicYear object corresponding to the provided JSON object
   */
  public static ModuleInProgramInAcademicYear jsonToResource(JsonObject json)
      throws MalformedResourceJsonException {
    try {
      String ModuleID = json.getJsonString(ResourceApi.p_ModuleID).getString();
      String ProgramID = json.getJsonString(ResourceApi.p_ProgramID).getString();
      String AYearID = json.getJsonString(ResourceApi.p_AcademicYearID).getString();
      if (!ModuleInProgramInAcademicYear.checkParametersAreValid(ModuleID, ProgramID, AYearID)) {
        throw new MalformedResourceJsonException(StringUtils.messageInvalidParameters(
            ResourceApi.p_ModuleID, ResourceApi.p_ProgramID, ResourceApi.p_AcademicYearID));
      }

      return new ModuleInProgramInAcademicYear(ModuleID, ProgramID, AYearID);
    } catch (MalformedResourceJsonException e) {
      throw e;
    } catch (NullPointerException e) {
      throw new MalformedResourceJsonException(
          StringUtils.messageMissingParameters(ResourceApi.p_ModuleID, ResourceApi.p_ProgramID));
    } catch (JsonParsingException e) {
      throw new MalformedResourceJsonException();
    }
  }

  public String getModuleID() {
    return this.ModuleID;
  }

  public String getProgramID() {
    return this.ProgramID;
  }

  public String getAYearID() {
    return this.AYearID;
  }

  public JsonObject exportResourceJson() {
    JsonObjectBuilder builder = Json.createObjectBuilder();
    builder.add(ModuleInProgramInAcademicYear.p_ModuleID, this.ModuleID);
    builder.add(ModuleInProgramInAcademicYear.p_ProgramID, this.ProgramID);
    builder.add(ModuleInProgramInAcademicYear.p_AcademicYearID, this.AYearID);
    JsonObject obj = builder.build();
    return obj;
  }

  /** Checks that the provided parameters are valid */
  public static boolean checkParametersAreValid(String ModuleID, String ProgramID, String AYearID) {
    return Resource.isIdValid(ModuleID) && Resource.isIdValid(ProgramID)
        && Resource.isIdValid(AYearID);
  }
}
