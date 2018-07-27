"""
Database Normalization

When creating a database, it is really important to think about how data will be stored.
This is known as normalization, and it is a huge part of most SQL classes.
If you are in charge of setting up a new database, it is important to have a thorough understanding of database normalization.

There are essentially three ideas that are aimed at database normalization:

    Are the tables storing logical groupings of the data?
    Can I make changes in a single location, rather than in many tables for the same information?
    Can I access and manipulate data quickly and efficiently?


However, most analysts are working with a database that was already set up with the necessary properties in place.
As analysts of data, you don 't really need to think too much about data normalization.
You just need to be able to pull the data from the database, so you can start drawing insights.
"""
"""
JOINs are useful for allowing us to pull data from multiple tables. This is both simple and powerful all at the same time.
The JOIN introduces the second table from which you would like to pull data,
and the ON tells you how you would like to merge the tables in the FROM and JOIN statements together.
"""
SELECT orders.*,
       account.*
FROM orders
JOIN accounts
ON orders.account_id = accounts.id;
"""
we are only pulling data from the orders table since in the SELECT statement we only reference columns from the orders table.
"""
SELECT orders.*
FROM orders
JOIN accounts
ON orders.account_id = accounts.id;
"""
If we wanted to only pull individual elements from either the orders or accounts table,
we can do this by using the exact same information in the FROM and ON statements.
However, in your SELECT statement, you will need to know how to specify tables and columns in the SELECT statement:

    The table name is always before the period.
    The column you want from that table is always after the period.

For example, if we want to pull only the account name and the dates in which that account placed an order,
but none of the other columns, we can do this with the following query:
"""
SELECT accounts.name, orders.occurred_at
FROM orders
JOIN accounts
ON orders.account_id = accounts.id;
"""
This query only pulls two columns, not all the information in these two tables.
Alternatively, the below query pulls all the columns from both the accounts and orders table.
"""
SELECT *
FROM orders
JOIN accounts
ON orders.account_id = accounts.id;
"""
And the first query you ran pull all the information from only the orders table:
"""
SELECT orders.*
FROM orders
JOIN accounts
ON orders.account_id = accounts.id;
"""
Joining tables allows you access to each of the tables in the SELECT statement through the table name,
and the columns will always follow a . after the table name.
Notice this result is the same as if you switched the tables in the FROM and JOIN.
Additionally, which side of the = a column is listed doesn't matter.
"""
SELECT orders.standard_qty ,
	   orders.gloss_qty,
	   orders.poster_qty,
	   accounts.website,
       accounts.primary_poc
FROM orders
JOIN accounts
ON orders.account_id=accounts.id;
"""
PK is associated with the first column in every table.
The PK here stands for primary key. A primary key exists in every table,
and it is a column that has a unique value for every row.

If you look at the first few rows of any of the tables in our database,
you will notice that this first, PK, column is always unique. For this database it is always called id, but that is not true of all databases.
Foreign Key (FK)

A foreign key is when we see a primary key in another table. We can see these in the previous ERD the foreign keys are provided as:

    region_id
    account_id
    sales_rep_id

Each of these is linked to the primary key of another table this is the primary-foreign key link that connects these two tables.
Notice our SQL query has the two tables we would like to join - one in the FROM and the other in the JOIN.
Then in the ON, we will ALWAYs have the PK equal to the FK
"""
"""
Joining 3 tables
"""
SELECT *
FROM web_events
JOIN accounts
ON web_events.account_id = accounts.id
JOIN orders
ON accounts.id = orders.account_id
"""
When we JOIN tables together, it is nice to give each table an alias.
Frequently an alias is just the first letter of the table name.
 You actually saw something similar for column names in the Arithmetic Operators concept.

Example:

FROM tablename AS t1
JOIN tablename2 AS t2

Before, you saw something like:

SELECT col1 + col2 AS total, col3

Frequently, you might also see these statements without the AS statement.
 Each of the above could be written in the following way instead, and they would still produce the exact same results:

FROM tablename t1
JOIN tablename2 t2

and

SELECT col1 + col2 total, col3

Aliases for Columns in Resulting Table

While aliasing tables is the most common use case. It can also be used to alias the columns selected to have the resulting table reflect a more readable name.

Example:

Select t1.column1 aliasname, t2.column2 aliasname2
FROM tablename AS t1
JOIN tablename2 AS t2

The alias name fields will be what shows up in the returned table instead of t1.column1 and t2.column2
aliasname 	aliasname2
example row 	example row
example row 	example row
"""
"""
Provide a table for all web_events associated with account name of Walmart.
There should be three columns. Be sure to include the primary_poc, time of the event, and the channel for each event.
Additionally, you might choose to add a fourth column to assure only Walmart events were chosen.
"""
SELECT web_events.occurred_at,
	   web_events.channel,
	   accounts.primary_poc
FROM web_events
JOIN accounts
ON web_events.account_id= accounts.id
WHERE accounts.name='Walmart';

SELECT a.primary_poc, w.occurred_at, w.channel, a.name
FROM web_events w
JOIN accounts a
ON w.account_id = a.id
WHERE a.name = 'Walmart';
"""
Provide a table that provides the region for each sales_rep along with their associated accounts.
Your final table should include three columns: the region name, the sales rep name, and the account name.
Sort the accounts alphabetically (A-Z) according to account name.
I had to do aliazing for names because it would make only one column
"""
SELECT sales_reps.name Name1,
	   region.name Name2,
	   accounts.name Name3
FROM sales_reps
JOIN region
ON sales_reps.region_id = region.id
JOIN accounts
ON accounts.sales_rep_id=sales_reps.id
ORDER BY Name3,

SELECT r.name region, s.name rep, a.name account
FROM sales_reps s
JOIN region r
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
ORDER BY a.name;
"""
Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order.
Your final table should have 3 columns: region name, account name, and unit price.
A few accounts have 0 for total, so I divided by (total + 0.01) to assure not dividing by zero.
"""
SELECT region.name region_name,
	     accounts.name account_name,
      orders.total_amt_usd/(orders.total+0.01) unit_price
FROM sales_reps
JOIN region
ON sales_reps.region_id = region.id
JOIN accounts
ON accounts.sales_rep_id=sales_reps.id
JOIN orders
ON orders.account_id=accounts.id,

SELECT r.name region, a.name account,
       o.total_amt_usd/(o.total + 0.01) unit_price
FROM region r
JOIN sales_reps s
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id;
"""
You have had a bit of an introduction to these one-to-one and one-to-many relationships when we introduced PKs and FKs.
One account may have place for a single order -->one to one
or another account may have place for many orders --->many to one
the one between Authors and Books. An author can write many books. A book could have many authors -->many to many
Notice, traditional databases do not allow for many-to-many relationships, as these break the schema down pretty quickly.
A very good answer is provided here.
  https://stackoverflow.com/questions/7339143/why-no-many-to-many-relationships

The types of relationships that exist in a database matter less to analysts, but you do need to understand why you would perform different types of JOINs,
and what data you are pulling from the database. These ideas will be expanded upon in the next concepts.
"""
"""
Join types :
inner join
left join = LEFT OUTER JOIN
right join
full outer join = OUTER JOIN ---A full outer join will return everything an inner join does and return all unmatched rows from each table
Notice each of these new JOIN statements pulls all the same rows as an INNER JOIN,
 which you saw by just using JOIN, but they also potentially pull some additional rows.

If there is not matching information in the JOINed table, then you will have columns with empty cells.
These empty cells introduce a new data type called NULL
"""
SELECT c.countryid, c.countryName, s.stateName
FROM Country c
JOIN State s
ON c.countryid = s.countryid;

SELECT c.countryid, c.countryName, s.stateName
FROM Country c
LEFT JOIN State s
ON c.countryid = s.countryid;
"""
A simple rule to remember this is that, when the database executes the following query,
it executes the join and everything in the ON clause first.
Think of this as building the new result set. That result set is then filtered using the WHERE clause.

The fact that this example is a left join is important.
Because inner joins only return the rows for which the two tables match,
moving this filter to the ON clause of an inner join (using and) will produce the same result as keeping it in the WHERE clause.

logic on the ON clause produces the rows before combining the tables
and statement before join clause filters before joining rather than after
if we want to mark all the sales_reps_id=321500 and keep all other orders in the result as well

"""


SELECT *
FROM orders
LEFT JOIN accounts
ON orders.account_id = accounts.id
WHERE accounts.sales_rep_id=321500;

SELECT *
FROM orders
LEFT JOIN accounts
ON orders.account_id = accounts.id
   AND accounts.sales_rep_id=321500;
"""
Provide a table that provides the region for each sales_rep along with their associated accounts.
This time only for the Midwest region. Your final table should include three columns: the region name, the sales rep name, and the account name.
Sort the accounts alphabetically (A-Z) according to account name.
"""
SELECT a.name a,r.name r,s.name s
FROM region r
JOIN sales_reps s
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
WHERE r.name='Midwest'
ORDER BY a
"""
Provide a table that provides the region for each sales_rep along with their associated accounts.
This time only for accounts where the sales rep has a first name starting with S and in the Midwest region.
Your final table should include three columns: the region name, the sales rep name, and the account name.
Sort the accounts alphabetically (A-Z) according to account name.

"""
SELECT a.name a,r.name r,s.name s
FROM region r
JOIN sales_reps s
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
WHERE r.name = 'Midwest' AND s.name LIKE 'S%'
ORDER BY a
"""
Provide a table that provides the region for each sales_rep along with their associated accounts.
This time only for accounts where the sales rep has a last name starting with K and in the Midwest region.
Your final table should include three columns: the region name, the sales rep name, and the account name.
Sort the accounts alphabetically (A-Z) according to account name.
"""


SELECT r.name region, s.name rep, a.name account
FROM sales_reps s
JOIN region r
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
WHERE r.name = 'Midwest' AND s.name LIKE '% K%'
ORDER BY a.name;
"""
Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order.
However, you should only provide the results if the standard order quantity exceeds 100.
Your final table should have 3 columns: region name, account name, and unit price.
In order to avoid a division by zero error, adding .01 to the denominator here is helpful total_amt_usd/(total+0.01).
"""
SELECT r.name region, a.name account, (o.total_amt_usd/(o.total+0.01)) unit_price
FROM sales_reps s
JOIN region r
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON a.id=o.account_id
WHERE  o.standard_qty>100;
"""
Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order.
However, you should only provide the results if the standard order quantity exceeds 100 and the poster order quantity exceeds 50.
Your final table should have 3 columns: region name, account name, and unit price. Sort for the smallest unit price first.
"""
SELECT r.name region, a.name account, (o.total_amt_usd/(o.total+0.01)) unit_price
FROM sales_reps s
JOIN region r
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON a.id=o.account_id
WHERE  o.standard_qty>100 and o.poster_qty>50
ORDER BY unit_price
"""
Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order.
However, you should only provide the results if the standard order quantity exceeds 100 and the poster order quantity exceeds 50.
Your final table should have 3 columns: region name, account name, and unit price. Sort for the largest unit price first.
"""
SELECT r.name region, a.name account, (o.total_amt_usd/(o.total+0.01)) unit_price
FROM sales_reps s
JOIN region r
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON a.id=o.account_id
WHERE  o.standard_qty>100 and o.poster_qty>50
ORDER BY unit_price DESC
"""
What are the different channels used by account id 1001?
Your final table should have only 2 columns: account name and the different channels.
You can try SELECT DISTINCT to narrow down the results to only the unique values.
"""
SELECT a.name, w.channel
FROM web_events w
JOIN accounts a
ON w.account_id = a.id
WHERE a.id=1001
"""
Find all the orders that occurred in 2015.
Your final table should have 4 columns: occurred_at, account name, order total, and order total_amt_usd.
"""
SELECT o.occurred_at, a.name, o.total, o.total_amt_usd
FROM accounts a
JOIN orders o
ON o.account_id = a.id
WHERE o.occurred_at BETWEEN '01-01-2015' AND '01-01-2016'
ORDER BY o.occurred_at DESC;
"""
Recap
Primary and Foreign Keys

You learned a key element for JOINing tables in a database has to do with primary and foreign keys:

    primary keys - are unique for every row in a table. These are generally the first column in our database.

    foreign keys - are the primary key appearing in another table, which allows the rows to be non-unique.

Choosing the set up of data in our database is very important, but not usually the job of a data analyst.
This process is known as Database Normalization.

JOINs

In this lesson, you learned how to combine data from multiple tables using JOINs. The three JOIN statements you are most likely to use are:

    JOIN - an INNER JOIN that only pulls data that exists in both tables.
    LEFT JOIN - a way to pull all of the rows from the table in the FROM even if they do not exist in the JOIN statement.
    RIGHT JOIN - a way to pull all of the rows from the table in the JOIN even if they do not exist in the FROM statement.

There are a few more advanced JOINs that we did not cover here, and they are used in very specific use cases.
UNION and UNION ALL, CROSS JOIN, and the tricky SELF JOIN.
These are more advanced than this course will cover, but it is useful to be aware that they exist, as they are useful in special cases.

Alias

You learned that you can alias tables and columns using AS or not using it.
This allows you to be more efficient in the number of characters you need to write, while at the same time you can assure that your column headings are informative of the data in your table.

Looking Ahead

The next lesson is aimed at aggregating data. You have already learned a ton, but SQL might still feel a bit disconnected from statistics and using Excel like platforms.
Aggregations will allow you to write SQL code that will allow for more complex queries, which assist in answering questions like:

    Which channel generated more revenue?
    Which account had an order with the most items?
    Which sales_rep had the most orders? or least orders? How many orders did they have?

"""
