package Menu.Admin;

import Menu.AbstractMenu;
import Menu.Main;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Scanner;

/**
 * Represent the menu for admin data modifications.
 */
public class Modifications extends AbstractMenu {

  /**
   * Creates an instance of this class.
   *
   * @param conn open SQL database connection
   * @param in   open input Scanner
   */
  public Modifications(Connection conn, Scanner in) {
    super(conn, in);
  }

  @Override
  public void run() throws SQLException {

    // print the menu options
    System.out.println("📊 Do you want to see the statistics on the data in the system or make "
        + "changes in the data?");
    System.out.println();
    System.out.println("1. See the statistics");
    System.out.println("2. Change or add the data");
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
          inputCorrect = true;
        case "2":
          inputCorrect = true;

        default:
          // process the standard or incorrect input
          inputCorrect = this.defaultInputHandler(input, new Main(this.conn));
      }
    }
  }
}
