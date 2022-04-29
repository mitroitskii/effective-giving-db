package View;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.Scanner;

/**
 * Implements a set of shared menu methods.
 */
public abstract class AbstractMenu implements Menu {

  protected Connection conn;
  protected Scanner in;

  /**
   * Creates an instance of a menu and sets its state parameters.
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
    System.out.print("Choose the option and type in its number, type in \"Home\" to go to the "
        + "main menu "
        + "\"Back\" to go back to the previous menu"
        + "or \"Quit\" to quit the app: ");
  }

  /**
   * Prints a line to separate block of UI on screen.
   */
  protected void printSeparatorLine() {
    System.out.println("–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––");
  }

  /**
   * Prints the error message with the provided SQLException data.
   *
   * @param e SQLException
   */
  protected void printErrorMsg(SQLException e) {
    System.out.println();
    System.out.print("❌ Error executing this command with the database: ");
    System.out.println(e.getMessage() + " " + e.getSQLState() + " " + e.getErrorCode());
    System.out.println();
  }

  /**
   * Prints the error message, for the incorrect menu input.
   *
   * @param option given user input
   */
  protected void printNoSuchMenuOptionMsg(String option) {
    System.out.println(
        "⚠️ You typed in " + option + ". There is no such option in this menu. Please try again");
  }

  /**
   * Prints the message of going back to the previous menu.
   */
  protected void printPreviousMenuMsg() {
    System.out.println();
    System.out.println("⏮ Going back to the previous menu");
    System.out.println();
  }


  /**
   * Handles all the other input options besides the ones specified in this menu.
   *
   * @param input    the input string
   * @param main     the instance of the main menu class
   * @param previous the instance of the previous menu class
   * @return false if the input passed is not recognized
   * @throws SQLException if any of the operations with the database throw an error
   */
  protected boolean checkStandardInputOptions(String input, Menu main, Menu previous)
      throws SQLException {
    switch (input.toLowerCase()) {
      case "quit":
        this.exit();
      case "back":
        this.printPreviousMenuMsg();
        previous.run();
      case "home":
        main.run();
      default:
        System.out.println();
        this.printNoSuchMenuOptionMsg(input);
        System.out.println();
        return false;
    }
  }

  /**
   * Exits the program
   *
   * @throws SQLException if there is an error when closing the database connection
   */
  protected void exit() throws SQLException {
    // close database connection
    this.conn.close();
    // close scanner
    this.in.close();
    System.out.println();
    System.out.println("👋 See you soon!");
    // exit the program
    System.exit(0);
  }


}
