import ballerina/io;

// Record with exactly two fields
type Employee record {|
    int id;
    string name;
|};

Employee e1 = {id: 1123, name: "John"};

// // Record with default field values
// type Employee record {|
//     int id;
//     string name;
//     boolean manager = false;
// |};

// Employee e1 = {id: 1211, name: "John"};
// Employee e2 = {id: 1212, name: "Joy", manager: true};

// // Record with optional fields
// type Employee record {|
//     int id;
//     string name;
//     string department?;
// |};

// Employee e1 = {id: 1211, name: "John", department: "legal"};
// Employee e2 = {id: 1212, name: "Joy"};

public function main() {
    io:println(e1);
}