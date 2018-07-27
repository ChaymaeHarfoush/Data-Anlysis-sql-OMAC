
"""
In this lesson, you will be learning a number of techniques to

    Clean and re-structure messy data.
    Convert columns to different data types.
    Tricks for manipulating NULLs.

This will give you a robust toolkit to get from raw data to clean data that's useful for analysis.

Here we looked at three new functions:

    LEFT
    RIGHT
    LENGTH

LEFT pulls a specified number of characters for each row in a specified column starting at the beginning (or from the left).
As you saw here, you can pull the first three digits of a phone number using LEFT(phone_number, 3).

RIGHT pulls a specified number of characters for each row in a specified column starting at the end (or from the right).
As you saw here, you can pull the last eight digits of a phone number using RIGHT(phone_number, 8).

LENGTH provides the number of characters for each row of a specified column.
Here, you saw that we could use this to get the length of each phone number as LENGTH(phone_number).

"""
"""
    1-In the accounts table, there is a column holding the website for each company.
    The last three digits specify what type of web address they are using.
    A list of extensions (and pricing) is provided here.
    Pull these extensions and provide how many of each website type exist in the accounts table.
"""
SELECT RIGHT(website, 3) AS domain, COUNT(*) num_companies
FROM accounts
GROUP BY 1
ORDER BY 2 DESC;

"""
    2-There is much debate about how much the name (or even the first letter of a company name) matters.
    Use the accounts table to pull the first letter of each company name to see the distribution of company names
    that begin with each letter (or number).
"""
SELECT LEFT(UPPER(name), 1) AS first_letter, COUNT(*) num_companies
FROM accounts
GROUP BY 1
ORDER BY 2 DESC;


"""
    3-Use the accounts table and a CASE statement to create two groups:
    one group of company names that start with a number and a second group
    of those company names that start with a letter.
    What proportion of company names start with a letter?
    There are 350 company names that start with a letter and 1 that starts with a number.
    This gives a ratio of 350/351 that are company names that start with a letter or 99.7%.
"""
WITH t1 AS (SELECT name,
            CASE WHEN LEFT(UPPER(name), 1) IN ('0','1','2','3','4','5','6','7','8','9') THEN 1 ELSE 0 END AS num,
            CASE WHEN LEFT(UPPER(name), 1) IN ('0','1','2','3','4','5','6','7','8','9') THEN 0 ELSE 1 END AS letter
            FROM accounts)
SELECT SUM(num) nums, SUM(letter) letters
FROM  t1;

SELECT case when LEFT(UPPER(name), 1) in ('0','1','2','3','4','5','6','7','8','9')  then 'numb'
            when LEFT(UPPER(name), 1) not in ('0','1','2','3','4','5','6','7','8','9') then 'letter'
             else 'none' end as FIRST_LETTER,
            COUNT(*) OCCUREANCE
FROM accounts
GROUP BY 1
ORDER BY 2 DESC;
"""
    4-Consider vowels as a, e, i, o, and u. What proportion of company names start with a vowel,
    and what percent start with anything else?
    There are 80 company names that start with a vowel and 271 that start with other characters.
    Therefore 80/351 are vowels or 22.8%. Therefore, 77.2% of company names do not start with vowels.
"""
WITH t1 AS(SELECT CASE WHEN LEFT(UPPER(a.name), 1) IN ('A','E','I','O','U') THEN 1	ELSE  0 END AS vowels,
        			    CASE WHEN LEFT(UPPER(a.name), 1) NOT IN ('A','E','I','O','U') THEN 1	ELSE  0 END AS not_vowels
        		      FROM accounts a)
SELECT SUM(vowels) v,SUM(not_vowels) not_v
FROM t1

"""
In this lesson, you learned about:

    POSITION
    STRPOS
    LOWER
    UPPER

POSITION takes a character and a column, and provides the index where that character is for each row.
The index of the first position is 1 in SQL. If you come from another programming language, many begin indexing at 0.
Here, you saw that you can pull the index of a comma as POSITION(',' IN city_state).

STRPOS provides the same result as POSITION, but the syntax for achieving those results is a bit different
as shown here: STRPOS(city_state, ',').

Note, both POSITION and STRPOS are case sensitive, so looking for A is different than looking for a.
"""
"""
1-Use the accounts table to create first and last name columns
that hold the first and last names for the primary_poc.
"""
SELECT primary_poc,
       POSITION(' ' IN primary_poc) space_pos,
		   LEFT(primary_poc,POSITION(' ' IN primary_poc)-1) first_name,
       RIGHT(primary_poc,LENGTH(primary_poc)-POSITION(' ' IN primary_poc)) last_name
FROM accounts
"""
2-Now see if you can do the same thing for every rep name in the sales_reps table.
Again provide first and last name columns.
"""

SELECT name,
       POSITION(' ' IN name) space_pos,
		   LEFT(name,POSITION(' ' IN name)-1) first_name,
       RIGHT(name,LENGTH(name)-POSITION(' ' IN name)) last_name
FROM sales_reps

"""
In this lesson you learned about:

    CONCAT
    Piping ||

Each of these will allow you to combine columns together across rows.
In this video, you saw how first and last names stored in separate columns could be combined together to create a full name:
CONCAT(first_name, ' ', last_name)
or with piping as
first_name || ' ' || last_name.
"""
"""
1-Each company in the accounts table wants to create an email address for each primary_poc.
The email address should be the first name of the primary_poc .
last name primary_poc @ company name .com.
"""
WITH t1 AS(SELECT primary_poc,name,
           POSITION(' ' IN primary_poc) space_pos,
    		   LEFT(primary_poc,POSITION(' ' IN primary_poc)-1) first_name,
           RIGHT(primary_poc,LENGTH(primary_poc)-POSITION(' ' IN primary_poc)) last_name
           FROM accounts)
SELECT t1.primary_poc,t1.name,
       CONCAT(t1.first_name, '.', t1.last_name,'@',t1.name,'.com') email,
       (t1.first_name || '.' || t1.last_name || '@' || t1.name ||'.com') alt_email
FROM t1




"""
You may have noticed that in the previous solution some of the company names include spaces,
which will certainly not work in an email address.
See if you can create an email address that will work by removing all of the spaces in the account name,
but otherwise your solution should be just as in question 1.
useful link https://www.postgresql.org/docs/8.1/static/functions-string.html
"""

WITH t1 AS ( SELECT LEFT(primary_poc,STRPOS(primary_poc, ' ') -1 ) first_name,
             RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) last_name, name
             FROM accounts)
SELECT first_name, last_name, CONCAT(first_name, '.', last_name, '@', REPLACE(name, ' ', ''), '.com')
FROM  t1;
"a better answer"
SELECT primary_poc,name,
       (replace(primary_poc,' ','.') || '@' || replace(name,' ','') ||'.com') alt_email
FROM accounts;
"""
We would also like to create an initial password, which they will change after their first log in.
The first password will be the first letter of the primary_poc's first name (lowercase),
then the last letter of their first name (lowercase),
the first letter of their last name (lowercase),
the last letter of their last name (lowercase),
the number of letters in their first name,
the number of letters in their last name,
and then the name of the company they are working with, all capitalized with no spaces.
"""
WITH t1 AS(SELECT primary_poc,name,
    		   LEFT(primary_poc,POSITION(' ' IN primary_poc)-1) first_name,
           RIGHT(primary_poc,LENGTH(primary_poc)-POSITION(' ' IN primary_poc)) last_name
           FROM accounts)
SELECT primary_poc,
		   name,
       (LOWER(LEFT(first_name,1) || RIGHT(first_name,1)|| LEFT(last_name,1) || RIGHT(last_name,1) || LENGTH(first_name) || LENGTH(last_name))
           || (UPPER(REPLACE(name, ' ', '')))) PASS
FROM t1;

"""
there additional functionality for working with dates including:

    TO_DATE
    CAST
    Casting with ::

DATE_PART('month', TO_DATE(month, 'month')) here changed a month name into
the number associated with that particular month.

Then you can change a string to a date using CAST.
CAST is actually useful to change lots of column types.
Commonly you might be doing as you saw here, where you change a string to a date using
CAST(date_column AS DATE).
However, you might want to make other changes to your columns in terms of their data types.
http://www.postgresqltutorial.com/postgresql-cast/


In this example, you also saw that instead of CAST(date_column AS DATE), you can use
date_column::DATE.

Expert Tip

Most of the functions presented in this lesson are specific to strings.
They won’t work with dates, integers or floating-point numbers.
However, using any of these functions will automatically change
the data to the appropriate type.

LEFT, RIGHT, and TRIM are all used to select only certain elements of strings,
 but using them to select elements of a number or date will treat them as strings for the purpose of the function.
 Though we didn't cover TRIM in this lesson explicitly, it can be used to remove characters from the beginning and end of a string.
 This can remove unwanted spaces at the beginning or end of a row that often happen with data being moved from Excel or other storage systems.

There are a number of variations of these functions, as well as several other string functions not covered here.
Different databases use subtle variations on these functions,
so be sure to look up the appropriate database’s syntax if you’re connected to a private database.
The Postgres literature contains a lot of the related functions.
https://www.postgresql.org/docs/9.1/static/functions-string.html
"""
 """
WHAT to do IF i want to show hours minutes and seconds in my answer???????
my answer:
 """
WITH sub AS (SELECT substr(s.date, 1,2) c_month,
		          substr(s.date, 4,2) c_day,
              substr(s.date, 7,4) c_year,
              substr(s.date,12 ,2) c_hours,
              s.date db_date,
              s.time db_time
              FROM sf_crime_data s)

SELECT (c_year || '-' || c_month || '-' || c_day || 'T' || c_hours || ':' || db_time || '.000z') :: DATE my_date
FROM sub
LIMIT 20;

"""
someone answer :D good solution
"""
SELECT TO_TIMESTAMP(date, 'MM/DD/YYYY HH12:MI:SS'), date
FROM sf_crime_data
LIMIT 10;
"""
his answer:
"""
SELECT date orig_date,
      (SUBSTR(date, 7, 4) || '-' || LEFT(date, 2) || '-' || SUBSTR(date, 4, 2))::DATE new_date
FROM sf_crime_data;


"""
  hahahahhahah a simpler answer than his :
"""
SELECT a.date orig_date, (SUBSTR(a.date, 1, 10) )::DATE new_date
FROM sf_crime_data a;
"""
heheheh more simpler XD
"""
SELECT a.date orig_date, a.date::DATE new_date
FROM sf_crime_data a;

"""
we can extract a different parts of the date but ONLY from the formated one to date datatype
EXTRACT is different form DATE_TRUNC as DATE_TRUNC function rounds a date to whatever precision
you specify.
but it could be like The DATEPART() function which returns a specified part of a given date,
as an integer value
"""
WITH DATE_TABLE AS (SELECT a.date orig_date, a.date::DATE new_date
                    FROM sf_crime_data a)
SELECT new_date
       EXTRACT('year'   FROM new_date) AS year,
       EXTRACT('month'  FROM new_date) AS month,
       EXTRACT('day'    FROM new_date) AS day,
       EXTRACT('hour'   FROM new_date) AS hour,
       EXTRACT('minute' FROM new_date) AS minute,
       EXTRACT('second' FROM new_date) AS second,
       EXTRACT('decade' FROM new_date) AS decade,
       EXTRACT('dow'    FROM new_date) AS day_of_week
  FROM DATE_TABLE

"""
COALESCE

COALESCE returns the first non-NULL value passed for each row.

COUNT returns the number of rows containing NON NULL values
"""
"""
6913 rows coulmns having non null values
"""
SELECT count(*)
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id
"""
COALESCE searches here for the first non null value for it's arguments -o.id,account_id,- are null
but -lat-  contains a value that's returns,
if COALESCE didn't found a non nul value in it's arguments it returns NULL
"""
SELECT COALESCE(o.id,o.account_id,a.lat) filled_id, a.name, a.website, a.lat, a.long, a.primary_poc, a.sales_rep_id, o.*
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id
WHERE o.total IS NULL;


"""
here we are sure that the person who haven't made any orders have account id -a.id-
so we just make new colums with the same name of the old ones: id and account_id and fill them with that a.id
and as qty =0 and usd=0 we filled them with this value 0

"""

SELECT  COALESCE(a.id) id,
        a.name, a.website, a.lat, a.long, a.primary_poc, a.sales_rep_id,
        COALESCE(a.id) account_id,
         o.occurred_at,
        COALESCE(0) standard_qty,COALESCE(0) gloss_qty,COALESCE(0) poster_qty,COALESCE(0) total,
        COALESCE(0) standard_amt_usd, COALESCE(0) gloss_amt_usd,COALESCE(0) poster_amt_usd,COALESCE(0) total_amt_usd
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id
WHERE o.total IS NULL;

"""
it makes sense while working with the hole db entering to arguments for COALESCE
as  It returns the first argument that is not null. If all arguments are null, the COALESCE function will return null:
-COALESCE(o.account_id, a.id) account_id---returns the id of the order if that acount have asked for order otherwise it returns the account id
-COALESCE(o.standard_qty, 0) standard_qty---returns the quantity of ordered standard paper for each acount that have made an orders,
if the account havent's made an  order so o.standard_qty (argument1) would be null so it go and return 0 (argument2 which is not null)

Well he uses a template: argument1-->the original colum  argument2-->the value that we want to raplace argument1 with if it's null
"""
SELECT COALESCE(a.id, a.id) id,
       a.name, a.website, a.lat, a.long, a.primary_poc, a.sales_rep_id,
       COALESCE(o.account_id, a.id) account_id,
       o.occurred_at,
       COALESCE(o.standard_qty, 0) standard_qty,
       COALESCE(o.gloss_qty,0) gloss_qty,
       COALESCE(o.poster_qty,0) poster_qty,
       COALESCE(o.total,0) total,
       COALESCE(o.standard_amt_usd,0) standard_amt_usd,
       COALESCE(o.gloss_amt_usd,0) gloss_amt_usd,
       COALESCE(o.poster_amt_usd,0) poster_amt_usd,
       COALESCE(o.total_amt_usd,0) total_amt_usd
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id;
"""
well following example assures that there is only one account whow haven't made any orders as
filled_total_count : 6913
org_total_count :	6912
COUNT(COALESCE(o.total,'no order')) would result an error as (invalid input syntax for integer:  no order ) as o.total is a colunm of integer values
"""

SELECT COUNT(COALESCE(o.total,0)) filled_total_count, COUNT(o.total) org_total_count
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id;



"""
There are a few other functions that work similarly. You can read more about those here.
https://www.w3schools.com/sql/sql_isnull.asp
You can also get a walk through of many of the functions you have seen throughout this lesson here.
https://community.modeanalytics.com/sql/tutorial/sql-string-functions-for-cleaning/
"""
