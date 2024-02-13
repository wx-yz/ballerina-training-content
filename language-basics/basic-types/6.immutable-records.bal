import ballerina/io;

type Person record {
    int id;
    string name;
};

public function main() {
    Person & readonly person = {name: "Jo", id: 12121};
    person.id = 12112; // compile-time error since an immutable value cannot be updated

    Person p2 = {name: "Anne", id: 12450};
    Person p3 = p2.cloneReadOnly();

    p2.id = 12345;
    p3.id = 12345; // runtime error since p3 is immutable

    io:println(p2);
}
