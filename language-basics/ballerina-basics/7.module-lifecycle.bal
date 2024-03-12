import ballerina/http;
import ballerina/io;

string host = "localhost";
listener http:Listener httpListener = new (9092);

service /foo on httpListener {

    resource function get bar() returns string {
        return "Hello, World!";
    }
}

function init() {
    io:println("Host:"\
    , host);
}

public function main() {
    io:println("This is the main function.");
}
