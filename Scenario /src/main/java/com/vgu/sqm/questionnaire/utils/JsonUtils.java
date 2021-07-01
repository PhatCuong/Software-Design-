package com.vgu.sqm.questionnaire.utils;

import com.vgu.sqm.questionnaire.resource.MalformedResourceJsonException;
import com.vgu.sqm.questionnaire.resource.Resource;
import java.io.IOException;
import java.io.StringReader;
import java.util.ArrayList;
import java.util.stream.Collectors;
import javax.json.Json;
import javax.json.JsonArray;
import javax.json.JsonArrayBuilder;
import javax.json.JsonObject;
import javax.json.stream.JsonParsingException;
import javax.servlet.http.HttpServletRequest;

/**
 * JSON utility functions
 */
public class JsonUtils {
  /**
   * Turns an int array into a corresponding JSON array
   *
   * @param input the input int array
   */
  public static JsonArray arrayToJson(int[] input) {
    JsonArrayBuilder builder = Json.createArrayBuilder();
    for (int a : input) {
      builder.add(a);
    }
    return builder.build();
  }

  /**
   * Turns a 2D int array into a corresponding JSON array
   *
   * @param input the input int array
   */
  public static JsonArray arrayToJson(int[][] input) {
    JsonArrayBuilder builder = Json.createArrayBuilder();
    for (int[] i : input) {
      JsonArrayBuilder iBuilder = Json.createArrayBuilder();
      for (int j : i) {
        iBuilder.add(j);
      }
      builder.add(iBuilder.build());
    }
    return builder.build();
  }

  /**
   * Turns an ArrayList of Resource objects into a corresponding JSON array
   *
   * @param input the input Resource ArrayList
   */
  public static JsonArray arrayToJson(ArrayList<Resource> input) {
    JsonArrayBuilder builder = Json.createArrayBuilder();
    for (Resource r : input) {
      builder.add(r.exportResourceJson());
    }
    return builder.build();
  }

  /**
   * Extracts JSON data from a request body
   *
   * @param request the request whose body holds the JSON to be extracted
   * @return the extracted JSON object
   */
  public static JsonObject extractJsonRequestBody(HttpServletRequest request)
      throws IOException, MalformedResourceJsonException {
    String requestBody = request.getReader().lines().collect(Collectors.joining());
    try {
      JsonObject obj = Json.createReader(new StringReader(requestBody)).readObject();
      return obj;
    } catch (JsonParsingException e) {
      throw new MalformedResourceJsonException();
    }
  }
}
