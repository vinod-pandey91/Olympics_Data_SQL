--1 which team has won the maximum gold medals over the years.

select name from sys.tables



select top 1 team, count(distinct event)total_gold_medal
from athlete_events ae inner join athletes a on 
ae.athlete_id=a.id
where medal='Gold'
group by team
order by total_gold_medal desc


--2 for each team print total silver medals and year in which they won maximum silver medal..output 3 columns
-- team,total_silver_medals, year_of_max_silver

with cte as (
select team, count(distinct event) total_silver_medals,year,
rank() over(partition by team order by count(distinct event) desc) rn
from athlete_events ae inner join athletes a 
on ae.athlete_id=a.id
where medal='silver'
group by team,year
--order by rn 
),
cte1 as (
select team, sum(total_silver_medals) as total_silver_medal,max(case when rn=1 then year end) year_of_max_silver from cte 
group by team)
select * from cte1;

--3 which player has won maximum gold medals  amongst the players 
--which have won only gold medal (never won silver or bronze) over the years



--select name, count(medal) as total_gold 
--from athlete_events ae inner join athletes a on ae.athlete_id=a.id
--where name not in(select distinct name from athlete_events ae inner join athletes a on ae.athlete_id=a.id where medal in ('Silver','Bronze') and medal='Gold')
--group by name 
--order by total_gold desc;

with cte as (
select name, medal 
from athlete_events ae inner join athletes a on ae.athlete_id=a.id)
select top 1 name, count(medal) as gold_medal_count from cte 
where name not in(select distinct name from cte where medal in ('Silver','Bronze'))
and medal='Gold'
group by name 
order by gold_medal_count desc;




--4 in each year which player has won maximum gold medal . Write a query to print year,player name 
--and no of golds won in that year . In case of a tie print comma separated player names.


with cte as (
select distinct year as year,athlete_id,count(medal) gold_medal_count,
rank() over(partition by year order by count(medal) desc ) rn
from athlete_events
where medal='Gold' 
group by year,athlete_id)
--order by gold_medal_count desc
select year,STRING_AGG(name, ',')as Player_name,max(gold_medal_count) as No_gold_medal
from cte ae inner join athletes a on ae.athlete_id = a.id
where rn=1
group by year
order by No_gold_medal,year,Player_name
;

--5 in which event and year India has won its first gold medal,first silver medal and first bronze medal
--print 3 columns medal,year,sport


select * from (
select event,year,Medal,
rank() over(partition by medal order by year) rn
from athlete_events  ae 
inner join athletes a on 
ae.athlete_id=a.id
where a.team='India' and medal!= 'NA'
group by Medal,event,year)a
where rn=1


--6 find players who won gold medal in summer and winter olympics both.
select top 1 * from athlete_events;
select top 1 * from athletes;

select name  
from athlete_events ae inner join athletes a 
on ae.athlete_id=a.id
where medal='Gold'
group by name 
having count(distinct season)=2

--7 find players who won gold, silver and bronze medal in a single olympics. print player name along with year.

select name, year
from athlete_events ae inner join athletes a on ae.athlete_id=a.id
where medal != 'NA'
group by name,year
having count(distinct medal)=3

--8 find players who have won gold medals in consecutive 3 summer olympics in the same event . Consider only olympics 2000 onwards. 
--Assume summer olympics happens every 4 year starting 2000. print player name and event name.


with cte as (
select name,medal,year,event
from athlete_events ae inner join athletes a on ae.athlete_id=a.id
where medal='gold' and year >=2000 and season='Summer')
select * from (
select *, lag(year) over (partition by name,event order by year) prev_year,
lead(year) over (partition by name,event order by year) nxt_year
from cte)a 
where nxt_year=year+4 and prev_year =year-4 ;
--where year=prev_year+4 and year=next_year-4



















