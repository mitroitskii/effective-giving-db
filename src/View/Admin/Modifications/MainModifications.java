package View.Admin.Modifications;

import View.AbstractMenu;
import View.Admin.MainAdmin;
import View.Home;
import View.Menu;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Scanner;

/**
 * Represents the menu for admin data modifications.
 */
public class MainModifications extends AbstractMenu {

  /**
   * Creates an instance of this class.
   *
   * @param conn open SQL database connection
   * @param in   open input Scanner
   */
  public MainModifications(Connection conn, Scanner in) {
    super(conn, in);
  }

  @Override
  public void run() throws SQLException {

    // init marker to check if the input is correct
    boolean inputCorrect = false;

    // repeat this menu prompt until the input is recognized
    while (!inputCorrect) {
      // print the menu options
      this.printSeparatorLine();
      System.out.println();
      System.out.println("What changes do you want to make?");
      System.out.println();
      System.out.println("1. Modify Cause Areas");
      System.out.println("2. Modify Problems");
      System.out.println("3. Modify Interventions");
      System.out.println("4. Modify Charities");
      System.out.println("5. Modify Projects");
      System.out.println();
      this.printStandardPrompt();

      // get the user input for this menu
      String input = this.in.nextLine();
      System.out.println();

      // process the input
      switch (input.toLowerCase()) {
        case "1":
          Menu cause = new CauseArea(this.conn, this.in);
          cause.run();
        case "2":
          Menu problem = new Problem(this.conn, this.in);
          problem.run();
        case "3":
          Menu intervention = new Intervention(this.conn, this.in);
          intervention.run();
        case "4":
          Menu charity = new Charity(this.conn, this.in);
          charity.run();
        case "5":
          Menu project = new Project(this.conn, this.in);
          project.run();
        default:
          // process the standard or incorrect input
          inputCorrect = this.checkStandardInputOptions(input, new Home(this.conn),
              new MainAdmin(this.conn, this.in));
      }
    }
  }
}
