/*
Lab 1 report Josef Atoui (josat799), Stefan Brynielsson (stebr364)
*/

/*
Drop all user created tables that have been created when solving the lab
*/

DROP TABLE IF EXISTS myitem CASCADE;
DROP VIEW IF EXISTS item_view CASCADE;
DROP VIEW IF EXISTS total_debit_view CASCADE;
DROP VIEW IF EXISTS total_debit_view2 CASCADE;
DROP VIEW IF EXISTS jbsale_supply CASCADE;

/* Have the source scripts in the file so it is easy to recreate!*/

SOURCE company_schema.sql;
SOURCE company_data.sql;

/*
Question 1 List all employees, i.e. all tuples in the jbemployeerelation.
*/

SELECT *
FROM jbemployee;

/*
+------+--------------------+--------+---------+-----------+-----------+
| id   | name               | salary | manager | birthyear | startyear |
+------+--------------------+--------+---------+-----------+-----------+
|   10 | Ross, Stanley      |  15908 |     199 |      1927 |      1945 |
|   11 | Ross, Stuart       |  12067 |    NULL |      1931 |      1932 |
|   13 | Edwards, Peter     |   9000 |     199 |      1928 |      1958 |
|   26 | Thompson, Bob      |  13000 |     199 |      1930 |      1970 |
|   32 | Smythe, Carol      |   9050 |     199 |      1929 |      1967 |
|   33 | Hayes, Evelyn      |  10100 |     199 |      1931 |      1963 |
|   35 | Evans, Michael     |   5000 |      32 |      1952 |      1974 |
|   37 | Raveen, Lemont     |  11985 |      26 |      1950 |      1974 |
|   55 | James, Mary        |  12000 |     199 |      1920 |      1969 |
|   98 | Williams, Judy     |   9000 |     199 |      1935 |      1969 |
|  129 | Thomas, Tom        |  10000 |     199 |      1941 |      1962 |
|  157 | Jones, Tim         |  12000 |     199 |      1940 |      1960 |
|  199 | Bullock, J.D.      |  27000 |    NULL |      1920 |      1920 |
|  215 | Collins, Joanne    |   7000 |      10 |      1950 |      1971 |
|  430 | Brunet, Paul C.    |  17674 |     129 |      1938 |      1959 |
|  843 | Schmidt, Herman    |  11204 |      26 |      1936 |      1956 |
|  994 | Iwano, Masahiro    |  15641 |     129 |      1944 |      1970 |
| 1110 | Smith, Paul        |   6000 |      33 |      1952 |      1973 |
| 1330 | Onstad, Richard    |   8779 |      13 |      1952 |      1971 |
| 1523 | Zugnoni, Arthur A. |  19868 |     129 |      1928 |      1949 |
| 1639 | Choy, Wanda        |  11160 |      55 |      1947 |      1970 |
| 2398 | Wallace, Maggie J. |   7880 |      26 |      1940 |      1959 |
| 4901 | Bailey, Chas M.    |   8377 |      32 |      1956 |      1975 |
| 5119 | Bono, Sonny        |  13621 |      55 |      1939 |      1963 |
| 5219 | Schwarz, Jason B.  |  13374 |      33 |      1944 |      1959 |
+------+--------------------+--------+---------+-----------+-----------+

25 rows in set (0.00 sec)
*/


/*
Question 2 List the name of all departments in alphabetical order.
Note: by “name” we mean the nameattribute for all tuples in the jbdeptrelation.
*/

SELECT name
FROM jbdept
ORDER BY name ASC;
/*
+------------------+
| name             |
+------------------+
| Bargain          |
| Book             |
| Candy            |
| Children's       |
| Children's       |
| Furniture        |
| Giftwrap         |
| Jewelry          |
| Junior Miss      |
| Junior's         |
| Linens           |
| Major Appliances |
| Men's            |
| Sportswear       |
| Stationary       |
| Toys             |
| Women's          |
| Women's          |
| Women's          |
+------------------+
19 rows in set (0.04 sec)
*/

/*
Question 3 What parts are not in store, i.e. qoh=0? (qoh= Quantity On Hand)
*/



SELECT name
FROM jbparts
WHERE qoh = 0;

/*
+-------------------+
| name              |
+-------------------+
| card reader       |
| card punch        |
| paper tape reader |
| paper tape punch  |
+-------------------+
4 rows in set (0.00 sec)
*/

/*
Question 4 Which employees have a salary between
9000 (included) and 10000 (included)?
*/
SELECT name, salary
FROM jbemployee
WHERE 9000 <= salary AND salary <= 10000;

/*
+----------------+--------+
| name           | salary |
+----------------+--------+
| Edwards, Peter |   9000 |
| Smythe, Carol  |   9050 |
| Williams, Judy |   9000 |
| Thomas, Tom    |  10000 |
+----------------+--------+
4 rows in set (0.00 sec)

*/

/*
Question 5 What was the age of each employee when
they started working (startyear)?
*/
SELECT name , (startyear-birthyear) AS age
FROM jbemployee;

/*
+--------------------+------+
| name               | age  |
+--------------------+------+
| Ross, Stanley      |   18 |
| Ross, Stuart       |    1 |
| Edwards, Peter     |   30 |
| Thompson, Bob      |   40 |
| Smythe, Carol      |   38 |
| Hayes, Evelyn      |   32 |
| Evans, Michael     |   22 |
| Raveen, Lemont     |   24 |
| James, Mary        |   49 |
| Williams, Judy     |   34 |
| Thomas, Tom        |   21 |
| Jones, Tim         |   20 |
| Bullock, J.D.      |    0 |
| Collins, Joanne    |   21 |
| Brunet, Paul C.    |   21 |
| Schmidt, Herman    |   20 |
| Iwano, Masahiro    |   26 |
| Smith, Paul        |   21 |
| Onstad, Richard    |   19 |
| Zugnoni, Arthur A. |   21 |
| Choy, Wanda        |   23 |
| Wallace, Maggie J. |   19 |
| Bailey, Chas M.    |   19 |
| Bono, Sonny        |   24 |
| Schwarz, Jason B.  |   15 |
+--------------------+------+
25 rows in set (0.00 sec)
*/


/*
Question 6 Which employees have a last name ending with “son”?
*/

SELECT name
FROM jbemployee
WHERE name like "%son,%";

/*
+---------------+
| name          |
+---------------+
| Thompson, Bob |
+---------------+
1 row in set (0.00 sec)
*/

/*
Question 7 Which items (note items, not parts) have been delivered by
a supplier called Fisher-Price? Formulate this query
using a subquery in the where-clause.
*/

SELECT name
FROM jbitem
WHERE supplier IN (SELECT id
				FROM jbsupplier
				WHERE name = "Fisher-Price");
/*
+-----------------+
| name            |
+-----------------+
| Maze            |
| The 'Feel' Book |
| Squeeze Ball    |
+-----------------+
3 rows in set (0.00 sec)

*/

/*
Question 8 Formulate the same query as above, but without a subquery.
*/
SELECT jbitem.name
FROM jbitem, jbsupplier
WHERE jbitem.supplier = jbsupplier.id AND
jbsupplier.name = 'Fisher-Price';
/*
+-----------------+
| name            |
+-----------------+
| Maze            |
| The 'Feel' Book |
| Squeeze Ball    |
+-----------------+
3 rows in set (0.00 sec)

*/

/*
Question 9 Show all cities that have suppliers located in them.
Formulate this query using a subquery in the where-clause.
*/
SELECT name
FROM jbcity
WHERE id IN (SELECT city
	     FROM jbsupplier);

/*
+----------------+
| name           |
+----------------+
| Amherst        |
| Boston         |
| New York       |
| White Plains   |
| Hickville      |
| Atlanta        |
| Madison        |
| Paxton         |
| Dallas         |
| Denver         |
| Salt Lake City |
| Los Angeles    |
| San Diego      |
| San Francisco  |
| Seattle        |
+----------------+
15 rows in set (0.07 sec)

*/

/*
Question 10 What is the name and color of the parts that are heavier
than a card reader? Formulate this query using a subquery in the where-clause.
(The SQL query must not contain the weight as a constant.)
*/

SELECT name, color
FROM jbparts
WHERE weight > (SELECT weight
		FROM jbparts
		WHERE name = "card reader");

/*
+--------------+--------+
| name         | color  |
+--------------+--------+
| disk drive   | black  |
| tape drive   | black  |
| line printer | yellow |
| card punch   | gray   |
+--------------+--------+
4 rows in set (0.00 sec)


*/

/*
Question 11 Formulate the same query as above, but without a subquery.
(The query must not contain the weight as a constant.)
*/
SELECT p1.name, p1.color
FROM jbparts p1, jbparts p2
WHERE p2.name = "card reader" AND p1.weight > p2.weight;
/*

+--------------+--------+
| name         | color  |
+--------------+--------+
| disk drive   | black  |
| tape drive   | black  |
| line printer | yellow |
| card punch   | gray   |
+--------------+--------+
4 rows in set (0.00 sec)

*/

/*
Question 12 What is the average weight of black parts?
*/
SELECT AVG(weight)
FROM jbparts
WHERE color = "black";
/*

+-------------+
| AVG(weight) |
+-------------+
|    347.2500 |
+-------------+
1 row in set (0.00 sec)


*/


/*
Question 13 What is the total weight of all parts thateach supplier in
Massachusetts (“Mass”) has delivered? Retrieve the name and the total weight
for each of these suppliers. Do not forget to take the quantity of delivered
parts into account.Note that one row should be returned for each supplier.
*/
SELECT jbsupplier.name, SUM(jbparts.weight * jbsupply.quan)
FROM jbsupplier, jbcity, jbsupply, jbparts
WHERE jbsupplier.city = jbcity.id AND
			jbcity.state = 'mass' AND
			jbsupplier.id =jbsupply.supplier AND
			jbsupply.part = jbparts.id
GROUP BY jbsupplier.name;
/*
+--------------+-------------------------------------+
| name         | SUM(jbparts.weight * jbsupply.quan) |
+--------------+-------------------------------------+
| DEC          |                                3120 |
| Fisher-Price |                             1135000 |
+--------------+-------------------------------------+
2 rows in set (0.01 sec)

*/

/*
Question 14 Create a new relation (a table),with the same attributes as the
table itemsusing the CREATE TABLE syntax where you define every attribute
explicitly (i.e. not 10 as a copy of another table). Then fill
the table with all items that cost less than the average price for items.
Remember to define primary and foreign keys in your table!
*/
CREATE TABLE myitem (
    id integer,
    name VARCHAR(255),
    dept integer,
    price integer,
    qoh integer,
    supplier integer,

    constraint pk_item
        primary key (id)
);

/*
Query OK, 0 rows affected (0.08 sec)
*/

ALTER TABLE myitem ADD CONSTRAINT fk_supplier FOREIGN KEY (supplier) REFERENCES jbsupplier(id);

/*
Query OK, 0 rows affected (0.09 sec)
Records: 0  Duplicates: 0  Warnings: 0

*/

ALTER TABLE myitem add CONSTRAINT fk_on_shelf FOREIGN KEY (dept) REFERENCES jbdept(id);
/*
Query OK, 0 rows affected (0.14 sec)
Records: 0  Duplicates: 0  Warnings: 0
*/
INSERT INTO myitem SELECT *
		 FROM jbitem
		 WHERE price < (SELECT AVG(price)
  				FROM jbitem);
/*
Query OK, 14 rows affected (0.01 sec)
Records: 14  Duplicates: 0  Warnings: 0
*/

/*
Question 15 Create a view that contains the items that cost less than the
average price for items.
*/
CREATE VIEW item_view AS
SELECT *
FROM myitem
WHERE myitem.price < (SELECT AVG(price)
		    FROM myitem);
/*
Query OK, 0 rows affected (0.03 sec)
*/

/*
Question 16 What is the difference between a table and a view?One is static
and the other is dynamic. Which is which and what do we mean by static
respectively dynamic?
*/

/*
A table can not be modified witout explicit manipulations therefore it
is static.
While a View only shows the values reffering to a table and therefore updates
dynamically when a manipulation hapends to the undelaying tables.
*/

/*
Question 17 Create a view, using onlytheimplicit join notation, i.e. only use
where statements but no inner join, right join orleft join statements, that
calculates the total cost of each debit, by considering price and quantity of
each bought item. (To be used for charging customer accounts). The view
should contain the sale identifier (debit) and total cost.
*/
CREATE VIEW total_debit_view AS
SELECT jbdebit.id,  SUM(jbsale.quantity * jbitem.price)
FROM jbdebit, jbsale, jbitem
WHERE jbdebit.id = jbsale.debit AND jbsale.item =jbitem.id
GROUP BY jbdebit.id;
/*
Query OK, 0 rows affected (0.04 sec)
*/

/*
Question 18 Do the same as in (17), using only theexplicit join notation, i.e.
using only left, rightorinnerjoins but no wherestatement.Motivate why you use
the join you do (left, right or inner), and why this is the correct one
(unlike the others).
*/
CREATE VIEW total_debit_view2 AS
SELECT jbdebit.id,  SUM(jbsale.quantity * jbitem.price)
FROM jbdebit INNER JOIN jbsale ON (jbdebit.id = jbsale.debit)
	     INNER JOIN jbitem ON (jbsale.item = jbitem.id)
GROUP BY jbdebit.id;
/*
Query OK, 0 rows affected (0.03 sec)
*/

/*
We use INNER JOIN beacuse we only want to
display the values that exist in all of the tables
and innerjoin should therefore be used.
*/


/*
Question 19 Oh no! An earthquake!
a)Remove all suppliers in Los Angeles from the table jbsupplier.
This will not work right away(you will receive error code 23000) which you
will have to solve by deleting some other related tuples. However, do not
delete more tuples from other tables than necessary and do not change the
structure of the tables, i.e. do not remove foreign keys.Also, remember that
you are only allowed to use “Los Angeles” as a constant in your queries,
not “199” or “900”.

b)Explain what you did and why.
*/
/*
a)

(1)This deletes all sales that has been made that relates to the supplier:
*/
DELETE
FROM jbsale
WHERE jbsale.item IN (SELECT jbitem.id
		      FROM jbitem
		      WHERE jbitem.supplier IN (SELECT jbsupplier.id
						FROM jbsupplier
						WHERE jbsupplier.city IN (SELECT id
									  FROM jbcity
									  WHERE name = 'Los Angeles')));
/*
Query OK, 1 row affected (0.01 sec)
*/

/*
(2)This Deletes all jbitems related to the supplier:
*/
DELETE
FROM jbitem
WHERE jbitem.supplier IN (SELECT jbsupplier.id
			  FROM jbsupplier
			  WHERE jbsupplier.city IN (SELECT id
						    FROM jbcity
						    WHERE name = 'Los Angeles'));

/*
Query OK, 2 rows affected (0.08 sec)
*/

/*
(3)This Deletes all items related to the supplier:
*/
DELETE
FROM myitem
WHERE myitem.supplier IN (SELECT jbsupplier.id
			FROM jbsupplier
			WHERE jbsupplier.city IN (SELECT id
						  FROM jbcity
						  WHERE name = 'Los Angeles'));

/*
Query OK, 0 rows affected (0.00 sec)
*/

/*
(4)This Deletes all suppliers in Los Angeles:
*/
Delete
FROM jbsupplier
WHERE jbsupplier.city IN (SELECT id
			  FROM jbcity
  			  WHERE name = 'Los Angeles');

/*
Query OK, 1 row affected (0.08 sec)
*/

/*
b)
(1) was used to delete all sales related to items that was supplied
by the supplier, this was needed since the sales had a foreign key
constraint to jbitems.
(2) and (3) Was then used to delete the items that had a foreign key
constraint to the supplier
(4) was used to delete the suppliers themself, which is possible
when the tuples with foreign keys to the supplier had been deleted.
*/

/*
Question 20 An employee has tried to find out which suppliers that have
delivered items that have been sold. He has created a view and a query that
shows the number of items sold from a supplier.

mysql> CREATE VIEW jbsale_supply(supplier, item, quantity) AS
	-> SELECTjbsupplier.name, jbitem.name, jbsale.quantity
	-> FROMjbsupplier, jbitem, jbsale
	-> WHEREjbsupplier.id = jbitem.supplier
	-> ANDjbsale.item = jbitem.id;
Query OK, 0 rows affected (0.01 sec)

mysql> SELECTsupplier, sum(quantity) ASsum FROMjbsale_supply
	-> GROUP BYsupplier;

	+--------------+---------------+
	| supplier		 | sum(quantity) |
	+--------------+---------------+
	| Cannon       |             6 |
	| Levi-Strauss |             1 |
	| Playskool    |             2 |
	| White Stag   |             4 |
	| Whitman's    |             2 |
	+--------------+---------------+
	5 rows in set (0.00 sec)

The employee would also like includethe suppliers which has delivered some
items, although for whom no items have been sold so far. In other words he
wants to list all suppliers, which has supplied any item, as well as the number
of these items that have been sold.
Help him!
Drop and redefine jbsale_supplyto consider suppliers that have delivered
items that have never been sold as well.
Hint: The above definition of jbsale_supplyuses an (implicit) inner join that
removes suppliers that have not had any of their delivered items sold.
*/
CREATE VIEW jbsale_supply(supplier, item, quantity) AS
SELECT jbsupplier.name, jbitem.name, coalesce(jbsale.quantity, 0)
FROM jbsupplier INNER JOIN jbitem ON (jbsupplier.id = jbitem.supplier)
                LEFT JOIN jbsale ON jbitem.id = jbsale.item;
/*
Query OK, 0 rows affected (0.04 sec)
*/

SELECT supplier, sum(quantity) AS sum
FROM jbsale_supply
GROUP BY supplier;

/*
+--------------+------+
| supplier     | sum  |
+--------------+------+
| Cannon       |    6 |
| Fisher-Price |    0 |
| Levi-Strauss |    1 |
| Playskool    |    2 |
| White Stag   |    4 |
| Whitman's    |    2 |
+--------------+------+
6 rows in set (0.00 sec)

*/
