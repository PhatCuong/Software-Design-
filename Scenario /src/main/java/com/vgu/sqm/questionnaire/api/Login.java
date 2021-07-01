package com.vgu.sqm.questionnaire.api;

import com.vgu.sqm.questionnaire.auth.BadCredentialException;
import com.vgu.sqm.questionnaire.auth.Credential;
import com.vgu.sqm.questionnaire.auth.JwtHandler;
import com.vgu.sqm.questionnaire.database.Database;
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

@WebServlet("/api/login")
public class Login extends Api {
  private static final long serialVersionUID = 1L;
  private static final Logger logger = Logger.getLogger(Login.class.getName());

  public static final String p_auth = "auth";
  // 1 day
  private static final int auth_age = 86400;
  private static final String msg_invalidLogin = "Username or password is incorrect";

  public Login() {
    super();
  }

  protected void doPost(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    try {
      JsonObject json = JsonUtils.extractJsonRequestBody(request);
      boolean valid = false;
      String username = json.getJsonString(Credential.p_Username).getString();
      String password = json.getJsonString(Credential.p_Password).getString();
      Credential credential = new Credential(username, password);

      if (!isCredentialValid(credential)) {
        response.setStatus(HttpServletResponse.SC_OK);
        response.getWriter().print(Login.msg_invalidLogin);
        return;
      }

      Cookie auth = new Cookie(Login.p_auth, JwtHandler.signUser(username));
      auth.setMaxAge(Login.auth_age);
      auth.setPath("/Questionnaire/");
      auth.setSecure(true);
      response.addCookie(auth);
      response.setStatus(HttpServletResponse.SC_OK);
      response.getWriter().print("OK");
    } catch (BadCredentialException e) {
      response.setStatus(HttpServletResponse.SC_OK);
      response.getWriter().print(e.getMessage());
    } catch (NullPointerException e) {
      response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
      response.getWriter().print("Username or password is missing");
    } catch (JsonParsingException e) {
      response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
    } catch (Exception e) {
      Api.handleHttp500Error(response, e, logger);
    }
  }

  /** Check with the database whether a Credential is of a valid user */
  private boolean isCredentialValid(Credential credential) throws SQLException, NamingException {
    Connection db = Database.getAcademiaConnection();
    CallableStatement st = db.prepareCall("CALL CheckCredential(?,?,?);");
    st.setString(1, credential.getUsername());
    st.setString(2, credential.getPassword());
    st.registerOutParameter(3, Types.BOOLEAN);

    st.execute();

    return st.getBoolean(3);
  }
}
