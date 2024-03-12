import ballerina/log;

const INVALID_USERNAME = "InvalidUsername";
const INVALID_PASSWORD = "InvalidPassword";

// Note how we have used `distinct`.
// TODO: Remove `distinct` and see how the code behaves.
type InvalidUsernameError distinct error<record {|string message;|}>;

type InvalidPasswordError distinct error<record {|string message;|}>;

function validateUser(string username, string password) returns InvalidUsernameError|InvalidPasswordError? {
    if username.length() < 6 {
        return error InvalidUsernameError(INVALID_USERNAME,
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

    if res is error {
        if res is InvalidUsernameError {
            log:printError(string `username validation failed : ${res.message()}`);
        } else {
            log:printError(string `password validation failed : ${res.message()}`);
        }
    }
}

public function main() {
    validate("mary", "pass");
    validate(" ", "123");
    validate("Richardson", "pass 123");
}
