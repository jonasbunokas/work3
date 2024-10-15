CREATE DATABASE IF NOT EXISTS banksystem;

USE banksystem;

CREATE TABLE Branches (
    branch_id INT AUTO_INCREMENT PRIMARY KEY,
    branch_name VARCHAR(100),
    address VARCHAR(255),
    city VARCHAR(50),
    zipcode VARCHAR(10),
    phone VARCHAR(15),
    manager_id INT,
    FOREIGN KEY (manager_id) REFERENCES Employees(employee_id)
);

CREATE TABLE Employees (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    position VARCHAR(50),
    branch_id INT,
    hire_date DATE,
    salary DECIMAL(10, 2),
    FOREIGN KEY (branch_id) REFERENCES Branches(branch_id)
);



CREATE TABLE Customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    dob DATE NOT NULL,
    address VARCHAR(255),
    phone VARCHAR(15),
    email VARCHAR(100) UNIQUE,
    branch_id INT,
    date_joined DATE,
    FOREIGN KEY (branch_id) REFERENCES Branches(branch_id)
);

CREATE TABLE Accounts (
    account_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    account_type ENUM('Savings', 'Checking', 'Fixed Deposit') NOT NULL,
    balance DECIMAL(15, 2) DEFAULT 0.00,
    interest_rate DECIMAL(5, 2),
    date_opened DATE,
    branch_id INT,
    status ENUM('Active', 'Dormant', 'Closed') DEFAULT 'Active',
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (branch_id) REFERENCES Branches(branch_id)
);

CREATE TABLE Transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    account_id INT,
    transaction_type ENUM('Deposit', 'Withdrawal', 'Transfer') NOT NULL,
    amount DECIMAL(15, 2),
    transaction_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    description VARCHAR(255),
    employee_id INT,
    FOREIGN KEY (account_id) REFERENCES Accounts(account_id),
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id)
);

CREATE TABLE Loans (
    loan_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    loan_type ENUM('Personal Loan', 'Home Loan', 'Auto Loan', 'Education Loan') NOT NULL,
    loan_amount DECIMAL(15, 2),
    interest_rate DECIMAL(5, 2),
    loan_start_date DATE,
    loan_end_date DATE,
    loan_status ENUM('Active', 'Closed', 'Defaulted') DEFAULT 'Active',
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

CREATE TABLE Cards (
    card_id INT AUTO_INCREMENT PRIMARY KEY,
    account_id INT,
    card_type ENUM('Debit', 'Credit') NOT NULL,
    card_number VARCHAR(20) UNIQUE,
    expiry_date DATE NOT NULL,
    cvv VARCHAR(4),
    card_status ENUM('Active', 'Blocked', 'Expired') DEFAULT 'Active',
    FOREIGN KEY (account_id) REFERENCES Accounts(account_id)
);

CREATE TABLE Payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    account_id INT,
    payment_amount DECIMAL(15, 2),
    payment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    payment_description VARCHAR(255),
    payment_type ENUM('Bill Payment', 'Loan Payment', 'Subscription'),
    FOREIGN KEY (account_id) REFERENCES Accounts(account_id)
);

CREATE TABLE AuditLogs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    entity VARCHAR(50),
    operation_type ENUM('INSERT', 'UPDATE', 'DELETE') NOT NULL,
    record_id INT,
    changed_by INT,
    change_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (changed_by) REFERENCES Employees(employee_id)
);

DELIMITER //

CREATE TRIGGER before_insert_customers
BEFORE INSERT ON Customers
FOR EACH ROW
BEGIN
    IF NEW.date_joined IS NULL THEN
        SET NEW.date_joined = CURDATE();
    END IF;
END //

DELIMITER ;

CREATE INDEX idx_customer_id ON Accounts(customer_id);
CREATE INDEX idx_account_id ON Transactions(account_id);
CREATE INDEX idx_branch_id ON Customers(branch_id);
CREATE INDEX idx_employee_id ON Transactions(employee_id);
