import ballerina/io;

type Detail record {|
    string reason;
    boolean fatal?;
|};

type InvalidUserError error<Detail>;

type InvalidAccessError error<record {|string reason;|}>;

public function main() {
    error<record {|string reason;|}> e1 = error("invalid username", reason = "contains spaces");
    // `true` since detail mapping in e1 satisfies the 
    // requirements for the detail type of InvalidUserError
    io:println(e1 is InvalidUserError); // true
    InvalidUserError e2 = error("invalid username", reason = "contains spaces");
    // `true` since the detail mapping has only the `string` `reason` field
    io:println(e2 is InvalidAccessError); // true
    InvalidUserError e3 = error("invalid username", reason = "contains spaces", fatal = true);
    // `false` since the detail mapping has the `fatal` field which is not allowed
    // in the detail type of InvalidAccessError
    io:println(e3 is InvalidAccessError); // false
}
