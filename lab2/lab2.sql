/*
Lab 2 report Josef Atoui (josat799), Stefan Brynielsson (stebr364)
*/

/*
Drop all user created tables that have been created when solving the lab
*/

ALTER TABLE jbdept DROP FOREIGN KEY fk_dept_mgr;
ALTER TABLE jbemployee DROP FOREIGN KEY fk_emp_mgr;
DROP TABLE IF EXISTS jbsale CASCADE;
DROP TABLE IF EXISTS jbmanager CASCADE;


DROP TABLE IF EXISTS jbwithdrawal CASCADE;
DROP TABLE IF EXISTS jbdeposit CASCADE;
DROP TABLE IF EXISTS jbdebit CASCADE;
DROP TABLE IF EXISTS jbtransaction CASCADE;
DROP TABLE IF EXISTS jbaccount CASCADE;
DROP TABLE IF EXISTS jbcustomer CASCADE;


-- DROP TABLE IF EXISTS myitem CASCADE;
-- DROP VIEW IF EXISTS item_view CASCADE;
-- DROP VIEW IF EXISTS total_debit_view CASCADE;
-- DROP VIEW IF EXISTS total_debit_view2 CASCADE;
-- DROP VIEW IF EXISTS jbsale_supply CASCADE;

/* Have the source scripts in the file so it is easy to recreate!*/

SOURCE company_schema.sql;
SOURCE company_data.sql;

/*
Question 3 Implement your extensions in the database by first creating tables,
if any, then populating them with existing manager data, then adding/modifying
foreign key constraints.Do you have to initialize the bonusattributeto a value?
Why?
*/

CREATE TABLE jbmanager (
		id integer,
		bonus integer,

		CONSTRAINT pk_manager
			PRIMARY KEY (id),

		constraint fk_employee
			FOREIGN KEY (id) REFERENCES jbemployee(id)
);
/*
Query OK, 0 rows affected (0.05 sec)
*/
INSERT INTO jbmanager SELECT manager, 0
		 									FROM jbdept
		 									GROUP BY manager;
/*
		 Query OK, 11 rows affected (0.00 sec)
		 Records: 11  Duplicates: 0  Warnings: 0
*/

INSERT INTO jbmanager SELECT manager, 0
											FROM jbemployee
											WHERE manager NOT IN (SELECT id
																						FROM jbmanager)
											GROUP BY manager;
 /*
 Query OK, 1 row affected (0.00 sec)
Records: 1  Duplicates: 0  Warnings: 0
 */

ALTER TABLE jbdept DROP FOREIGN KEY fk_dept_mgr;
/*
Query OK, 0 rows affected (0.04 sec)
Records: 0  Duplicates: 0  Warnings: 0
*/

ALTER TABLE jbemployee DROP FOREIGN KEY fk_emp_mgr;
/*
Query OK, 0 rows affected (0.04 sec)
Records: 0  Duplicates: 0  Warnings: 0
*/

ALTER TABLE jbdept ADD CONSTRAINT fk_dept_mgr
	FOREIGN KEY (manager) REFERENCES jbmanager(id);
/*
Query OK, 19 rows affected (0.12 sec)
Records: 19  Duplicates: 0  Warnings: 0
*/

ALTER TABLE jbemployee ADD CONSTRAINT fk_emp_mgr
	FOREIGN KEY (manager) REFERENCES jbmanager(id);
/*
Query OK, 25 rows affected (0.14 sec)
Records: 25  Duplicates: 0  Warnings: 0
*/

/*
Yes in our implementation we need to initilaize the bonus attribute to some integer.
If we would have choosen defualt 0 then it would have initialized by itself.
*/

/*
Question 4 All departments showed good sales figures last year! Give all
current department managers $10,000 in bonus. This bonus is an addition to
other possible bonuses they have. Hint:Not all managers are department managers.
Update all managers that are referredin the jbdeptrelation.
*/


UPDATE jbmanager
SET bonus = bonus + 10000
WHERE id IN (SELECT manager
						 FROM jbdept);
/*
Query OK, 11 rows affected (0.00 sec)
Rows matched: 11  Changed: 11  Warnings: 0
*/

/*
Question 5 (Partly at home)In the existing database, customers can buy items and
pay for them, as reflected by the sale and debit tables. Now, you want to create
support for storing customer information. The customers will have accounts,
where they can deposit and withdraw money.
The requirements are:
	•Customers are stored with name, street address, city, and state. Use existing
	 city information!
	•A customer can have several accounts.
	•Accounts are stored with account number, and balance.
	•Information about transactions such as their type (withdrawal/deposit/debit),
	 transaction number, account number, date and time of the transaction, amount,
	 and the employee responsible for the transaction (that is, the employee that
	 registers the transaction, not the customer that owns the account) should be
	 captured by an entity type called Transaction. Use subclasses to distinguish
	 between the different types of transactions (withdrawals/deposit/debit).
	 This means that the new Transactionentity type will be a superclass of the
	 existing Debitentity type.

	 a)(At home) Extend the EER-diagram with your new entity types, relationship
	 types, and attributes.

	 b)Implement your extensions in your database. Add primary key constraints,
	 foreign key constraints and integrity constraints to your table definitions.
	 Do not forget to correctly set up the new and existing foreign keys.
*/

/*
b
*/


DELETE FROM jbsale;

/*
Query OK, 8 rows affected (0.00 sec)
*/

DELETE FROM jbdebit;
/*
Query OK, 6 rows affected (0.01 sec)
*/

CREATE TABLE jbcustomer (
		id integer,
		adress varchar(255),
		name varchar(255),
		city integer,

		CONSTRAINT pk_customer
			PRIMARY KEY (id),

		CONSTRAINT fk_city
			FOREIGN KEY (city) REFERENCES jbcity(id)
);

/*
Query OK, 0 rows affected (0.08 sec)
*/

CREATE TABLE jbaccount (
		ac_number integer,
		balance integer,
		owner integer,

		CONSTRAINT pk_account
			PRIMARY KEY (ac_number),

		CONSTRAINT fk_owner
			FOREIGN KEY (owner) REFERENCES jbcustomer(id)
);
/*
Query OK, 0 rows affected (0.04 sec)
*/

CREATE TABLE jbtransaction (
		ts_number integer,
		sdate timestamp,
		account integer,
		responsible integer,

		CONSTRAINT pk_transaction
			PRIMARY KEY (ts_number),

		 CONSTRAINT fk_responsible
			 FOREIGN KEY (responsible) REFERENCES jbemployee(id),

		 CONSTRAINT fk_account
			 FOREIGN KEY (account) REFERENCES jbaccount(ac_number)

);

/*
Query OK, 0 rows affected (0.07 sec)
*/

CREATE TABLE jbwithdrawal (
		ts_number integer,
		amount integer,

		CONSTRAINT pk_withdrawal
			PRIMARY KEY (ts_number),

		CONSTRAINT fk_transaction_withdrawal
			FOREIGN KEY (ts_number) REFERENCES jbtransaction(ts_number)
);
/*
Query OK, 0 rows affected (0.09 sec)
*/

CREATE TABLE jbdeposit (
		ts_number integer,
		amount integer,

		CONSTRAINT pk_deposit
			PRIMARY KEY (ts_number),

		CONSTRAINT fk_transaction_deposit
			FOREIGN KEY (ts_number) REFERENCES jbtransaction(ts_number)
);
/*
Query OK, 0 rows affected (0.06 sec)
*/

ALTER TABLE jbdebit DROP FOREIGN KEY fk_debit_employee;
/*
Query OK, 0 rows affected (0.04 sec)
Records: 0  Duplicates: 0  Warnings: 0
*/

ALTER TABLE jbdebit DROP COLUMN sdate CASCADE;
/*
Query OK, 0 rows affected (0.11 sec)
Records: 0  Duplicates: 0  Warnings: 0
*/

ALTER TABLE jbdebit DROP COLUMN account CASCADE;

/*
Query OK, 0 rows affected (0.10 sec)
Records: 0  Duplicates: 0  Warnings: 0
*/

ALTER TABLE jbdebit DROP COLUMN employee CASCADE;
/*
Query OK, 0 rows affected (0.11 sec)
Records: 0  Duplicates: 0  Warnings: 0
*/

ALTER TABLE jbdebit ADD FOREIGN KEY (id) REFERENCES jbtransaction(ts_number);
/*
Query OK, 0 rows affected (0.11 sec)
Records: 0  Duplicates: 0  Warnings: 0
*/
