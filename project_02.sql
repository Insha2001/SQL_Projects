create database project_02;
use project_02;

select * from dataset1;
select * from dataset2;

-- Total number of rows in both the tables
Select count(*) from dataset1;
select count(*) from dataset2;

-- Collect Data for jharkhand and bihar
Select * from dataset1
where state in ('Jharkhand' , 'bihar');

-- Calculate population of india
 select SUM(Population) as population from dataset2;
 
 -- What was the average growth of the country
 select AVG(growth)*100 growth from dataset1;
 -- This is overall
 
 -- What is the average growth by state 
 -- Aggreagte function
 select state, avg(growth)*100 growth_state from dataset1
 group by state;
 
 -- What is the average sex ratio of India and by state
 
 select avg(sex_ratio)  from dataset1;
 select state, round(avg(sex_ratio),0) as avg_sex_ratio from dataset1
 group by state
 order by  avg_sex_ratio desc ;
 
 -- What is the avg literacy rate by state
 -- Having clause is used on aggregate function
 select state, round(avg(literacy),0) avg_literacy_rate from dataset1
 group by state
 having avg_literacy_rate>90
 order by avg_literacy_rate desc;
 
 -- What are the top 3 state having highest growth rate
 select state, round(avg(growth)*100, 2) growth_state from dataset1
 group by state
 order by growth_state desc limit 3;
 -- top doesn't work in mysql 
 select top 3 state, round(avg(growth)*100, 2) growth_state from dataset1
 group by state
 
  -- What are the bottom 3 state having lowest growth rate
 select state, round(avg(growth)*100, 2) growth_state from dataset1
 group by state
 order by growth_state limit 3;
  -- What are the bottom 3 state having highest sex ratio
  select state, round(avg(sex_ratio),0) avg_sex_ratio from dataset1
  group by state
  order by avg_sex_ratio limit 3;
  
  