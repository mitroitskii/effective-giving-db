package Menu.Admin.Modifications;

import Menu.AbstractMenu;
import Menu.Admin.MainAdmin;
import Menu.Home;
import Menu.Menu;
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

    // print the menu options
    System.out.println("What changes do you want to make?");
    System.out.println();
    System.out.println("1. Modify Cause Areas");
    System.out.println("2. Modify Problems");
    System.out.println("3. Modify Interventions");
    System.out.println("4. Modify Charities");
    System.out.println("5. Modify Projects");
    System.out.println("6. Modify Evaluators");
    System.out.println("7. Modify Evaluations");
    System.out.println("8. Modify New Donor Sources");
    System.out.println();

    // init marker to check if the input is correct
    boolean inputCorrect = false;

    while (!inputCorrect) {
      this.printStandardPrompt();
      // get the user input for this menu
      String input = this.in.nextLine();
      System.out.println();
      // process the input
      switch (input.toLowerCase()) {
        case "1":
          Menu cause = new CauseArea(this.conn, this.in);
        case "2":
        case "3":
        case "4":
        case "5":
        case "6":
        case "7":
        case "8":
        default:
          // process the standard or incorrect input
          inputCorrect = this.defaultInputHandler(input, new Home(this.conn),
              new MainAdmin(this.conn, this.in));
      }
    }
  }
}
