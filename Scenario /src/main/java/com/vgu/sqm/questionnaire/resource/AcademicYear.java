package com.vgu.sqm.questionnaire.resource;

import com.vgu.sqm.questionnaire.api.ResourceApi;
import com.vgu.sqm.questionnaire.utils.JsonUtils;
import com.vgu.sqm.questionnaire.utils.StringUtils;
import javax.json.Json;
import javax.json.JsonObject;
import javax.json.JsonObjectBuilder;
import javax.json.stream.JsonParsingException;

public class AcademicYear extends Resource {
  private String AYearID;
  public static final String p_id = "AYearID";

  public AcademicYear(String AYearID) {
    this.AYearID = AYearID;
  }

  /**
   * Parse a JSON object and turn it into an AcademicYear object
   *
   * @param json The JSON object to be turned into a AcademicYear object
   * @return sn AcademicYear object corresponding to the provided JSON object
   */
  public static AcademicYear jsonToResource(JsonObject json) throws MalformedResourceJsonException {
    try {
      String id = json.getJsonString(ResourceApi.p_AcademicYearID).getString();
      return new AcademicYear(id);
    } catch (JsonParsingException e) {
      throw new MalformedResourceJsonException();
    } catch (NullPointerException e) {
      throw new MalformedResourceJsonException(
          StringUtils.messageMissingParameters(ResourceApi.p_AcademicYearID));
    }
  }

  public String getAYearID() {
    return this.AYearID;
  }

  public JsonObject exportResourceJson() {
    JsonObjectBuilder builder = Json.createObjectBuilder();
    builder.add(AcademicYear.p_id, this.AYearID);
    JsonObject obj = builder.build();
    return obj;
  }

  /** Checks that the provided parameters are valid */
  public static boolean checkParametersAreValid(String AYearID) {
    return Resource.isIdValid(AYearID);
  }
}
