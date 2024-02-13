import ballerina/io;

type Person record {
    readonly string name;
    int id?;
    string[]|string address;
    string country;
};

type Employee record {
    *Person;
    int id;
    string address;
    boolean isManager;
};

Employee employee = {
    name: "Maya",
    id: 1232,
    country: "Colombo, Sri Lanka",
    address: "LKA",
    isManager: false
};

public function main() {
    io:println(employee);
}
