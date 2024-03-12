import ballerina/http;
import ballerina/udp;
import ballerina/io;
service on new http:Listener(9090) {
    resource function get greeting() returns string {
        return "Hello, World!";

    }
}

// HTTP Listener declaration and service declaration are separated
listener http:Listener httpListener = new (9092);

service on httpListener {
    resource function get greeting() returns string {
        return "Hello, World!";

    }

}

// UDP Service
service on new udp:Listener(8080) {
    remote function onDatagram(readonly & udp:Datagram dg) {
        io:println("Received: ", dg.data);
    }
}
