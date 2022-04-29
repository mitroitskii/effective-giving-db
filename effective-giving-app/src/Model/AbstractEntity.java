package Model;

import java.util.ArrayList;

public class AbstractEntity implements Entity {

  ArrayList<AbstractColumn> columns;


  @Override
  public ArrayList<Column> getColumns() {
    return null;
  }


}
