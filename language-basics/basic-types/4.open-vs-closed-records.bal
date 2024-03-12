import ballerina/io;

// Open record : it explicitly specifying a record rest descriptor
type Employee record {|
    int id;
    string name;
    boolean manager = false;
    string department?;
    (string|int)...;
|};

// Unlike with required and optional fields that use identifiers as keys, 
// we have used string literals with the rest fields. 
Employee e1 = {id: 1211, name: "John", "year": 2, "eCode": "E1211"};

// // Open record : using the inclusive record type descriptor syntax (record { })
// type Employee record {
//    int id;
//    string name;
//    boolean manager = false;
//    string department?;
// };

// // The above is same as
// type Employee record {|
//    int id;
//    string name;
//    boolean manager = false;
//    string department?;
//    anydata...;
// |};

//Employee e2 = {id: 1211, name: "Anne", "age": 30, "city": "Austin"};

public function main() {
    io:println(e1);
}
