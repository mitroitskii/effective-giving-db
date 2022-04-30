package View;

import View.Admin.Modifications.MainModifications;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Objects;
import java.util.Scanner;

/**
 * Implements and declares a set of shared modification menu methods.
 */
public abstract class AbstractModification extends AbstractMenu {

  // a name of the type of the modified entity
  protected String entityName;
  // a name of the table
  protected String tableName;
  // a name of the table
  protected int idColNum;
  // a name of the table
  protected String idColName;
  // a name of the table
  protected int[] colsToPrint;

  /**
   * Creates an instance of modification menu class and sets its state parameters.
   *
   * @param conn        open SQL database connection
   * @param in          open input Scanner
   * @param entityName  the name of the entity this menu modifies
   * @param tableName   the table name in the database, where these entities are stored
   * @param idColNum    the number of the column where the id of the entity is
   * @param idColName   the name of the column where the id of the entity is
   * @param colsToPrint the array with the numbers of columns to print as a table
   */
  protected AbstractModification(Connection conn, Scanner in, String entityName, String tableName
      , int idColNum, String idColName, int[] colsToPrint) {
    super(conn, in);
    this.entityName = entityName;
    this.tableName = tableName;
    this.idColNum = idColNum;
    this.idColName = idColName;
    this.colsToPrint = colsToPrint;
  }

  @Override
  public void run() throws SQLException {

    // init marker to check if the input is correct
    boolean inputCorrect = false;

    // repeat this menu prompt until the input is recognized
    while (!inputCorrect) {
      // print the menu options
      this.printSeparatorLine();
      System.out.println();
      System.out.println("1. Add " + this.entityName);
      System.out.println("2. Change existing " + this.entityName);
      System.out.println("3. Delete existing " + this.entityName);
      System.out.println();
      this.printStandardPrompt();

      // get the user input for this menu
      String input = this.in.nextLine();
      System.out.println();

      // process the input
      switch (input.toLowerCase()) {
        case "1":
          this.add();
          continue;
        case "2":
          this.update();
          continue;
        case "3":
          this.delete();
          continue;
        default:
          // process the standard or incorrect input
          inputCorrect = this.checkStandardInputOptions(input, new Home(this.conn),
              new MainModifications(this.conn,
                  this.in));
      }
    }

  }

  /**
   * Prints the success message.
   */
  protected void printSuccessMsg() {
    System.out.println();
    System.out.println("✅ Success");
  }

  /**
   * Prints the current value of field. If the value is null, prints "empty".
   *
   * @param fieldName the name of the field
   * @param curVal    current value of the field
   */
  protected void printCurrentValue(String fieldName, String curVal) {
    System.out.println();
    System.out.println(
        "⚫️ The current " + fieldName + " of this " + this.entityName + " is \"" +
            // if the value is null, print "empty"
            (Objects.isNull(curVal) ? "empty" : curVal)
            + "\"");
  }

  /**
   * Prompts for the updated value of the given field until given non-empty input.
   *
   * @param in        open input scanner
   * @param fieldName the name of the field
   * @return the value of the input
   */
  protected String promptUpdateWhileEmpty(Scanner in, String fieldName) {
    return this.promptWhileInputEmpty(in,
        "❓ What is the new " + fieldName + " of the " + this.entityName +
            "?: ");
  }

  /**
   * Prompts for the updated value of the given field.
   *
   * @param in        open input scanner
   * @param fieldName the name of the field
   * @return the value of the input
   */
  protected String promptUpdate(Scanner in, String fieldName) {
    String prompt = "❓ What is the new " + fieldName + " of the " + this.entityName +
        "?: ";
    System.out.println();
    System.out.print(prompt);
    return in.nextLine();
  }

  /**
   * Prompts for the value of the given field until given non-empty input.
   *
   * @param in        open input scanner
   * @param fieldName the name of the field
   * @return the value of the input
   */
  protected String promptAddWhileEmpty(Scanner in, String fieldName) {
    System.out.println();
    return this.promptWhileInputEmpty(in,
        "❓ What is the " + fieldName + " of the " + this.entityName +
            "?: ");
  }

  /**
   * Prompts for the value of the given field.
   *
   * @param in        open input scanner
   * @param fieldName the name of the field
   * @return the value of the input
   */
  protected String promptAdd(Scanner in, String fieldName) {
    System.out.println();
    String prompt = "❓ What is the " + fieldName + " of the " + this.entityName +
        "?: ";
    System.out.println();
    System.out.print(prompt);
    return in.nextLine();
  }

  // TODO CREATE A METHOD TO RUN DUPLICATE CHECK IN A LOOP UNTIL RETURN ** STRING **
  // if ()
  // String name = promptWhileDuplicate(this.in, this.promptUpdateWhileEmpty(this.in,
  // "name", oldName)
  //      -- check that oldName != name, only after that call dupcheck procedure
  // ,,
  //                ⚠️ FUNCTION NAME FOR THE QUERY))

  /**
   * Prompts the user to provide input and checks that the input is not empty.
   *
   * @param in     the input scanner
   * @param prompt text, asking for the user input
   * @return non-empty input string
   */
  private String promptWhileInputEmpty(Scanner in, String prompt) {
    System.out.print(prompt);
    String input = in.nextLine();
    while (input.isEmpty()) {
      System.out.println();
      System.out.println("❌ The input cannot be empty. Try again");
      System.out.println();
      System.out.print(prompt);
      input = in.nextLine();
    }
    return input;
  }

  /**
   * Prints a table of all values of this entity and prompts user to choose one of the rows. Returns
   * the value the user have chosen or -1 if there was an error reading the table.
   *
   * @param tableName the name of the table to print
   * @param idCol     number of the column, where the entity's id is stored
   * @param cols      an array of numbers of columns to print
   * @return the string value of the number of the rows chosen
   * @throws SQLException if there is an error when running standard menu commands
   */
  // TODO switch table name into procedure name to query resuts !!!
  // - use Ayeshas fetch procedures
  protected String promptTable(String tableName, int idCol, int[] cols) throws SQLException {
// we store the width of each row
    HashMap<Integer, Integer> colWidths = new HashMap<>();
    // we store the id of each row
    ArrayList<String> ids = new ArrayList<>();
    // we store the values for each row in a hashmap, where the column is the key and the cell
    // text is a value
    ArrayList<HashMap<Integer, String>> rows = new ArrayList<>();

    // initialize a result set
    ResultSet rs;
    String query = "SELECT * FROM " + tableName;

    try {
      PreparedStatement pstmt = conn.prepareStatement(query);
      pstmt.clearParameters();
      rs = pstmt.executeQuery();

      // get all the rows and row widths
      while (rs.next()) {
        // instantiate a hashmap for this row
        HashMap<Integer, String> row = new HashMap<>();
        // add the id of the tuple in this row to a list of ids
        String id = rs.getString(idCol);
        ids.add(id);
        for (Integer col : cols) {
          // get value of this row in this column and add to a hashmap in the list of rows
          String val = rs.getString(col);
          // if the cell is null, we store the string "empty" as its value
          row.put(col, Objects.isNull(val) ? "empty" : val);
          // fetching the length of the string in the current cell
          int valLength = Objects.isNull(val) ? 5 : val.length();
          // replacing a column width value with the length of the current cell
          // if it's larger than the old value or the width of the header
          colWidths.put(col,
              colWidths.getOrDefault(col,
                  rs.getMetaData().getColumnName(col).length()) > valLength ?
                  colWidths.getOrDefault(col, rs.getMetaData().getColumnName(col).length())
                  : valLength);
        }
        // add row to the list of rows
        rows.add(row);
      }
    } catch (SQLException e) {
      // if getting all the rows of the table throws an exception, we print an error and return
      // to the previous menu
      this.printErrorMsg(e);
      this.run();
      return "-1";
    }

    // get an id of the element chosen by the user
    String id;

    while (true) {

      // line separator
      this.printSeparatorLine();
      System.out.println();

      // print header

      // create a space for the row numeration
      // print as many spaces as there are digits in the largest numeration number
      int spaces = ("" + rows.size()).length() + 2;
      System.out.format("%" + spaces + "s", " ");
      System.out.print("|");
      for (Integer col : cols) {
        System.out.format(
            // set up a format string based on the width of this column
            // the text in each column is left-justified
            "  %-" + colWidths.get(col) + "s  |",
            // get the name of this column and print it upper-cased
            rs.getMetaData().getColumnName(col).toUpperCase());
      }

      // add newline
      System.out.println();

      // print rows
      for (int i = 0; i < rows.size(); i++) {
        // print the row number (i + 1, since array index starts with 0)
        System.out.format("%" + spaces + "s", i + 1 + ".");
        System.out.print("|");
        for (Integer col : cols) {
          System.out.format(
              // set up a format string based on the width of this column
              // the text in each column is left-justified
              "  %-" + colWidths.get(col) + "s  |",
              // get the value of the row in this column
              rows.get(i).get(col)
          );
        }
        // add newline to put row item onto the new line
        System.out.println();
      }

      // add newline
      System.out.println();

      // print standard prompt to choose the option
      this.printStandardPrompt();

      // get the user input for this menu
      String input = in.nextLine();
      System.out.println();
      int number = -1;

      try {
        // get id input
        number = Integer.parseInt(input) - 1;
      } catch (NumberFormatException e) {
        // we either process an incorrect input and continue in the loop, or invoke one of the
        // standard input commands
        // (exit, main, back, etc)
        this.checkStandardInputOptions(input,
            new MainModifications(this.conn, this.in),
            this);
        continue;
      }

      // get the id of the row with the given number
      try {
        id = ids.get(number);
        break;
      }
      // if there is row with the given number, we output an error and continue the loop
      catch (IndexOutOfBoundsException e) {
        System.out.println("❌ There is no row with the given number! Try again.");
        System.out.println();
      }
    }

    return id;
  }

  /**
   * Set the value of the parameter of the prepared statement to a provided string. If the string is
   * empty, sets the value to null.
   *
   * @param pstmt          prepared statement
   * @param paremeterIndex index of the parameter to set
   * @param value          value to set
   * @param SQLType        the SQL type code defined in java.sql.Types
   * @throws SQLException if there is an error with the database
   */
  protected void setStringOrNull(PreparedStatement pstmt, int paremeterIndex, String value,
      int SQLType)
      throws SQLException {
    if (value.isEmpty()) {
      pstmt.setNull(paremeterIndex, SQLType);
    } else {
      pstmt.setString(paremeterIndex, value);
    }
  }

  /**
   * Adds new entity of this type to the database.
   */
  protected abstract void add() throws SQLException;

  /**
   * Changes existing entity of this type in the database.
   */
  protected abstract void update() throws SQLException;

  /**
   * Deletes an entity of this type from the database.
   */
  protected void delete() throws SQLException {

    // loop until the item is correctly deleted
    while (true) {

      System.out.println("Pick the item to delete:");
      System.out.println();

      // print the table of values and get the id of the value to delete
      String id = this.promptTable(this.tableName, this.idColNum, this.colsToPrint);

      // define participating variables
      PreparedStatement pstmt;
      String query = "DELETE FROM " + this.tableName + " WHERE " + this.idColName + " = ?";

      try {

        // set up delete query
        pstmt = conn.prepareStatement(query);
        pstmt.clearParameters();
        pstmt.setString(1, id);

        // run the delete query
        pstmt.executeUpdate();

        // success
        this.printSuccessMsg();
        this.printPreviousMenuMsg();
        break;
      } catch (SQLException e) {
        this.printErrorMsg(e);
      }
    }

  }

}
