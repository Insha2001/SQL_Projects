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
  
  -- What are the bottom and top 3 literacy rate
  
  select a.* from 
 (select state, round(avg(literacy),0) avg_literacy_rate from dataset1
 group by state
 order by avg_literacy_rate desc limit 3) a
 union 
 select b.* from
 (select state, round(avg(literacy),0) avg_literacy_rate from dataset1
 group by state
 order by avg_literacy_rate asc limit 3)b;
 
 -- OR
 
 drop table if exists topstates;
 create table topstates(state varchar(255), topstate float);
 insert into topstates (  select state, round(avg(literacy),0) avg_literacy_rate from dataset1
 group by state
 order by avg_literacy_rate desc limit 3);
  drop table if exists bottomstates;
 create table bottomstates(state varchar(255), bottomstate float);
 insert into bottomstates (  select state, round(avg(literacy),0) avg_literacy_rate from dataset1
 group by state
 order by avg_literacy_rate asc limit 3);
 
 select * from topstates
 union
 select * from bottomstates;
 
 -- What are the states d=satrting with a and a or b
 select distinct(state) from dataset1
 where state like 'a%' ;
 
  select distinct(state) from dataset1
 where state like 'a%' or state like 'b%';
 
 -- Joining the tables on district to get number of males and females
 select d.state,sum(d.males) total_males,sum(d.Females) total_females from(select district, state,round(population/(sex_ratio+1),0) as males,round((population*(sex_ratio))/(sex_ratio+1),0) as Females 
 from (select a.district, a.state,a.sex_ratio,b.population from dataset1 a inner join dataset2 b
 on a.district=b.district) c)d
 group by d.state;
 
 -- total literacy people
 -- joning he two tables
 select d.state,sum(literacy_people),sum(illiteracy_people) from
 (select district, state,round((literacy*population),0) literacy_people,round(population*(1-literacy),0) illiteracy_people from 
 (select a.district,a.state,a.literacy/100 literacy,b.population 
 from dataset1 a inner join dataset2 b
 on a.district=b.district)c)d
 group by d.state;
 
 -- population of previous census
 select sum(e.total_by_states_prev), sum(e.total_by_states_curr) from
 (select d.state,sum(prev_census_population) total_by_states_prev, sum(curr_census_population) total_by_states_curr from
 (select c.district, c.state, round(population/(growth+1),0) prev_census_population, population curr_census_population from
 (select a.district, a.state,a.growth,b.population from dataset1 a inner join dataset2 b
 on a.district=b.district)c)d
 group by d.state)e;
 
 -- How population is affecting the area occupied
 -- Giving a common key to the tables answer and joining them
  select l.area/l.sum_popu_prev,l.area/l.sum_popu_curr from
  (select h.*,i.area from
  (select '1' as keyy, f.* from
  (select sum(e.total_by_states_prev) sum_popu_prev, sum(e.total_by_states_curr) sum_popu_curr from
 (select d.state,sum(prev_census_population) total_by_states_prev, sum(curr_census_population) total_by_states_curr from
 (select c.district, c.state, round(population/(growth+1),0) prev_census_population, population curr_census_population from
 (select a.district, a.state,a.growth,b.population from dataset1 a inner join dataset2 b
 on a.district=b.district)c)d
 group by d.state)e)f)h inner join
 (select '1' as keyy, g.* from
 (select sum(area_km2) area from dataset2)g)i
 on h.keyy=i.keyy)l;
 
 -- Window function as rank
 -- give rank to the district with the highest literacy rate per states
 select a.* from
 (select district, state, literacy,rank() over(partition by state order by literacy desc) rnk from dataset1)a
 where a.rnk<=3;
 
