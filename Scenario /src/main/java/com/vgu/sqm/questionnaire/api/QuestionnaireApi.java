package com.vgu.sqm.questionnaire.api;

import com.vgu.sqm.questionnaire.database.Database;
import com.vgu.sqm.questionnaire.database.SQLCustomException;
import com.vgu.sqm.questionnaire.resource.MalformedResourceJsonException;
import com.vgu.sqm.questionnaire.resource.Questionnaire;
import com.vgu.sqm.questionnaire.resource.Resource;
import com.vgu.sqm.questionnaire.utils.JsonUtils;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;
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

@WebServlet("/api/questionnaire")
public class QuestionnaireApi extends ResourceApi {
  private static final Logger logger = Logger.getLogger(QuestionnaireApi.class.getName());
  private static final long serialVersionUID = 1L;

  // parameter names
  public static final String p_Gender = "gender";
  public static final String p_Answers = "qa";
  public static final String p_Comment = "comment";
  public static final String p_Question = "q";
  public static final List<String> validQuestions = Arrays.asList("gender", "0", "1", "2", "3", "4",
      "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17");

  public QuestionnaireApi() {
    super();
  }

  protected ArrayList<Resource> dumpResource() {
    ArrayList<Resource> resources = new ArrayList<Resource>();

    try {
      Connection db = Database.getAcademiaConnection();
      CallableStatement st = db.prepareCall("CALL DumpQuestionnaire()");
      ResultSet rs = st.executeQuery();
      while (rs.next()) {
        int qId = rs.getInt(Questionnaire.p_QuestionnaireID); // Attribute name QuestionnaireId
        String lId = rs.getString(Questionnaire.p_LecturerID); // Attribute name LecturerId
        String cId = rs.getString(Questionnaire.p_ClassID); // Attribute name ClassId
        char gender = rs.getString(Questionnaire.p_gender).charAt(0); // Attribute name Gender

        int[] answers = new int[18];
        answers[0] = rs.getInt(Questionnaire.p_Attendance);

        for (int i = 1; i < answers.length; i++) {
          answers[i] = rs.getInt("Question" + i);
          if (answers[i] == 6) {
            answers[i] = 0;
          }
        }

        String content = rs.getString(Questionnaire.p_comment); // Attribute name Comment
        if (content == null) {
          content = "";
        }

        resources.add(new Questionnaire(lId, cId, qId, gender, answers, content));
      }
      logger.log(Level.INFO, "Getting info from database successfully.");
      db.close();
    } catch (SQLException | NamingException e) {
      logger.log(Level.SEVERE, e.toString());
    }
    return resources;
  }

  /**
   * Gets the answer counts for an answer in the questionnaire answers with the corresponding
   * academic year, faculty, program and module
   *
   * @param AcademicYearID is not used in the filter if null
   * @param FacultyID      is not used in the filter if null
   * @param ProgramID      is not used in the filter if null
   * @param ModuleID       is not used in the filter if null
   * @param question       is the question to get the counts for and is compulsory
   * @returns a JSON object with the answer counts
   */
  private JsonObject getCounts(String AcademicYearID, String SemesterID, String FacultyID,
      String ProgramID, String ModuleID, String ClassID, String LecturerID, String question)
      throws SQLCustomException {
    HashMap<String, Integer> result = new HashMap<>();

    try {
      Connection db = Database.getAcademiaConnection();
      CallableStatement st;
      ResultSet rs;
      int status;

      st = db.prepareCall("CALL GetQuestionnaireCount(?,?,?,?,?,?,?,?,?)");
      st.setString(1, AcademicYearID);
      st.setString(2, SemesterID);
      st.setString(3, FacultyID);
      st.setString(4, ProgramID);
      st.setString(5, ModuleID);
      st.setString(6, ClassID);
      st.setString(7, LecturerID);
      st.setString(8, question);
      st.registerOutParameter(9, Types.INTEGER);
      rs = st.executeQuery();

      status = st.getInt(9);
      logger.log(Level.INFO, "Status is " + status);

      if (status != 200) {
        throw new SQLCustomException(status);
      }

      while (rs.next()) {
        String key = rs.getString("ValuesCount");
        int values = rs.getInt("Count");

        if (key.equals("N/A")) {
          continue;
        }

        result.put(key, values);
      }

      // when certain answers have 0 count
      for (String key : new String[] {"1", "2", "3", "4", "5"}) {
        if (!result.containsKey(key)) {
          result.put(key, 0);
        }
      }

    } catch (SQLException | NamingException e) {
      logger.log(Level.SEVERE, e.toString());
    }

    // turn the above results into JSON objects
    JsonObjectBuilder builder = Json.createObjectBuilder();
    for (Map.Entry<String, Integer> entry : result.entrySet()) {
      builder.add(entry.getKey(), entry.getValue());
    }
    return builder.build();
  }

  /**
   * Get a JSON array of comments of the Questionnaires identified by a Class ID and Lecturer ID
   *
   * @param ClassID
   * @param LecturerID
   * @returns a JSON array of comments for the Questionnaire of the Class-Lecturer pair
   */
  private JsonArray getComments(String ClassID, String LecturerID) throws SQLCustomException {
    JsonArrayBuilder builder = Json.createArrayBuilder();
    try {
      Connection db = Database.getAcademiaConnection();
      CallableStatement st;
      ResultSet rs;
      int status;

      st = db.prepareCall("CALL GetComments(?,?,?)");
      st.setString(1, ClassID);
      st.setString(2, LecturerID);
      st.registerOutParameter(3, Types.INTEGER);
      rs = st.executeQuery();
      status = st.getInt(3);

      if (status != 200) {
        throw new SQLCustomException(status);
      }

      while (rs.next()) {
        builder.add(rs.getString("comments"));
      }
    } catch (SQLException | NamingException e) {
      logger.log(Level.SEVERE, e.toString());
    }
    return builder.build();
  }

  /**
   * Get the maximum allow response count of all the questionnaires corresponding to the provided
   * academic year, faculty, program and module
   *
   * @param AcademicYearID is not used in the filter if null
   * @param FacultyID      is not used in the filter if null
   * @param ProgramID      is not used in the filter if null
   * @param ModuleID       is not used in the filter if null
   * @returns the max response count
   */
  private int getMaxResponseCount(String AcademicYearID, String SemesterID, String FacultyID,
      String ProgramID, String ModuleID, String ClassID, String LecturerID)
      throws SQLCustomException {
    int result = 0;
    try {
      Connection db = Database.getAcademiaConnection();
      CallableStatement st;
      ResultSet rs;
      int status;

      st = db.prepareCall("CALL GetTotalClassesSize(?,?,?,?,?,?,?,?)");
      st.setString(1, AcademicYearID);
      st.setString(2, SemesterID);
      st.setString(3, FacultyID);
      st.setString(4, ProgramID);
      st.setString(5, ModuleID);
      st.setString(6, LecturerID);
      st.setString(7, ClassID);
      st.registerOutParameter(8, Types.INTEGER);
      rs = st.executeQuery();

      status = st.getInt(8);
      logger.log(Level.INFO, "Status is " + status);

      if (status != 200) {
        throw new SQLCustomException(status);
      }

      if (rs.next()) {
        // TODO handle when there's no next()
        result = rs.getInt("TotalClassesSize");
      }
    } catch (SQLException | NamingException e) {
      logger.log(Level.SEVERE, e.toString());
    }
    return result;
  }

  @Override
  protected void doGetCustomAction(HttpServletRequest request, HttpServletResponse response,
      String action) throws ServletException, IOException {
    try {
      switch (action) {
        case "getCounts":
          handleActionGetCounts(request, response);
          break;
        case "getMaxResponseCount":
          handleActionGetMaxResponseCount(request, response);
          break;
        case "getComments":
          handleActionGetComments(request, response);
          break;
        default:
          ResourceApi.handleInvalidGetAction(response, action);
      }
    } catch (SQLCustomException e) {
      response.setStatus(HttpServletResponse.SC_OK);
      response.getWriter().print(e.getMessage());
    } catch (Exception e) {
      Api.handleHttp500Error(response, e, logger);
    }
  }

  /** Handle GET requests with action=getCounts */
  private void handleActionGetCounts(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException, SQLCustomException {
    String question = request.getParameter(QuestionnaireApi.p_Question);
    if (question == null) {
      Api.handleMissingParameters(response, QuestionnaireApi.p_Question);
      return;
    }

    if (!validQuestions.contains(question) || question.equals("comment")) {
      // invalid question for counting
      response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
      response.getWriter().print(String.format("Question %s is unvailable", question));
      return;
    }

    String yid = request.getParameter(ResourceApi.p_AcademicYearID);
    String sid = request.getParameter(ResourceApi.p_SemesterID);
    String fid = request.getParameter(ResourceApi.p_FacultyID);
    String pid = request.getParameter(ResourceApi.p_ProgramID);
    String mid = request.getParameter(ResourceApi.p_ModuleID);
    String cid = request.getParameter(ResourceApi.p_ClassID);
    String lid = request.getParameter(ResourceApi.p_LecturerID);

    // check parameters' validity
    if (!Resource.areIdsValidAllowNull(yid, sid, fid, pid, mid, cid, lid)) {
      Api.handleInvalidParameters(response, ResourceApi.p_AcademicYearID, ResourceApi.p_SemesterID,
          ResourceApi.p_FacultyID, ResourceApi.p_ProgramID, ResourceApi.p_ModuleID,
          ResourceApi.p_ClassID, ResourceApi.p_LecturerID);
      return;
    }

    response.setContentType("application/json");
    response.setStatus(HttpServletResponse.SC_OK);
    response.getWriter().print(getCounts(yid, sid, fid, pid, mid, cid, lid, question));
  }

  /** Handle GET requests with action=getMaxResponseCount */
  private void handleActionGetMaxResponseCount(HttpServletRequest request,
      HttpServletResponse response) throws ServletException, IOException, SQLCustomException {
    String yid = request.getParameter(ResourceApi.p_AcademicYearID);
    String sid = request.getParameter(ResourceApi.p_SemesterID);
    String fid = request.getParameter(ResourceApi.p_FacultyID);
    String pid = request.getParameter(ResourceApi.p_ProgramID);
    String mid = request.getParameter(ResourceApi.p_ModuleID);
    String cid = request.getParameter(ResourceApi.p_ClassID);
    String lid = request.getParameter(ResourceApi.p_LecturerID);
    // check parameters' validity
    if (!Resource.areIdsValidAllowNull(yid, sid, fid, pid, mid, cid, lid)) {
      Api.handleInvalidParameters(response, ResourceApi.p_AcademicYearID, ResourceApi.p_SemesterID,
          ResourceApi.p_FacultyID, ResourceApi.p_ProgramID, ResourceApi.p_ModuleID,
          ResourceApi.p_ClassID, ResourceApi.p_LecturerID);
      return;
    }

    response.setContentType("application/json");
    response.setStatus(HttpServletResponse.SC_OK);
    response.getWriter().print(getMaxResponseCount(yid, sid, fid, pid, mid, cid, lid));
  }

  /** Handle GET requests with action=getComments */
  private void handleActionGetComments(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException, SQLCustomException {
    String cid = request.getParameter(ResourceApi.p_ClassID);
    String lid = request.getParameter(ResourceApi.p_LecturerID);
    if (cid == null || lid == null) {
      Api.handleMissingParameters(response, ResourceApi.p_ClassID, ResourceApi.p_LecturerID);
      return;
    }

    if (!Resource.isIdValid(cid) || !Resource.isIdValid(lid)) {
      Api.handleInvalidParameters(response, ResourceApi.p_ClassID, ResourceApi.p_LecturerID);
      return;
    }

    response.getWriter().print(getComments(cid, lid));
    response.setStatus(HttpServletResponse.SC_OK);
  }

  protected void doPut(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    try {
      JsonObject json = JsonUtils.extractJsonRequestBody(request);
      addResourceToDatabase(Questionnaire.jsonToResource(json));
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
          || !request.getParameterMap().containsKey(ResourceApi.p_ClassID)
          || !request.getParameterMap().containsKey(ResourceApi.p_QuestionnaireID)) {
        Api.handleMissingParameters(response, ResourceApi.p_LecturerID, ResourceApi.p_ClassID,
            ResourceApi.p_QuestionnaireID);
        return;
      }

      String lid = request.getParameter(ResourceApi.p_LecturerID);
      String cid = request.getParameter(ResourceApi.p_ClassID);
      int qid = Integer.parseInt(request.getParameter(ResourceApi.p_QuestionnaireID));
      if (!Resource.areIdsValid(lid, cid)) {
        Api.handleInvalidParameters(response, ResourceApi.p_ClassID, ResourceApi.p_LecturerID);
        return;
      }

      deleteResourceFromDataBase(lid, cid, qid);
      response.setStatus(HttpServletResponse.SC_OK);
      response.getWriter().print("OK");
    } catch (NumberFormatException e) {
      response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
      response.getWriter().print(String.format("%s must be int", ResourceApi.p_QuestionnaireID));
    } catch (SQLCustomException e) {
      response.setStatus(HttpServletResponse.SC_OK);
      response.getWriter().print(e.getMessage());
    } catch (Exception e) {
      Api.handleHttp500Error(response, e, logger);
    }
  }

  protected void addResourceToDatabase(Resource resource) throws SQLCustomException {
    Questionnaire element = (Questionnaire) resource;

    String lId = element.getLecturerID();
    String cId = element.getClassID();
    char gender = element.getGender();
    int[] answers = element.getAnswers();
    String comment = element.getComment();

    try {
      Connection db = Database.getAcademiaConnection();
      CallableStatement st =
          db.prepareCall("CALL AddQuestionnaire(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);");
      st.setString(1, lId);
      st.setString(2, cId);
      st.setString(3, Character.toString(gender));
      for (int i = 0; i <= 17; i++) {
        st.setInt(4 + i, answers[i]);
      }
      st.setString(22, comment);
      st.registerOutParameter(23, Types.INTEGER);

      st.execute();

      int status = st.getInt(23);
      logger.log(Level.INFO, "Status: " + status);
      if (status != 200) {
        throw new SQLCustomException(status);
      }

    } catch (SQLException | NamingException e) {
      logger.log(Level.SEVERE, e.toString());
    }
  }

  private void deleteResourceFromDataBase(String LecturerID, String ClassID, int QuestionnaireID)
      throws SQLCustomException {
    try {
      Connection db = Database.getAcademiaConnection();
      CallableStatement st = db.prepareCall("CALL DeleteQuestionnaire(?,?,?,?)");
      st.setString(1, LecturerID);
      st.setString(2, ClassID);
      st.setInt(3, QuestionnaireID);
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
}
