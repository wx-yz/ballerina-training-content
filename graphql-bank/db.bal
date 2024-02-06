import ballerina/sql;
import ballerinax/mysql;
import ballerinax/mysql.driver as _;

configurable string host = ?;
configurable string username = ?;
configurable string password = ?;
configurable string databaseName = ?;


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

function queryAccountData() returns Account[]|error {
    mysql:Client db =  check new (host, username, password, databaseName);

    stream<DBAccount, sql:Error?> accountStream = db->query(`SELECT a.acc_number, a.account_type, a.account_holder, a.address, 
    a.opened_date, e.employee_id, e.position, e.name from Accounts a LEFT JOIN Employees e on a.employee_id  = e.employee_id; `);

    DBAccount[] dbAccounts = check from DBAccount dbAccount in accountStream
        select dbAccount;
    return transform(dbAccounts);
}

function transform(DBAccount[] dbAccount) returns Account[] => from var dbAccountItem in dbAccount
    select {
        number: dbAccountItem.acc_number,
        accType: dbAccountItem.account_type,
        holder: dbAccountItem.account_holder,
        address: dbAccountItem.address,
        openedDate: dbAccountItem.opened_date,
        bankEmployee: {
            id: dbAccountItem.employee_id,
            name: dbAccountItem.name,
            position: dbAccountItem.position
        }
    };
