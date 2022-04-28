package Menu;

import App.State;
import java.sql.SQLException;
import java.util.Scanner;
import org.jetbrains.annotations.NotNull;

/**
 * Represents the main application menu.
 */
public class Main extends AbstractMenu {


  @Override
  void printStandardPrompt() {
    System.out.print("Choose the option and type in its number, or type in "
        + "\"Quit\" to quit the app: ");
  }

  public void run(@NotNull State state) throws SQLException {

    // initialize the input Scanner and sets its value to the state
    Scanner in = new Scanner(System.in);
    state.setScanner(in);

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
          inputCorrect = true;
        case "2":
          inputCorrect = true;
        case "3":
          inputCorrect = true;
        default:
          inputCorrect = this.defaultInputHandler(input, state, new Main());
      }
    }

  }

}
