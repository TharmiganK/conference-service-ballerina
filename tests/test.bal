import ballerina/http;
import ballerina/test;

final http:Client conferenceClient = check new (string `http://localhost:${conferenceServicePort}`);

@test:Config {}
function test() returns error? {
    http:Response response = check conferenceClient->/conferences.post(
        {
            name: "WSO2Con"
        }
    );
    test:assertEquals(response.statusCode, 201, "Status code should be 201");

    Conference[] conferences = check conferenceClient->/conferences;
    test:assertEquals(conferences.length(), 1, "Conference count should be 1");
    test:assertEquals(conferences[0].name, "WSO2Con", "Conference name should be WSO2Con");
}
