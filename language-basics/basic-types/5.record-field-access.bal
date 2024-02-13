import ballerina/io;

type Employee record {|
    int id;
    string name;
    boolean manager = false;
    string department?;
    decimal? salary?;
    (int|string)...;
|};

public function main() {
    Employee e = {
        id: 1124,
        name: "John",
        salary: 1200,
        "eCode": "E1124"
    };

    // Field access - type is int since the field is guaranteed to be
    // present and be an integer.
    int id = e.id;
    io:println(id); // 1124

    // Field access - type contains nil to allow for the absence of the field.
    string? department = e.department;
    io:println(department is string); // false

    // Optional field access - value will be nil if either the field is
    // not present or the value is nil.
    decimal? salary = e?.salary;
    io:println(salary); // 1200

    // Member access - type contains nil to allow for the absence of the field.
    int|string? eCode = e["eCode"];
    io:println(eCode); // E1124

    string key = "eCode";
    int|string|boolean|decimal? value = e[key];
    io:println(value); // E1124

    // Field update
    e.id = 1500;
    e.department = "HR";
    e["eCode"] = "E1500";
    io:println(e); // {"id":1500,"name":"John","manager":false,"department":"HR","salary":1200,"eCode":"E1500"}
}
