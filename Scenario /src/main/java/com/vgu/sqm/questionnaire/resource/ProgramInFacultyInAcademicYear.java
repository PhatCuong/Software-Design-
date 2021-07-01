package com.vgu.sqm.questionnaire.resource;

import com.vgu.sqm.questionnaire.api.ResourceApi;
import com.vgu.sqm.questionnaire.utils.StringUtils;
import java.util.regex.Matcher;
import javax.json.Json;
import javax.json.JsonObject;
import javax.json.JsonObjectBuilder;
import javax.json.stream.JsonParsingException;

public class ProgramInFacultyInAcademicYear extends Resource {
  private String ProgramID;
  private String FacultyID;
  private String AYearID;

  public static final String p_ProgramID = "ProgramID";
  public static final String p_FacultyID = "FacultyID";
  public static final String p_AcademicYearID = "AYearID";

  public ProgramInFacultyInAcademicYear(String ProgramID, String FacultyID, String AYearID) {
    this.ProgramID = ProgramID;
    this.FacultyID = FacultyID;
    this.AYearID = AYearID;
  }

  /**
   * Parse a JSON object and turn it into an ProgramInFacultyInAcademicYear object
   *
   * @param json The JSON object to be turned into a ProgramInFacultyInAcademicYear object
   * @return a ProgramInFacultyInAcademicYear object corresponding to the provided JSON object
   */
  public static ProgramInFacultyInAcademicYear jsonToResource(JsonObject json)
      throws MalformedResourceJsonException {
    try {
      String ProgramID = json.getJsonString(ResourceApi.p_ProgramID).getString();
      String FacultyID = json.getJsonString(ResourceApi.p_FacultyID).getString();
      String AYearID = json.getJsonString(ResourceApi.p_AcademicYearID).getString();
      if (!ProgramInFacultyInAcademicYear.checkParametersAreValid(ProgramID, FacultyID, AYearID)) {
        throw new MalformedResourceJsonException(StringUtils.messageInvalidParameters(
            ResourceApi.p_ProgramID, ResourceApi.p_FacultyID, ResourceApi.p_AcademicYearID));
      }

      return new ProgramInFacultyInAcademicYear(ProgramID, FacultyID, AYearID);
    } catch (MalformedResourceJsonException e) {
      throw e;
    } catch (NullPointerException e) {
      throw new MalformedResourceJsonException(
          StringUtils.messageMissingParameters(ResourceApi.p_ProgramID, ResourceApi.p_FacultyID));
    } catch (JsonParsingException e) {
      throw new MalformedResourceJsonException();
    }
  }

  public String getProgramID() {
    return this.ProgramID;
  }

  public String getFacultyID() {
    return this.FacultyID;
  }

  public String getAYearID() {
    return this.AYearID;
  }

  public JsonObject exportResourceJson() {
    JsonObjectBuilder builder = Json.createObjectBuilder();
    builder.add(ProgramInFacultyInAcademicYear.p_ProgramID, this.ProgramID);
    builder.add(ProgramInFacultyInAcademicYear.p_FacultyID, this.FacultyID);
    builder.add(ProgramInFacultyInAcademicYear.p_AcademicYearID, this.AYearID);
    JsonObject obj = builder.build();
    return obj;
  }

  /** Checks that the provided parameters are valid */
  public static boolean checkParametersAreValid(
      String ProgramID, String FacultyID, String AYearID) {
    return Resource.isIdValid(ProgramID) && Resource.isIdValid(FacultyID)
        && Resource.isIdValid(AYearID);
  }
}
