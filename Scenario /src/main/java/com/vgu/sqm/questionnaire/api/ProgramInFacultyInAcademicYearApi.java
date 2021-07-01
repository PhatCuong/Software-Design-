package com.vgu.sqm.questionnaire.api;

import com.vgu.sqm.questionnaire.database.Database;
import com.vgu.sqm.questionnaire.database.SQLCustomException;
import com.vgu.sqm.questionnaire.resource.MalformedResourceJsonException;
import com.vgu.sqm.questionnaire.resource.ProgramInFacultyInAcademicYear;
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

@WebServlet("/api/programInFacultyInAcademicYear")
public class ProgramInFacultyInAcademicYearApi extends ResourceApi {
  private static final Logger logger =
      Logger.getLogger(ProgramInFacultyInAcademicYearApi.class.getName());
  private static final long serialVersionUID = 1L;

  public ProgramInFacultyInAcademicYearApi() {
    super();
  }

  protected ArrayList<Resource> dumpResource() {
    ArrayList<Resource> resources = new ArrayList<Resource>();

    try {
      Connection db = Database.getAcademiaConnection();
      CallableStatement st = db.prepareCall("CALL DumpProgramInFacultyInAcademicYear();");
      ResultSet rs = st.executeQuery();
      while (rs.next()) {
        String pId =
            rs.getString(ProgramInFacultyInAcademicYear.p_ProgramID); // Attribute name: ProgramID
        String fId =
            rs.getString(ProgramInFacultyInAcademicYear.p_FacultyID); // Attribute name: FacultyID
        String yID = rs.getString(
            ProgramInFacultyInAcademicYear.p_AcademicYearID); // Attribute name: AYearID

        resources.add(new ProgramInFacultyInAcademicYear(pId, fId, yID));
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
        case "getPrograms":
          handleActionGetPrograms(request, response);
          break;
        default:
          ResourceApi.handleInvalidGetAction(response, action);
      }
    } catch (Exception e) {
      Api.handleHttp500Error(response, e, logger);
    }
  }

  /** Handle GET requests with action=getPrograms */
  private void handleActionGetPrograms(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    String yid = request.getParameter(ResourceApi.p_AcademicYearID);
    String fid = request.getParameter(ResourceApi.p_FacultyID);
    if (yid == null || fid == null) {
      Api.handleMissingParameters(response, ResourceApi.p_AcademicYearID, ResourceApi.p_FacultyID);
      return;
    }

    response.setStatus(HttpServletResponse.SC_OK);
    response.getWriter().print(getPrograms(yid, fid));
  }

  protected void doPut(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    try {
      JsonObject json = JsonUtils.extractJsonRequestBody(request);
      addResourceToDatabase(ProgramInFacultyInAcademicYear.jsonToResource(json));
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
      if (!request.getParameterMap().containsKey(ResourceApi.p_ProgramID)
          || !request.getParameterMap().containsKey(ResourceApi.p_AcademicYearID)) {
        Api.handleMissingParameters(
            response, ResourceApi.p_ProgramID, ResourceApi.p_AcademicYearID);
        return;
      }

      String pid = request.getParameter(ResourceApi.p_ProgramID);
      String yid = request.getParameter(ResourceApi.p_AcademicYearID);
      if (!Resource.areIdsValid(pid, yid)) {
        Api.handleInvalidParameters(
            response, ResourceApi.p_ProgramID, ResourceApi.p_AcademicYearID);
        return;
      }

      deleteResourceFromDataBase(pid, yid);
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
    ProgramInFacultyInAcademicYear element = (ProgramInFacultyInAcademicYear) resource;

    String pId = element.getProgramID();
    String fId = element.getFacultyID();
    String aYearId = element.getAYearID();

    try {
      Connection db = Database.getAcademiaConnection();
      CallableStatement st = db.prepareCall("CALL AddProgramInFacultyInAcademicYear(?,?,?,?);");
      st.setString(1, pId);
      st.setString(2, fId);
      st.setString(3, aYearId);
      st.registerOutParameter(4, Types.INTEGER);

      st.execute();

      int status = st.getInt(4);
      logger.log(Level.INFO, "Status: " + status);
      if (status != 200) {
        throw new SQLCustomException(status);
      }
      db.close();
    } catch (SQLException | NamingException e) {
      logger.log(Level.SEVERE, e.toString());
    }
  }

  private void deleteResourceFromDataBase(String ProgramID, String AYearID)
      throws SQLCustomException {
    try {
      Connection db = Database.getAcademiaConnection();
      CallableStatement st = db.prepareCall("CALL DeleteProgramInFacultyInAcademicYear(?,?,?)");
      st.setString(1, ProgramID);
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
   * Get Program objects from the provided Academic Year and Faculty
   */
  private JsonArray getPrograms(String AcademicYearID, String FacultyID) {
    JsonArrayBuilder builder = Json.createArrayBuilder();
    try {
      Connection db = Database.getAcademiaConnection();
      CallableStatement st = db.prepareCall("CALL GetPrograms(?,?,?)");
      st.setString(1, AcademicYearID);
      st.setString(2, FacultyID);
      st.registerOutParameter(3, Types.INTEGER);

      ResultSet rs = st.executeQuery();

      int status = st.getInt(3);
      logger.log(Level.INFO, "Status: " + status);

      if (status != 200) {
        throw new SQLCustomException(status);
      }

      while (rs.next()) {
        builder.add(rs.getString("ProgramId"));
      }

    } catch (SQLException | NamingException | SQLCustomException e) {
      logger.log(Level.SEVERE, e.toString());
    }

    return builder.build();
  }
}
