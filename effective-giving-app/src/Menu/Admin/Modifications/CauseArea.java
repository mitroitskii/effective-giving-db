package Menu.Admin.Modifications;

import Menu.Home;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Scanner;

/**
 * Represents the Cause Area modification menu for the admin.
 */
public class CauseArea extends AbstractModification {

  /**
   * Creates an instance of this class.
   *
   * @param conn open SQL database connection
   * @param in   open input Scanner
   */
  public CauseArea(Connection conn, Scanner in) {
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
          this.add();
        case "2":
          this.update();
        case "3":
          this.delete();
        default:
          // process the standard or incorrect input
          inputCorrect = this.defaultInputHandler(input, new Home(this.conn),
              new MainModifications(this.conn,
                  this.in));
      }
    }
  }

  @Override
  protected void add() throws SQLException {

  }

  protected void update() throws SQLException {
    String input = this.in.nextLine();
    // init marker to check if the input is correct
    boolean inputCorrect = false;
    switch (input.toLowerCase()) {
      case "1":
        this.update();
      case "2":
      case "3":
      default:
        // process the standard or incorrect input
        inputCorrect = this.defaultInputHandler(input, new Home(this.conn),
            new MainModifications(this.conn,
                this.in));
    }
  }

  @Override
  protected void delete() throws SQLException {

  }

}
