package Menu;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.Scanner;

/**
 * Implements a set of shared menu methods.
 */
public abstract class AbstractMenu implements Menu {

  protected Connection conn;
  protected Scanner in;

  // TODO donor ID to class Donor and then extend nested menus from there

  /**
   * Creates an instance of this class.
   *
   * @param conn open SQL database connection
   * @param in   open input Scanner
   */
  protected AbstractMenu(Connection conn, Scanner in) {
    this.conn = conn;
    this.in = in;
  }

  /**
   * Prints the standard choose your option prompt.
   */
  protected void printStandardPrompt() {
    System.out.print("Choose the option and type in its number, or type in \"Home\" to go to the "
        + "main menu"
        + "or \"Quit\" to quit the app: ");
  }

  /**
   * Prints the success message.
   */
  protected void printSuccessMsg() {
    System.out.println("✅ Success");
  }

  /**
   * Prints the error message, for the incorrect menu input.
   *
   * @param option given user input
   */
  protected void printNoSuchMenuOption(String option) {
    System.out.println(
        "⚠️ You typed in " + option + ". There is no such option in this menu. Please try again");
  }

  /**
   * Handles all the other input options besides the ones specified in this menu.
   *
   * @param input the input string
   * @param main  the instance of the main menu class
   * @return false if the input passed is not recognized
   * @throws SQLException if any of the operations with the database throw an error
   */
  protected boolean defaultInputHandler(String input, Menu main) throws SQLException {
    switch (input.toLowerCase()) {
      case "quit":
        this.exit();
      case "main":
        main.run();
      default:
        System.out.println("⚠️ You typed in \"" + input + "\". There is no such option in this "
            + "menu. "
            + "Please try again!");
        System.out.println();
        return false;
    }
  }

  /**
   * Exits the program
   */
  protected void exit() {
    System.out.println("See you soon!");
    System.exit(0);
  }


}
