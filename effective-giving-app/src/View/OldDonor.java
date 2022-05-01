package View;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Scanner;

public class OldDonor extends AbstractModification {

  String donorEmail;

  /**
   * Creates an instance of a menu and sets its state parameters.
   *
   * @param conn open SQL database connection
   * @param in   open input Scanner
   */
  protected OldDonor(Connection conn, Scanner in) {
    super(conn, in,
        "Donor",
        "donor",
        1,
        "donor_id",
        new int[]{2, 3, 4, 5, 6, 7});
  }

  // TODO method to check donor existence

  /*
  Helper method to check the existence of the donor
   */
  private void checkDonor() {
    // define participating variables
    String email;
    PreparedStatement pstmt;
    ResultSet rs;

    // set up a query
    String query = "SELECT * FROM donor WHERE email = ?";

    while (true) {

      this.printSeparatorLine();
      System.out.println();
      email = this.promptWhileInputEmpty(
          this.in, "📫 What is your email?: ");

      try {
        pstmt = conn.prepareStatement(query);
        pstmt.clearParameters();
        pstmt.setString(1, email);
        rs = pstmt.executeQuery();
        // move cursor to the first line
        rs.next();

        System.out.println("✌️ Hello, " + rs.getString(2) + rs.getString(3));
        this.donorEmail = rs.getString(4);

        // TODO check user existence;
        // get email from donor class getID method??

        // return from the function on success
        return;
      } catch (SQLException e) {
        this.printErrorMsg(e);
      }
    }
  }

  @Override
  public void run() throws SQLException {
    this.checkDonor();
  }

  @Override
  /**
   * This method is not implemented for that class.
   */
  protected void add() throws SQLException {
    //FIXME refactor here
  }

  @Override
  /**
   * This method is not implemented for that class.
   */
  protected void update() throws SQLException {
    //FIXME refactor here
  }

  @Override
  /**
   * This method is not implemented for that class.
   */
  protected void delete() throws SQLException {
    //FIXME refactor here
  }
}
