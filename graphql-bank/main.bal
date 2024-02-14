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
    resource function get accounts(graphql:Field gqField, int? accNumber, @graphql:ID int? employeeID)
            returns Account[]|error {
        return queryAccountData(gqField, accNumber, employeeID);
    }
}

type EmployeeInfo readonly & record {|
    int? number;
    string? accType;
    string? holder;
    string? address;
    string? openedDate;
|};

type BankEmployee readonly & record {|
    @graphql:ID int? id;
    string? name;
    string? position;
|};

enum State {
    CA,
    NY,
    TX
};

service class Account {
    private final EmployeeInfo employeeInfo;
    private final BankEmployee bankEmployee;

    function init(EmployeeInfo employeeInfo, BankEmployee bankEmployee) {
        self.employeeInfo = employeeInfo;
        self.bankEmployee = bankEmployee;
    }

    // Each resource method becomes a field of the `Account` type.
    resource function get number() returns int? => self.employeeInfo.number;

    resource function get accType() returns string? => self.employeeInfo.accType;

    resource function get holder() returns string? => self.employeeInfo.holder;

    resource function get address() returns string? => self.employeeInfo.address;

    resource function get openedDate() returns string? => self.employeeInfo.openedDate;

    resource function get bankEmployee() returns BankEmployee => self.bankEmployee;

    resource function get isLocal(State state) returns boolean? {
        string? address = self.employeeInfo.address;
        if address is () {
            return false;
        }
        return address.includes(state);
    }
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
    sql:ParameterizedQuery selectQuery = `SELECT `;
    int i = 0;
    foreach graphql:Field subField in subFields {
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
            "address" | "isLocal" => {
                selectQuery = sql:queryConcat(selectQuery, `a.address`);
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
        i = i + 1;
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
        {
            number: dbAccountItem?.acc_number,
            accType: dbAccountItem?.account_type,
            holder: dbAccountItem?.account_holder,
            address: dbAccountItem?.address,
            openedDate: dbAccountItem?.opened_date
        },
        {
            id: dbAccountItem?.employee_id,
            position: dbAccountItem?.position,
            name: dbAccountItem?.name
        }
    );
