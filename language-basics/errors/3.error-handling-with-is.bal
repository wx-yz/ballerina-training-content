import ballerina/log;

public function main() {
    string firstName = "John";
    string lastName = "Doe";
    registerUser(firstName, lastName);
}

//Use `is` to check if the return value is an error.
function registerUser (string first, string last) {
    string|error greeting = constructGreet(first, last);

    if greeting is error { //narrow the type to error
        log:printError("Error occurred: ", greeting);
    } else {
        string s = greeting;
        // Add the user registering logic here.
    }
}

function constructGreet (string first, string last) returns string|error {
    if (first.length() < 2) {
        return error("Invalid length", length = first.length(), code = "E1001");
    }
    return string `Hello, ${first} ${last}!`;
}

