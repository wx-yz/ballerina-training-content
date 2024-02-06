{
    "number": "1234567890",
    "type": "savings",
    "owner": "John Doe",
    "address": "123 Main St, Cityville",
    "openedDate": "2024-01-15",
    "bankEmployee": {
        "id": "emp789",
        "name": "Jane Smith",
        "position": "Customer Service Representative"
    }
}


    remote function add(AccountEntry accountEntry) returns Account | error {
        return {
            number: "123",
            accType: "Savings",
            owner: "John",
            address: "Colombo",
            openedDate: "2020-01-01",
            bankEmployee: {id: 1, name: "Mary Jones", position: "Operations Manager"}
        };
    }

    type AccountEntry record {
    string accType;
    string owner;
    string address;
    string openedDate;
};



//////Step 1

import ballerina/graphql;

service /bank on new graphql:Listener(9090) {

    resource function get accounts() returns Account[]|error {
        Account acc1 = {
            number: "123",
            accType: "Savings",
            owner: "John Doe",
            address: "20A, FM Road, Austin, TX, 73301",
            openedDate: "2020-01-01",
            bankEmployee: {id: 1, name: "Mary Jones", position: "Operations Manager"}
        };
        Account[] accounts = [];
        accounts.push(acc1);
        return accounts;
    }
}

type BankEmployee record {
    int id;
    string name;
    string position;
};

type Account record {
    string number;
    string accType;
    string owner;
    string address;
    string openedDate;
    BankEmployee bankEmployee;
};






query {
  accounts {
    number,
    owner,
    bankEmployee {
      name,
      position
    }
  }
}


//////Step 2


DROP DATABASE IF EXISTS gq_bank_test;
CREATE DATABASE gq_bank_test;
USE gq_bank_test;
CREATE TABLE Accounts(acc_number INT AUTO_INCREMENT, account_type VARCHAR(255), account_holder VARCHAR(255), address VARCHAR(255), opened_date VARCHAR(255), PRIMARY KEY (acc_number));
CREATE TABLE Employees(employee_id INT AUTO_INCREMENT, name  VARCHAR(255), position VARCHAR(255), PRIMARY KEY (employee_id));
CREATE TABLE AccountOwners (acc_number INT NOT NULL, employee_id INT NOT NULL,PRIMARY KEY (acc_number, employee_id),FOREIGN KEY (acc_number) REFERENCES Accounts(acc_number), FOREIGN KEY (employee_id) REFERENCES Employees(employee_id));
INSERT INTO Employees(name, position) VALUES ("Mary Jones", "Operations Manager");
INSERT INTO Employees(name, position) VALUES ("Jennifer Davis", "Operations Manager");
INSERT INTO Employees(name, position) VALUES ("John Smith", "Lead Manager");
INSERT INTO Accounts(account_type, account_holder, address, opened_date) VALUES ("Savings", "Robert Wilson", "101 Pine Road, Villagetown, TX 24680", "2022-10-01");
INSERT INTO Accounts(account_type, account_holder, address, opened_date) VALUES ("FD", "Emily Johnson", "234 Maple Lane Suburbia, FL 13579", "2023-08-16");
INSERT INTO Accounts(account_type, account_holder, address, opened_date) VALUES ("IRA", "Sarah Brown", "456 Elm Avenue Smalltown, CA 98765", "2010-10-22");
INSERT INTO Accounts(account_type, account_holder, address, opened_date) VALUES ("Savings", "Lisa Martinez", "789 Oak Street Cityville, NY 54321", "2022-10-01");
INSERT INTO AccountOwners(acc_number,employee_id) VALUES ((SELECT acc_number FROM Accounts WHERE account_holder="Robert Wilson"),(SELECT employee_id FROM Employees WHERE name="Mary Jones"));
INSERT INTO AccountOwners(acc_number,employee_id) VALUES ((SELECT acc_number FROM Accounts WHERE account_holder="Emily Johnson"),(SELECT employee_id FROM Employees WHERE name="Mary Jones"));
INSERT INTO AccountOwners(acc_number,employee_id) VALUES ((SELECT acc_number FROM Accounts WHERE account_holder="Sarah Brown"),(SELECT employee_id FROM Employees WHERE name="Jennifer Davis"));
INSERT INTO AccountOwners(acc_number,employee_id) VALUES ((SELECT acc_number FROM Accounts WHERE account_holder="Lisa Martinez"),(SELECT employee_id FROM Employees WHERE name="John Smith"));

