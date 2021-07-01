package com.vgu.sqm.questionnaire.api;

import com.vgu.sqm.questionnaire.auth.BadCredentialException;
import com.vgu.sqm.questionnaire.auth.Credential;
import com.vgu.sqm.questionnaire.database.Database;
import com.vgu.sqm.questionnaire.database.SQLCustomException;
import com.vgu.sqm.questionnaire.utils.JsonUtils;
import java.io.IOException;
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.json.JsonObject;
import javax.json.stream.JsonParsingException;
import javax.naming.NamingException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/api/signup")
public class Signup extends Api {
  private static final long serialVersionUID = 1L;
  private static final Logger logger = Logger.getLogger(Login.class.getName());

  public Signup() {
    super();
  }

  protected void doPost(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    try {
      JsonObject json = JsonUtils.extractJsonRequestBody(request);
      String username = json.getJsonString(Credential.p_Username).getString();
      String password = json.getJsonString(Credential.p_Password).getString();
      addCredentialToDatabase(new Credential(username, password));
      response.setStatus(HttpServletResponse.SC_OK);
      response.getWriter().print("OK");
    } catch (BadCredentialException | SQLCustomException e) {
      response.setStatus(HttpServletResponse.SC_OK);
      response.getWriter().print(e.getMessage());
    } catch (JsonParsingException e) {
      response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
    } catch (NullPointerException e) {
      response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
      response.getWriter().print("Username or password is missing");
    } catch (Exception e) {
      Api.handleHttp500Error(response, e, logger);
    }
  }

  /** Add a Credential to the database */
  private void addCredentialToDatabase(Credential credential)
      throws SQLCustomException, NamingException {
    try {
      Connection db = Database.getAcademiaConnection();
      CallableStatement st = db.prepareCall("CALL AddCredential(?,?,?);");
      st.setString(1, credential.getUsername());
      st.setString(2, credential.getPassword());
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
}
