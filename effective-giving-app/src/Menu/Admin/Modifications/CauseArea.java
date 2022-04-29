package Menu.Admin.Modifications;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.Scanner;

/**
 * Represents the Cause Area modification menu for the admin.
 */
public class CauseArea extends AbstractModification {

  /**
   * Creates an instance of this class.
   *
   * @param conn open SQL database connection
   * @param in   open input Scanner
   */
  public CauseArea(Connection conn, Scanner in) {
    super(conn, in,
        "Cause Area",
        "cause_area",
        1,
        "cause_id",
        new int[]{2});
  }

  @Override
  protected void add() throws SQLException {
    System.out.println("Adding a new a Cause Area.");
    // defining participating variables
    String input;
    PreparedStatement pstmt;
    String query = "INSERT INTO cause_area (cause_name) value (?)";
    // getting input and executing a database operation
    while (true) {
      // checking that the input is not empty
      input = this.promptWhileInputEmpty(this.in, "What is the Cause Area name?: ");
      try {
        pstmt = conn.prepareStatement(query);
        pstmt.clearParameters();
        pstmt.setString(1, input);
        pstmt.executeUpdate();
        this.printSuccessMsg();
        this.printPreviousMenuMsg();
        break;
      } catch (SQLException e) {
        this.printErrorMsg(e);
      }
    }
  }

  // TODO leave one class Modification
  // - provide special contrustor args
  // TODO - provide name of id column + array of cols + special handler function
  // TODO additionalInputCheck lambda functions as parameters
  // - (int col) {if (col = 5) execute test }
  @Override
  protected void update() throws SQLException {

  }

}
