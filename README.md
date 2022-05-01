# effective-giving-db

Preferred IDE: IntelliJ

### The following libraries/connectors/frameworks will be needed to run the files

* JDBC Connector:
    - Download the connector from here
    - Add it to the path of your project File > Project Structure > Modules > Dependencies > Add
      JAR/directory > select the downloaded .jar connector file > Apply > OK
* Java SDK 8
* An instance of a MySQL Server with an imported dump of the provided database.
    - The name of the database that the program expects is “effective_giving”

### Instructions:

1. Open the provided Java project with an IDE of your choice.
2. Set up two environment variables for the run configuration – USERNAME and PASSWORD with the
   values of the Username and the Password of your local MySQL Server
3. The entry point to the program is the main() method of the “App” Java Class.