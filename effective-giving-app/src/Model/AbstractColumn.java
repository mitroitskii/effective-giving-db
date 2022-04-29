package Model;

public class AbstractColumn implements Column {

  int number;
  String name;
  boolean updatable;
  boolean printable;
  String value;

  public int getNumber() {
    return number;
  }

  public String getName() {
    return name;
  }

  public boolean isUpdatable() {
    return updatable;
  }

  public boolean isPrintable() {
    return printable;
  }

  public String getValue() {
    return value;
  }

  public void setValue(String value) {
    this.value = value;
  }
}
