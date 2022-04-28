package Menu;

import java.sql.SQLException;

public interface Menu {

  /**
   * Runs this menu's sequence.
   *
   * @throws SQLException if any of the database operations do not go correctly
   */
  void run() throws SQLException;

}
