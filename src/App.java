import static java.lang.System.exit;

import View.Home;
import View.Menu;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

/**
 * Home application class. Contains an entry point.
 *
 * @author mitroitskii
 */
public class App {

  /**
   * Runs the App starting from the main menu. The program entry point.
   *
   * @param args standard set of program arguments
   */
  public static void main(String[] args) {
    String userName = System.getenv("USERNAME");
    String password = System.getenv("PASSWORD");

    Connection conn = null;
    try {
      conn = getConnection(userName, password);
    } catch (SQLException e) {
      System.out.println("ERROR: Could not connect to the database");
      System.out.println(e.getMessage() + e.getSQLState() + e.getErrorCode());
      e.printStackTrace();
      exit(1);
    }

    try {
      Menu main = new Home(conn);
      main.run();
    } catch (SQLException e) {
      System.out.println(e.getMessage() + e.getSQLState() + e.getErrorCode());
    }

  }

  /**
   * Returns a new database connection.
   *
   * @return a new database connection
   * @throws SQLException if there is an error when establishing the connection
   */

  private static Connection getConnection(String userName, String password) throws SQLException {

    Connection conn = null;
    Properties connectionProps = new Properties();
    connectionProps.put("user", userName);
    connectionProps.put("password", password);

    // db config
    String serverName = "localhost";
    int portNumber = 3306;
    String dbName = "effective_giving";

    conn = DriverManager.getConnection("jdbc:mysql://"
            + serverName + ":" + portNumber + "/" + dbName
            + "?characterEncoding=UTF-8&useSSL=false",
        connectionProps);

    return conn;
  }

}
        

   