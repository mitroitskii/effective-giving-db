package Model;

import java.util.ArrayList;

public interface Entity {

  static ArrayList<Entity> getAll() {
    return null;
  }

  static void add() {
  }

  ArrayList<Column> getColumns();
}
