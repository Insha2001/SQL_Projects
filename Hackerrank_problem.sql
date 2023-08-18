
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
