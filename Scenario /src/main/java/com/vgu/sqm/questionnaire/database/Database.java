package com.vgu.sqm.questionnaire.database;

import java.sql.Connection;
import java.sql.SQLException;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

public class Database {
  public static final String msg_getSuccess = "Getting info from database successfully.";
  /**
   * Gets a database connection
   *
   * @return the connection to the configured database
   */
  public static Connection getAcademiaConnection() throws SQLException, NamingException {
    Context initContext = new InitialContext();
    Context envContext = (Context) initContext.lookup("java:comp/env");
    DataSource ds = (DataSource) envContext.lookup("jdbc/vgu6");
    return ds.getConnection();
  }
}
