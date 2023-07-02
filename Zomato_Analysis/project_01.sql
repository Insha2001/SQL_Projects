use project_01;

drop table if exists goldusers_signup;
CREATE TABLE goldusers_signup(userid int,gold_signup_date date); 
-- Date value in MySQL database is YYYY-MM-DD
INSERT INTO goldusers_signup VALUES (1,'2017-09-22'),
(3,'2017-04-21');

drop table if exists users;
CREATE TABLE users(userid int,signup_date date); 

INSERT INTO users(userid,signup_date) 
 VALUES (1,'2014-09-02'),
(2,'2015-01-15'),
(3,'2014-04-11');

drop table if exists sales;
CREATE TABLE sales(userid int,created_date date,product_id int); 


INSERT INTO sales(userid,created_date,product_id) 
 VALUES (1,'2017-04-19',2),
(3,'2019-12-18',1),
(2,'2020-07-20',3),
(1,'2019-10-23',2),
(1,'2018-03-19',3),
(3,'2016-12-20',2),
(1,'2016-11-09-',1),
(1,'2016-05-20',3),
(2,'2017-09-24',1),
(1,'2017-03-11',2),
(1,'2016-03-11',1),
(3,'2016-11-10',1),
(3,'2017-12-07',2),
(3,'2016-12-15',2),
(2,'2017-11-08',2),
(2,'2018-09-10',3);


drop table if exists product;
CREATE TABLE product(product_id int,product_name text,price int); 

INSERT INTO product(product_id,product_name,price) 
 VALUES
(1,'p1',980),
(2,'p2',870),
(3,'p3',330);


select * from sales;
select * from product;
select * from goldusers_signup;
select * from users;

-- Q-1: What is the total amount each customer spent on zomato?
Select a.userid,sum(b.price) as total_price from sales a
inner join product b
on a.product_id=b.product_id
group by a.userid;
-- Here we did it with just user you can select product id and put it in group by condition also

-- Q-2: How many days has each customer visited zomato?
Select userid,count(created_date)as days_visited from sales
group by userid
order by days_visited;

-- Q-3: What was the first product purchased by each customer?
select a.userid,a.created_date,b.product_name from sales a 
inner join product b
on a.product_id=b.product_id
order by a.created_date;

select * from 
(select *,rank() over(partition by userid order by created_date) rnk from sales) a where rnk=1;

-- Q-4: What is the most purchased item on the menu and how many times was it purchased by all customer?
select count(product_id) as max_times,product_id from sales 
group by product_id
order by max_times DESC LIMIT 1;

select userid,count(product_id) max_times from sales 
where product_id=(select top 1 product_id from sales group by product_id order by count(product_id) desc)
group by userid;

-- Q-5: Which item was most popular for each customer?

select * from 
(select *, rank() over(partition by userid order by cnt desc) rnk from(
select userid, count(product_id) as cnt, product_id from sales
group by userid, product_id) a)b
where rnk=1;

-- Q-6: Which item was purchased first by the custimer aftey became a member?
select *from (
select c.*,rank() over(partition by userid order by created_date) rnk from
(select a.userid,a.created_date, a.product_id,b.gold_signup_date from sales a
inner join goldusers_signup b 
on a.userid=b.userid and created_date>=gold_signup_date)c)d where rnk=1;

-- Q-7: Which item was purchased just before the customer become a member?
select *from (
select c.*,rank() over(partition by userid order by created_date desc) rnk from
(select a.userid,a.created_date, a.product_id,b.gold_signup_date from sales a
inner join goldusers_signup b 
on a.userid=b.userid and created_date<=gold_signup_date)c)d where rnk=1;

-- Q-8: What is the total order and amt spent for each member before they became a member?

select userid,count(created_date), sum(price) from
(select c.*, d.price from
(select a.userid,a.created_date,a.product_id, b.gold_signup_date from sales a
inner join goldusers_signup b
on a.userid=b.userid and a.created_date<=b.gold_signup_date)c
inner join product d
on c.product_id=d.product_id)e
group by userid;

-- Q-9: if buying each product generates point for eg 5rs=2 point and each product has different has diffferent purchasing points
-- for eq for p1 5rs=1 points, for p2 10rs=5 point and p3 5rs=1 point
-- calculate point collected by each customer

select userid, total_points_earned*2.5 from
(select userid,sum(total_points) total_points_earned from
(select e.*, amt/points as total_points from
(select d.*, case when d.product_id=1 then 5 when d.product_id=2 then 2 when d.product_id=3 then 5 else 0 end as points from  
(select c.userid,c.product_id, sum(price) amt from
(select a.userid,a.product_id, b.price from sales a
inner join product b
on a.product_id=b.product_id)c
group by a.userid,a.product_id)d)e)f
group by userid)g;
-- Second part of the problem whwere userid is changed to product id
-- Providing subquery inorder to get the new col
select * from 
(select *, rank() over(order by total_points_earned desc) rnk from
(select product_id,sum(total_points) total_points_earned from
(select e.*, amt/points as total_points from
(select d.*, case when d.product_id=1 then 5 when d.product_id=2 then 2 when d.product_id=3 then 5 else 0 end as points from  
(select c.userid,c.product_id, sum(price) amt from
(select a.userid,a.product_id, b.price from sales a
inner join product b
on a.product_id=b.product_id)c
group by a.userid,a.product_id)d)e)f
group by product_id)g)h where rnk=1;

-- Q-10: In the first one year after a customer joins the gold program (including join date)
-- irrespective of what the customer has purchased they earn 5 zomato points for every 10 rs spent
-- who earned more more 1 or 3 and what was their points earnings in their first years?

select * from sales;
select * from product;
select * from goldusers_signup;
select * from users;

select c.*, (d.price)*0.5 as total_points from 
(select a.userid, a.product_id, a.created_date,b.gold_signup_date from sales a
inner join goldusers_signup b
on a.userid=b.userid and a.created_date>=b.gold_signup_date and a.created_date<=date_add(gold_signup_date, INTERVAL 1 YEAR))c
inner join product d
on c.product_id=d.product_id;

-- Q-11: Rank all the transcation for customer>

Select *, rank() over(partition by userid order by created_date) rnk from sales; 


-- Q-12: Rank all the transcation for each member whenever they are a member of glod and for non gold transcation mark na

select d.*, case when rnk=0 then 'na' else rnk end as rnkk from
(select c.*, cast((case when gold_signup_date is null then 0 else rank() over(partition by userid order by created_date desc) end ) as char) as rnk from 
(select a.userid, a.created_date,b.gold_signup_date from sales a
left join goldusers_signup b
on a.userid=b.userid and created_date>=gold_signup_date)c)d;

-- varchar doesn't work here

