package View.Admin.Modifications;

import View.AbstractModification;
import View.Home;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Scanner;

/**
 * Represents the Project modification menu for the admin.
 */
public class Project extends AbstractModification {

  /**
   * Creates an instance of Project modification menu.
   *
   * @param conn open SQL database connection
   * @param in   open input Scanner
   */
  public Project(Connection conn, Scanner in) {
    super(conn, in,
        "Project",
        "project",
        "getProjects()",
        3,
        "project_name",
        new int[]{3, 1, 2, 4, 5});
  }

  /*
  Helper method to prompt for the status of the project.
   */
  private String promptProjectStatus() throws SQLException {
    // init marker to check if the input is correct
    boolean inputCorrect = false;

    // repeat this menu prompt until the input is recognized
    while (!inputCorrect) {

      // print the menu options
      System.out.println();
      System.out.println("Choose the project status:");
      System.out.println("1. Active");
      System.out.println("2. Completed");
      System.out.println("3. Planned");
      System.out.println("4. Frozen");
      System.out.println();
      this.printStandardPrompt();

      // get the user input for this menu
      String input = this.in.nextLine();
      System.out.println();

      // process the input
      switch (input.toLowerCase()) {
        case "1":
          return "Active";
        case "2":
          return "Completed";
        case "3":
          return "Planned";
        case "4":
          return "Frozen";
        default:
          // process the standard or incorrect input
          inputCorrect = this.checkStandardInputOptions(input, new Home(this.conn),
              new MainModifications(this.conn,
                  this.in));
      }
    }

    return null;
  }

  /**
   * Helper method to check that the year within the given range.
   */
  private boolean checkYear(String input) {
    int year;
    try {
      year = Integer.parseInt(input);
    } catch (NumberFormatException e) {
      System.out.println();
      System.out.println("❌ The year should be a number!");
      System.out.println();
      return false;
    }
    int currentYear = java.time.Year.now().getValue();
    if (1970 <= year && year <= currentYear) {
      return true;
    } else {
      System.out.println();
      System.out.println("❌ The year should be in range between 1970 and " + currentYear + " "
          + "(inclusive)!");
      System.out.println();
      return false;
    }
  }


  @Override
  protected void add() throws SQLException {

    System.out.println("Adding a new " + this.entityName + ".");

    // define participating variables
    String name, intervention, charityID, year, status;
    PreparedStatement pstmt;

    // set up a query
    //
    String query = "CALL addProject(?, ?, ?, ?, ?)";

    // get input and execute a database operation
    while (true) {

      // get name
      name = this.promptAddWhileEmpty(this.in, "name");

      // get a table of interventions
      System.out.println("❓ Which intervention does this project implement?");
      intervention = this.promptTable("getInterventions()", 1, new int[]{1, 2, 3});

      // get a table of charities
      System.out.println("❓ Which charity implements this project?");
      charityID = this.promptTable("getCharities()", 1, new int[]{2, 3, 4, 5, 6});

      // get year
      year = this.promptAddWhileEmpty(this.in, "year");
      // check that the year within the given range
      while (!year.isEmpty() && !this.checkYear(year)) {
        year = this.promptAdd(this.in, "year");
      }

      // get status
      status = this.promptProjectStatus();

      try {
        pstmt = conn.prepareStatement(query);
        pstmt.clearParameters();
        pstmt.setString(3, name);
        pstmt.setString(1, intervention);
        pstmt.setString(2, charityID);
        pstmt.setString(4, year);
        pstmt.setString(5, status);
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
      String query = "SELECT * FROM project WHERE project_name = ?";
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
            "UPDATE project SET project_name = ?, intervention = ?, charity = ?, year_init = ?, "
                + "project_status = ? WHERE project_name = ?";
        pstmt = conn.prepareStatement(query);
        pstmt.clearParameters();

        // get new name
        String curName = rs.getString(3);
        this.printCurrentValue("name", curName);
        String name = this.promptUpdateWhileEmpty(this.in, "name");
        pstmt.setString(1, name);

        // get new intervention
        String curInterventionID = rs.getString(1);
        // TODO get intervention name of the cause with this id (use procedure)
        // FIXME print intervention name instead of id here
        this.printCurrentValue("intervention", curInterventionID);
        String interventionID = this.promptTable("getInterventions()",
            1, new int[]{1, 2, 3});
        pstmt.setString(2, interventionID);

        // get new charity
        String curCharityID = rs.getString(2);
        // TODO get charity name of the cause with this id (use procedure)
        // FIXME print charity name instead of id here
        this.printCurrentValue("charity", curCharityID);
        String charityID = this.promptTable("getCharities()",
            1, new int[]{2, 3, 4, 5, 6});
        pstmt.setString(3, charityID);

        // get new year
        String curYear = rs.getString(4);
        this.printCurrentValue("year", curYear);
        String year = this.promptUpdateWhileEmpty(this.in, "year");
        // check that the year within the given range
        while (!year.isEmpty() && !this.checkYear(year)) {
          year = this.promptUpdateWhileEmpty(this.in, "year");
        }
        pstmt.setString(4, year);

        String curStatus = rs.getString(5);
        this.printCurrentValue("status", curStatus);
        String status = this.promptProjectStatus();
        pstmt.setString(5, status);

        // set the id value for the row in the query
        pstmt.setString(6, id);

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
