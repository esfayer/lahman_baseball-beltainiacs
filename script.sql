--finding avg strikeouts & home runs per game during 1870s
select round(avg(so / g), 2) AS avg_so_1920s, round(avg(hr / g), 2) AS avg_hr_1920s
from teams
where yearid between 1920 and 1929;

select round(avg(so / g), 2) AS avg_so_1930s, round(avg(hr / g), 2) AS avg_hr_1930s
from teams
where yearid between 1930 and 1939;


select sum(so) as totalso, sum(ghome) as totalghome, sum(hr) as homers
from teams
where ghome is not null and yearid between 1920 and 1929



select round((sum(hr))/(sum(ghome)), 10)
from teams
where ghome is not null and yearid between 1920 and 1929




-----Q6-----
with total_sb_attempts AS (select playerid, sb, (sb+cs) AS total_sb
							   from batting
							   where cs is not null and sb is not null
							   group by playerid, total_sb, sb
						   	   having sb > 19
						  	   order by total_sb desc)
							   
select people.namefirst, people.namelast, total_sb_attemps.total_sb
from batting inner join total_sb_attempts on batting.sb = total_sb_attempts.sb
			 inner join people using (playerid)
where yearid = 2016
group by people.namefirst, people.namelast,total_sb_attempts.total_sb;

