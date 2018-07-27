"""
Write a query to return the 10 earliest orders in the orders table. Include the id, occurred_at, and total_amt_usd.
"""
    SELECT id, occurred_at, total_amt_usd
    FROM orders
    ORDER BY occurred_at
    LIMIT 10;
"""
Write a query to return the top 5 orders in terms of largest total_amt_usd. Include the id, account_id, and total_amt_usd.
"""
    SELECT id, account_id, total_amt_usd
    FROM orders
    ORDER BY total_amt_usd DESC
    LIMIT 5;
"""
Write a query to return the bottom 20 orders in terms of least total. Include the id, account_id, and total
"""
    SELECT id, account_id, total
    FROM orders
    ORDER BY total
    LIMIT 20;
"""
we can ORDER BY more than one column at a time. The statement sorts according to
 columns listed from left first and those listed on the right after that.
 We still have the ability to flip the way we order using DESC.
"""
SELECT total_amt_usd,occurred_at
FROM orders
ORDER BY occurred_at DESC,total_amt_usd DESC
LIMIT 5
"""

Write a query that returns the top 10 rows from orders ordered according
 to oldest to newest, but with the smallest total_amt_usd for each date
 listed first for each date. You will notice each of these dates shows up
 as unique because of the time element. When you learn about truncating dates
 in a later lesson, you will better be able to tackle this question on a day, month,
  or yearly basis.
  """
  SELECT total_amt_usd,occurred_at
FROM orders
ORDER BY occurred_at ,total_amt_usd
LIMIT 10;

"""
Pull the first 5 rows and all columns from the orders table
that have a dollar amount of gloss_amt_usd greater than or equal to 1000.
"""
SELECT *
FROM orders
WHERE gloss_amt_usd>= 1000
LIMIT 5;
"""
Pull the first 10 rows and all columns from the orders table
 that have a total_amt_usd less than 500.
"""
SELECT *
FROM orders
WHERE total_amt_usd< 500
LIMIT 10;
"""
The WHERE statement can also be used with non-numerical data.
We can use the = and != operators here. You also need to be sure to use
single quotes (just be careful if you have quotes in the original text)
with the text data.

Commonly when we are using WHERE with non-numeric data fields,
 we use the LIKE, NOT, or IN operators.
"""
"""
Filter the accounts table to include the company name, website,
 and the primary point of contact (primary_poc) for Exxon Mobil in the accounts table
"""
SELECT name, website,primary_poc
FROM accounts
WHERE name='Exxon Mobil'
"""
Derived Columns

Creating a new column that is a combination of existing columns is known as a derived column.

Common operators include:

    * (Multiplication)
    + (Addition)
    - (Subtraction)
    / (Division)

"""
"""
Create a column that divides the standard_amt_usd by the standard_qty to find
the unit price for standard paper for each order. Limit the results to the first 10 orders,
 and include the id and account_id fields.
"""
SELECT id,
	   account_id,
       standard_amt_usd,
       standard_qty,
       standard_amt_usd/standard_qty AS nonstandard_qty
FROM orders
LIMIT 10;
"""
Write a query that finds the percentage of
revenue that comes from poster paper for each order.
You will need to use only the columns that end with _usd.
(Try to do this without using the total column). Include the id and account_id fields.
NOTE - you will be thrown an error with the correct solution to this question. This is for a division by zero.
You will learn how to get a solution without an error to this query when you learn about CASE statements in a later section.
For now, you might just add some very small value to your denominator as a work around.

Notice, the above operators combine information across columns for the same row. If you want to combine values of a particular column,
across multiple rows, we will do this with aggregations.
"""
SELECT id, account_id,
       poster_amt_usd/(standard_amt_usd + gloss_amt_usd + poster_amt_usd) AS post_per
FROM orders;
"""
introduction to Logical Operators

In the next concepts, you will be learning about Logical Operators. Logical Operators include:

    LIKE
    This allows you to perform operations similar to using WHERE and =, but for cases when you might not know exactly what you are looking for.

    IN
    This allows you to perform operations similar to using WHERE and =, but for more than one condition.

    NOT
    This is used with IN and LIKE to select all of the rows NOT LIKE or NOT IN a certain condition.

    AND & BETWEEN
    These allow you to combine operations where all combined conditions must be true.

    OR
    This allow you to combine operations where at least one of the combined conditions must be true.

"""
"""
The LIKE operator is extremely useful for working with text.
You will use LIKE within a WHERE clause. The LIKE operator is frequently used with %.
The % tells us that we might want any number of characters leading up to a particular set of characters
or following a certain set of characters, as we saw with the google syntax above.
remember you will need to use single quotes for the text you pass to the LIKE operator,
because of this lower and uppercase letters are not the same within the string.
Searching for 'T' is not the same as searching for 't'.
In other SQL environments (outside the classroom), you can use either single or double quotes.
"""
"""
Use the accounts table to find

    All the companies whose names start with 'C'.

    All companies whose names contain the string 'one' somewhere in the name.

    All companies whose names end with 's'.

"""
SELECT *
FROM accounts
WHERE name LIKE 'C%';
SELECT *
FROM accounts
WHERE name LIKE '%one%';
SELECT *
FROM accounts
WHERE name LIKE '%s';
"""
The IN operator is useful for working with both numeric and text columns.
This operator allows you to use an =, but for more than one item of that particular column.
We can check one, two or many column values for which we want to pull data, but all within the same query.
In most SQL environments, you can use single or double quotation marks -
and you may NEED to use double quotation marks if you have an apostrophe within the text you are attempting to pull.
note you can include an apostrophe by putting two single quotes together.
Example Macy's in our work space would be
'Macy<put double quotes here>s'.
"""
"""
Use the accounts table to find the account name, primary_poc, and sales_rep_id for Walmart, Target, and Nordstrom.
"""
SELECT name,
	   primary_poc,
       sales_rep_id
FROM accounts
WHERE  name in ('Walmart', 'Target','Nordstrom');
"""
Use the web_events table to find all information regarding individuals who were contacted via the channel of organic or adwords.
"""
SELECT *
FROM web_events
WHERE channel in ('organic','adwords');

"""
The NOT operator is an extremely useful operator for working with the previous two operators we introduced: IN and LIKE.
By specifying NOT LIKE or NOT IN, we can grab all of the rows that do not meet a particular criteria.
"""
"""
We can pull all of the rows that were excluded from the queries in the previous two concepts with our new operator.

    Use the accounts table to find the account name, primary poc, and sales rep id for all stores except Walmart, Target, and Nordstrom.

    Use the web_events table to find all information regarding individuals who were contacted via any method except using organic or adwords methods.

Use the accounts table to find:

    All the companies whose names do not start with 'C'.

    All companies whose names do not contain the string 'one' somewhere in the name.

    All companies whose names do not end with 's'.

"""
SELECT name,primary_poc,sales_rep_id
FROM accounts
where name NOT IN ('Walmart', 'Target','Nordstrom');

SELECT *
FROM web_events
where channel NOT IN ('organic', 'adwords');

SELECT *
FROM accounts
WHERE name NOT LIKE 'C%';

SELECT *
FROM accounts
WHERE name NOT LIKE '%one%';

SELECT *
FROM accounts
WHERE name NOT LIKE '%s';
"""
The AND operator is used within a WHERE statement to consider more than one logical clause at a time.
Each time you link a new statement with an AND, you will need to specify the column you are interested in looking at.
You may link as many statements as you would like to consider at the same time.
This operator works with all of the operations we have seen so far including arithmetic operators (+, *, -, /). LIKE, IN, and NOT logic can also be linked together using the AND operator.
BETWEEN Operator

Sometimes we can make a cleaner statement using BETWEEN than we can using AND.
Particularly this is true when we are using the same column for different parts of our AND statement.

Instead of writing :

WHERE column >= 6 AND column <= 10

we can instead write, equivalently:

WHERE column BETWEEN 6 AND 10

"""
"""
Write a query that returns all the orders where the standard_qty is over 1000, the poster_qty is 0, and the gloss_qty is 0.

Using the accounts table find all the companies whose names do not start with 'C' and end with 's'.

Use the web_events table to find all information regarding individuals who were contacted via organic or adwords
and started their account at any point in 2016 sorted from newest to oldest.
"""
SELECT *
FROM orders
WHERE standard_qty>1000
	  AND poster_qty=0
      AND gloss_qty=0;

SELECT *
FROM accounts
WHERE name LIKE '%s'
	  AND name LIKE 'C%';

SELECT *
FROM web_events
WHERE channel IN ('organic', 'adwords')
      AND occurred_at BETWEEN '2016-01-01' AND '2017-01-01'
ORDER BY occurred_at DESC;

SELECT *
FROM web_events
where channel IN ('organic', 'adwords')
	    AND occurred_at >='2016-01-01'
      AND occurred_at <'2017-01-01'
      ORDER BY occurred_at DESC;
"""
Find list of orders ids where either gloss_qty or poster_qty is greater than 4000. Only include the id field in the resulting table.

Write a query that returns a list of orders where the standard_qty is zero and either the gloss_qty or poster_qty is over 1000.

Find all the company names that start with a 'C' or 'W', and the primary contact contains 'ana' or 'Ana', but it doesn't contain 'eana'.
"""
SELECT id
FROM orders
WHERE gloss_qty>4000 or poster_qty>4000;

SELECT*
FROM orders
WHERE standard_qty=0
	  AND (gloss_qty>1000 OR poster_qty>1000) ;

SELECT *
FROM accounts
WHERE (name LIKE 'C%' OR name LIKE 'W%')
       AND ((primary_poc LIKE '%ana%' OR primary_poc LIKE '%Ana%')
           AND primary_poc NOT LIKE '%eana%');

"""
Recap
Commands


Statement 	How to Use It 	Other Details
SELECT 	SELECT Col1, Col2, ... 	Provide the columns you want
FROM 	FROM Table 	Provide the table where the columns exist
LIMIT 	LIMIT 10 	Limits based number of rows returned
ORDER BY 	ORDER BY Col 	Orders table based on the column. Used with DESC.
WHERE 	WHERE Col > 5 	A conditional statement to filter your results
LIKE 	WHERE Col LIKE '%me%' 	Only pulls rows where column has 'me' within the text
IN 	WHERE Col IN ('Y', 'N') 	A filter for only rows with column of 'Y' or 'N'
NOT 	WHERE Col NOT IN ('Y', 'N') 	NOT is frequently used with LIKE and IN
AND 	WHERE Col1 > 5 AND Col2 < 3 	Filter rows where two or more conditions must be true
OR 	WHERE Col1 > 5 OR Col2 < 3 	Filter rows where at least one condition must be true
BETWEEN 	WHERE Col BETWEEN 3 AND 5 	Often easier syntax than using an AND
Other Tips

Though SQL is not case sensitive (it doesn't care if you write your statements as all uppercase or lowercase), we discussed some best practices.
 The order of the key words does matter! Using what you know so far, you will want to write your statements as:

SELECT col1, col2
FROM table1
WHERE col3  > 5 AND col4 LIKE '%os%'
ORDER BY col5
LIMIT 10;

Notice, you can retrieve different columns than those being used in the ORDER BY and WHERE statements.
Assuming all of these column names existed in this way (col1, col2, col3, col4, col5) within a table called table1,
this query would run just fine.
"""
