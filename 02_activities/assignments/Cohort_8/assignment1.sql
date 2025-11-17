/* ASSIGNMENT 1 */
/* SECTION 2 */


--SELECT
/* 1. Write a query that returns everything in the customer table. */
SELECT *  -- Selecting all columns from customer
FROM customer;


/* 2. Write a query that displays all of the columns and 10 rows from the cus- tomer table, 
sorted by customer_last_name, then customer_first_ name. */

SELECT * -- Selecting all columns from customer
FROM customer
ORDER BY customer_last_name, customer_first_name
LIMIT 10; -- Shows only first 10 Rows after ORDER BY?


--WHERE
/* 1. Write a query that returns all customer purchases of product IDs 4 and 9. */

SELECT
market_date -- Selecting all columns from customer_purchases excluding transaction_time, best practice not to use * 
,customer_id
,vendor_id
,product_id
,quantity
FROM customer_purchases
WHERE product_id IN (4, 9); 


/*2. Write a query that returns all customer purchases and a new calculated column 'price' (quantity * cost_to_customer_per_qty), 
filtered by customer IDs between 8 and 10 (inclusive) using either:
	1.  two conditions using AND
	2.  one condition using BETWEEN
*/
-- option 1

SELECT
market_date -- Selecting all columns from customer_purchases excluding transaction_time, best practice not to use * 
,customer_id
,vendor_id
,product_id
,quantity
,quantity * cost_to_customer_per_qty AS price -- New calculated column named price
FROM customer_purchases -- All costumer purchases
WHERE customer_id >= 8 -- First condition
AND customer_id <= 10; -- AND with second condition



-- option 2

SELECT
market_date -- Selecting all columns from customer_purchases excluding transaction_time, best practice not to use * 
,customer_id
,vendor_id
,product_id
,quantity
,quantity * cost_to_customer_per_qty AS price -- New calculated column named price
FROM customer_purchases -- All costumer purchases
WHERE customer_id BETWEEN 8 AND 10; -- One condition same boolean as above AND


--CASE
/* 1. Products can be sold by the individual unit or by bulk measures like lbs. or oz. 
Using the product table, write a query that outputs the product_id and product_name
columns and add a column called prod_qty_type_condensed that displays the word “unit” 
if the product_qty_type is “unit,” and otherwise displays the word “bulk.” */

SELECT
product_id -- Selecting columns product_id and product_name from product
,product_name
,CASE WHEN product_qty_type = 'unit' THEN 'unit' -- displays unit for units type 
ELSE 'bulk' END -- otherwise displays bulk for units type 
AS prod_qty_type_condensed -- new column named prod_qty_type_condensed
FROM product;



/* 2. We want to flag all of the different types of pepper products that are sold at the market. 
add a column to the previous query called pepper_flag that outputs a 1 if the product_name 
contains the word “pepper” (regardless of capitalization), and otherwise outputs 0. */

SELECT
product_id -- Outputs columns product_id and product_name
,product_name
,CASE WHEN product_name LIKE '%epper%' THEN 1 -- outputs a 1 if product_name contains the word peper (regardless of capitilization)
ELSE 0 END --otherwise outputs 0
AS pepper_flag -- new column named prod_qty_type_condensed
FROM product
ORDER BY product_id;

--JOIN
/* 1. Write a query that INNER JOINs the vendor table to the vendor_booth_assignments table on the 
vendor_id field they both have in common, and sorts the result by vendor_name, then market_date. */

SELECT * -- Selecting every column in vendor
FROM vendor v -- Make an alias of vendor table as v
INNER JOIN vendor_booth_assignments vba -- make an alias of vendor_booth_assignments as vba
		ON v.vendor_id =vba.vendor_id -- join tables on vendor_id
ORDER BY v.vendor_name, vba.market_date; 
 -- order ascending by vendor_name then market_date


/* SECTION 3 */

-- AGGREGATE
/* 1. Write a query that determines how many times each vendor has rented a booth 
at the farmer’s market by counting the vendor booth assignments per vendor_id. */

SELECT
vendor_id -- selecting vendor_id from vendor_booth_assignments table
,COUNT(*) AS booth_assignment_frequency
FROM vendor_booth_assignments
GROUP BY	 vendor_id; -- outputs frequency by vendor 

/* 2. The Farmer’s Market Customer Appreciation Committee wants to give a bumper 
sticker to everyone who has ever spent more than $2000 at the market. Write a query that generates a list 
of customers for them to give stickers to, sorted by last name, then first name. 

HINT: This query requires you to join two tables, use an aggregate function, and use the HAVING keyword. */

SELECT -- selecting columns from customer table
c.customer_id --ambiguous column name without alias reference from join 
,c.customer_first_name
,c.customer_last_name
,ROUND(SUM(quantity * cost_to_customer_per_qty),2)AS total_spent

FROM customer c -- creating an alias for JOIN
INNER JOIN customer_purchases cp
    ON c.customer_id = cp.customer_id

GROUP BY
c.customer_id,
c.customer_first_name,
c.customer_last_name

HAVING total_spent > 2000

ORDER BY c.customer_last_name, c.customer_first_name;

--Temp Table
/* 1. Insert the original vendor table into a temp.new_vendor and then add a 10th vendor: 
Thomass Superfood Store, a Fresh Focused store, owned by Thomas Rosenthal

HINT: This is two total queries -- first create the table from the original, then insert the new 10th vendor. 
When inserting the new vendor, you need to appropriately align the columns to be inserted 
(there are five columns to be inserted, I've given you the details, but not the syntax) 

-> To insert the new row use VALUES, specifying the value you want for each column:
VALUES(col1,col2,col3,col4,col5) 
*/

CREATE TABLE temp.new_vendor AS --create a temporary table from vendor table
SELECT *
FROM vendor;

INSERT INTO temp.new_vendor
-- insert values into table by column order, vendor_id, vendor_name, vendor_type,vendor_owner_first_name,vendor_owner_last_name 
VALUES(10, 'Thomass Superfood Store', 'Fresh Focused', 'Thomas', 'Rosenthal'); 

-- Date
/*1. Get the customer_id, month, and year (in separate columns) of every purchase in the customer_purchases table.

HINT: you might need to search for strfrtime modifers sqlite on the web to know what the modifers for month 
and year are! */



/* 2. Using the previous query as a base, determine how much money each customer spent in April 2022. 
Remember that money spent is quantity*cost_to_customer_per_qty. 

HINTS: you will need to AGGREGATE, GROUP BY, and filter...
but remember, STRFTIME returns a STRING for your WHERE statement!! */

