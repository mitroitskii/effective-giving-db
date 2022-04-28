package Menu;

import App.State;
import java.sql.SQLException;

/**
 * Implements a set of shared menu methods.
 */
public abstract class AbstractMenu implements Menu {

  /**
   * Prints the standard choose your option prompt.
   */
  protected void printStandardPrompt() {
    System.out.print("Choose the option and type in its number, or type in \"Main\" to go to the "
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
   * @param state the state to pass in to the main menu
   * @param main  the instance of the main menu class
   * @return false if the input passed is not recognized
   * @throws SQLException if any of the operations with the database throw an error
   */
  protected boolean defaultInputHandler(String input, State state, Menu main) throws SQLException {
    switch (input.toLowerCase()) {
      case "quit":
        this.exit();
      case "main":
        main.run(state);
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
