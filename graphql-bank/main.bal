import ballerina/graphql;
import ballerina/sql;
import ballerinax/mysql;
import ballerinax/mysql.driver as _;

configurable string host = ?;
configurable string username = ?;
configurable string password = ?;
configurable string databaseName = ?;
configurable int port = ?;

final mysql:Client db = check new (host, username, password, databaseName, port);

@graphql:ServiceConfig {
    graphiql: {
        enabled: true
    }
}
service /bank on new graphql:Listener(9094) {
    resource function get accounts(int? accNumber, int? employeeID) returns Account[]|error {
        return queryAccountData(accNumber, employeeID);
    }
}

type BankEmployee readonly & record {
    int id;
    string name;
    string position;
};

service class Account {
    private final int number;
    private final string accType;
    private final string holder;
    private final string address;
    private final string openedDate;
    private final BankEmployee bankEmployee;

    function init(int number, string accType, string holder, string address, string openedDate, BankEmployee bankEmployee) {
        self.number = number;
        self.accType = accType;
        self.holder = holder;
        self.address = address;
        self.openedDate = openedDate;
        self.bankEmployee = bankEmployee;
    }

    // Each resource method becomes a field of the `Account` type.
    resource function get number() returns int {
        return self.number;
    }
    resource function get accType() returns string {
        return self.accType;
    }
    resource function get holder() returns string {
        return self.holder;
    }

    resource function get address() returns string {
        return self.address;
    }

    resource function get openedDate() returns string {
        return self.openedDate;
    }

    resource function get bankEmployee() returns BankEmployee {
        return self.bankEmployee;
    }

    resource function get isLocal(State state) returns boolean {
        return self.address.includes(state);
    }
}

enum State {
    TX,
    CA,
    NY
}

type DBAccount record {|
    int acc_number;
    string account_type;
    string account_holder;
    string address;
    string opened_date;
    int employee_id;
    string position;
    string name;
|};

function queryAccountData(int? accNumber, int? employeeID) returns Account[]|error {
    sql:ParameterizedQuery selectQuery = `SELECT a.acc_number, a.account_type, a.account_holder, a.address, 
    a.opened_date, e.employee_id, e.position, e.name from Accounts a LEFT JOIN Employees e on a.employee_id  = e.employee_id `;

    // Where clause
    if accNumber != () || employeeID != () {
        selectQuery = sql:queryConcat(selectQuery, `WHERE `);
        if accNumber != () {
            selectQuery = sql:queryConcat(selectQuery, `a.acc_number = ${accNumber} `);
            if employeeID != () {
                selectQuery = sql:queryConcat(selectQuery, `AND `);
            }
        }
        if employeeID != () {
            selectQuery = sql:queryConcat(selectQuery, `e.employee_id = ${employeeID}`);
        }
    }

    stream<DBAccount, sql:Error?> accountStream = db->query(selectQuery);

    DBAccount[] dbAccounts = check from DBAccount dbAccount in accountStream
        select dbAccount;
    return transform(dbAccounts);
}

function transform(DBAccount[] dbAccount) returns Account[] => from var dbAccountItem in dbAccount
    select new Account(
        dbAccountItem.acc_number,
        dbAccountItem.account_type,
        dbAccountItem.account_holder,
        dbAccountItem.address,
        dbAccountItem.opened_date,
        {
            id: dbAccountItem.employee_id,
            position: dbAccountItem.position,
            name: dbAccountItem.name
        }
    );
