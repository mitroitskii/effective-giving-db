package View;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Scanner;

public class Donation extends AbstractModification {

  private final String donorEmail;

  /**
   * Creates an instance of this class.
   *
   * @param conn open SQL database connection
   * @param in   open input Scanner
   */
  protected Donation(Connection conn, Scanner in, String donorEmail) {
    super(conn, in,
        "Donation",
        "donation",
        "getDonations()",
        1,
        "donation_id",
        new int[]{2, 3, 4, 5});
    this.donorEmail = donorEmail;
  }

  /*
  Helper method to check that given amount is a number > 0.
   */
  private boolean checkAmount(String amount) {
    try {
      int parsed = Integer.parseInt(amount);
      if (parsed > 0) {
        return true;
      }
    } catch (NumberFormatException ignore) {
    }
    System.out.println();
    System.out.println("❌ A donation amount should be a integer number larger than zero!");
    System.out.println();
    return false;
  }

  private void donate(String charityID) {

    // define participating variables
    String amount, donorID;
    PreparedStatement pstmt;

    // set up a query
    String query = "CALL addDonation(?, ?, ?)";

    // get input and execute a database operation
    while (true) {

      System.out.println();
      amount = this.promptWhileInputEmpty(this.in, "Type in the amount you want to donate: ");
      // check that the amount value is in proper format
      while (!this.checkAmount(amount)) {
        amount = this.promptWhileInputEmpty(this.in, "Type in the amount you want to donate: ");
      }

      try {
        query = "CALL getDonorId(?)";
        pstmt = conn.prepareStatement(query);
        pstmt.clearParameters();
        pstmt.setString(1, this.donorEmail);
        ResultSet rs = pstmt.executeQuery();
        rs.next();
        donorID = rs.getString(1);

        query = "CALL addDonation(?, ?, ?)";
        pstmt = conn.prepareStatement(query);
        pstmt.clearParameters();
        pstmt.setString(1, donorID);
        pstmt.setString(2, charityID);
        pstmt.setString(3, amount);

        pstmt.executeQuery();
        this.printSuccessMsg();
        this.printPreviousMenuMsg();
        // return from the function on success
        return;
      } catch (SQLException e) {
        this.printErrorMsg(e);
      }

    }

  }

  /*
  Helper method to get a list of charities filtered by evaluator.
   */
  private void byEvaluator() {

    // define participating variables
    String evaluatorID, charityID;

    while (true) {

      this.printSeparatorLine();
      System.out.println();

      try {

        // get the evaluator
        System.out.println("Pick the evaluator to get its rating of charities:");
        System.out.println();
        evaluatorID = this.promptTable("getEvaluators()", 1, new int[]{2, 3});

        System.out.println("Pick the charity to donate to:");
        System.out.println();
        String query = "getLastEvaluatedCharities(" + evaluatorID + ")";
        charityID = this.promptTable(query, 1, new int[]{2, 3, 4, 5});

        this.donate(charityID);
        return;

      } catch (SQLException e) {
        this.printErrorMsg(e);
      }
    }

  }

  /*
 Helper method to get a list of charities filtered by cause area.
  */
  private void byCause() {

    // define participating variables
    String causeID, charityID;

    while (true) {

      this.printSeparatorLine();
      System.out.println();

      try {

        // get the cause
        System.out.println("Pick the cause area the charity works in:");
        System.out.println();
        causeID = this.promptTable("getCauseAreas()", 1, new int[]{2});

        // get the charity
        System.out.println("Pick the charity to donate to:");
        System.out.println();
        String procedure = "getCharitiesFromCause(" + causeID + ")";
        charityID = this.promptTable(procedure, 1, new int[]{2, 3, 4});

        this.donate(charityID);
        return;

      } catch (SQLException e) {
        this.printErrorMsg(e);
      }
    }

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
      System.out.println("Pick how you want to filter the charities:");
      System.out.println();
      System.out.println(
          "1. By evaluator – get a list of top-rated charities, chosen by the specific evaluator");
      System.out.println(
          "2. By cause area – get a list of charities, working in a specific cause area");
      System.out.println();
      this.printStandardPrompt();

      // get the user input for this menu
      String input = in.nextLine();
      System.out.println();

      // process the input
      switch (input.toLowerCase()) {
        case "1":
          this.byEvaluator();
          continue;
        case "2":
          this.byCause();
          continue;
        default:
          // process the standard or incorrect input
          inputCorrect = this.checkStandardInputOptions(input, new Home(this.conn), this);
      }
    }
  }

  @Override
  protected void add() throws SQLException {
    // TODO add new donation here?
  }

  @Override
  /**
   * This method is not implemented for that class.
   */
  protected void update() throws SQLException {
    //FIXME refactor here
  }
}
