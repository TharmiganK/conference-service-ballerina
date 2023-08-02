import ballerina/http;

# Represents a Error Detail
#
# + message - The message of the error
# + cause - The cause of the error
public type ErrorDetail record {|
    string message;
    string cause;
|};

# Represents a Internal Server Error Response
#
# + body - The body of the response
public type ConferenceServerError record {|
    *http:InternalServerError;
    ErrorDetail body;
|};
