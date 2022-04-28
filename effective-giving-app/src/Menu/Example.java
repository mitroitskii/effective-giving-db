package Menu;

import App.State;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Scanner;

/**
 * Main application menu.
 */
public class Example {

  public static void run(State state) throws SQLException {

    Connection conn = state.getConnection();

    // initialize the input Scanner
    Scanner in = new Scanner(System.in);

    ResultSet rs = null;
    PreparedStatement pstmt = null;

    // the array to store the names of the characters from the db in
    ArrayList<String> names = new ArrayList<>();

    // Get the set of all character names and store in the array
    String query = "SELECT character_name FROM lotr_character;";
    pstmt = conn.prepareStatement(query);
    pstmt.clearParameters();
    rs = pstmt.executeQuery();
    while (rs.next()) {
      String name = rs.getString("character_name");
      names.add(name.toLowerCase());
    }
    pstmt.close();

    System.out.println();
    System.out.print("Type in the character name: ");
    String charName = in.nextLine();
    // checking that the character name exists in the array of names
    while (!names.contains(charName.toLowerCase())) {
      System.out.println("No such character in the database!");
      System.out.print("Type in the character name again: ");
      charName = in.nextLine();
    }
    System.out.println();

    // closing the scanner
    in.close();

    // Call the track_character SQL function
    query = "CALL track_character(?);";
    pstmt = conn.prepareStatement(query);
    pstmt.clearParameters();
    pstmt.setString(1, charName);
    rs = pstmt.executeQuery();
    System.out.println("Here are the the encounters of " + charName + ":");
    while (rs.next()) {
      String name = rs.getString("character_name");

      String region = rs.getString("region_name");
      String book = rs.getString("book");
      String enc = rs.getString("char_enc");
      // printing all the data in one line
      System.out.println(
          name + " encountered " + enc + " in region " + region + " in the book " + "\"" + book
              + "\"" + ";");
    }

    rs.close();
    pstmt.close();

    conn.close();

  }

}
