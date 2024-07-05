--1.  Employees Whose Manager Left the Company

SELECT employee_id
FROM Employees as a
WHERE manager_id not in (SELECT employee_id FROM employees) and 
	salary < 30000
ORDER BY employee_id ASC

--2. Exchange Seats

SELECT CASE WHEN MOD(id, 2) = 0 THEN id - 1 
			WHEN MOD(id, 2) <> 0 AND id + 1 NOT IN (SELECT id FROM Seat) THEN id
			ELSE id + 1 END AS id, 
	student
FROM Seat
ORDER BY id;

--3. Movie Rating

(SELECT u.name AS results
FROM MovieRating AS m
INNER JOIN Users AS u
USING(user_id)
GROUP BY u.name
ORDER BY COUNT(m.user_id) DESC, 
	u.name
LIMIT 1)

UNION ALL

(SELECT mo.title AS results
FROM MovieRating AS m
INNER JOIN Movies AS mo
USING(movie_id)
WHERE m.created_at BETWEEN '2020-02-01' AND '2020-02-29'
GROUP BY mo.title
ORDER BY AVG(m.rating) DESC, 
	mo.title
LIMIT 1);


--4. Restaurant Growth

SELECT visited_on, 
	amount, 
	average_amount
FROM (WITH cte AS (SELECT visited_on,
						   SUM(amount) AS total
      FROM Customer
      GROUP BY visited_on) 

      SELECT visited_on,  
	         SUM(total) OVER(ORDER BY visited_on ASC ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS amount, 
	         ROUND(AVG(total) OVER(ORDER BY visited_on ASC ROWS BETWEEN 6 PRECEDING AND CURRENT ROW), 2) AS average_amount, ROW_NUMBER() OVER() AS R
FROM cte)
WHERE r > 6;

--5. Friend Requests II: Who Has the Most Friends

WITH a AS
(SELECT requester_id AS id FROM RequestAccepted
UNION ALL
SELECT accepter_id AS id FROM RequestAccepted)

SELECT id, 
	COUNT(id) AS num
FROM a
GROUP BY id
ORDER BY num DESC
LIMIT 1

--6. Investments in 2016

WITH cte AS
(SELECT pid, 
		TIV_2015, 
		TIV_2016, COUNT(concat(lat, lon)) OVER (PARTITION BY concat(lat, lon))AS cnt1, 
		COUNT(TIV_2015) OVER(PARTITION BY tiv_2015) AS cnt
FROM insurance)

SELECT ROUND(CAST(SUM(TIV_2016) * 1.00 AS numeric), 2) AS TIV_2016 
FROM cte 
WHERE cnt1=1 AND 
	  cnt!=1

--7. Department Top Three Salaries

WITH RankedEmployees AS (
    SELECT
        e.name AS Employee,
        e.salary,
        d.name AS Department,
        DENSE_RANK() OVER(PARTITION BY e.departmentId ORDER BY e.Salary DESC) AS num
    FROM
        Employee AS e
    LEFT JOIN
        Department AS d
    ON
        e.departmentId = d.id
)

SELECT
    Department,
    Employee,
    Salary
FROM
    RankedEmployees
WHERE
    num <= 3
ORDER BY
    Department,
    num;