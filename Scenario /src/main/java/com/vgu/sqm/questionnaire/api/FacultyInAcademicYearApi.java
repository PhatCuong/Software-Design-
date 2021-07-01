package com.vgu.sqm.questionnaire.api;

import com.vgu.sqm.questionnaire.database.Database;
import com.vgu.sqm.questionnaire.database.SQLCustomException;
import com.vgu.sqm.questionnaire.resource.FacultyInAcademicYear;
import com.vgu.sqm.questionnaire.resource.MalformedResourceJsonException;
import com.vgu.sqm.questionnaire.resource.Resource;
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
import javax.json.stream.JsonParsingException;
import javax.naming.NamingException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/api/facultyInAcademicYear")
public class FacultyInAcademicYearApi extends ResourceApi {
  private static final Logger logger = Logger.getLogger(FacultyInAcademicYearApi.class.getName());
  private static final long serialVersionUID = 1L;

  public FacultyInAcademicYearApi() {
    super();
  }

  protected ArrayList<Resource> dumpResource() {
    ArrayList<Resource> resources = new ArrayList<Resource>();

    try {
      Connection db = Database.getAcademiaConnection();
      CallableStatement st = db.prepareCall("CALL DumpFacultyInAcademicYear();");
      ResultSet rs = st.executeQuery();
      while (rs.next()) {
        String fId = rs.getString(FacultyInAcademicYear.p_FacultyID); // Attribute name: FacultyID
        String aId =
            rs.getString(FacultyInAcademicYear.p_AcademicYearID); // Attribute name: AYearID

        resources.add(new FacultyInAcademicYear(fId, aId));
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
        case "getFaculties":
          handleActionGetFaculties(request, response);
          break;
        default:
          ResourceApi.handleInvalidGetAction(response, action);
      }
    } catch (Exception e) {
      Api.handleHttp500Error(response, e, logger);
    }
  }

  /** Handle GET requests with action=getFaculties */
  private void handleActionGetFaculties(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    String yid = request.getParameter(ResourceApi.p_AcademicYearID);
    if (yid == null) {
      Api.handleMissingParameters(response, ResourceApi.p_AcademicYearID);
      return;
    }

    response.setStatus(HttpServletResponse.SC_OK);
    response.getWriter().print(getFaculties(yid));
  }

  protected void doPut(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    try {
      JsonObject json = JsonUtils.extractJsonRequestBody(request);
      addResourceToDatabase(FacultyInAcademicYear.jsonToResource(json));
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
      if (!request.getParameterMap().containsKey(ResourceApi.p_FacultyID)
          || !request.getParameterMap().containsKey(ResourceApi.p_AcademicYearID)) {
        Api.handleMissingParameters(
            response, ResourceApi.p_FacultyID, ResourceApi.p_AcademicYearID);
        return;
      }

      String fid = request.getParameter(ResourceApi.p_FacultyID);
      String yid = request.getParameter(ResourceApi.p_AcademicYearID);
      if (!Resource.areIdsValid(fid, yid)) {
        Api.handleInvalidParameters(response, ResourceApi.p_FacultyID);
        return;
      }

      deleteResourceFromDataBase(fid, yid);
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
    FacultyInAcademicYear element = (FacultyInAcademicYear) resource;

    String fId = element.getFacultyID();
    String aYearId = element.getAYearID();

    try {
      Connection db = Database.getAcademiaConnection();
      CallableStatement st = db.prepareCall("CALL AddFacultyInAcademicYear(?,?,?);");
      st.setString(1, fId);
      st.setString(2, aYearId);
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

  private void deleteResourceFromDataBase(String FacultyID, String AYearID)
      throws SQLCustomException {
    try {
      Connection db = Database.getAcademiaConnection();
      CallableStatement st = db.prepareCall("CALL DeleteFacultyInAcademicYear(?,?,?)");
      st.setString(1, FacultyID);
      st.setString(2, AYearID);
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
   * Get Faculty objects from the provided Academic Year
   */
  private JsonArray getFaculties(String AYearID) {
    JsonArrayBuilder builder = Json.createArrayBuilder();
    try {
      Connection db = Database.getAcademiaConnection();
      CallableStatement st = db.prepareCall("CALL GetFaculties(?,?)");
      st.setString(1, AYearID);
      st.registerOutParameter(2, Types.INTEGER);

      ResultSet rs = st.executeQuery();

      int status = st.getInt(2);
      logger.log(Level.INFO, "Status: " + status);

      if (status != 200) {
        throw new SQLCustomException(status);
      }

      while (rs.next()) {
        builder.add(rs.getString("FacultyId"));
      }

    } catch (SQLException | NamingException | SQLCustomException e) {
      logger.log(Level.SEVERE, e.toString());
    }
    return builder.build();
  }
}
