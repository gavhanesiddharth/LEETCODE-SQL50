--1. Fix Names in a Table

SELECT user_id, 
	CONCAT(UPPER(LEFT(name,1),
	LOWER(RIGHT(name,LENGTH(name)-1))) AS name 
FROM Users 
ORDER BY user_id

--2. Delete Duplicate Emails

DELETE FROM Person
WHERE Id NOT IN (select min_id 
				  FROM (SELECT MIN(Id) AS min_id 
						FROM Person 
						GROUP BY Email) AS a)


--3. Second Highest Salary

SELECT MAX(salary) As SecondHighestSalary
FROM Employee
WHERE salary != (SELECT MAX(salary) 
				  FROM Employee);

--4. Group Sold Products By The Date

SELECT sell_date, 
       COUNT(DISTINCT activities.product) AS num_sold, 
       STRING_AGG(DISTINCT activities.product, ',') AS products
FROM activities
GROUP BY sell_date
ORDER BY sell_date;

--5. List the Products Ordered in a Period

SELECT product_name, 
	SUM(unit) AS unit
FROM Products
RIGHT JOIN Orders
USING(product_id )
WHERE EXTRACT(YEAR FROM order_date) = 2020
  AND EXTRACT(MONTH FROM order_date) = 2
GROUP BY product_name
HAVING SUM(unit) >= 100

--6. Find Users With Valid E-Mails

SELECT *
FROM Users
WHERE mail ~ '^[a-zA-Z][a-zA-Z0-9_.-]*@leetcode\.com$'
  AND mail NOT LIKE '%#%';
