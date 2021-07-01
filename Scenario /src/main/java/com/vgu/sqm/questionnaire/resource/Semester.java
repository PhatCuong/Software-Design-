package com.vgu.sqm.questionnaire.resource;

import com.vgu.sqm.questionnaire.api.ResourceApi;
import com.vgu.sqm.questionnaire.utils.StringUtils;
import java.util.regex.Matcher;
import javax.json.Json;
import javax.json.JsonObject;
import javax.json.JsonObjectBuilder;
import javax.json.stream.JsonParsingException;

public class Semester extends Resource {
  private String SemesterID;
  private String AYearID;

  public static final String p_SemesterID = "SemesterID";
  public static final String p_AcademicYearID = "AYearID";

  public Semester(String SemesterID, String AYearID) {
    this.SemesterID = SemesterID;
    this.AYearID = AYearID;
  }

  /**
   * Parse a JSON object and turn it into an Semester object
   *
   * @param json The JSON object to be turned into a Semester object
   * @return a Semester object corresponding to the provided JSON object
   */
  public static Semester jsonToResource(JsonObject json) throws MalformedResourceJsonException {
    try {
      String SemesterID = json.getJsonString(ResourceApi.p_SemesterID).getString();
      String AYearID = json.getJsonString(ResourceApi.p_AcademicYearID).getString();
      if (!Semester.checkParametersAreValid(SemesterID, AYearID)) {
        throw new MalformedResourceJsonException(StringUtils.messageInvalidParameters(
            ResourceApi.p_SemesterID, ResourceApi.p_AcademicYearID));
      }

      return new Semester(SemesterID, AYearID);
    } catch (MalformedResourceJsonException e) {
      throw e;
    } catch (NullPointerException e) {
      throw new MalformedResourceJsonException(
          StringUtils.messageMissingParameters(ResourceApi.p_SemesterID));
    } catch (JsonParsingException e) {
      throw new MalformedResourceJsonException();
    }
  }

  public String getSemesterID() {
    return this.SemesterID;
  }

  public String getAYearID() {
    return this.AYearID;
  }

  public JsonObject exportResourceJson() {
    JsonObjectBuilder builder = Json.createObjectBuilder();
    builder.add(Semester.p_SemesterID, this.SemesterID);
    builder.add(Semester.p_AcademicYearID, this.AYearID);
    JsonObject obj = builder.build();
    return obj;
  }

  /** Checks that the provided parameters are valid */
  public static boolean checkParametersAreValid(String SemesterID, String AYearID) {
    return Resource.isIdValid(SemesterID) && Resource.isIdValid(AYearID);
  }
}
