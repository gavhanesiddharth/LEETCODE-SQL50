--1. Recyclable and Low Fat Products

SELECT product_id
FROM Products
WHERE low_fats = 'Y' and recyclable = 'Y'

--2. Find Customer Referee

SELECT name
FROM Customer
WHERE referee_id IS NULL OR referee_id <> 2;

--3. Big Countries

SELECT name, population, area
FROM World
WHERE area >= 3000000 OR population >= 25000000;

--4.  Article Views I

SELECT DISTINCT viewer_id AS id
FROM Views
WHERE author_id = viewer_id
ORDER BY viewer_id 

--5. Invalid Tweets

SELECT tweet_id
FROM Tweets
WHERE LENGTH( content ) > 15

