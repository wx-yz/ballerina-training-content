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
    do {
        if name.trim().length() == 0 {
            // transferred to on fail only if `check` or `fail` is used.
            // Returned errors or panics will NOT cause transfer of control to the on fail clause.
            check error("Blank string as the name");
        }
        int marks = check get(name);
        return marks >= passMark;
    } on fail error e {
        io:println("error on pass:", e);
        return false;
    }
}

// on fail can have any logic and can avoid the typed binding
// function pass2(string name, int passMark) returns boolean {
//     do {
//         if name.trim().length() == 0 {
//             check error("Blank string as the name");
//         }
//         int marks = check get(name);
//         return marks >= passMark;
//     } on fail {
//         io:println("error on pass:");
//         // can have any logic here
//         return false;
//     }
// }

public function main() {
    io:println(pass("Tom", 75)); // true
    io:println(pass("Alice", 75)); // error on pass:error("user not found") false
    io:println(pass("", 75)); // error on pass:error("Blank string as the name") false
    io:println(pass("Jack", 75)); // false
}
