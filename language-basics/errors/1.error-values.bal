import ballerina/io;
import ballerina/lang.value;

public function main() {

    string username = "jo";
    // error with message.
    error e1 = error("Invalid length");

    // error with message and two detail fields, no cause.
    error e2 = error("Invalid length", length = username.length(), code = "E1001");
    
    // error with message, cause and detail fields.
    error e3 = error(string `Invalid username: ${username}`, e2, code = "E2001");

    // Access and print the message of `e1`.
    string message = e1.message();
    io:println(message); // Invalid ength

    // Access the cause of `e1`.
    error? cause = e1.cause();
    // Since a cause wasn't specified, `cause` will be nil.
    io:println(cause is ()); // true

    // Access the detail mapping of `e2`.
    map<value:Cloneable> & readonly detail = e2.detail();
    io:println(detail.length()); // 2
    io:println(detail["code"]); // E1001

    // Access the cause of `e3`.
    error? errorCause = e3.cause();
    // Since `e2` was specified as the cause, `cause` will be `e2`.
    io:println(errorCause); // error("Invalid length",length=2, code="E1001")
    io:println(errorCause === e2); // true
}
