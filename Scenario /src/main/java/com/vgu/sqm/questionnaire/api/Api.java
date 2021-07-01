package com.vgu.sqm.questionnaire.api;

import com.vgu.sqm.questionnaire.utils.StringUtils;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletResponse;

public abstract class Api extends HttpServlet {
  /** throws HTTP 500 Internal server error */
  protected static void handleHttp500Error(HttpServletResponse response, Exception e, Logger logger)
      throws ServletException, IOException {
    logger.log(Level.SEVERE, e.toString());
    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
    response.getWriter().print("Oh no, you broke the server! Call the admins!");
  }

  /** throws HTTP 500 Internal server error */
  protected static void handleHttp500Error(HttpServletResponse response, Exception e)
      throws ServletException, IOException {
    Logger logger = Logger.getLogger("Api");
    Api.handleHttp500Error(response, e, logger);
  }

  /** handles cases where one or more parameters is missing */
  protected static void handleMissingParameters(HttpServletResponse response, String... params)
      throws ServletException, IOException {
    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
    response.getWriter().print(StringUtils.messageMissingParameters(params));
  }

  /** handles cases where one or more parameters is invalid */
  protected static void handleInvalidParameters(HttpServletResponse response, String... params)
      throws ServletException, IOException {
    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
    response.getWriter().print(StringUtils.messageInvalidParameters(params));
  }
}
