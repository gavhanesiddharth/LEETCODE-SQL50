--1. Not Boring Movies

SELECT *
FROM Cinema
WHERE id % 2 <> 0 AND 
	description <> 'boring'
ORDER BY rating DESC

--2. Average Selling Price

SELECT 
    p.product_id 
    ,COALESCE(ROUND(SUM(p.price * u.units)::NUMERIC / NULLIF(SUM(u.units), 0), 2), 0) AS average_price 
FROM 
    Prices AS p
LEFT JOIN 
    UnitsSold AS u
ON 
    p.product_id = u.product_id
AND 
    u.purchase_date >= p.start_date 
AND 
    u.purchase_date <= p.end_date
GROUP BY 
    p.product_id
ORDER BY 
    p.product_id;

--3. Project Employees I

SELECT p.project_id
	,ROUND(AVG(e.experience_years), 2) AS average_years
FROM Project AS p
INNER JOIN Employee AS e
USING(employee_id)
GROUP BY 1
ORDER BY 1


--4. Percentage of Users Attended a Contest

WITH total_count AS (SELECT COUNT(user_id) AS total_user_count FROM Users)
 
SELECT r.contest_id
	,ROUND(COUNT(r.user_id) * 100.00/total_count.total_user_count, 2) AS percentage
FROM Register AS r
JOIN total_count 
ON TRUE
GROUP BY r.contest_id
	,total_count.total_user_count
ORDER BY percentage DESC
	,r.contest_id

--5. Queries Quality and Percentage

SELECT 
    query_name, 
    ROUND(AVG(rating :: NUMERIC/position), 2) AS quality,  
    ROUND(SUM(CASE WHEN rating < 3 THEN 1 ELSE 0 END) * 100.00/COUNT(rating), 2) AS poor_query_percentage
FROM Queries 
WHERE query_name IS NOT NULL
GROUP BY 1
ORDER BY quality DESC

--6. Monthly Transactions I

WITH a AS (SELECT * FROM Transactions AS t WHERE state = 'approved')

SELECT TO_CHAR(b.trans_date, 'YYYY-MM') AS month
	,b.country, COUNT(b.state) AS trans_count, COUNT(a.state ) AS approved_count
	,SUM(b.amount) AS trans_total_amount, COALESCE(SUM(a.amount), 0) AS approved_total_amount 
FROM Transactions AS b
LEFT JOIN a
USING(id)
GROUP BY 2, 1

--7. Immediate Food Delivery II

SELECT 
    ROUND(SUM(CASE WHEN output = 'immediate' THEN 1 ELSE 0 END) * 100.00/COUNT(output), 2) AS immediate_percentage

FROM 
    (SELECT *
    ,(CASE WHEN order_date = customer_pref_delivery_date THEN 'immediate' 
	ELSE 'scheduled' END) AS output,
    ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY order_date) AS a 
    FROM Delivery ) SUB
    

--8. Game Play Analysis IV

WITH b AS (SELECT *
           FROM Activity AS a
           LEFT JOIN (SELECT *, ROW_NUMBER() OVER(PARTITION BY player_id ORDER BY event_date) AS a 
                      FROM Activity) SUB
           USING(player_id)
           WHERE a = 1 AND a.event_date = SUB.event_date + 1)

SELECT ROUND(COUNT(DISTINCT b.player_id)::NUMERIC/COUNT(DISTINCT c.player_id), 2) AS fraction
FROM Activity AS c
LEFT JOIN b
USING(player_id)



