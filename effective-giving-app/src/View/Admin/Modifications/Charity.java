package View.Admin.Modifications;

import View.AbstractModification;
import View.Home;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Scanner;

/**
 * Represents the Charity modification menu for the admin.
 */
public class Charity extends AbstractModification {

  /**
   * Creates an instance of Charity modification menu.
   *
   * @param conn open SQL database connection
   * @param in   open input Scanner
   */
  public Charity(Connection conn, Scanner in) {
    super(conn, in,
        "Charity",
        "charity",
        1,
        "charity_id",
        new int[]{2, 3, 5, 6, 7});
  }


  /*
  Helper method to prompt for the type of charity.
   */
  private String promptCharityType() throws SQLException {
    // init marker to check if the input is correct
    boolean inputCorrect = false;

    // repeat this menu prompt until the input is recognized
    while (!inputCorrect) {

      // print the menu options
      System.out.println();
      System.out.println("Choose the type of the charity:");
      System.out.println("1. Community");
      System.out.println("2. Research");
      System.out.println("3. Program Delivery");
      System.out.println();
      this.printStandardPrompt();

      // get the user input for this menu
      String input = this.in.nextLine();
      System.out.println();

      // process the input
      switch (input.toLowerCase()) {
        case "1":
          return "Community";
        case "2":
          return "Research";
        case "3":
          return "Program Delivery";
        default:
          // process the standard or incorrect input
          inputCorrect = this.checkStandardInputOptions(input, new Home(this.conn),
              new MainModifications(this.conn,
                  this.in));
      }
    }

    return null;
  }

  @Override
  protected void add() throws SQLException {

    System.out.println("Adding a new " + this.entityName + ".");

    // define participating variables
    String name, website, description, type, causeID, link;
    PreparedStatement pstmt;

    // set up a query
    String query = "INSERT INTO charity (charity_name, charity_website, charity_description, "
        + "charity_type, charity_cause, donations_link) "
        + "value(?, ?, ?, ?, ?, ?)";

    // get input and execute a database operation
    while (true) {

      // get name
      name = this.promptAddWhileEmpty(this.in, "name");
      // TODO MYSQL DUPLICATE CHECK

      // get website
      website = this.promptAddWhileEmpty(this.in, "website");

      // get description
      description = this.promptAddWhileEmpty(this.in, "description");

      // get type
      type = this.promptCharityType();

      // get a table of causes
      System.out.println("❓ Which cause area does this charity work in?");
      causeID = this.promptTable("cause_area", 1, new int[]{2});

      // get direct donation link
      link = this.promptAdd(this.in, "direct donation link");

      try {
        pstmt = conn.prepareStatement(query);
        pstmt.clearParameters();
        pstmt.setString(1, name);
        pstmt.setString(2, website);
        pstmt.setString(3, description);
        pstmt.setString(4, type);
        pstmt.setString(5, causeID);
        this.setStringOrNull(pstmt, 6, link, Types.VARCHAR);
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
      String query = "SELECT * FROM charity WHERE charity_id = ?";
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
        query =
            "UPDATE charity SET charity_name = ?, charity_website = ?, charity_description = ?, "
                + "charity_type = ?, charity_cause = ?, donations_link = ?"
                + "WHERE "
                + "charity_id = ?";
        pstmt = conn.prepareStatement(query);
        pstmt.clearParameters();

        // get new name
        // current name for intervention is the id
        this.printCurrentValue("name", id);
        // TODO MYSQL DUPLICATE CHECK
        String name = this.promptUpdateWhileEmpty(this.in, "name");
        pstmt.setString(1, name);

        // get new qaly
        String curQaly = rs.getString(2);
        this.printCurrentValue("QALY", curQaly);
        String qaly = this.promptUpdate(this.in, "QALY");
        // check that the qaly value is in proper format
//        while (!qaly.isEmpty() && !this.checkQALY(qaly)) {
//          qaly = this.promptUpdate(this.in, "QALY");
//        }
        this.setStringOrNull(pstmt, 2, qaly, Types.DECIMAL);

        // get new cause area
        String curProblemID = rs.getString(3);
        // TODO get problem name of the cause with this id (use procedure)
        // FIXME print problem name instead of id here
        this.printCurrentValue("problem", curProblemID);
        // TODO MYSQL DUPLICATE CHECK
        System.out.println("❓ What is the new problem that this intervention addresses?");
        String problemID = this.promptTable("problem", 1, new int[]{2, 3});
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
