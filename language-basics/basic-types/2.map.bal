import ballerina/io;

public function main() {
    map<int> digits = {
        one: 1,
        two: 2,
        three: 3
    };
    io:println(digits); // {"one":1,"two":2,"three":3}

    int? v = digits["two"];
    io:println(v); // 2

    string key = "six";
    io:println(digits[key] is ()); // true

    digits["four"] = 4;
    io:println(digits); // {"one":1,"two":2,"three":3,"four":4}

    int val = digits.get("one");
    io:println(val); // 1

    val = digits.get("seven"); // panics
}
