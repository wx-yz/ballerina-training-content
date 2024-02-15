import ballerina/http;

service /rooms on new http:Listener(8080) {
    resource function get availability(string roomtype, int count) returns error|boolean {
        if roomtype == "single" || roomtype == "double" || roomtype == "queen" {
            if count < 1 {
                return error("Invalid count");
            } else if count < 5 {
                return true;
            } else {
                return false;
            }
        } else {
            return error("Invalid room type");
        }
    }
}
