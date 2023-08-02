import ballerinax/java.jdbc;
import ballerina/sql;
import ballerina/http;
import ballerinax/h2.driver as _;

# Represents the configuration of the h2 database
#
# + user - The user of the database  
# + password - The password of the database  
# + dbName - The file path of the database
public type H2dbConfigs record {|
    string user;
    string password;
    string dbName;
|};

# Represents the conference database client
public isolated client class ConferenceDBClient {

    private final jdbc:Client conferenceJDBCClient;
    private final http:Client countryClient;

    public isolated function init(H2dbConfigs dbConfigs, string countryServiceUrl)
            returns error? {

        self.conferenceJDBCClient = check new (
            "jdbc:h2:mem:" + dbConfigs.dbName,
            dbConfigs.user,
            dbConfigs.password
        );
        self.countryClient = check new (countryServiceUrl,
            retryConfig = {
                count: 3,
                interval: 2
            }
        );
        // Reinitialize table
        check self.dropTable();
        check self.createTable();
    }

    # Create the conference table in the database
    #
    # + return - returns an error if the table creation fails
    isolated function createTable() returns error? {
        _ = check self.conferenceJDBCClient->execute(
            `CREATE TABLE conferences (
                id INT AUTO_INCREMENT PRIMARY KEY, 
                name VARCHAR(255))`
        );
    }

    # Drop the conference table in the database
    #
    # + return - returns an error if the table drop fails
    isolated function dropTable() returns error? {
        _ = check self.conferenceJDBCClient->execute(
            `DROP TABLE IF EXISTS conferences`);
    }

    # Retrieve all the conferences from the database
    #
    # + return - retruns an array of conferences or
    # an error if the retrieval fails
    isolated resource function get conferences()
            returns Conference[]|error {

        stream<Conference, sql:Error?> conferences = self.conferenceJDBCClient->query(
            `SELECT * FROM conferences`);
        return from Conference conference in conferences
            select conference;
    }

    # Create a conference in the database
    #
    # + conference - The conference to be created
    # + return - returns an error if the conference creation fails
    isolated resource function post conferences(ConferenceRequest conference)
            returns error? {

        _ = check self.conferenceJDBCClient->execute(
            `INSERT INTO conferences (name) VALUES (${conference.name})`);
    }

    # Retrieve all the conferences with the country from the database
    #
    # + return - retruns an array of extended conferences 
    # or an error if the retrieval fails
    isolated resource function get conferenceswithcountry()
            returns ExtendedConference[]|error {

        Conference[] conferences = check self->/conferences;
        return from Conference conference in conferences
            select {
                name: conference.name,
                country: check self.getCountry(conference.name)
            };
    }

    # Retrieve the country of a conference by calling the country service
    #
    # + conference - The conference name
    # + return - retruns the country of the conference 
    # or an error if the retrieval fails
    isolated function getCountry(string conference)
            returns string|error {

        Country country = check self.countryClient->/conferences/[conference]/country;
        return country.name;
    }
}
