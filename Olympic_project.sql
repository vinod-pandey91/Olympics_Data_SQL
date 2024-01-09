--1 which team has won the maximum gold medals over the years.


select distinct a.team,count(case when medal='gold' then 1 else 0 end) count_of_gold_medal,
count(distinct event) count_of_gold
from athlete_events ae
inner join 
athletes a on ae.athlete_id=a.id 
where medal='gold' 
group by a.team
order by count_of_gold_medal desc;


select   team,count(distinct event) as cnt from athlete_events ae
inner join athletes a on ae.athlete_id=a.id
where medal='Gold'
group by team
order by cnt desc


----2 for each team print total silver medals and year in which they won maximum silver medal..output 3 columns
-- team,total_silver_medals, year_of_max_silver

--with cte as (
--select year,a.team as team_name,
--count(distinct ae.event) as silver_medal
--from athlete_events ae inner join athletes a on ae.athlete_id=a.id
--where medal='silver'
--group by a.team,year
----order by silver_medal desc
--),
--cte2 as
--(select *, rank () over (partition by team_name order by silver_medal desc) rn from cte)

--select team_name,sum (silver_medal) total_silver_medal,max((case when rn=1 then year end)) as  max_medal_year
--from cte2 
--group by team_name
--order by total_silver_medal desc;
------------------------------------------------------------------------------------------------



with cte as (
select  year , a.team,
count(distinct event) silver_medal_count,
rank() over(partition by team order by count(distinct event) desc) rn
from athletes a inner join athlete_events ae on  a.id=ae.athlete_id
where medal='silver'
group by ae.year ,a.team
--order by silver_medal_count desc
)
select team, sum(silver_medal_count)total_silver_medal,max(case when rn=1 then year end ) as year_of_max_silver
from cte 
group by team
order by total_silver_medal desc;



--3 which player has won maximum gold medals  amongst the players 
--which have won only gold medal (never won silver or bronze) over the years


select top 1 * from athlete_events;
select  distinct(id)  from athletes; 

with cte as (
select distinct(athlete_id)id,name ,count(medal) gold_medal_count
from athlete_events ae inner join athletes a on ae.athlete_id=a.id
where medal='gold' 
group by athlete_id, name

)

select name,sum(gold_medal_count)gold_medal_count
from cte
where id not in (select distinct athlete_id from athlete_events where medal not in('silver','bronze')) and medal='gold'
group by  name
order by gold_medal_count desc;


with cte as (
select name,medal
from athlete_events ae
inner join athletes a on ae.athlete_id=a.id)
select top 1 name , count(1) as no_of_gold_medals
from cte 
where name not in (select distinct name from cte where medal in ('Silver','Bronze'))
and medal='Gold'
group by name
order by no_of_gold_medals desc;

select distinct name, count(case when medal='gold' then 1 end ) as gold,
count(case when medal='silver' then 1 end ) as silver,
count(case when medal='bronze' then 1 end ) as bronze

from athlete_events ae inner join athletes a 
on ae.athlete_id=a.id
group by name
order by gold desc, silver, bronze desc
