package App;

import java.sql.Connection;
import java.util.Scanner;


/**
 * Stores the state of the application.
 **/
public class State {

  private Connection connection;
  private int currentDonorID;
  private Scanner in;

  /**
   * Returns this application's connection object.
   *
   * @return this application's connection object.
   */
  public Connection getConnection() {
    return connection;
  }

  /**
   * Sets up this application's connection object.
   */
  public void setConnection(Connection connection) {
    this.connection = connection;
  }

  /**
   * Returns the current donor id.
   *
   * @return the current donor id
   */
  public int getCurrentDonorID() {
    return currentDonorID;
  }

  /**
   * Sets up the current donor id.
   */
  public void setCurrentDonorID(int currentDonorID) {
    this.currentDonorID = currentDonorID;
  }

  /**
   * Returns the current input scanner.
   *
   * @return the current input scanner
   */
  public Scanner getScanner() {
    return in;
  }

  /**
   * Sets up the current input scanner.
   */
  public void setScanner(Scanner in) {
    this.in = in;
  }
}
