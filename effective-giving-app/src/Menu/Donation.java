package Menu;

import App.State;
import java.sql.SQLException;
import org.jetbrains.annotations.NotNull;

public class Donation extends AbstractMenu {

  @Override
  public void run(@NotNull State state) throws SQLException {

  }

  // TODO add info from DonatePrompt
  // DonatePrompt(charity id)
  // → IncorrectInputException("⚠️ A donation amount should be a integer number larger than zero")
  // - “Type in the amount you want to donate `[Amount Donation]`"
  // - [ ]  `addDonation(charity id, amount)`
}
