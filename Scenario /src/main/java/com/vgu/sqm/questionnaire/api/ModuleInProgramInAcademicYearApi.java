package com.vgu.sqm.questionnaire.api;

import com.vgu.sqm.questionnaire.database.Database;
import com.vgu.sqm.questionnaire.database.SQLCustomException;
import com.vgu.sqm.questionnaire.resource.MalformedResourceJsonException;
import com.vgu.sqm.questionnaire.resource.ModuleInProgramInAcademicYear;
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

@WebServlet("/api/moduleInProgramInAcademicYear")
public class ModuleInProgramInAcademicYearApi extends ResourceApi {
  private static final Logger logger =
      Logger.getLogger(ModuleInProgramInAcademicYearApi.class.getName());
  private static final long serialVersionUID = 1L;

  public ModuleInProgramInAcademicYearApi() {
    super();
  }

  protected ArrayList<Resource> dumpResource() {
    ArrayList<Resource> resources = new ArrayList<Resource>();

    try {
      Connection db = Database.getAcademiaConnection();
      CallableStatement st = db.prepareCall("CALL DumpModuleInProgramInAcademicYear();");
      ResultSet rs = st.executeQuery();
      while (rs.next()) {
        String pId =
            rs.getString(ModuleInProgramInAcademicYear.p_ProgramID); // Attribute name: ProgramID
        String mId =
            rs.getString(ModuleInProgramInAcademicYear.p_ModuleID); // Attribute name: ModuleID
        String yID =
            rs.getString(ModuleInProgramInAcademicYear.p_AcademicYearID); // Attribute name: AYearID

        resources.add(new ModuleInProgramInAcademicYear(pId, mId, yID));
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
        case "getModules":
          handleActionGetModules(request, response);
          break;
        case "getClasses":
          handleActionGetClasses(request, response);
          break;
        default:
          ResourceApi.handleInvalidGetAction(response, action);
      }
    } catch (Exception e) {
      Api.handleHttp500Error(response, e, logger);
    }
  }

  /** Handle GET requests with action=getModules */
  private void handleActionGetModules(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    String yid = request.getParameter(ResourceApi.p_AcademicYearID);
    String pid = request.getParameter(ResourceApi.p_ProgramID);
    if (yid == null || pid == null) {
      Api.handleMissingParameters(response, ResourceApi.p_AcademicYearID, ResourceApi.p_ProgramID);
      return;
    }
    response.setStatus(HttpServletResponse.SC_OK);
    response.getWriter().print(getModules(yid, pid));
  }

  /** Handle GET requests with action=getClasses */
  private void handleActionGetClasses(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    String sid = request.getParameter(ResourceApi.p_SemesterID);
    String pid = request.getParameter(ResourceApi.p_ProgramID);
    String mid = request.getParameter(ResourceApi.p_ModuleID);
    if (sid == null || pid == null || mid == null) {
      Api.handleMissingParameters(
          response, ResourceApi.p_SemesterID, ResourceApi.p_ProgramID, ResourceApi.p_ModuleID);
      return;
    }

    response.setStatus(HttpServletResponse.SC_OK);
    response.getWriter().print(getClasses(sid, pid, mid));
  }

  protected void doPut(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    try {
      JsonObject json = JsonUtils.extractJsonRequestBody(request);
      addResourceToDatabase(ModuleInProgramInAcademicYear.jsonToResource(json));
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
      if (!request.getParameterMap().containsKey(ResourceApi.p_ModuleID)
          || !request.getParameterMap().containsKey(ResourceApi.p_ProgramID)
          || !request.getParameterMap().containsKey(ResourceApi.p_AcademicYearID)) {
        Api.handleMissingParameters(response, ResourceApi.p_ModuleID, ResourceApi.p_ProgramID,
            ResourceApi.p_AcademicYearID);
        return;
      }

      String mid = request.getParameter(ResourceApi.p_ModuleID);
      String pid = request.getParameter(ResourceApi.p_ProgramID);
      String yid = request.getParameter(ResourceApi.p_AcademicYearID);
      if (!Resource.areIdsValid(mid, pid, yid)) {
        response.getWriter().print("OK");
        Api.handleInvalidParameters(response, ResourceApi.p_AcademicYearID, ResourceApi.p_ProgramID,
            ResourceApi.p_ModuleID);
        return;
      }

      deleteResourceFromDataBase(mid, pid, yid);
      response.setStatus(HttpServletResponse.SC_OK);
    } catch (SQLCustomException e) {
      response.setStatus(HttpServletResponse.SC_OK);
      response.getWriter().print(e.getMessage());
    } catch (Exception e) {
      Api.handleHttp500Error(response, e, logger);
    }
  }

  protected void addResourceToDatabase(Resource resource) throws SQLCustomException {
    ModuleInProgramInAcademicYear element = (ModuleInProgramInAcademicYear) resource;

    String pId = element.getProgramID();
    String mId = element.getModuleID();
    String aYearId = element.getAYearID();

    try {
      Connection db = Database.getAcademiaConnection();
      CallableStatement st = db.prepareCall("CALL AddModuleInProgramInAcademicYear(?,?,?,?);");
      st.setString(1, pId);
      st.setString(2, mId);
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

  private void deleteResourceFromDataBase(String ModuleID, String ProgramID, String AYearID)
      throws SQLCustomException {
    try {
      Connection db = Database.getAcademiaConnection();
      CallableStatement st = db.prepareCall("CALL DeleteModuleInProgramInAcademicYear(?,?,?,?)");
      st.setString(1, ModuleID);
      st.setString(2, ProgramID);
      st.setString(3, AYearID);
      st.registerOutParameter(4, Types.INTEGER);

      st.execute();

      int status = st.getInt(4);
      logger.log(Level.INFO, "Status: " + status);

      if (status != 200) {
        throw new SQLCustomException(status);
      }

    } catch (SQLException | NamingException e) {
      logger.log(Level.SEVERE, e.toString());
    }
  }

  /**
   * Get Module objects from the provided Academic Year and Program
   */
  private JsonArray getModules(String AcademicYearID, String ProgramID) {
    JsonArrayBuilder builder = Json.createArrayBuilder();
    try {
      Connection db = Database.getAcademiaConnection();
      CallableStatement st = db.prepareCall("CALL GetModules(?,?,?)");
      st.setString(1, AcademicYearID);
      st.setString(2, ProgramID);
      st.registerOutParameter(3, Types.INTEGER);

      ResultSet rs = st.executeQuery();

      int status = st.getInt(3);
      logger.log(Level.INFO, "Status: " + status);

      if (status != 200) {
        throw new SQLCustomException(status);
      }

      while (rs.next()) {
        builder.add(rs.getString("ModuleId"));
      }

    } catch (SQLException | NamingException | SQLCustomException e) {
      logger.log(Level.SEVERE, e.toString());
    }

    return builder.build();
  }

  /**
   * Get Class objects from the provided Academic Year, Program and Module
   */
  private JsonArray getClasses(String SemesterID, String ProgramID, String ModuleID) {
    JsonArrayBuilder builder = Json.createArrayBuilder();
    try {
      Connection db = Database.getAcademiaConnection();
      CallableStatement st = db.prepareCall("CALL GetClasses(?,?,?,?)");
      st.setString(1, SemesterID);
      st.setString(2, ProgramID);
      st.setString(3, ModuleID);
      st.registerOutParameter(4, Types.INTEGER);

      ResultSet rs = st.executeQuery();

      int status = st.getInt(4);
      logger.log(Level.INFO, "Status: " + status);

      if (status != 200) {
        throw new SQLCustomException(status);
      }

      while (rs.next()) {
        builder.add(rs.getString("ClassId"));
      }

    } catch (SQLException | NamingException | SQLCustomException e) {
      logger.log(Level.SEVERE, e.toString());
    }

    return builder.build();
  }
}
