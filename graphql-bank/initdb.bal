function initdDatabase() returns error? {
    _ = check db->execute(`DROP TABLE IF  EXISTS Employees`);
    _ = check db->execute(`DROP TABLE IF  EXISTS Accounts`);
    _ = check db->execute(`CREATE TABLE IF NOT EXISTS Employees
                                (employee_id INTEGER NOT NULL, name  VARCHAR(255), position VARCHAR(255),
                                PRIMARY KEY (employee_id))`);
    _ = check db->execute(`CREATE TABLE IF NOT EXISTS Accounts
                                (acc_number INTEGER NOT NULL, account_type VARCHAR(255), account_holder VARCHAR(255), 
                                address VARCHAR(255), opened_date VARCHAR(255), employee_id INT NOT NULL,
                                PRIMARY KEY (acc_number))`);
    //Add data
    _ = check db->execute(`INSERT INTO Employees(employee_id, name, position) VALUES (1, 'Mary Jones', 'Operations Manager')`);
    _ = check db->execute(`INSERT INTO Employees(employee_id, name, position) VALUES (2, 'Jennifer Davis', 'Operations Manager')`);
    _ = check db->execute(`INSERT INTO Employees(employee_id, name, position) VALUES (3, 'John Smith', 'Lead Manager')`);

    _ = check db->execute(`INSERT INTO Accounts(acc_number, account_type, account_holder, address, opened_date, employee_id) VALUES (1, 'Savings', 'Robert Wilson', '101 Pine Road, Villagetown, TX 24680', '2022-10-01', 1)`);
    _ = check db->execute(`INSERT INTO Accounts(acc_number, account_type, account_holder, address, opened_date, employee_id) VALUES (2, 'FD', 'Emily Johnson', '234 Maple Lane Suburbia, FL 13579', '2023-08-16', 1)`);
    _ = check db->execute(`INSERT INTO Accounts(acc_number, account_type, account_holder, address, opened_date, employee_id) VALUES (3, 'IRA', 'Sarah Brown', '456 Elm Avenue Smalltown, CA 98765', '2010-10-22', 2)`);
    _ = check db->execute(`INSERT INTO Accounts(acc_number, account_type, account_holder, address, opened_date, employee_id) VALUES (4, 'Savings', 'Lisa Martinez', '789 Oak Street Cityville, NY 54321', '2022-10-01', 3)`);
}

