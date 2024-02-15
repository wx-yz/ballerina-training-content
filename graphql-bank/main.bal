import ballerina/graphql;

service /bank on new graphql:Listener(9090) {

    resource function get accounts() returns Account[]|error {
        return [
            {
                number: "123",
                accType: "Savings",
                holder: "John Doe",
                address: "20A, FM Road, Austin, TX, 73301",
                openedDate: "2020-01-01",
                bankEmployee: {id: 1, name: "Mary Jones", position: "Operations Manager"}
            }
        ];
    }
}

type BankEmployee record {|
    int id;
    string name;
    string position;
|};

type Account record {|
    string number;
    string accType;
    string holder;
    string address;
    string openedDate;
    BankEmployee bankEmployee;
|};
