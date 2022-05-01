package View.Admin;

import View.AbstractMenu;
import View.Admin.Modifications.MainModifications;
import View.Home;
import View.Menu;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Scanner;

/**
 * Represent the menu for the admin.
 */
public class MainAdmin extends AbstractMenu {

  /**
   * Creates an instance of this class.
   *
   * @param conn open SQL database connection
   * @param in   open input Scanner
   */
  public MainAdmin(Connection conn, Scanner in) {
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
      System.out.println("Hello Admin!");
//      System.out.println("📊 Do you want to see the statistics on the data in the system or make "
//          + "changes in the data?");
      System.out.println();
//      System.out.println("1. See the statistics");
      System.out.println("1. Change or add the data");
      System.out.println();

      this.printStandardPrompt();

      // get the user input for this menu
      String input = this.in.nextLine();
      System.out.println();

      // process the input
      switch (input.toLowerCase()) {
//        case "1":
//          inputCorrect = true;
        case "1":
          inputCorrect = true;
          Menu mods = new MainModifications(conn, in);
          mods.run();
        default:
          // process the standard or incorrect input
          inputCorrect = this.checkStandardInputOptions(input, new Home(this.conn),
              new Home(this.conn));
      }
    }
  }
}
