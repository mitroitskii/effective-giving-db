package Menu;

import App.State;
import java.sql.SQLException;
import org.jetbrains.annotations.NotNull;

public interface Menu {

  /**
   * Runs this menu's sequence.
   *
   * @param state is a current application state passed from the previous calling menu
   * @throws SQLException if any of the database operations do not go correctly
   */
  void run(@NotNull State state) throws SQLException;

}
