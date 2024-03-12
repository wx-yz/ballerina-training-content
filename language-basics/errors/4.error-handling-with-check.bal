import ballerina/io;

map<int> results = {
    "Tom": 83,
    "Jack": 34
};

function get(string name) returns int|error {
    if results.hasKey(name) {
        return results.get(name);
    }
    return error("user not found");
}

function pass(string name, int passMark) returns boolean|error {
    int|error marks = get(name);

    if marks is error {
        return marks;
    }
    // Since the error case is handled in the if block and the error is always returned,
    // the type of `marks` is safely narrowed to the non-error type (`int`) here.
    return marks >= passMark;
}

//Instead of `is` check we can simply use `check`
// function pass2(string name, int passMark) returns boolean|error {
//     int marks = check get(name);
//     return marks >= passMark;
// }

// Use expression bodied function to further simplify
// function pass3(string name, int passMark) returns boolean|error => check get(name) >= passMark;

public function main() {
    io:println(pass("Tom", 75)); // true
    io:println(pass("Alic", 75)); // error("user not found")
}
