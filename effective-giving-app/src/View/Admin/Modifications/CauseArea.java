package View.Admin.Modifications;

import View.AbstractModification;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Scanner;

/**
 * Represents the Cause Area modification menu for the admin.
 */
public class CauseArea extends AbstractModification {

  /**
   * Creates an instance Cause Area modification menu.
   *
   * @param conn open SQL database connection
   * @param in   open input Scanner
   */
  public CauseArea(Connection conn, Scanner in) {
    super(conn, in,
        "Cause Area",
        "cause_area",
        "getCauseAreas()",
        1,
        "cause_id",
        new int[]{2});
  }

  @Override
  protected void add() throws SQLException {
    System.out.println("Adding a new " + this.entityName + ".");
    // defining participating variables
    String name;
    PreparedStatement pstmt;
    String query = "INSERT INTO cause_area (cause_name) value (?)";
    // getting input and executing a database operation
    while (true) {
      // checking that the input is not empty
      name = this.promptAddWhileEmpty(this.in, "name");
      try {
        pstmt = conn.prepareStatement(query);
        pstmt.clearParameters();
        pstmt.setString(1, name);
        pstmt.executeUpdate();
        this.printSuccessMsg();
        this.printPreviousMenuMsg();
        // return from the function on success
        return;
      } catch (SQLException e) {
        this.printErrorMsg(e);
      }
    }
  }


  @Override
  protected void update() throws SQLException {

    // loop until the item is correctly updated
    while (true) {

      System.out.println("Pick the item to update:");
      System.out.println();

      // print the table of values and get the id of the value to update
      String id = this.promptTable(this.procedure, this.idColNum, this.colsToPrint);

      // define participating variables
      PreparedStatement pstmt;

      // query to get the current values of the chosen row
      String query = "SELECT * FROM cause_area WHERE cause_id = ?";
      ResultSet rs;

      try {

        // set up select query
        pstmt = conn.prepareStatement(query);
        pstmt.clearParameters();
        pstmt.setString(1, id);
        rs = pstmt.executeQuery();
        // position cursor to the first row
        rs.next();

        // set up update queryw
        query = "UPDATE cause_area SET cause_name = ? WHERE cause_id = ?";
        pstmt = conn.prepareStatement(query);
        pstmt.clearParameters();

        // get new name
        String curName = rs.getString(2);
        this.printCurrentValue("name", curName);
        String name = this.promptUpdateWhileEmpty(this.in, "name");
        pstmt.setString(1, name);

        // set the id value for the row in the query
        pstmt.setString(2, id);

        // run the update
        pstmt.executeUpdate();

        this.printSuccessMsg();
        this.printPreviousMenuMsg();
        // return from the function on success
        return;

      } catch (SQLException e) {
        this.printErrorMsg(e);
      }
    }

  }

}
