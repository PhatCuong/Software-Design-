package com.vgu.sqm.questionnaire.api;

import com.vgu.sqm.questionnaire.api.Api;
import com.vgu.sqm.questionnaire.database.Database;
import com.vgu.sqm.questionnaire.database.SQLCustomException;
import com.vgu.sqm.questionnaire.resource.Lecturer;
import com.vgu.sqm.questionnaire.resource.MalformedResourceJsonException;
import com.vgu.sqm.questionnaire.resource.Resource;
import com.vgu.sqm.questionnaire.resource.Teaching;
import com.vgu.sqm.questionnaire.utils.JsonUtils;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.json.Json;
import javax.json.JsonArray;
import javax.json.JsonArrayBuilder;
import javax.json.JsonObject;
import javax.json.JsonObjectBuilder;
import javax.json.stream.JsonParsingException;
import javax.naming.NamingException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/api/teaching")
public class TeachingApi extends ResourceApi {
  private static final Logger logger = Logger.getLogger(TeachingApi.class.getName());
  private static final long serialVersionUID = 1L;

  public TeachingApi() {
    super();
  }

  protected ArrayList<Resource> dumpResource() {
    ArrayList<Resource> resources = new ArrayList<Resource>();

    try {
      Connection db = Database.getAcademiaConnection();
      CallableStatement st = db.prepareCall("CALL DumpTeaching()");
      ResultSet rs = st.executeQuery();
      while (rs.next()) {
        String lId = rs.getString(Teaching.p_LecturerID); // Attribute name LecturerID
        String cId = rs.getString(Teaching.p_ClassID); // Attribute name ClassID

        resources.add(new Teaching(lId, cId));
      }
      logger.log(Level.INFO, "Getting info from database successfully.");
      db.close();
    } catch (SQLException | NamingException e) {
      logger.log(Level.SEVERE, e.toString());
    }
    return resources;
  }

  @Override
  protected void doGetCustomAction(HttpServletRequest request, HttpServletResponse response,
      String action) throws ServletException, IOException {
    try {
      switch (action) {
        case "getLecturers":
          handleActionGetLecturers(request, response);
          break;
        default:
          ResourceApi.handleInvalidGetAction(response, action);
      }
    } catch (Exception e) {
      Api.handleHttp500Error(response, e, logger);
    }
  }

  /** Handle GET requests with action=getLecturers */
  private void handleActionGetLecturers(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    String cid = request.getParameter(ResourceApi.p_ClassID);
    response.setStatus(HttpServletResponse.SC_OK);
    response.getWriter().print(getLecturers(cid));
  }

  protected void doPut(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    try {
      JsonObject json = JsonUtils.extractJsonRequestBody(request);
      addResourceToDatabase(Teaching.jsonToResource(json));
      response.setStatus(HttpServletResponse.SC_OK);
      response.getWriter().print("OK");
    } catch (MalformedResourceJsonException e) {
      response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
      response.getWriter().print(e.getMessage());
    } catch (SQLCustomException e) {
      response.setStatus(HttpServletResponse.SC_OK);
      response.getWriter().print(e.getMessage());
    } catch (Exception e) {
      Api.handleHttp500Error(response, e, logger);
    }
  }

  protected void doDelete(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    try {
      if (!request.getParameterMap().containsKey(ResourceApi.p_LecturerID)
          || !request.getParameterMap().containsKey(ResourceApi.p_ClassID)) {
        Api.handleMissingParameters(response, ResourceApi.p_LecturerID, ResourceApi.p_ClassID);
        return;
      }

      String lid = request.getParameter(ResourceApi.p_LecturerID);
      String cid = request.getParameter(ResourceApi.p_ClassID);
      String id = request.getParameter(ResourceApi.p_FacultyID);
      if (!Resource.areIdsValid(lid, cid)) {
        Api.handleInvalidParameters(response, ResourceApi.p_LecturerID, ResourceApi.p_ClassID);
        return;
      }

      deleteResourceFromDataBase(lid, cid);
      response.setStatus(HttpServletResponse.SC_OK);
      response.getWriter().print("OK");
    } catch (SQLCustomException e) {
      response.setStatus(HttpServletResponse.SC_OK);
      response.getWriter().print(e.getMessage());
    } catch (Exception e) {
      Api.handleHttp500Error(response, e, logger);
    }
  }

  protected void addResourceToDatabase(Resource resource) throws SQLCustomException {
    Teaching element = (Teaching) resource;

    String lId = element.getLecturerID();
    String cId = element.getClassID();

    try {
      Connection db = Database.getAcademiaConnection();
      CallableStatement st = db.prepareCall("CALL AddTeaching(?,?,?);");
      st.setString(1, lId);
      st.setString(2, cId);
      st.registerOutParameter(3, Types.INTEGER);

      st.execute();

      int status = st.getInt(3);
      logger.log(Level.INFO, "Status: " + status);
      if (status != 200) {
        throw new SQLCustomException(status);
      }
      db.close();
    } catch (SQLException | NamingException e) {
      logger.log(Level.SEVERE, e.toString());
    }
  }

  private void deleteResourceFromDataBase(String LectureID, String ClassID)
      throws SQLCustomException {
    try {
      Connection db = Database.getAcademiaConnection();
      CallableStatement st = db.prepareCall("CALL DeleteTeaching(?,?,?)");
      st.setString(1, LectureID);
      st.setString(2, ClassID);
      st.registerOutParameter(3, Types.INTEGER);

      st.execute();

      int status = st.getInt(3);
      logger.log(Level.INFO, "Status: " + status);

      if (status != 200) {
        throw new SQLCustomException(status);
      }

    } catch (SQLException | NamingException e) {
      logger.log(Level.SEVERE, e.toString());
    }
  }

  /**
   * Get Lecturer objects from the provided Class
   */
  private JsonArray getLecturers(String ClassID) {
    JsonArrayBuilder builder = Json.createArrayBuilder();
    try {
      Connection db = Database.getAcademiaConnection();
      CallableStatement st = db.prepareCall("CALL GetLecturers(?,?)");
      st.setString(1, ClassID);
      st.registerOutParameter(2, Types.INTEGER);

      ResultSet rs = st.executeQuery();

      int status = st.getInt(2);
      logger.log(Level.INFO, "Status: " + status);

      if (status != 200) {
        throw new SQLCustomException(status);
      }

      while (rs.next()) {
        JsonObjectBuilder jsonObjectBuilder = Json.createObjectBuilder();
        jsonObjectBuilder.add(ResourceApi.p_LecturerID, rs.getString("LecturerId"));
        jsonObjectBuilder.add(ResourceApi.p_Username, rs.getString("UserName"));

        builder.add(jsonObjectBuilder);
      }

    } catch (SQLException | NamingException | SQLCustomException e) {
      logger.log(Level.SEVERE, e.toString());
    }

    return builder.build();
  }
}
