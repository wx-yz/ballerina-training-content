import ballerina/log;

const INVALID_USERNAME = "InvalidUsername";
const INVALID_PASSWORD = "InvalidPassword";

type InvalidUsernameError distinct error<record {|string message;|}>;

type InvalidUsernameLengthError distinct InvalidUsernameError;

type InvalidPasswordError distinct error<record {|string message;|}>;

function validateUser(string username, string password) returns error? {
    if username.length() < 6 {
        return error InvalidUsernameLengthError(INVALID_USERNAME,
                                        message = "invalid length");
    }

    if username.indexOf(" ") !is () {
        return error InvalidUsernameError(INVALID_USERNAME,
                                        message = "contains spaces");
    }

    if password.indexOf(" ") !is () {
        return error InvalidPasswordError(INVALID_PASSWORD,
                                        message = "contains spaces");
    }
}

function validate(string username, string password) {
    error? res = validateUser(username, password);

    // TODO: Swap if conditions to see how it behaves.
    if res is error {
        if res is InvalidUsernameLengthError {
            log:printError(string `username validation failed : ${res.message()}`);
        } else if res is InvalidUsernameError {
            log:printError(string `username length validation failed : ${res.message()}`);
        } else {
            log:printError(string `password validation failed : ${res.message()}`);
        }
    }
}

public function main() {
    validate("mary", "pass");
    validate("mar y ", "123");
    validate("Richardson", "pass 123");
}

// Because InvalidUsernameLengthError is a subtype of InvalidUsernameError, we need to check for 
// InvalidUsernameLengthError before checking for InvalidUsernameError, since is InvalidUsernameError 
// will evaluate to true for an InvalidUsernameLengthError error value also.
