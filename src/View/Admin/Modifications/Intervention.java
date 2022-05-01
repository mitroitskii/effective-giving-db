package View.Admin.Modifications;

import View.AbstractModification;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Scanner;

/**
 * Represents the Intervention modification menu for the admin.
 */
public class Intervention extends AbstractModification {

  /**
   * Creates an instance of Intervention modification menu.
   *
   * @param conn open SQL database connection
   * @param in   open input Scanner
   */
  public Intervention(Connection conn, Scanner in) {
    super(conn, in,
        "Intervention",
        "intervention",
        "getInterventions()",
        1,
        "Intervention_name",
        new int[]{1, 2, 3});
  }

  /**
   * Helper method to check that the qaly is in the proper format.
   */
  private boolean checkQALY(String input) {
    if (input.matches("\\d{1,2}(\\.\\d{1,2}){0,1}")) {
      return true;
    } else {
      System.out.println();
      System.out.println("❌ QALY should be a number with the maximum of 2 digits before and after "
          + "the decimal point. Try again.");
      System.out.println();
      return false;
    }
  }

  @Override
  protected void add() throws SQLException {

    System.out.println("Adding a new " + this.entityName + ".");

    // define participating variables
    String name, qaly, problemID;
    PreparedStatement pstmt;

    // set up a query
    String query = "INSERT INTO intervention (intervention_name, qaly, problem) value (?, ?, ?)";

    // get input and execute a database operation
    while (true) {

      // check that the input is not empty
      name = this.promptAddWhileEmpty(this.in, "name");

      qaly = this.promptAdd(this.in, "QALY");
      // check that the qaly value is in proper format
      while (!qaly.isEmpty() && !this.checkQALY(qaly)) {
        qaly = this.promptAdd(this.in, "QALY");
      }

      // get a table of problems
      System.out.println("❓ Which problem does this intervention address?");
      problemID = this.promptTable("getProblems()", 1, new int[]{2, 3});

      try {
        pstmt = conn.prepareStatement(query);
        pstmt.clearParameters();
        pstmt.setString(1, name);
        // qaly can be null
        this.setStringOrNull(pstmt, 2, qaly, Types.DECIMAL);
        pstmt.setString(3, problemID);
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
      String query = "SELECT * FROM intervention WHERE intervention_name = ?";
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
        query = "UPDATE intervention SET intervention_name = ?, qaly = ?, problem = ? WHERE "
            + "intervention_name = ?";
        pstmt = conn.prepareStatement(query);
        pstmt.clearParameters();

        // get new name
        // current name for intervention is the id
        this.printCurrentValue("name", id);
        String name = this.promptUpdateWhileEmpty(this.in, "name");
        pstmt.setString(1, name);

        // get new qaly
        String curQaly = rs.getString(2);
        this.printCurrentValue("QALY", curQaly);
        String qaly = this.promptUpdate(this.in, "QALY");
        // check that the qaly value is in proper format
        while (!qaly.isEmpty() && !this.checkQALY(qaly)) {
          qaly = this.promptUpdate(this.in, "QALY");
        }
        this.setStringOrNull(pstmt, 2, qaly, Types.DECIMAL);

        // get new problem id
        String curProblemID = rs.getString(3);
        // TODO get problem name of the cause with this id (use procedure)
        // FIXME print problem name instead of id here
        this.printCurrentValue("problem", curProblemID);
        System.out.println("❓ What is the new problem that this intervention addresses?");
        String problemID = this.promptTable("getProblems()", 1, new int[]{2, 3});
        pstmt.setString(3, problemID);

        // set the id value for the row in the query
        pstmt.setString(4, id);

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
