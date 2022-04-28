package Menu.Admin.Modifications;

import Menu.AbstractMenu;
import Menu.Home;
import Menu.Menu;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Scanner;

public class CauseArea extends AbstractMenu {

  /**
   * Creates an instance of this class.
   *
   * @param conn open SQL database connection
   * @param in   open input Scanner
   */
  protected CauseArea(Connection conn, Scanner in) {
    super(conn, in);
  }

  @Override
  public void run() throws SQLException {

    // print the menu options
    System.out.println("Pick an action");
    System.out.println();
    System.out.println("1. Add Cause Area");
    System.out.println("2. Change existing Cause Area");
    System.out.println("3. Delete existing Cause Area");
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
        default:
          // process the standard or incorrect input
          inputCorrect = this.defaultInputHandler(input, new Home(this.conn),
              new MainModifications(this.conn,
                  this.in));
      }
    }

  }
}
