--1. Replace Employee ID With The Unique Identifier

SELECT eu.unique_id
	  ,e.name
FROM Employees AS e
LEFT JOIN EmployeeUNI AS eu
USING(id)

--2. Customer Who Visited but Did Not Make Any Transactions

SELECT v.customer_id
	  ,SUM(CASE WHEN t.transaction_id IS NULL THEN 1 ELSE 0 END) AS count_no_trans
FROM Visits AS v
LEFT JOIN Transactions AS t
USING(visit_id)
WHERE t.transaction_id IS NULL
GROUP BY v.customer_id

--3. Rising Temperature

SELECT w1.id
FROM Weather AS w1
	,Weather AS w2
WHERE w2.recordDate = (w1.recordDate - 1) AND  
	  w1.temperature > w2.temperature

--4. Average Time of Process per Machine

SELECT a1.machine_id
	  ,ROUND(AVG(a1.timestamp - a2.timestamp):: NUMERIC, 3) AS processing_time
FROM Activity AS a1, Activity AS a2
WHERE a1.machine_id = a2.machine_id AND 
	  a1.process_id = a2.process_id AND 
	  a1.activity_type = 'end' AND 
	  a2.activity_type = 'start'
GROUP BY a1.machine_id

--5. Employee Bonus

SELECT e.name
	  ,b.bonus
FROM Employee AS e
LEFT JOIN Bonus AS b
USING(empId)
WHERE b.bonus < 1000 OR 
	  b.bonus IS NULL

--6. Students and Examinations

SELECT s.student_id
	  ,s.student_name
	  ,sb.subject_name
	  ,COUNT(e.subject_name ) AS attended_exams
FROM Students AS s
CROSS JOIN Subjects AS sb
LEFT JOIN Examinations AS e
ON s.student_id = e.student_id AND 
   sb.subject_name = e.subject_name
GROUP BY 1, 2, 3
ORDER BY 1, 3

--7. Managers with at Least 5 Direct Reports

SELECT f.name
FROM Employee f
WHERE f.id  IN (SELECT m.managerId 
                      FROM employee m 
                      JOIN employee e 
                      ON e.id = m.managerId 
                      GROUP BY m.managerId 
                      HAVING COUNT(m.managerId) >= 5)

--8. Confirmation Rate

SELECT s.user_id
	  ,ROUND(COALESCE(SUM(CASE WHEN action = 'confirmed' THEN 1 ELSE 0 END)/NULLIF(COUNT(action)::float, 0), 0)::NUMERIC, 2) AS  confirmation_rate 
FROM Signups AS s
LEFT JOIN Confirmations AS c
USING(user_id)
GROUP BY user_id 


