--1. The Number of Employees Which Report to Each Employee

SELECT e1.employee_id, 
	e1.name, 
	COUNT(e2.reports_to) AS reports_count, 
	ROUND(AVG(e2.age)) AS average_age
FROM Employees AS e1
INNER JOIN Employees AS e2
ON e1.employee_id = e2.reports_to
GROUP BY e1.employee_id, 
	e1.name
ORDER BY e1.employee_id;

--2. Primary Department for Each Employee

SELECT employee_id, 
	department_id
FROM Employee
WHERE primary_flag = 'Y' OR 
	employee_id IN (SELECT employee_id FROM employee GROUP BY employee_id HAVING COUNT(department_id) = 1)


--3. Triangle Judgement

SELECT x, 
	y, 
	z, 
	CASE WHEN x + y > z AND y + z > x AND x + z > y THEN 'Yes'
            ELSE 'No'
            END AS triangle
FROM Triangle;

--4. Consecutive Numbers

SELECT DISTINCT n1.num as ConsecutiveNums
FROM logs as n1
JOIN logs as n2 
	ON n1.num = n2.num
JOIN logs as n3 
	ON n1.num = n3.num
WHERE n2.num = n1.num AND 
	n3.num = n1.num AND 
	n1.id = n2.id - 1 AND 
 	n2.id = n3.id - 1;

--5. Product Price at a Given Date

SELECT DISTINCT p.product_id, 
	COALESCE(sub.new_price, 10) AS price 
FROM Products AS p
LEFT JOIN (SELECT product_id, 
				  new_price, 
				  RANK() OVER(PARTITION BY product_id ORDER BY change_date DESC) AS r
FROM Products
WHERE change_date <=  '2019-08-16') AS sub
ON  p.product_id = sub.product_id AND 
	sub.r = 1

--6. Last Person to Fit in the Bus

SELECT person_name
FROM (SELECT *, 
		     SUM(weight) OVER(ORDER BY turn) AS CUMSUM
      FROM Queue)
WHERE cumsum <= 1000
ORDER BY CUMSUM DESC
LIMIT 1

--7. Count Salary Categories

SELECT category, 
	COALESCE(CCOUNT(category), 0)
FROM (SELECT *, 
			CASE WHEN income < 20000 THEN 'Low Salary'
            WHEN income >= 20000 AND income <= 50000 THEN 'Average Salary'
            ELSE 'High Salary'
            END AS category
FROM Accounts)
GROUP BY category