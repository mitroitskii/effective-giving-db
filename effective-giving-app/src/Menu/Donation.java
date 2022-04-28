package Menu;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.Scanner;

public class Donation extends AbstractMenu {

  /**
   * Creates an instance of this class.
   *
   * @param conn open SQL database connection
   * @param in   open input Scanner
   */
  protected Donation(Connection conn, Scanner in) {
    super(conn, in);
  }

  @Override
  public void run() throws SQLException {

  }

  // TODO add info from DonatePrompt
  // DonatePrompt(charity id)
  // → IncorrectInputException("⚠️ A donation amount should be a integer number larger than zero")
  // - “Type in the amount you want to donate `[Amount Donation]`"
  // - [ ]  `addDonation(charity id, amount)`
}
