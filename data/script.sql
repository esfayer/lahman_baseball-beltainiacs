--q3
SELECT 	p.namefirst,
		p.namelast,
		SUM(sa.salary)
FROM people AS p
LEFT JOIN collegeplaying AS c
ON p.playerid = c.playerid
LEFT JOIN schools AS s
ON c.schoolid = s.schoolid
LEFT JOIN salaries AS sa
ON p.playerid = sa.playerid
WHERE s.schoolname LIKE '%Vanderbilt%' AND sa.salary IS NOT NULL
GROUP BY p.namefirst, p.namelast
ORDER BY SUM(sa.salary) DESC;

--q5
SELECT CASE WHEN yearid BETWEEN 1920 AND 1929 THEN '1920s'
	   		WHEN yearid BETWEEN 1930 AND 1939 THEN '1930s' 
			WHEN yearid BETWEEN 1940 AND 1949 THEN '1940s'
			WHEN yearid BETWEEN 1950 AND 1959 THEN '1950s'
			WHEN yearid BETWEEN 1960 AND 1969 THEN '1960s'
			WHEN yearid BETWEEN 1970 AND 1979 THEN '1970s'
			WHEN yearid BETWEEN 1980 AND 1989 THEN '1980s'
			WHEN yearid BETWEEN 1990 AND 1999 THEN '1990s'
			WHEN yearid BETWEEN 2000 AND 2010 THEN '2000s'
			WHEN yearid BETWEEN 2010 AND 2019 THEN '2010s'
			ELSE '1919 & Before' END AS decade,
			round(SUM(hr::numeric)/SUM(ghome::numeric),2) AS avg_homers_per_game,
	    	round(SUM(so::numeric)/SUM(ghome::numeric),2) AS avg_strikeouts_per_game
FROM teams
WHERE ghome IS NOT NULL
GROUP BY decade
ORDER BY decade;
--
--
-----Q6-----
--andrea's attempts
WITH sb_successes AS (SELECT playerid,
							 sb,
					  		 cs,
					  		 yearid,
					  		 SUM((sb) + (cs)) AS sb_attempt
					   FROM batting
					   GROUP BY playerid, yearid, sb, cs)
						
SELECT 	p.namefirst,
		p.namelast,
		ROUND((sba.sb::numeric / sba.sb_attempt::numeric) * 100, 2) AS sb_percent
FROM people AS p
LEFT JOIN sb_successes AS sba
ON sba.playerid = p.playerid
WHERE sba.sb_attempt >= 20
AND sba.yearid = 2016
GROUP BY p.namefirst, p.namelast, sb_percent
ORDER BY sb_percent DESC;


--
--
--
--Q7--pt 1
select name, yearid, w, wswin 
from teams
where yearid between 1970 and 2016
group by name, yearid, w, wswin
having wswin = 'N'
order by w desc;
--pt 2
select name, yearid, w, wswin 
from teams
where yearid between 1970 and 2016
group by name, yearid, w, wswin
having wswin = 'Y'
order by w;
--pt3
select name, yearid, w, wswin 
from teams
where yearid between 1970 and 2016
group by name, yearid, w, wswin
having wswin = 'Y' and yearid <> 1981
order by w;
--pt 4
WITH final_table_please_god as (WITH wins_n_ws as (select name, yearid as year, wswin, sum(w) as total_wins
												   from teams
												   where yearid between 1970 and 2016
												   group by name, yearid, wswin),
	 				    		
								new as (SELECT name, year, total_wins, wswin,
										max(total_wins) OVER (PARTITION BY year ORDER BY year) as most_wins
										FROM wins_n_ws)

								SELECT name, year, total_wins, most_wins
								FROM new
								WHERE wswin='Y')

SELECT round(SUM ((CASE WHEN total_wins = most_wins THEN 1 ELSE 0 END) * 100)/COUNT(*),3)
FROM final_table_please_god;


WITH winners as (
SELECT 
DISTINCT p.playerID


FROM
people AS p

INNER JOIN managers m using (playerID)
INNER JOIN teams t on (m.teamid=t.teamid AND m.yearID= t.yearID)
INNER JOIN awardsManagers aw on (p.playerID=aw.playerID AND aw.yearID=t.yearID)

WHERE aw.awardID is not null
AND aw.awardid='TSN Manager of the Year'
AND (aw.lgID='AL')

INTERSECT 


SELECT 
distinct p.playerID


FROM
people p

INNER JOIN managers m using (playerID)
INNER JOIN teams t on (m.teamid=t.teamid AND m.yearID= t.yearID)
INNER JOIN awardsManagers aw on (p.playerID=aw.playerID AND aw.yearID=t.yearID)

WHERE aw.awardID is not null
AND aw.awardid='TSN Manager of the Year'
AND (aw.lgID='NL'))

SELECT
aw.playerid
,concat(p.nameGiven,' ',p.nameLast)
,aw.yearid
,t.name

FROM awardsmanagers aw

JOIN winners using (playerid)
JOIN managers m on (aw.playerid=m.playerid and aw.yearid=m.yearid)
JOIN teams t on (t.teamid=m.teamid and t.yearid=aw.yearid)
JOIN people p on aw.playerid=p.playerid

WHERE aw.awardid='TSN Manager of the Year' 


--
SELECT distinct playerID,nameFirst,nameLast,height,batting.g, name
FROM people inner join batting using(playerid)
            inner join teams using (teamid)
WHERE playerid='gaedeed01'
ORDER BY height

--
WITH all_info as (SELECT playerID,nameFirst,nameLast,height,count(batting.g) as total_games, name as team_name
FROM people inner join batting using(playerid)
            inner join teams using (teamid)
			GROUP by 1,2,3,4,6
ORDER BY height)
SELECT namefirst, namelast,height, total_games, team_name
from all_info
WHERE playerid='gaedeed01'

