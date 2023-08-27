
-- Query the list of CITY names ending with vowels (a, e, i, o, u) from STATION. Your result cannot contain duplicates.
Select distinct(city) from station
where RIGHT(city,1) in ('a','e','i','o','u');
--or
Select distinct(city) from station
where city like '%a' or city like '%e' or city like '%i' or city like '%o' or city like '%u';

-- Query the list of CITY names from STATION which have vowels (i.e., a, e, i, o, and u) as both their first and last characters. Your result cannot contain duplicates.
select distinct(city) from station 
where right(city,1) in ('a','e','i','o','u') and left(city,1) in ('a','e','i','o','u');

-- Query the list of CITY names from STATION that do not start with vowels. Your result cannot contain duplicates.
select distinct(city) from station
where left(city,1) not in ('a','e','i','o','u');

-- Query the list of CITY names from STATION that do not end with vowels. Your result cannot contain duplicates.
select distinct(city) from station
where right(city,1) not in ('a','e','i','o','u');

-- Query the list of CITY names from STATION that either do not start with vowels or do not end with vowels. Your result cannot contain duplicates.
select distinct(city) from station
where left(city,1) not in ('a','e','i','o','u') or right(city,1) not in ('a','e','i','o','u');

-- Query the list of CITY names from STATION that do not start with vowels and do not end with vowels. Your result cannot contain duplicates.
select distinct(city) from station
where left(city,1) not in ('a','e','i','o','u') and right(city,1) not in ('a','e','i','o','u');

-- Advanced Select
-- Write a query identifying the type of each record in the TRIANGLES table using its three side lengths. Output one of the following statements for each record in the table:

-- Equilateral: It's a triangle with  sides of equal length.
-- Isosceles: It's a triangle with  sides of equal length.
-- Scalene: It's a triangle with  sides of differing lengths.
-- Not A Triangle: The given values of A, B, and C don't form a triangle
SELECT CASE 
WHEN A+B<=C OR A+C<=B OR B+C<=A THEN "Not A Triangle"
WHEN A=B AND A<>C THEN "Isosceles"
WHEN A=C AND A<>B THEN "Isosceles"
WHEN A<>B AND A<>C THEN "Scalene"
ELSE "Equilateral"
END FROM TRIANGLES;


-- Query an alphabetically ordered list of all names in OCCUPATIONS, immediately followed by the first letter of each profession as a parenthetical (i.e.: enclosed in parentheses). For example: AnActorName(A), ADoctorName(D), AProfessorName(P), and ASingerName(S).
-- Query the number of ocurrences of each occupation in OCCUPATIONS. Sort the occurrences in ascending order, and output them in the following format:
select concat(name,'(',LEFT(occupation,1),')') as modify_name 
from occupations 
union 
select concat('There are a total of ',count(*),' ', lower(occupation),'s.') as occupation_count 
from occupations 
group by occupation order by modify_name

-- PIVOT TABLES
drop table if exists orders;
CREATE TABLE orders(order_id integer,date date,cust_id integer,amount integer); 

INSERT INTO orders(order_id,date,cust_id,amount) 
 VALUES 
(1,'2021-08-28',1,4922),
(2,'2020-08-05',2,7116),
(3,'2022-08-04',3,1206),
(4,'2022-08-20',1,2841),
(5,'2022-08-20',2,2522),
(6,'2022-08-21',3,5084),
(7,'2022-08-20',1,6680),
(8,'2022-08-02',2,8123),
(9,'2020-08-02',3,6015),
(10,'2022-08-01',2,4092),
(11,'2022-08-02',1,7224),
(12,'2021-08-02',2,7679),
(13,'2022-08-02',3,1303),
(14,'2022-08-02',1,5185),
(15,'2022-08-22',2,2139);

select count(*) from orders;
-- To get the count number of sales by each customer
select 
count(case when cust_id=1 then order_id else null end) as "1",
count(case when cust_id=2 then order_id else null end) as "2",
count(case when cust_id=3 then order_id else null end) as "3"
from orders;
-- To get the count number of sales by each customer yearly basis
select year(date),
count(case when cust_id=1 then order_id else null end) as "1",
count(case when cust_id=2 then order_id else null end) as "2",
count(case when cust_id=3 then order_id else null end) as "3"
from orders
group by year(date);
