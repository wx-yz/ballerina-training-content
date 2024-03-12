import ballerina/http;

listener http:Listener httpListener = new (9092);

service /demo on httpListener {
    resource function get greeting/hello() returns string {
        return "Hello, World! This is /demo/greeting/hello";
    }

    resource function get greeting/hi() returns string {
        return "Hello, World! This is /demo/greeting/hi";
    }
}

service /test on httpListener {

    resource function get greeting() returns string {
        return "Hello, World! This is /test/greeting";
    }
}

service on httpListener {

    resource function get greeting() returns string {
        return "Hello, World! This is /greeting";
    }
}
