package com.vgu.sqm.questionnaire.api;

import com.vgu.sqm.questionnaire.database.SQLCustomException;
import com.vgu.sqm.questionnaire.resource.Resource;
import com.vgu.sqm.questionnaire.utils.JsonUtils;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.json.Json;
import javax.json.JsonArray;
import javax.json.JsonArrayBuilder;
import javax.json.JsonObject;
import javax.naming.NamingException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public abstract class ResourceApi extends Api {
  // parameter names
  public static final String p_AcademicYearID = "yid";
  public static final String p_ClassID = "cid";
  public static final String p_FacultyID = "fid";
  public static final String p_FacultyName = "fname";
  public static final String p_LecturerID = "lid";
  public static final String p_Username = "user";
  public static final String p_ModuleID = "mid";
  public static final String p_ModuleName = "mname";
  public static final String p_ProgramID = "pid";
  public static final String p_ProgramName = "pname";
  public static final String p_QuestionnaireID = "qid";
  public static final String p_SemesterID = "sid";
  public static final String p_Size = "size";

  abstract protected void doPut(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException;
  abstract protected void doDelete(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException;
  /** Adds a Resource object to the database */
  abstract protected void addResourceToDatabase(Resource resource) throws SQLCustomException;
  /** Dumps all objects of a Resource type */
  abstract protected ArrayList<Resource> dumpResource();

  /** Turns an ArrayList of Resource objects into a corresponding JSON array */
  protected JsonArray ResourceArrayToJson(ArrayList<Resource> resources) {
    JsonArrayBuilder builder = Json.createArrayBuilder();
    for (Resource resource : resources) {
      builder.add(resource.exportResourceJson());
    }
    JsonArray array = builder.build();
    return array;
  }

  protected void doGet(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    try {
      String action =
          request.getParameterMap().containsKey("action") ? request.getParameter("action") : "";
      switch (action) {
        case "dump":
          response.setContentType("application/json");
          response.setStatus(HttpServletResponse.SC_OK);
          response.getWriter().print(ResourceArrayToJson(dumpResource()));
          break;
        case "":
          response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
          response.getWriter().print("You need to supply an 'action'");
          break;
        default:
          doGetCustomAction(request, response, action);
      }
    } catch (Exception e) {
      Api.handleHttp500Error(response, e);
    }
  }

  /** Handle a custom GET request not default in ResourceApi */
  protected void doGetCustomAction(HttpServletRequest request, HttpServletResponse response,
      String action) throws ServletException, IOException {
    ResourceApi.handleInvalidGetAction(response, action);
  }

  protected static void handleInvalidGetAction(HttpServletResponse response, String action)
      throws ServletException, IOException {
    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
    response.getWriter().print(String.format("Action '%s' is not supported", action));
  }
}
