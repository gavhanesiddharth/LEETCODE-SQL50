--1. Number of Unique Subjects Taught by Each Teacher

SELECT teacher_id, 
	COUNT( DISTINCT subject_id) AS cnt
FROM Teacher
GROUP BY teacher_id
ORDER BY teacher_id

--2. User Activity for the Past 30 Days I

SELECT  activity_date AS day,
	COUNT(DISTINCT user_id) AS active_users
FROM Activity
WHERE ('2019-07-27'  - activity_date) < 30 AND 
	activity_date <= '2019-07-27' 
GROUP BY activity_date
ORDER BY activity_date ASC;

--3. Product Sales Analysis III

WITH first_years AS (
    SELECT product_id, 
	MIN(year) AS first_year
    FROM Sales
    GROUP BY product_id
)
SELECT p.product_id, 
	f.first_year, s.quantity, 
	s.price
FROM Product AS p
JOIN first_years AS f 
	ON p.product_id = f.product_id
JOIN Sales AS s 
	ON p.product_id = s.product_id AND 
	f.first_year = s.year
ORDER BY p.product_id;

--4. Classes More Than 5 Students

SELECT class
FROM Courses
GROUP BY class
HAVING COUNT(student) >= 5

--5. Find Followers Count

SELECT user_id, 
	COUNT(DISTINCT follower_id) AS followers_count
FROM Followers
GROUP BY user_id

--6. Biggest Single Number

SELECT MAX(num) AS num
FROM (SELECT num FROM MyNumbers
GROUP BY num
HAVING COUNT(num) = 1);

--7. Customers Who Bought All Products

SELECT c.customer_id
FROM Customer c 
JOIN Product p
ON c.product_key = p.product_key
GROUP BY 1
HAVING COUNT(DISTINCT p.product_key) = (SELECT COUNT(product_key) FROM Product);