import ballerina/log;
import ballerina/http;
import ballerina/lang.runtime;

configurable int conferenceServicePort = ?;

public function main() returns error? {
    http:Listener conferenceListener = check new (conferenceServicePort);
    log:printInfo("Starting the listener...");
    // Attach the service to the listener.
    check conferenceListener.attach(check new ConferenceService());
    // Start the listener.
    check conferenceListener.'start();
    // Register the listener dynamically.
    runtime:registerListener(conferenceListener);
    log:printInfo("Startup completed. " +  
        string`Listening on: http://localhost:${conferenceServicePort}`);
}
