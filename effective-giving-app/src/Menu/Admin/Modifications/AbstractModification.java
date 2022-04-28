package Menu.Admin.Modifications;

import Menu.AbstractMenu;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Scanner;

public abstract class AbstractModification extends AbstractMenu {

  protected AbstractModification(Connection conn, Scanner in) {
    super(conn, in);
  }

  @Override
  protected void printStandardPrompt() {
    System.out.print("Type in \"Home\" to go to the "
        + "main menu"
        + "\"Back\" to go back to the previous menu"
        + "or \"Quit\" to quit the app: ");
  }

  /**
   * Add new data to the database.
   */
  protected abstract void add() throws SQLException;

  /**
   * Change existing data in the database.
   */
  protected abstract void update() throws SQLException;

  /**
   * Delete data from the database.
   */
  protected abstract void delete() throws SQLException;

}
