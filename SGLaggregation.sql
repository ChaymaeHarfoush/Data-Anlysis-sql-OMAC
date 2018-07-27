
"""
NULLs are a datatype that specifies where no data exists in SQL.
They are often ignored in our aggregation functions, which you will get a first look at in the next concept using COUNT.
Notice that NULLs are different than a zero - they are cells where data does not exist.

When identifying NULLs in a WHERE clause, we write IS NULL or IS NOT NULL. We don't use =,
because NULL isn't considered a value in SQL. Rather, it is a property of the data.
NULLs - Expert Tip

There are two common ways in which you are likely to encounter NULLs:

    NULLs frequently occur when performing a LEFT or RIGHT JOIN. You saw in the last lesson -
    when some rows in the left table of a left join are not matched with rows in the right table,
    those rows will contain some NULL values in the result set.

    NULLs can also occur from simply missing data in our database.


"""
SELECT *
FROM accounts
WHERE primary_poc IS NULL
"""
to get the inverse use
"""
WHERE primary_poc IS NOT NULL
"""
COUNT the Number of Rows in a Table

Try your hand at finding the number of rows in each table. Here is an example of finding all the rows in the accounts table.
the count() functuion is returning the count of all rows that contains some none null data which is unusual so the account produced by
COUNT(*) is tepicallt equal to the number of rows in the table
Notice that COUNT does not consider rows that have NULL values.
 Therefore, this can be useful for quickly identifying which rows have missing data.
 You will learn GROUP BY in an upcoming concept, and then each of these aggregators will become much more useful.
"""
SELECT COUNT(*)
FROM accounts;
"""
But we could have just as easily chosen a column to drop into the aggregation function:
"""
SELECT COUNT(accounts.id)
FROM accounts;
"""
Unlike COUNT, you can only use SUM on numeric columns.
However, SUM will ignore NULL values, and read them as zero.

Aggregation Reminder

An important thing to remember: aggregators only aggregate vertically - the values of a column.
If you want to perform a calculation across rows, you would do this with simple arithmetic.

We saw this in the first lesson if you need a refresher
"""
"""

    Find the total amount of poster_qty paper ordered in the orders table.

    Find the total amount of standard_qty paper ordered in the orders table.

    Find the total dollar amount of sales using the total_amt_usd in the orders table.

    Find the total amount spent on standard_amt_usd and gloss_amt_usd paper for each order in the orders table.
    This should give a dollar amount for each order in the table.

    Find the standard_amt_usd per unit of standard_qty paper. Your solution should use both an aggregation and a mathematical operator.

"""
"""
I GOT THIS ERROR FOR THE FOLLOWING CODE:
column orders.standard_amt_usd must appear in the GROUP BY clause or be used in an aggregate function
While his answer was to put each line alone with a new select
the reason is that while using SUM() we are collapsing all rows in a single rows  but total_standard_gloss column doesn't seems to be
collapsed like the coulmns that have been aggregated, the query isn't sure whether it have to sum this coulmn also or whethere to make it into grouping

"""
SELECT SUM(poster_qty) AS total_poster_sales,
SUM(standard_qty)  AS total_standard_sales,
SUM( total_amt_usd) AS total_dollar_sales,
standard_amt_usd + gloss_amt_usd AS total_standard_gloss,
SUM(standard_amt_usd)/SUM(standard_qty) AS standard_price_per_unit
FROM orders
"""
MIN and MAX are similar to COUNT in that they can be used on non-numerical columns.
Depending on the column type, MIN will return the lowest number, earliest date, or non-numerical value as early in the alphabet as possible.
As you might suspect, MAX does the opposite—it returns the highest number, the latest date, or the non-numerical value closest alphabetically to “Z.”

Similar to other software AVG returns the mean of the data -
that is the sum of all of the values in the column divided by the number of values in a column.
This aggregate function again ignores the NULL values in both the numerator and the denominator.

If you want to count NULLs as zero, you will need to use SUM and COUNT.
However, this is probably not a good idea if the NULL values truly just represent unknown values for a cell.

MEDIAN - Expert Tip

One quick note that a median might be a more appropriate measure of center for this data,
 but finding the median happens to be a pretty difficult thing to get using SQL alone —
 so difficult that finding a median is occasionally asked as an interview question.

"""
"""

    When was the earliest order ever placed? You only need to return the date.

    Try performing the same query as in question 1 without using an aggregation function.

    When did the most recent (latest) web_event occur?

    Try to perform the result of the previous query without using an aggregation function.

    Find the mean (AVERAGE) amount spent per order on each paper type, as well as the mean amount of each paper type purchased per order.
    Your final answer should have 6 values - one for each paper type for the average number of sales, as well as the average amount.

    you might be interested in how to calculate the MEDIAN. Though this is more advanced than what we have covered so far try finding -
    what is the MEDIAN total_usd spent on all orders?
    Since there are 6912 orders - we want the average of the 3457 and 3456 order amounts when ordered. This is the average of 2483.16 and 2482.55.
    This gives the median of 2482.855. This obviously isn't an ideal way to compute. If we obtain new orders, we would have to change the limit.
    SQL didn't even calculate the median for us. The following used a SUBQUERY, but you could use any method to find the two necessary values,
    and then you just need the average of them.

"""

SELECT MIN(occurred_at)
FROM orders;

SELECT occurred_at
FROM orders
ORDER BY occurred_at
LIMIT 1;

SELECT MIN(occurred_at)
FROM web_events;

SELECT MIN(occurred_at)
FROM web_events;
ORDER BY occurred_at
LIMIT 1;

SELECT AVG(standard_qty) mean_standard, AVG(gloss_qty) mean_gloss,
           AVG(poster_qty) mean_poster, AVG(standard_amt_usd) mean_standard_usd,
           AVG(gloss_amt_usd) mean_gloss_usd, AVG(poster_amt_usd) mean_poster_usd
FROM orders;

SELECT *
FROM (SELECT total_amt_usd
      FROM orders
      ORDER BY total_amt_usd
      LIMIT 3457) AS Table1
ORDER BY total_amt_usd DESC
LIMIT 2;

"""
The key takeaways here:

    GROUP BY can be used to aggregate data within subsets of the data.
    For example, grouping for different accounts, different regions, or different sales representatives.

    Any column in the SELECT statement that is not within an aggregator must be in the GROUP BY clause.

    The GROUP BY always goes between WHERE and ORDER BY.

    ORDER BY works like SORT in spreadsheet software.

GROUP BY - Expert Tip

Before we dive deeper into aggregations using GROUP BY statements,
it is worth noting that SQL evaluates the aggregations before the LIMIT clause.
If you don’t group by any columns, you’ll get a 1-row result—no problem there.
If you group by a column with enough unique values that it exceeds the LIMIT number,
the aggregates will be calculated, and then some rows will simply be omitted from the results.

This is actually a nice way to do things because you know you’re going to get the correct aggregates.
If SQL cuts the table down to 100 rows, then performed the aggregations, your results would be substantially different.
"""

"""

    Which account (by name) placed the earliest order? Your solution should have the account name and the date of the order.

    Find the total sales in usd for each account. You should include two columns -
    the total sales for each company's orders in usd and the company name.

    Via what channel did the most recent (latest) web_event occur,
    which account was associated with this web_event?
    Your query should return only three values - the date, channel, and account name.

    Find the total number of times each type of channel from the web_events was used.
    Your final table should have two columns - the channel and the number of times the channel was used.

    Who was the primary contact associated with the earliest web_event?

    What was the smallest order placed by each account in terms of total usd.
    Provide only two columns - the account name and the total usd. Order from smallest dollar amounts to largest.

    Find the number of sales reps in each region. Your final table should have two columns -
    the region and the number of sales_reps. Order from fewest reps to most reps.

"""

SELECT a.name,
MIN(o.occurred_at) dates
FROM accounts a
JOIN orders o
ON o.account_id = a.id
GROUP BY a.name
ORDER BY dates
LIMIT 1;
"""
the following code gives the same answer as the above one but it's of course simpler
"""
SELECT a.name, o.occurred_at
FROM accounts a
JOIN orders o
ON a.id = o.account_id
ORDER BY occurred_at
LIMIT 1;


SELECT a.name, SUM(total_amt_usd) total_sales
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY a.name;

SELECT a.name, w.occurred_at ,w.channel
FROM accounts a
JOIN web_events w
ON w.account_id = a.id
ORDER BY w.occurred_at
LIMIT 1;

SELECT w.channel, COUNT(w.channel)
FROM web_events w
GROUP BY w.channel;
"""
it's the same
SELECT w.channel, COUNT(*)
FROM web_events w
GROUP BY w.channel;
"""

SELECT a.primary_poc
FROM accounts a
JOIN web_events w
ON w.account_id = a.id
ORDER BY w.occurred_at
LIMIT 1;

SELECT MIN(o.total_amt_usd) smallest_order,a.name account
FROM accounts a
JOIN orders o
ON o.account_id = a.id
GROUP BY a.name
ORDER BY smallest_order;

SELECT r.name,COUNT(s.id) number_sales_reps
FROM sales_reps s
JOIN region r
ON s.region_id = r.id
GROUP BY r.name
ORDER BY number_sales_reps;

"""
it's the same because after making join we are having repition in r. name coulmn
SELECT r.name, COUNT(*) num_reps
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
GROUP BY r.name
ORDER BY num_reps;
"""
"""
Key takeaways:

    You can GROUP BY multiple columns at once,
    This is often useful to aggregate across a number of different segments.

    The order of columns listed in the ORDER BY clause does make a difference.
    You are ordering the columns from left to right.

GROUP BY - Expert Tips

    The order of column names in your GROUP BY clause doesn’t matter—the results will be the same regardless.
    If we run the same query and reverse the order in the GROUP BY clause.

    As with ORDER BY, you can substitute numbers for column names in the GROUP BY clause.
    It’s generally recommended to do this only when you’re grouping many columns,
    or if something else is causing the text in the GROUP BY clause to be excessively long.

    A reminder here that any column that is not within an aggregation must show up in your GROUP BY statement.
    If you forget, you will likely get an error.
    However, in the off chance that your query does work, you might not like the results!
"""
"""
In the following example we are counting the number of times each account_id occurred
(the number of times the same account shown up in the web_events regardless of the used channel or site)
"""
SELECT account_id,COUNT(id) AS  events
FROM web_events
GROUP BY account_id
ORDER BY account_id, events DESC;
"""
in this one we are counting the number of times each account id have choosen the same channel in the web_events
"""

SELECT account_id,channel,COUNT(id) AS  events
FROM web_events
GROUP BY account_id,channel
ORDER BY account_id, events DESC

"""
For each account, determine the average amount of each type of paper they purchased across their orders.
Your result should have four columns - one for the account name and one for the average quantity purchased
for each of the paper types for each account.

For each account, determine the average amount spent per order on each paper type.
Your result should have four columns - one for the account name and one for the average amount spent on each paper type.

Determine the number of times a particular channel was used in the web_events table for each sales rep.
Your final table should have three columns - the name of the sales rep, the channel, and the number of occurrences.
Order your table with the highest number of occurrences first.

Determine the number of times a particular channel was used in the web_events table for each region.
Your final table should have three columns - the region name, the channel, and the number of occurrences.
Order your table with the highest number of occurrences first.
"""
SELECT a.name account,
AVG(o.standard_qty ) str,
AVG(o.gloss_qty ) gloss,
AVG(o.poster_qty ) poster
FROM accounts a
JOIN orders o
ON a.id= o.account_id
GROUP BY account;

SELECT a.name account,
AVG(o.standard_amt_usd ) str,
AVG(o.gloss_amt_usd ) gloss,
AVG(o.poster_amt_usd ) poster
FROM accounts a
JOIN orders o
ON a.id= o.account_id
GROUP BY account;

""" we could replace COUNT(W.channel) by COUNT(*) in the following 2 solutions it gives the same ansewer """
SELECT s.name,w.channel,COUNT(w.channel) AS  events
FROM sales_reps s
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN web_events w
ON w.account_id=a.id
GROUP BY s.name,w.channel
ORDER BY s.name, events DESC;

SELECT r.name,w.channel,COUNT(w.channel) AS  events
FROM sales_reps s
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN web_events w
ON w.account_id=a.id
JOIN region r
ON r.id=s.region_id
GROUP BY r.name,w.channel
ORDER BY r.name, events DESC;

"""
DISTINCT is always used in SELECT statements, and it provides the unique rows for all columns written in the SELECT statement. Therefore, you only use DISTINCT once in any particular SELECT statement.

You could write:

SELECT DISTINCT column1, column2, column3
FROM table1;

which would return the unique (or DISTINCT) rows across all three columns.

You would not write:

SELECT DISTINCT column1, DISTINCT column2, DISTINCT column3
FROM table1;

You can think of DISTINCT the same way you might think of the statement "unique".
DISTINCT - Expert Tip

It’s worth noting that using DISTINCT, particularly in aggregations, can slow your queries down quite a bit.

"""

"""
    Use DISTINCT to test if there are any accounts associated with more than one region.
    The below two queries have the same number of resulting rows (351),
    so we know that every account is associated with only one region.
    If each account was associated with more than one region,
    the first query should have returned more rows than the second query.
"""
    SELECT a.id as "account id", r.id as "region id",
    a.name as "account name", r.name as "region name"
    FROM accounts a
    JOIN sales_reps s
    ON s.id = a.sales_rep_id
    JOIN region r
    ON r.id = s.region_id;


    SELECT DISTINCT id, name
    FROM accounts;
"""
    Have any sales reps worked on more than one account?

    Actually all of the sales reps have worked on more than one account.
    The fewest number of accounts any sales rep works on is 3.
    There are 50 sales reps, and they all have more than one account.
    Using DISTINCT in the second query assures that all of the sales reps are accounted for in the first query.
"""
    SELECT s.id, s.name, COUNT(*) num_accounts
    FROM accounts a
    JOIN sales_reps s
    ON s.id = a.sales_rep_id
    GROUP BY s.id, s.name
    ORDER BY num_accounts;


    SELECT DISTINCT id, name
    FROM sales_reps;

"""
WOW the difference simply could be revealed by the
following 2 codes
https://www.w3schools.com/sql/sql_distinct.asp
without DISTINCT we have duplicated rows and the 351 results output Rows
but is the second case the output us only 50 rows
so DISTINCT have removed repeated rows
"""
SELECT  s.id, s.name
FROM accounts a
JOIN sales_reps s
ON s.id = a.sales_rep_id

SELECT DISTINCT s.id, s.name
FROM accounts a
JOIN sales_reps s
ON s.id = a.sales_rep_id

"""
HAVING - Expert Tip

HAVING is the “clean” way to filter a query that has been aggregated,
but this is also commonly done using a subquery. Essentially,
any time you want to perform a WHERE on an element of your query that was created by an aggregate,
you need to use HAVING instead.

WHERE appears after the FROM, JOIN, and ON clauses, but before GROUP BY.

HAVING appears after the GROUP BY clause, but before the ORDER BY clause.

"""



"""
How many of the sales reps have more than 5 accounts that they manage?
"""
SELECT s.id, s.name, COUNT(*) num_accounts
FROM accounts a
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY s.id, s.name
HAVING COUNT(*) > 5
ORDER BY num_accounts;
"""
technically, we can get this using a SUBQUERY as shown below.
This same logic can be used for the other queries, but this will not be shown.
"""
SELECT COUNT(*) num_reps_above5
FROM(SELECT s.id, s.name, COUNT(*) num_accounts
     FROM accounts a
     JOIN sales_reps s
     ON s.id = a.sales_rep_id
     GROUP BY s.id, s.name
     HAVING COUNT(*) > 5
     ORDER BY num_accounts) AS Table1;
"""
How many accounts have more than 20 orders?
"""
SELECT a.id, a.name, COUNT(*) num_orders
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
HAVING COUNT(*) > 20
ORDER BY num_orders;
"""
Which account has the most orders?
"""
SELECT a.id, a.name, COUNT(*) num_orders
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
ORDER BY num_orders DESC
LIMIT 1;


SELECT MAX(num_accounts)  """ but usig this we didn't show the account name"""
FROM(SELECT a.name,COUNT(*) num_accounts
      FROM accounts a
      JOIN orders o
      ON a.id = o.account_id
      GROUP BY a.name) AS tabel;
"""
How many accounts spent more than 30,000 usd total across all orders?
"""
SELECT a.id, a.name, SUM(o.total_amt_usd) total_spent
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
HAVING SUM(o.total_amt_usd) > 30000
ORDER BY total_spent;

SELECT COUNT(*)
FROM(
SELECT  a.name, SUM(o.total_amt_usd) total_spent
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
HAVING SUM(o.total_amt_usd)>30000) AS tabel;


"""
How many accounts spent less than 1,000 usd total across all orders?
"""
SELECT a.id, a.name, SUM(o.total_amt_usd) total_spent
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
HAVING SUM(o.total_amt_usd) < 1000
ORDER BY total_spent;

SELECT COUNT(*)
FROM(
SELECT  a.name, SUM(o.total_amt_usd) total_spent
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
HAVING SUM(o.total_amt_usd)<1000) AS tabel;

"""
Which account has spent the most with us?
"""
SELECT a.id, a.name, SUM(o.total_amt_usd) total_spent
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
ORDER BY total_spent DESC
LIMIT 1;


"""
Which account has spent the least with us?
"""
SELECT a.id, a.name, SUM(o.total_amt_usd) total_spent
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
ORDER BY total_spent
LIMIT 1;
"""
Which accounts used facebook as a channel to contact customers more than 6 times?
"""
SELECT a.id, a.name, w.channel, COUNT(*) use_of_channel
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
GROUP BY a.id, a.name, w.channel
HAVING COUNT(*) > 6 AND w.channel = 'facebook'
ORDER BY use_of_channel;

SELECT a.id, a.name,w.channel, count(w.channel) channel_usage
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
WHERE w.channel ='facebook'
GROUP BY a.id, a.name,w.channel
HAVING count(w.channel)>6;



"""
Which account used facebook most as a channel?
"""
SELECT a.id, a.name, w.channel, COUNT(*) use_of_channel
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
WHERE w.channel = 'facebook'
GROUP BY a.id, a.name, w.channel
ORDER BY use_of_channel DESC
LIMIT 1;
"""
Which channel was most frequently used by most accounts?
"""
SELECT a.id, a.name, w.channel, COUNT(*) use_of_channel
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
GROUP BY a.id, a.name, w.channel
ORDER BY use_of_channel DESC
LIMIT 10;
"""
GROUPing BY a date column is not usually very useful in SQL, as these columns tend to have transaction data down to a second.
Keeping date information at such a granular data is both a blessing and a curse, as it gives really precise information (a blessing),
but it makes grouping information together directly difficult (a curse).

Lucky for us, there are a number of built in SQL functions that are aimed at helping us improve our experience in working with dates.

Here we saw that dates are stored in year, month, day, hour, minute, second, which helps us in truncating.
In the next concept, you will see a number of functions we can use in SQL to take advantage of this functionality.
"""
"""
The first function you are introduced to in working with dates is DATE_TRUNC.

DATE_TRUNC allows you to truncate your date to a particular part of your date-time column.
Common trunctions are day, month, and year. Here is a great blog post by Mode Analytics on the power of this function.
https://blog.modeanalytics.com/date-trunc-sql-timestamp-function-count-on/

DATE_PART can be useful for pulling a specific portion of a date,
but notice pulling month or day of the week (dow) means that you are no longer keeping the years in order.
Rather you are grouping for certain components regardless of which year they belonged in.

For additional functions you can use with dates, check out the documentation here,
https://www.postgresql.org/docs/9.1/static/functions-datetime.html
but the DATE_TRUNC and DATE_PART functions definitely give you a great start!

You can reference the columns in your select statement in GROUP BY and ORDER BY clauses
with numbers that follow the order they appear in the select statement. For example

SELECT standard_qty, COUNT(*)

FROM orders

GROUP BY 1 (this 1 refers to standard_qty since it is the first of the columns included in the select statement)

ORDER BY 1 (this 1 refers to standard_qty since it is the first of the columns included in the select statement)
"""
"""

    Find the sales in terms of total dollars for all orders in each year,
    ordered from greatest to least. Do you notice any trends in the yearly sales totals?
"""
SELECT DATE_PART('year', occurred_at) ord_year,  SUM(total_amt_usd) total_spent
FROM orders
GROUP BY 1
ORDER BY 2 DESC;
"""
When we look at the yearly totals, you might notice that 2013 and 2017
have much smaller totals than all other years. If we look further at the monthly data,
we see that for 2013 and 2017 there is only one month of sales for each of these years (12 for 2013 and 1 for 2017).
Therefore, neither of these are evenly represented.
Sales have been increasing year over year, with 2016 being the largest sales to date.
At this rate, we might expect 2017 to have the largest sales.
"""
"""
    Which month did Parch & Posey have the greatest sales in terms of total dollars? Are all months evenly represented by the dataset?
"""
"""    In order for this to be 'fair', we should remove the sales from 2013 and 2017. For the same reasons as discussed above."""

    SELECT DATE_PART('month', occurred_at) ord_month, SUM(total_amt_usd) total_spent
    FROM orders
    WHERE occurred_at BETWEEN '2014-01-01' AND '2017-01-01'
    GROUP BY 1
    ORDER BY 2 DESC;
"""
    Which year did Parch & Posey have the greatest sales in terms of total number of orders?
    Are all years evenly represented by the dataset?
"""
    SELECT DATE_PART('year', occurred_at) ord_year,  COUNT(*) total_sales
    FROM orders
    GROUP BY 1
    ORDER BY 2 DESC;
"""
    Again, 2016 by far has the most amount of orders,
    but again 2013 and 2017 are not evenly represented to the other years in the dataset.

    Which month did Parch & Posey have the greatest sales in terms of total number of orders?
    Are all months evenly represented by the dataset?
"""
    SELECT DATE_PART('month', occurred_at) ord_month, COUNT(*) total_sales
    FROM orders
    WHERE occurred_at BETWEEN '2014-01-01' AND '2017-01-01'
    GROUP BY 1
    ORDER BY 2 DESC;
"""
    December still has the most sales, but interestingly,
    November has the second most sales (but not the most dollar sales.
      To make a fair comparison from one month to another 2017 and 2013 data were removed.

    In which month of which year did Walmart spend the most on gloss paper in terms of dollars?
"""
    SELECT DATE_TRUNC('month', o.occurred_at) ord_date, SUM(o.gloss_amt_usd) tot_spent
    FROM orders o
    JOIN accounts a
    ON a.id = o.account_id
    WHERE a.name = 'Walmart'
    GROUP BY 1
    ORDER BY 2 DESC
    LIMIT 1;
"""
CASE - Expert Tip

    The CASE statement always goes in the SELECT clause.

    CASE must include the following components: WHEN, THEN, and END.
    ELSE is an optional component to catch cases that didn’t meet any of the other previous CASE conditions.

    You can make any conditional statement using any conditional operator (like WHERE) between WHEN and THEN.
    This includes stringing together multiple conditional statements using AND and OR.

    You can include multiple WHEN statements, as well as an ELSE statement again, to deal with any unaddressed conditions.

Example

In a quiz question in the previous Basic SQL lesson, you saw this question:

    Create a column that divides the standard_amt_usd by the standard_qty to find the unit price for standard paper for each order.
    Limit the results to the first 10 orders, and include the id and account_id fields.
    NOTE - you will be thrown an error with the correct solution to this question. This is for a division by zero.
    You will learn how to get a solution without an error to this query when you learn about CASE statements in a later section.

Let's see how we can use the CASE statement to get around this error.
"""
SELECT id, account_id, standard_amt_usd/standard_qty AS unit_price
FROM orders
LIMIT 10;
"""
Now, let's use a CASE statement. This way any time the standard_qty is zero, we will return 0,
and otherwise we will return the unit_price.
"""
SELECT account_id, CASE WHEN standard_qty = 0 OR standard_qty IS NULL THEN 0
                        ELSE standard_amt_usd/standard_qty END AS unit_price
FROM orders
LIMIT 10;
"""
Now the first part of the statement will catch any of those division by zero values that were causing the error,
and the other components will compute the division as necessary.
You will notice, we essentially charge all of our accounts 4.99 for standard paper.
It makes sense this doesn't fluctuate, and it is more accurate than adding 1 in the denominator
like our quick fix might have been in the earlier lesson.

"""
"""
Case and aggregation
"""

"""
    We would like to understand 3 different branches of customers based on the amount associated with their purchases.
    The top branch includes anyone with a Lifetime Value (total sales of all orders) greater than 200,000 usd.
    The second branch is between 200,000 and 100,000 usd. The lowest branch is anyone under 100,000 usd.
     Provide a table that includes the level associated with each account. You should provide the account name,
     the total sales of all orders for the customer, and the level. Order with the top spending customers listed first.
"""
    SELECT a.name, SUM(total_amt_usd) total_spent,
         CASE WHEN SUM(total_amt_usd) > 200000 THEN 'top'
         WHEN  SUM(total_amt_usd) > 100000 THEN 'middle'
         ELSE 'low' END AS customer_level
    FROM orders o
    JOIN accounts a
    ON o.account_id = a.id
    GROUP BY a.name
    ORDER BY 2 DESC;
"""
    We would now like to perform a similar calculation to the first,
    but we want to obtain the total amount spent by customers only in 2016 and 2017.
    Keep the same levels as in the previous question. Order with the top spending customers listed first.
"""
    SELECT a.name, SUM(total_amt_usd) total_spent,
         CASE WHEN SUM(total_amt_usd) > 200000 THEN 'top'
         WHEN  SUM(total_amt_usd) > 100000 THEN 'middle'
         ELSE 'low' END AS customer_level
    FROM orders o
    JOIN accounts a
    ON o.account_id = a.id
    WHERE occurred_at > '2015-12-31'
    GROUP BY 1
    ORDER BY 2 DESC;
"""
    We would like to identify top performing sales reps,
    which are sales reps associated with more than 200 orders.
    Create a table with the sales rep name, the total number of orders,
    and a column with top or not depending on if they have more than 200 orders.
    Place the top sales people first in your final table.
"""
    SELECT s.name, COUNT(*) num_ords,
         CASE WHEN COUNT(*) > 200 THEN 'top'
         ELSE 'not' END AS sales_rep_level
    FROM orders o
    JOIN accounts a
    ON o.account_id = a.id
    JOIN sales_reps s
    ON s.id = a.sales_rep_id
    GROUP BY s.name
    ORDER BY 2 DESC;
"""
    It is worth mentioning that this assumes each name is unique -
    which has been done a few times. We otherwise would want to break by the name and the id of the table.


    The previous didn't account for the middle,
    nor the dollar amount associated with the sales.
    Management decides they want to see these characteristics represented as well.
    We would like to identify top performing sales reps,
    which are sales reps associated with more than 200 orders or more than 750000 in total sales.
    The middle group has any rep with more than 150 orders or 500000 in sales.
    Create a table with the sales rep name, the total number of orders,
    total sales across all orders, and a column with top, middle, or low depending on this criteria.
    Place the top sales people based on dollar amount of sales first in your final table.
    You might see a few upset sales people by this criteria!
"""
    SELECT s.name, COUNT(*), SUM(o.total_amt_usd) total_spent,
         CASE WHEN COUNT(*) > 200 OR SUM(o.total_amt_usd) > 750000 THEN 'top'
         WHEN COUNT(*) > 150 OR SUM(o.total_amt_usd) > 500000 THEN 'middle'
         ELSE 'low' END AS sales_rep_level
    FROM orders o
    JOIN accounts a
    ON o.account_id = a.id
    JOIN sales_reps s
    ON s.id = a.sales_rep_id
    GROUP BY s.name
    ORDER BY 3 DESC;
