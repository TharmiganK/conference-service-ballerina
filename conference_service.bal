import ballerina/http;
import ballerina/mime;

configurable string countryServiceUrl = ?;
configurable H2dbConfigs dbConfigs = ?;

service class ConferenceService {
    *http:Service;
    final ConferenceDBClient conferenceDBClient;

    isolated function init() returns error? {
        self.conferenceDBClient = check new (dbConfigs, countryServiceUrl);
    }

    @http:ResourceConfig {produces: [mime:APPLICATION_JSON]}
    isolated resource function get conferences()
            returns Conference[]|ConferenceServerError {

        do {
            return check self.conferenceDBClient->/conferences;
        } on fail error err {
            return {
                body: {
                    message: "Error occurred while retrieving conferences",
                    cause: err.message()
                }
            };
        }
    }

    @http:ResourceConfig {consumes: [mime:APPLICATION_JSON]}
    isolated resource function post conferences(ConferenceRequest conference)
            returns ConferenceServerError? {

        do {
            return check self.conferenceDBClient->/conferences.post(conference);
        } on fail error err {
            return {
                body: {
                    message: "Error occurred while creating conference",
                    cause: err.message()
                }
            };
        }
    }

    @http:ResourceConfig {produces: [mime:APPLICATION_JSON]}
    isolated resource function get conferenceswithcountry()
            returns ExtendedConference[]|ConferenceServerError {

        do {
            return check self.conferenceDBClient->/conferenceswithcountry;
        } on fail error err {
            return {
                body: {
                    message: "Error occurred while retrieving conferences with country",
                    cause: err.message()
                }
            };
        }
    }
}
