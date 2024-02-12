import ballerina/io;

type InvalidUserErrorDetails record {|
    string reason;
    int code = 1001;
|};

type InvalidUserError error<InvalidUserErrorDetails>;

public function main() {
    InvalidUserError e1 = error InvalidUserError("invalid user",
                            reason = "contains spaces");
    io:println(e1.detail().reason); // contains spaces

    error<record {|int length;|}> e2 =
                error("invalid length", length = 5);
    io:println(e2.detail().length); // 5
}
