package Menu;

import Menu.Admin.Admin;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Scanner;

/**
 * Represents the main application menu.
 */
public class Main extends AbstractMenu {

  /**
   * Creates an instance of this class.
   *
   * @param conn open SQL database connection
   */
  public Main(Connection conn) {
    super(conn, null);
  }

  @Override
  protected void printStandardPrompt() {
    System.out.print("Choose the option and type in its number, or type in "
        + "\"Quit\" to quit the app: ");
  }

  public void run() throws SQLException {

    // initialize the input Scanner and sets its value to the state
    Scanner in = new Scanner(System.in);

    // print the menu options
    System.out.println("👋 Welcome to the Effective Giving Community!");
    System.out.println();
    System.out.println("Are you a new donor, a returning donor, or an admin?");
    System.out.println();
    System.out.println("1. I’m a new donor");
    System.out.println("2. I’m a returning donor");
    System.out.println("3. I’m an admin");
    System.out.println();

    // init marker to check if the input is correct
    boolean inputCorrect = false;

    while (!inputCorrect) {
      this.printStandardPrompt();
      // get the user input for this menu
      String input = in.nextLine();
      System.out.println();
      // process the input
      switch (input.toLowerCase()) {
        case "1":
        case "2":
        case "3":
          Menu admin = new Admin(this.conn, this.in);
          admin.run();
        default:
          // process the standard or incorrect input
          inputCorrect = this.defaultInputHandler(input, new Main(this.conn));
      }
    }

  }

}
