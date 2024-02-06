import ballerina/graphql;

service /bank on new graphql:Listener(9090) {

    resource function get accounts() returns Account[]|error {
        return queryAccountData();
    }
}

type BankEmployee record {
    int id;
    string name;
    string position;
};

type Account record {
    int number;
    string accType;
    string holder;
    string address;
    string openedDate;
    BankEmployee bankEmployee;
};
