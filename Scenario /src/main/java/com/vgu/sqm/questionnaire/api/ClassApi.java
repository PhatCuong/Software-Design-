package com.vgu.sqm.questionnaire.api;

import com.vgu.sqm.questionnaire.database.Database;
import com.vgu.sqm.questionnaire.database.SQLCustomException;
import com.vgu.sqm.questionnaire.resource.Class;
import com.vgu.sqm.questionnaire.resource.Faculty;
import com.vgu.sqm.questionnaire.resource.Lecturer;
import com.vgu.sqm.questionnaire.resource.MalformedResourceJsonException;
import com.vgu.sqm.questionnaire.resource.Program;
import com.vgu.sqm.questionnaire.resource.Resource;
import com.vgu.sqm.questionnaire.resource.Semester;
import com.vgu.sqm.questionnaire.utils.JsonUtils;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.json.Json;
import javax.json.JsonObject;
import javax.json.stream.JsonParsingException;
import javax.naming.NamingException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/api/class")
public class ClassApi extends ResourceApi {
  private static final Logger logger = Logger.getLogger(ClassApi.class.getName());
  private static final long serialVersionUID = 1L;

  public ClassApi() {
    super();
  }

  protected ArrayList<Resource> dumpResource() {
    ArrayList<Resource> resources = new ArrayList<Resource>();

    try {
      Connection db = Database.getAcademiaConnection();
      CallableStatement st = db.prepareCall("CALL DumpClass();");
      ResultSet rs = st.executeQuery();
      while (rs.next()) {
        String cId = rs.getString(Class.p_ClassID); // Attribute name: ClassID
        int size = rs.getInt(Class.p_Size); // Attribute name: Size
        String sId = rs.getString(Class.p_SemesterID); // Attribute name: SemesterID
        String mId = rs.getString(Class.p_ModuleID); // Attribute name: ModuleID

        resources.add(new Class(cId, size, sId, mId));
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
      addResourceToDatabase(Class.jsonToResource(json));
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
      if (!request.getParameterMap().containsKey(ResourceApi.p_ClassID)) {
        Api.handleMissingParameters(response, ResourceApi.p_ClassID);
        return;
      }

      String id = request.getParameter(ResourceApi.p_ClassID);
      if (!Resource.isIdValid(id)) {
        Api.handleInvalidParameters(response, ResourceApi.p_ClassID);
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
    Class element = (Class) resource;

    String cId = element.getClassID();
    int size = element.getSize();
    String sId = element.getSemesterID();
    String mId = element.getModuleID();

    try {
      Connection db = Database.getAcademiaConnection();
      CallableStatement st = db.prepareCall("CALL AddClass(?,?,?,?,?);");
      st.setString(1, cId);
      st.setInt(2, size);
      st.setString(3, sId);
      st.setString(4, mId);
      st.registerOutParameter(5, Types.INTEGER);

      st.execute();

      int status = st.getInt(5);
      logger.log(Level.INFO, "Status: " + status);
      if (status != 200) {
        throw new SQLCustomException(status);
      }

    } catch (SQLException | NamingException e) {
      logger.log(Level.SEVERE, e.toString());
    }
  }

  private void deleteResourceFromDataBase(String ClassID) throws SQLCustomException {
    try {
      Connection db = Database.getAcademiaConnection();
      CallableStatement st = db.prepareCall("CALL DeleteClass(?,?)");
      st.setString(1, ClassID);
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
