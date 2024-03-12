import ballerina/http;

listener http:Listener httpListener = new (9092);

service /demo on httpListener {
    resource function get hello/[string name]() returns string {
        return "Hi , " + name;
    }

    resource function get hello(string name) returns string {
        return "Hello  , " + name;
    }
}
