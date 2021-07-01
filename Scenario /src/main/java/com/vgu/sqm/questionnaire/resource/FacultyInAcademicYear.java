package com.vgu.sqm.questionnaire.resource;

import com.vgu.sqm.questionnaire.api.ResourceApi;
import com.vgu.sqm.questionnaire.utils.StringUtils;
import java.util.regex.Matcher;
import javax.json.Json;
import javax.json.JsonObject;
import javax.json.JsonObjectBuilder;
import javax.json.stream.JsonParsingException;

public class FacultyInAcademicYear extends Resource {
  private String FacultyID;
  private String AYearID;

  public static final String p_FacultyID = "FacultyID";
  public static final String p_AcademicYearID = "AYearID";

  public FacultyInAcademicYear(String FacultyID, String AYearID) {
    this.FacultyID = FacultyID;
    this.AYearID = AYearID;
  }

  /**
   * Parse a JSON object and turn it into an FacultyInAcademicYear object
   *
   * @param json The JSON object to be turned into a FacultyInAcademicYear object
   * @return a FacultyInAcademicYear object corresponding to the provided JSON object
   */
  public static FacultyInAcademicYear jsonToResource(JsonObject json)
      throws MalformedResourceJsonException {
    try {
      String fid = json.getJsonString(ResourceApi.p_FacultyID).getString();
      String yid = json.getJsonString(ResourceApi.p_AcademicYearID).getString();
      if (!FacultyInAcademicYear.checkParametersAreValid(fid, yid)) {
        throw new MalformedResourceJsonException(StringUtils.messageInvalidParameters(
            ResourceApi.p_FacultyID, ResourceApi.p_AcademicYearID));
      }

      return new FacultyInAcademicYear(fid, yid);
    } catch (MalformedResourceJsonException e) {
      throw e;
    } catch (NullPointerException e) {
      throw new MalformedResourceJsonException(StringUtils.messageMissingParameters(
          ResourceApi.p_FacultyID, ResourceApi.p_AcademicYearID));
    } catch (JsonParsingException e) {
      throw new MalformedResourceJsonException();
    }
  }

  public String getFacultyID() {
    return this.FacultyID;
  }

  public String getAYearID() {
    return this.AYearID;
  }

  public JsonObject exportResourceJson() {
    JsonObjectBuilder builder = Json.createObjectBuilder();
    builder.add(FacultyInAcademicYear.p_FacultyID, this.FacultyID);
    builder.add(FacultyInAcademicYear.p_AcademicYearID, this.AYearID);
    JsonObject obj = builder.build();
    return obj;
  }

  /** Checks that the provided parameters are valid */
  public static boolean checkParametersAreValid(String FacultyID, String AYearID) {
    return Resource.isIdValid(FacultyID) && Resource.isIdValid(AYearID);
  }
}
