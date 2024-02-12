import ballerina/io;

map<int> results = {
    "Tom": 83,
    "Jack": 34
};

function checkMarks() {
    // The get function from the lang.map lang panics 
    // if the key specified is not available in the map.
    int marks = results.get("alice");
    io:println(marks);

    io:println(results.get("Tom")); // Not executed
}

// function checkMarks() {
//     // error is returned
//     int|error marks = trap results.get("alice");
//     io:println(marks);

//     io:println(results.get("Tom")); // executed
// }

public function main() {
    checkMarks();
}
