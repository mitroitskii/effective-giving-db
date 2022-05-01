package View;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.Scanner;

/**
 * Represents the New Donor menu.
 */
public class NewDonor extends AbstractModification {

  /**
   * Creates an instance of New Donor menu.
   *
   * @param conn open SQL database connection
   * @param in   open input Scanner
   */
  public NewDonor(Connection conn, Scanner in) {
    super(conn, in,
        "Donor",
        "donor",
        1,
        "donor_id",
        new int[]{2, 3, 4, 5, 6, 7});
  }

  /*
  Helper method
   */
  private boolean checkRank(String income) {
    try {
      Integer.parseInt(income);
      return true;
    } catch (NumberFormatException e) {
      return false;
    }
  }

  @Override
  protected void add() throws SQLException {

    this.printSeparatorLine();
    System.out.println();
    System.out.println("Let us register you in the system.");

    // define participating variables
    String firstName, lastName, email, countryID, sourceID, rank;
    PreparedStatement pstmt;

    // set up a query
    String query = "INSERT INTO donor (first_name, last_name, email, "
        + "donor_country, source, income_rank) "
        + "value(?, ?, ?, ?, ?, ?)";

    // get input and execute a database operation
    while (true) {

      // get first name
      firstName = this.promptWhileInputEmpty(this.in, "1️⃣ What is your first name?: ");

      // get last name
      lastName = this.promptWhileInputEmpty(this.in, "2️⃣ What is your last name?: ");

      // get email
      email = this.promptWhileInputEmpty(this.in, "3️⃣ What is your email?: ");
      // TODO MYSQL DUPLICATE CHECK

      // get country
      System.out.println("4️⃣ What is your country of residence?");
      countryID = this.promptTable("country", 1, new int[]{2});

      // get source
      System.out.println("5️⃣ How did you learn about us?");
      sourceID = this.promptTable("source", 1, new int[]{2});

      // get income rate
      rank = this.promptWhileInputEmpty(this.in,
          "6️⃣ What is your average annual income? (This data is not stored on our servers, "
              + "but will allow you to compare yourself against global income rates): ");
      // check that the income input is a number
      while (!rank.isEmpty() && !this.checkRank(rank)) {
        rank = this.promptWhileInputEmpty(this.in,
            "6️⃣ What is your average annual income? (This data is not stored on our servers, "
                + "but will allow you to compare yourself against global income rates): ");
      }
      // TODO run income rank fetch function
//      System.out.println(
//          "6️⃣ What is your average annual income? (This data is not stored on our servers, "
//              + "but will allow you to compare yourself against global income rates):");
      // TODO make a method in this class for that

      try {
        pstmt = conn.prepareStatement(query);
        pstmt.clearParameters();
        pstmt.setString(1, firstName);
        pstmt.setString(2, lastName);
        pstmt.setString(3, email);
        pstmt.setString(4, countryID);
        pstmt.setString(5, sourceID);
        pstmt.setString(6, rank);
        pstmt.executeUpdate();

        this.printSuccessMsg();
        this.printPreviousMenuMsg();

        // return from the function on success
        return;
      } catch (SQLException e) {
        this.printErrorMsg(e);
      }
    }

  }

  @Override
  /**
   * This method is not implemented for that class.
   */
  protected void delete() throws SQLException {
    //FIXME refactor here
  }

  @Override
  /**
   * This method is not implemented for that class.
   */
  protected void update() {
    //FIXME refactor here
  }

}