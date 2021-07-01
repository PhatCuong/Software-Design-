package com.vgu.sqm.questionnaire.api;

import com.vgu.sqm.questionnaire.database.Database;
import com.vgu.sqm.questionnaire.database.SQLCustomException;
import com.vgu.sqm.questionnaire.resource.MalformedResourceJsonException;
import com.vgu.sqm.questionnaire.resource.Program;
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

@WebServlet("/api/program")
public class ProgramApi extends ResourceApi {
  private static final Logger logger = Logger.getLogger(ProgramApi.class.getName());
  private static final long serialVersionUID = 1L;

  public ProgramApi() {
    super();
  }

  protected ArrayList<Resource> dumpResource() {
    ArrayList<Resource> resources = new ArrayList<Resource>();

    try {
      Connection db = Database.getAcademiaConnection();
      CallableStatement st = db.prepareCall("CALL DumpProgram()");
      ResultSet rs = st.executeQuery();
      while (rs.next()) {
        String id = rs.getString(Program.p_ProgramID); // Attribute name ProgramId
        String name = rs.getString(Program.p_ProgramName); // Attribute name ProgramName

        resources.add(new Program(id, name));
      }
      logger.log(Level.INFO, "Getting info from database successfully.");
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
      addResourceToDatabase(Program.jsonToResource(json));
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
      if (!request.getParameterMap().containsKey(ResourceApi.p_ProgramID)) {
        Api.handleMissingParameters(response, ResourceApi.p_ProgramID);
        return;
      }

      String id = request.getParameter(ResourceApi.p_ProgramID);
      if (!Resource.isIdValid(id)) {
        Api.handleInvalidParameters(response, ResourceApi.p_ProgramID);
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
    Program element = (Program) resource;

    String pId = element.getProgramID();
    String pName = element.getProgramName();

    try {
      Connection db = Database.getAcademiaConnection();
      CallableStatement st = db.prepareCall("CALL AddProgram(?,?,?);");
      st.setString(1, pId);
      st.setString(2, pName);
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

  private void deleteResourceFromDataBase(String ProgramID) throws SQLCustomException {
    try {
      Connection db = Database.getAcademiaConnection();
      CallableStatement st = db.prepareCall("CALL DeleteProgram(?,?)");
      st.setString(1, ProgramID);
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
