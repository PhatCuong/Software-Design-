package com.vgu.sqm.questionnaire.api;

import com.vgu.sqm.questionnaire.database.Database;
import com.vgu.sqm.questionnaire.database.SQLCustomException;
import com.vgu.sqm.questionnaire.resource.AcademicYear;
import com.vgu.sqm.questionnaire.resource.MalformedResourceJsonException;
import com.vgu.sqm.questionnaire.resource.Resource;
import com.vgu.sqm.questionnaire.utils.JsonUtils;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.json.JsonObject;
import javax.json.stream.JsonParsingException;
import javax.naming.NamingException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/api/academicYear")
public class AcademicYearApi extends ResourceApi {
  private static final Logger logger = Logger.getLogger(AcademicYearApi.class.getName());
  private static final long serialVersionUID = 1L;

  public AcademicYearApi() {
    super();
  }

  protected ArrayList<Resource> dumpResource() {
    ArrayList<Resource> resources = new ArrayList<Resource>();

    try {
      Connection db = Database.getAcademiaConnection();
      CallableStatement st = db.prepareCall("CALL DumpAcademicYear();");
      ResultSet rs = st.executeQuery();
      while (rs.next()) {
        String id = rs.getString(AcademicYear.p_id); // Attribute name: aYearId

        resources.add(new AcademicYear(id));
      }
      logger.log(Level.INFO, Database.msg_getSuccess);
      db.close();
    } catch (SQLException | NamingException e) {
      logger.log(Level.SEVERE, e.toString());
    }
    return resources;
  }

  protected void doPut(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    try {
      JsonObject json = JsonUtils.extractJsonRequestBody(request);
      addResourceToDatabase(AcademicYear.jsonToResource(json));
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

  @Override
  protected void doDelete(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    try {
      if (!request.getParameterMap().containsKey(ResourceApi.p_AcademicYearID)) {
        Api.handleMissingParameters(response, ResourceApi.p_AcademicYearID);
        return;
      }

      String id = request.getParameter(ResourceApi.p_AcademicYearID);
      if (!AcademicYear.checkParametersAreValid(id)) {
        Api.handleInvalidParameters(response, ResourceApi.p_AcademicYearID);
        return;
      }

      deleteResourceFromDataBase(id);
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
    AcademicYear element = (AcademicYear) resource;

    String id = element.getAYearID();

    try {
      Connection db = Database.getAcademiaConnection();
      CallableStatement st = db.prepareCall("CALL AddAcademicYear(?,?);");
      st.setString(1, id);
      st.registerOutParameter(2, Types.INTEGER);

      st.execute();

      int status = st.getInt(2);
      logger.log(Level.INFO, "Status: " + status);
      if (status != 200) {
        throw new SQLCustomException(status);
      }

    } catch (SQLException | NamingException e) {
      logger.log(Level.SEVERE, e.toString());
    }
  }

  private void deleteResourceFromDataBase(String AYearID) throws SQLCustomException {
    try {
      Connection db = Database.getAcademiaConnection();
      CallableStatement st = db.prepareCall("CALL DeleteAcademicYear(?,?)");
      st.setString(1, AYearID);
      st.registerOutParameter(2, Types.INTEGER);

      st.execute();

      int status = st.getInt(2);
      logger.log(Level.INFO, "Status: " + status);

      if (status != 200) {
        throw new SQLCustomException(status);
      }

    } catch (SQLException | NamingException e) {
      logger.log(Level.SEVERE, e.toString());
    }
  }
}
