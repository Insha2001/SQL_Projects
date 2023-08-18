
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
