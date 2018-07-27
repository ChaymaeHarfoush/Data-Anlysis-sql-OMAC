"""
What this lesson is about...

Up to this point you have learned a lot about working with data using SQL. This lesson will focus on three topics:

    Subqueries
    Table Expressions
    Persistent Derived Tables

Both subqueries and table expressions are methods for being able to write a query that creates a table,
and then write a query that interacts with this newly created table.
Sometimes the question you are trying to answer doesn't have an answer when working directly with existing tables in database.

However, if we were able to create new tables from the existing tables,
we know we could query these new tables to answer our question.
This is where the queries of this lesson come to the rescue.

If you can't yet think of a question that might require such a query,
don't worry because you are about to see a whole bunch of them!
"""
"""
Whenever we need to use existing tables to create a new table that we then want to query again,
this is an indication that we will need to use some sort of subquery.
"""
"""
    First, we needed to group by the day and channel.
    Then ordering by the number of events (the third column)
"""
    SELECT DATE_TRUNC('day',occurred_at) AS day,
       channel, COUNT(*) as events
    FROM web_events
    GROUP BY 1,2
    ORDER BY 3 DESC;
"""
    Here you can see that to get the entire table in question 1 back,
    we included an * in our SELECT statement. You will need to be sure to alias your table.
"""
    SELECT *
    FROM (SELECT DATE_TRUNC('day',occurred_at) AS day,
               channel, COUNT(*) as events
         FROM web_events
         GROUP BY 1,2
         ORDER BY 3 DESC) sub;
"""
    Finally, here we are able to get a table that shows the average number of events a day for each channel.
"""
    SELECT channel, AVG(events) AS average_events
    FROM (SELECT DATE_TRUNC('day',occurred_at) AS day,
                 channel, COUNT(*) as events
          FROM web_events
          GROUP BY 1,2) sub
    GROUP BY channel
    ORDER BY 2 DESC;
"""
Subquery Formatting

When writing Subqueries, it is easy for your query to look incredibly complex.
In order to assist your reader, which is often just yourself at a future date,
formatting SQL will help with understanding your code.

The important thing to remember when using subqueries is to provide some way for the reader
 to easily determine which parts of the query will be executed together.
 Most people do this by indenting the subquery in some way

The examples in this class are indented quite far—all the way to the parentheses.
This isn’t practical if you nest many subqueries,
but in general, be thinking about how to write your queries in a readable way.
Examples of the same query written multiple different ways is provided below.
You will see that some are much easier to read than others.

Badly Formatted Queries

Though these poorly formatted examples will execute the same way as the well formatted examples,
they just aren't very friendly for understanding what is happening!

Here is the first, where it is impossible to decipher what is going on:
"""
SELECT * FROM (SELECT DATE_TRUNC('day',occurred_at) AS day, channel, COUNT(*) as events FROM web_events GROUP BY 1,2 ORDER BY 3 DESC) sub;
"""
This second version, which includes some helpful line breaks, is easier to read than that previous version,
but it is still not as easy to read as the queries in the Well Formatted Query section.
"""
SELECT *
FROM (
SELECT DATE_TRUNC('day',occurred_at) AS day,
channel, COUNT(*) as events
FROM web_events
GROUP BY 1,2
ORDER BY 3 DESC) sub;
"""
Well Formatted Query

Now for a well formatted example, you can see the table we are pulling from much easier than in the previous queries.
"""
SELECT *
FROM (SELECT DATE_TRUNC('day',occurred_at) AS day,
                channel, COUNT(*) as events
      FROM web_events
      GROUP BY 1,2
      ORDER BY 3 DESC) sub;
"""
Additionally, if we have a GROUP BY, ORDER BY, WHERE, HAVING, or any other statement following our subquery,
we would then indent it at the same level as our outer query.

The query below is similar to the above, but it is applying additional statements to the outer query,
so you can see there are GROUP BY and ORDER BY statements used on the output are not tabbed.
The inner query GROUP BY and ORDER BY statements are indented to match the inner table.
"""
SELECT *
FROM (SELECT DATE_TRUNC('day',occurred_at) AS day,
                channel, COUNT(*) as events
      FROM web_events
      GROUP BY 1,2
      ORDER BY 3 DESC) sub
GROUP BY channel
ORDER BY 2 DESC;
"""
These final two queries are so much easier to read!
"""
"""
Subqueries Part II

In the first subquery you wrote, you created a table that you could then query again in the FROM statement.
However, if you are only returning a single value, you might use that value in a logical statement
like WHERE, HAVING, or even SELECT - the value could be nested within a CASE statement.

Expert Tip

Note that you should not include an alias when you write a subquery in a conditional statement.
This is because the subquery is treated as an individual value (or set of values in the IN case) rather than as a table.

Also, notice the query here compared a single value.
If we returned an entire column IN would need to be used to perform a logical argument.
If we are returning an entire table, then we must use an ALIAS for the table, and perform additional logic on the entire table.
"""
SELECT *
FROM orders
WHERE DATE_TRUNC('month',occurred_at)=
(
  SELECT DATE_TRUNC('month',MIN(occurred_at)) as min_month
  FROM orders
)
ORDER BY occurred_at

"""
The average amount of standard paper sold on the first month that any order was placed in the orders table (in terms of quantity).
The average amount of gloss paper sold on the first month that any order was placed in the orders table (in terms of quantity).
The average amount of poster paper sold on the first month that any order was placed in the orders table (in terms of quantity).
The total amount spent on all orders on the first month that any order was placed in the orders table (in terms of usd).

"""
SELECT AVG(standard_qty) avg_std, AVG(gloss_qty) avg_gls, AVG(poster_qty) avg_pst, SUM(total_amt_usd) avg_total_amt
FROM orders
WHERE DATE_TRUNC('month', occurred_at) =
     (SELECT DATE_TRUNC('month', MIN(occurred_at)) FROM orders);


"""
1-Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales.

First, I wanted to find the total_amt_usd totals associated with each sales rep,
and I also wanted the region in which they were located. The query below provided this information.
"""
SELECT s.name rep_name, r.name region_name, SUM(o.total_amt_usd) total_amt
FROM sales_reps s
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id
JOIN region r
ON r.id = s.region_id
GROUP BY 1,2
ORDER BY 3 DESC;
"""
Next, I pulled the max for each region, and then we can use this to pull those rows in our final result.
"""
SELECT region_name, MAX(total_amt) total_amt
     FROM(SELECT s.name rep_name, r.name region_name, SUM(o.total_amt_usd) total_amt
             FROM sales_reps s
             JOIN accounts a
             ON a.sales_rep_id = s.id
             JOIN orders o
             ON o.account_id = a.id
             JOIN region r
             ON r.id = s.region_id
             GROUP BY 1, 2) t1
     GROUP BY 1;
"""
Essentially, this is a JOIN of these two tables, where the region and amount match.
"""

SELECT t3.rep_name, t3.region_name, t3.total_amt
FROM(SELECT region_name, MAX(total_amt) total_amt
     FROM(SELECT s.name rep_name, r.name region_name, SUM(o.total_amt_usd) total_amt
             FROM sales_reps s
             JOIN accounts a
             ON a.sales_rep_id = s.id
             JOIN orders o
             ON o.account_id = a.id
             JOIN region r
             ON r.id = s.region_id
             GROUP BY 1, 2) t1
     GROUP BY 1) t2
JOIN (SELECT s.name rep_name, r.name region_name, SUM(o.total_amt_usd) total_amt
     FROM sales_reps s
     JOIN accounts a
     ON a.sales_rep_id = s.id
     JOIN orders o
     ON o.account_id = a.id
     JOIN region r
     ON r.id = s.region_id
     GROUP BY 1,2
     ORDER BY 3 DESC) t3
ON t3.region_name = t2.region_name AND t3.total_amt = t2.total_amt;

"""
2-For the region with the largest sales total_amt_usd, how many total orders were placed?

The first query I wrote was to pull the total_amt_usd for each region.
"""
SELECT r.name region_name, SUM(o.total_amt_usd) total_amt
FROM sales_reps s
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id
JOIN region r
ON r.id = s.region_id
GROUP BY r.name;
"""
Then we just want the region with the max amount from this table.
There are two ways I considered getting this amount.
One was to pull the max using a subquery. Another way is to order descending and just pull the top value.
"""
SELECT MAX(total_amt)
FROM (SELECT r.name region_name, SUM(o.total_amt_usd) total_amt
             FROM sales_reps s
             JOIN accounts a
             ON a.sales_rep_id = s.id
             JOIN orders o
             ON o.account_id = a.id
             JOIN region r
             ON r.id = s.region_id
             GROUP BY r.name) sub;
"""
Finally, we want to pull the total orders for the region with this amount:
"""
SELECT r.name, COUNT(o.total) total_orders
FROM sales_reps s
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id
JOIN region r
ON r.id = s.region_id
GROUP BY r.name
HAVING SUM(o.total_amt_usd) = (
      SELECT MAX(total_amt)
      FROM (SELECT r.name region_name, SUM(o.total_amt_usd) total_amt
              FROM sales_reps s
              JOIN accounts a
              ON a.sales_rep_id = s.id
              JOIN orders o
              ON o.account_id = a.id
              JOIN region r
              ON r.id = s.region_id
              GROUP BY r.name) sub);



"""
3-For the account that purchased the most (in total over their lifetime as a customer) standard_qty paper,
how many accounts still had more in total purchases?

First, we want to find the account that had the most standard_qty paper.
The query here pulls that account, as well as the total amount:
"""
SELECT a.name account_name, SUM(o.standard_qty) total_std, SUM(o.total) total
FROM accounts a
JOIN orders o
ON o.account_id = a.id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;
"""
Now, I want to use this to pull all the accounts with more total sales:
"""
SELECT a.name
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY 1
HAVING SUM(o.total) > (
                       SELECT total
                       FROM (
                              SELECT a.name act_name, SUM(o.standard_qty) tot_std, SUM(o.total) total
                              FROM accounts a
                              JOIN orders o
                              ON o.account_id = a.id
                              GROUP BY 1
                              ORDER BY 2 DESC
                              LIMIT 1) sub
                      );
"""
This is now a list of all the accounts with more total orders. We can get the count with just another simple subquery.
"""
SELECT COUNT(*)
FROM (SELECT a.name
      FROM orders o
      JOIN accounts a
      ON a.id = o.account_id
      GROUP BY 1
      HAVING SUM(o.total) > (
                             SELECT total
                             FROM (SELECT a.name act_name, SUM(o.standard_qty) tot_std, SUM(o.total) total
                                    FROM accounts a
                                    JOIN orders o
                                    ON o.account_id = a.id
                                    GROUP BY 1
                                    ORDER BY 2 DESC
                                    LIMIT 1) inner_tab
                              )
            ) counter_tab;


"""
4-For the customer that spent the most (in total over their lifetime as a customer) total_amt_usd,
how many web_events did they have for each channel?

Here, we first want to pull the customer with the most spent in lifetime value.
"""
SELECT a.id, a.name, SUM(o.total_amt_usd) tot_spent
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY a.id, a.name
ORDER BY 3 DESC
LIMIT 1;
"""
Now, we want to look at the number of events on each channel this company had,
which we can match with just the id.
"""
SELECT a.name, w.channel, COUNT(*)
FROM accounts a
JOIN web_events w
ON a.id = w.account_id AND a.id =  (
                                     SELECT id
                                     FROM (SELECT a.id, a.name, SUM(o.total_amt_usd) tot_spent
                                           FROM orders o
                                           JOIN accounts a
                                           ON a.id = o.account_id
                                           GROUP BY a.id, a.name
                                           ORDER BY 3 DESC
                                           LIMIT 1) inner_table
                                    )
GROUP BY 1, 2
ORDER BY 3 DESC;

"""
My solution is quite the same
here:
"""
SELECT a.name,w.channel,count(*) web_events_per_channel
FROM accounts a
JOIN web_events w
ON a.id=w.account_id
WHERE a.name=(
			  SELECT one_name
			  FROM(
					SELECT a.name one_name,SUM(total_amt_usd)
					FROM accounts a
					JOIN orders o
					ON o.account_id = a.id
					GROUP BY 1
					ORDER BY 2 DESC
					LIMIT 1) MOST_SPEND
			 )
GROUP BY 1,2
ORDER BY 3 DESC;

"""
5-What is the lifetime average amount spent in terms of total_amt_usd for the top 10 total spending accounts?

First, we just want to find the top 10 accounts in terms of highest total_amt_usd.
"""
SELECT a.id, a.name, SUM(o.total_amt_usd) tot_spent
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY a.id, a.name
ORDER BY 3 DESC
LIMIT 10;
"""
Now, we just want the average of these 10 amounts.
"""
SELECT AVG(tot_spent)
FROM (SELECT a.id, a.name, SUM(o.total_amt_usd) tot_spent
      FROM orders o
      JOIN accounts a
      ON a.id = o.account_id
      GROUP BY a.id, a.name
      ORDER BY 3 DESC
       LIMIT 10) temp;

"""
6-What is the lifetime average amount spent in terms of total_amt_usd for only
the companies that spent more than the average of all orders.

First, we want to pull the average of all accounts in terms of total_amt_usd:
"""
SELECT AVG(o.total_amt_usd) avg_all
FROM orders o
JOIN accounts a
ON a.id = o.account_id;
"""
it's the same as :
"""
SELECT AVG(o.total_amt_usd) avg_all
FROM orders o;
"""
Then, we want to only pull the accounts with more than this average amount.
"""
SELECT o.account_id, AVG(o.total_amt_usd)
FROM orders o
GROUP BY 1
HAVING AVG(o.total_amt_usd) > (SELECT AVG(o.total_amt_usd) avg_all
                               FROM orders o
                               JOIN accounts a
                               ON a.id = o.account_id);
"""
Finally, we just want the average of these values.
"""
SELECT AVG(avg_amt)
FROM (SELECT o.account_id, AVG(o.total_amt_usd) avg_amt
    FROM orders o
    GROUP BY 1
    HAVING AVG(o.total_amt_usd) > (SELECT AVG(o.total_amt_usd) avg_all
                               FROM orders o
                               JOIN accounts a
                               ON a.id = o.account_id)) temp_table;

"""
The WITH statement is often called a Common Table Expression or CTE.
Though these expressions serve the exact same purpose as subqueries,
they are more common in practice, as they tend to be cleaner for a future reader to follow the logic.
"""
"""
Your First WITH (CTE)
CTEs are more readable and more efficient, as the tables aren't recreated with each subquery portion.

QUESTION: You need to find the average number of events for each channel per day.

SOLUTION:
"""
SELECT channel, AVG(events) AS average_events
FROM (SELECT DATE_TRUNC('day',occurred_at) AS day,
             channel, COUNT(*) as events
      FROM web_events
      GROUP BY 1,2) sub
GROUP BY channel
ORDER BY 2 DESC;
"""
Let's try this again using a WITH statement.

Notice, you can pull the inner query:
"""
SELECT DATE_TRUNC('day',occurred_at) AS day,
       channel, COUNT(*) as events
FROM web_events
GROUP BY 1,2
"""
This is the part we put in the WITH statement. Notice, we are aliasing the table as events below:
"""
WITH events AS (
          SELECT DATE_TRUNC('day',occurred_at) AS day,
                        channel, COUNT(*) as events
          FROM web_events
          GROUP BY 1,2)
"""
Now, we can use this newly created events table as if it is any other table in our database:
"""
WITH events AS (
          SELECT DATE_TRUNC('day',occurred_at) AS day,
                        channel, COUNT(*) as events
          FROM web_events
          GROUP BY 1,2)

SELECT channel, AVG(events) AS average_events
FROM events
GROUP BY channel
ORDER BY 2 DESC;
"""
For the above example, we don't need anymore than the one additional table,
but imagine we needed to create a second table to pull from.
We can create an additional table to pull from in the following way:
"""
WITH table1 AS (
          SELECT *
          FROM web_events),

     table2 AS (
          SELECT *
          FROM accounts)


SELECT *
FROM table1
JOIN table2
ON table1.account_id = table2.id;

"""
these are the same 6 examples above but using CTE
1-Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales.
"""
WITH t1 AS (
            SELECT s.name rep_name, r.name region_name, SUM(o.total_amt_usd) total_amt
             FROM sales_reps s
             JOIN accounts a
             ON a.sales_rep_id = s.id
             JOIN orders o
             ON o.account_id = a.id
             JOIN region r
             ON r.id = s.region_id
             GROUP BY 1,2
             ORDER BY 3 DESC),
      t2 AS (
             SELECT region_name, MAX(total_amt) total_amt
             FROM t1
             GROUP BY 1)
SELECT t1.rep_name, t1.region_name, t1.total_amt
FROM t1
JOIN t2
ON t1.region_name = t2.region_name AND t1.total_amt = t2.total_amt;
"""
2-For the region with the largest sales total_amt_usd, how many total orders were placed?
"""
WITH t1 AS (
             SELECT r.name region_name, SUM(o.total_amt_usd) total_amt
             FROM sales_reps s
             JOIN accounts a
             ON a.sales_rep_id = s.id
             JOIN orders o
             ON o.account_id = a.id
             JOIN region r
             ON r.id = s.region_id
             GROUP BY r.name),
    t2 AS (
             SELECT MAX(total_amt)
             FROM t1)
SELECT r.name, SUM(o.total) total_orders
FROM sales_reps s
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id
JOIN region r
ON r.id = s.region_id
GROUP BY r.name
HAVING SUM(o.total_amt_usd) = (SELECT * FROM t2);
"""
3-For the account that purchased the most (in total over their lifetime as a customer) standard_qty paper,
how many accounts still had more in total purchases?
"""
WITH t1 AS (
            SELECT a.name account_name, SUM(o.standard_qty) total_std, SUM(o.total) total
            FROM accounts a
            JOIN orders o
            ON o.account_id = a.id
            GROUP BY 1
            ORDER BY 2 DESC
            LIMIT 1),
    t2 AS (
            SELECT a.name
            FROM orders o
            JOIN accounts a
            ON a.id = o.account_id
            GROUP BY 1
            HAVING SUM(o.total) > (SELECT total FROM t1))
SELECT COUNT(*)
FROM t2;
"""
4-For the customer that spent the most (in total over their lifetime as a customer) total_amt_usd,
how many web_events did they have for each channel?
"""
WITH t1 AS (
             SELECT a.id, a.name, SUM(o.total_amt_usd) tot_spent
             FROM orders o
             JOIN accounts a
             ON a.id = o.account_id
             GROUP BY a.id, a.name
             ORDER BY 3 DESC
             LIMIT 1)
SELECT a.name, w.channel, COUNT(*)
FROM accounts a
JOIN web_events w
ON a.id = w.account_id AND a.id =  (SELECT id FROM t1)
GROUP BY 1, 2
ORDER BY 3 DESC;
"""
5-What is the lifetime average amount spent in terms of total_amt_usd
for the top 10 total spending accounts?
"""
WITH t1 AS (
             SELECT a.id, a.name, SUM(o.total_amt_usd) tot_spent
             FROM orders o
             JOIN accounts a
             ON a.id = o.account_id
             GROUP BY a.id, a.name
             ORDER BY 3 DESC
             LIMIT 10)
SELECT AVG(tot_spent)
FROM t1;

"""
6-What is the lifetime average amount spent in terms of total_amt_usd
for only the companies that spent more than the average of all accounts.
"""
WITH t1 AS (
             SELECT AVG(o.total_amt_usd) avg_all
             FROM orders o
             JOIN accounts a
             ON a.id = o.account_id),
    t2 AS (
             SELECT o.account_id, AVG(o.total_amt_usd) avg_amt
             FROM orders o
             GROUP BY 1
             HAVING AVG(o.total_amt_usd) > (SELECT * FROM t1))
SELECT AVG(avg_amt)
FROM t2;

"""
Recap

This lesson was the first of the more advanced sequence in writing SQL.
Arguably, the advanced features of Subqueries and CTEs are the most widely used in an analytics role within a company.
Being able to break a problem down into the necessary tables and finding a solution using the resulting table is very useful in practice.
"""
