import ballerina/io;

public function main() {

    string firstName = "John";
    string lastName = "Doe";

    // Errors cannot be assigned to any
    any greet = constructGreet(firstName, lastName); 

    // Errors cannot be ignored
    _ = constructGreet(firstName, lastName);

}

//Functions can return errors
function constructGreet (string first, string last) returns string|error {
    if (first.length() < 2) {
        return error("Invalid length", length = first.length(), code = "E1001");
    }
    return string `Hello, ${first} ${last}!`;
}

// Errors can be passed as arguments to functions
function handleError(error e) {
    io:println(e.message());
    //..........
}

