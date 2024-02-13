import ballerina/io;

type Person record {
    //1. the field is effectively final meaning a new value cannot be set 
    //to this field once the record value is created. 
    //2. the value required by the field is an immutable value
    readonly string[] name;

    // the address field is not a readonly field, 
    // but its type is an intersection with readonly, 
    // which requires the value to be an immutable string array. 
    // Therefore, while the array set to the address field cannot be updated, 
    // it is possible to set a new array value to the address 
    // field since it is not a readonly field.
    string[] & readonly address;
    boolean employed;
};

public function main() {
    Person person = {
        name: ["Maya", "Silva"],
        address: ["Colombo", "Sri Lanka"],
        employed: true
    };

    person.name = ["maya", "silva"]; // compile-time error
    person.name[0] = "maya"; // compile-time error
    person.address = ["Colombo", "SL"]; // valid
    person.address[1] = "SL"; // compile-time error
}
