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

// 
function pass(string name, int passMark) returns boolean {
    int|error marks = get(name);

    if marks is error {
        panic marks;
    }
    // Since the error case is handled in the if block and the error is always results in panic,
    // the type of `marks` is safely narrowed to the non-error type (`int`) here.
    return marks >= passMark;
}

//Instead of `is` check we can simply use `checkpanic`
// function pass2(string name, int passMark) returns boolean {
//     int marks = checkpanic get(name);
//     return marks >= passMark;
// }

// // Use expression bodied function to further simplify
// function pass3(string name, int passMark) returns boolean => checkpanic get(name) >= passMark;

public function main() {
    io:println(pass("Tom", 75)); // true
    io:println(pass("Alice", 75)); // panics
    io:println(pass("Jack", 23)); // not executed
}
