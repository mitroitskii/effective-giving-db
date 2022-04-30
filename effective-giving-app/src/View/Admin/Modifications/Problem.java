package View.Admin.Modifications;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Scanner;

/**
 * Represents the Problem modification menu for the admin.
 */
public class Problem extends AbstractModification {

  /**
   * Creates an instance of Problem modification menu.
   *
   * @param conn open SQL database connection
   * @param in   open input Scanner
   */
  public Problem(Connection conn, Scanner in) {
    super(conn, in,
        "Problem",
        "problem",
        1,
        "problem_id",
        new int[]{2, 3});
  }

  @Override
  protected void add() throws SQLException {
    System.out.println("Adding a new " + this.entityName + ".");
    // defining participating variables
    String name, causeID;
    PreparedStatement pstmt;
    String query = "INSERT INTO problem (problem_name, cause) value (?, ?)";
    // getting input and executing a database operation
    while (true) {
      // checking that the input is not empty
      name = this.promptAddWhileEmpty(this.in, "name");
      // TODO MYSQL DUPLICATE CHECK
      System.out.println();
      System.out.println("❓ What is the cause area of this problem?");
      causeID = this.promptTable("cause_area", 1, new int[]{2});
      try {
        pstmt = conn.prepareStatement(query);
        pstmt.clearParameters();
        pstmt.setString(1, name);
        pstmt.setString(2, causeID);
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
      String id = this.promptTable(this.tableName, this.idColNum, this.colsToPrint);

      // define participating variables
      PreparedStatement pstmt;

      // query to get the current values of the chosen row
      String query = "SELECT * FROM problem WHERE problem_id = ?";
      ResultSet rs;

      try {

        // set up select query
        pstmt = conn.prepareStatement(query);
        pstmt.clearParameters();
        pstmt.setString(1, id);
        rs = pstmt.executeQuery();
        // position cursor to the first row
        rs.next();

        // set up update query
        query = "UPDATE problem SET problem_name = ?, cause = ? WHERE problem_id = ?";
        pstmt = conn.prepareStatement(query);
        pstmt.clearParameters();

        // get new name
        String curName = rs.getString(2);
        this.printCurrentValue("name", curName);
        // TODO MYSQL DUPLICATE CHECK
        String name = this.promptUpdateWhileEmpty(this.in, "name");
        pstmt.setString(1, name);

        // get new cause area
        String curCauseID = rs.getString(2);
        // TODO get cause name of the cause with this id (use procedure)
        // FIXME print cause name instead of cause id here
        this.printCurrentValue("cause area", curCauseID);
        // TODO MYSQL DUPLICATE CHECK
        System.out.println("❓ What is the new cause area of this problem?");
        String causeID = this.promptTable("cause_area", 1, new int[]{2});
        pstmt.setString(2, causeID);

        // set the id value for the row in the query
        pstmt.setString(3, id);

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
