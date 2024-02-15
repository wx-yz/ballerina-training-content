import ballerina/graphql;
import ballerina/sql;
import ballerinax/h2.driver as _;
import ballerinax/java.jdbc;

configurable string url = ?;
configurable string username = ?;
configurable string password = ?;

final jdbc:Client db = check new (url = url, user = username, password = password);

function init() returns error? {
    _ = check initdDatabase();
}

@graphql:ServiceConfig {
    graphiql: {
        enabled: true
    }
}
service /bank on new graphql:Listener(9094) {
    resource function get accounts(graphql:Field gqField, int? accNumber, int? employeeID)
            returns Account[]|error {
        return queryAccountData(gqField, accNumber, employeeID);
    }
}

type BankEmployee readonly & record {|
    int? id;
    string? name;
    string? position;
|};

service class Account {
    private final int? number;
    private final string? accType;
    private final string? holder;
    private final string? address;
    private final string? openedDate;
    private final BankEmployee bankEmployee;

    function init(int? number, string? accType, string? holder, string? address, string? openedDate, BankEmployee bankEmployee) {
        self.number = number;
        self.accType = accType;
        self.holder = holder;
        self.address = address;
        self.openedDate = openedDate;
        self.bankEmployee = bankEmployee;
    }

    // Each resource method becomes a field of the `Account` type.
    resource function get number() returns int? => self.number;

    resource function get accType() returns string? => self.accType;

    resource function get holder() returns string? => self.holder;

    resource function get address() returns string? => self.address;

    resource function get openedDate() returns string? => self.openedDate;

    resource function get bankEmployee() returns BankEmployee => self.bankEmployee;

    resource function get isLocal(State state) returns boolean? {
        string? address = self.address;
        if address is () {
            return false;
        }
        return address.includes(state);
    }
}

enum State {
    TX,
    CA,
    NY
}

type DBAccount record {|
    int acc_number?;
    string account_type?;
    string account_holder?;
    string address?;
    string opened_date?;
    int employee_id?;
    string position?;
    string name?;
|};

function queryAccountData(graphql:Field gqField, int? accNumber, int? employeeID) returns Account[]|error {
    graphql:Field[]? subFields = gqField.getSubfields();
    if subFields is () {
        return error("Invalid query with no sub fields");
    }

    //Select clause
    boolean isJoin = false;
    boolean addressAdded = false;
    sql:ParameterizedQuery selectQuery = `SELECT `;
    int i = 0;
    foreach graphql:Field subField in subFields {
        i = i + 1;
        match subField.getName() {
            "number" => {
                selectQuery = sql:queryConcat(selectQuery, `a.acc_number`);
            }
            "accType" => {
                selectQuery = sql:queryConcat(selectQuery, `a.account_type`);
            }
            "holder" => {
                selectQuery = sql:queryConcat(selectQuery, `a.account_holder`);
            }
            "address"|"isLocal" => {
                if addressAdded {
                    continue;
                }
                selectQuery = sql:queryConcat(selectQuery, `a.address`);
                addressAdded = true;

            }
            "openedDate" => {
                selectQuery = sql:queryConcat(selectQuery, `a.opened_date`);
            }
            "bankEmployee" => {
                graphql:Field[]? employeeSubFields = subField.getSubfields();
                if employeeSubFields is () {
                    return error("Invalid query with no employee sub fields");
                }
                isJoin = true;
                int j = 0;
                foreach graphql:Field empSubField in employeeSubFields {
                    match empSubField.getName() {
                        "id" => {
                            selectQuery = sql:queryConcat(selectQuery, `e.employee_id`);
                        }
                        "name" => {
                            selectQuery = sql:queryConcat(selectQuery, `e.name`);
                        }
                        "position" => {
                            selectQuery = sql:queryConcat(selectQuery, `e.position`);
                        }
                    }
                    j = j + 1;
                    if j < employeeSubFields.length() {
                        selectQuery = sql:queryConcat(selectQuery, `, `);
                    }
                }
            }
        }

        if i < subFields.length() {
            selectQuery = sql:queryConcat(selectQuery, `, `);
        }
    }
    //From Clause
    selectQuery = sql:queryConcat(selectQuery, ` from Accounts as a `);
    if isJoin {
        selectQuery = sql:queryConcat(selectQuery, ` LEFT JOIN Employees as e on a.employee_id = e.employee_id `);
    }
    //Where clause
    if accNumber !is () || employeeID !is () {
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
        dbAccountItem?.acc_number,
        dbAccountItem?.account_type,
        dbAccountItem?.account_holder,
        dbAccountItem?.address,
        dbAccountItem?.opened_date,
        {
            id: dbAccountItem?.employee_id,
            position: dbAccountItem?.position,
            name: dbAccountItem?.name
        }
    );

