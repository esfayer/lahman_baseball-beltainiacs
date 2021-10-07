-- Hot tip for everyone: It is possible to join on two columns in one join. Here's a made-up example.
-- SELECT *
-- FROM students
-- INNER JOIN courses
-- ON (students.id = course.student_id AND students.semester = courses.semester)



--1. What range of years for baseball games played does the provided database cover?
--1871-2016
-- SELECT min(year),
-- 	   max(year)
-- FROM homegames;



--2. Find the name and height of the shortest player in the database. How many games did he play in? 
--What is the name of the team for which he played?
--One game, lol
--Eddie Gaedel, 43 gaedeed01, team SLA St.Lous Browns, 1951


WITH all_info as (SELECT playerID,nameFirst,nameLast,height,count(batting.g) as total_games, name as team_name
FROM people inner join batting using(playerid)
            inner join teams using (teamid)
			GROUP by 1,2,3,4,6
ORDER BY height)
SELECT namefirst, namelast,height, total_games, team_name
from all_info
WHERE playerid='gaedeed01'



--3. Find all players in the database who played at Vanderbilt University. Create a list showing each player’s
--first and last names as well as the total salary they earned in the major leagues. Sort this list in
--descending order by the total salary earned. Which Vanderbilt player earned the most money in the majors?

-- SELECT 	p.namefirst,
-- 		p.namelast,
-- 		SUM(sa.salary)
-- FROM people AS p
-- LEFT JOIN collegeplaying AS c
-- ON p.playerid = c.playerid
-- LEFT JOIN schools AS s
-- ON c.schoolid = s.schoolid
-- LEFT JOIN salaries AS sa
-- ON p.playerid = sa.playerid
-- WHERE s.schoolname LIKE '%Vanderbilt%' AND sa.salary IS NOT NULL
-- GROUP BY p.namefirst, p.namelast
-- ORDER BY SUM(sa.salary) DESC;


-- SELECT DISTINCT(people.namefirst),
-- 	   people.namelast,
-- 	   schoolid
-- FROM collegeplaying JOIN people ON collegeplaying.playerid=people.playerid
-- WHERE schoolid ILIKE '%vandy%'


--4. Using the fielding table, group players into three groups based on their position: label players 
--with position OF as "Outfield", those with position "SS", "1B", "2B", and "3B" as "Infield", and those 
--with position "P" or "C" as "Battery". Determine the number of putouts made by each of these three 
--groups in 2016.


-- SELECT 	SUM(po),
-- 		CASE
-- 			WHEN pos = 'OF' THEN 'Outfield'
-- 			WHEN pos = 'P' THEN 'Battery'
-- 			WHEN pos = 'C' THEN 'Battery'
-- 			WHEN pos = '1B' THEN 'Infield'
-- 			WHEN pos = '2B' THEN 'Infield'
-- 			WHEN pos = '3B' THEN 'Infield'
-- 			WHEN pos = 'SS' THEN 'Infield'
-- 			END AS pos_group
-- FROM fielding
-- WHERE yearid = '2016'
-- GROUP BY pos_group


--5.Barrett
-- SELECT SUM(ghome) AS total_ghome, SUM(hr) AS tota_hr, SUM(so) AS total_so
-- FROM teams
-- where ghome is not null and yearid between 1920 and 1929

-- SELECT (SUM(so::numeric)/SUM(ghome::numeric)) AS per_game
-- FROM teams
-- WHERE ghome IS NOT NULL AND yearid BETWEEN 1920 AND 1929


-- SELECT (SUM(hr::numeric)/SUM(ghome::numeric)) AS per_game
-- FROM teams
-- WHERE ghome IS NOT NULL AND yearid BETWEEN 1920 AND 1929



--6. Find the player who had the most success stealing bases in 2016, where __success__ is measured 
--as the percentage of stolen base attempts which are successful. (A stolen base attempt results 
--either in a stolen base or being caught stealing.) Consider only players who attempted _at least_ 20 
--stolen bases.

-- WITH sb_successes AS (	SELECT	playerid,
-- 								sb,
-- 					  			cs,
-- 					  			yearid,
-- 					  			SUM((sb) + (cs)) AS sb_attempt
-- 						FROM batting
-- 						GROUP BY playerid, yearid, sb, cs)
						
-- SELECT 	p.namefirst,
-- 		p.namelast,
-- 		ROUND((sba.sb::numeric / sba.sb_attempt::numeric) * 100, 2) AS sb_percent
-- FROM people AS p
-- LEFT JOIN sb_successes AS sba
-- ON sba.playerid = p.playerid
-- WHERE sba.sb_attempt >= 20
-- AND sba.yearid = 2016
-- GROUP BY p.namefirst, p.namelast, sb_percent
-- ORDER BY sb_percent DESC;



--7.  From 1970 – 2016, what is the largest number of wins for a team that did not win the world series? 
--SEA 2001 116 wins
--26%


-- WITH final_table_please_god as (
-- WITH wins_n_ws as (
-- select
-- name
-- ,yearid as year
-- ,wswin
-- ,sum(w) as total_wins
-- from teams
-- where yearid between 1970 and 2016
-- group by name, yearid, wswin),
-- new as (
-- SELECT
-- name
-- ,year
-- ,total_wins
-- ,wswin
-- ,max(total_wins) OVER (PARTITION BY year ORDER BY year) as most_wins
-- FROM
-- wins_n_ws)
-- SELECT
-- name
-- ,year
-- ,total_wins
-- ,most_wins
-- FROM
-- new
-- WHERE wswin='Y')
-- SELECT
-- round(SUM ((CASE WHEN total_wins = most_wins THEN 1 ELSE 0 END) * 100)/COUNT(*),3)
-- FROM
-- final_table_please_god



--8. Using the attendance figures from the homegames table, find the teams and parks which had the top 5 
--average attendance per game in 2016 (where average attendance is defined as total attendance divided
--by number of games). Only consider parks where there were at least 10 games played. Report the park name, 
--team name, and average attendance. Repeat for the lowest 5 average attendance.

-- SELECT	*
-- FROM (
-- 		SELECT 	p.park_name,
-- 				t.name,
-- 				SUM((h.attendance) / (h.games)) AS avg_attendence
-- 		FROM homegames AS h
-- 		LEFT JOIN parks AS p
-- 		ON h.park = p.park
-- 		LEFT JOIN teams AS t
-- 		ON h.team = t.teamid
-- 		WHERE games >= 10 AND year = 2016
-- 		GROUP BY p.park_name, t.name
-- 		ORDER BY avg_attendence DESC
-- 		LIMIT 5) AS top_5_avg_att
-- UNION
-- SELECT 	*
-- FROM (
-- 		SELECT	p.park_name,
-- 				t.name,
-- 				SUM((h.attendance) / (h.games)) AS avg_attendence
-- 		FROM homegames AS h
-- 		LEFT JOIN parks AS p
-- 		ON h.park = p.park
-- 		LEFT JOIN teams AS t
-- 		ON h.team = t.teamid
-- 		WHERE games >= 10 AND year = 2016
-- 		GROUP BY p.park_name, t.name
-- 		ORDER BY avg_attendence ASC
-- 		LIMIT 5) AS bottom_5_avg_att
-- ORDER BY avg_attendence DESC



--9. Which managers have won the TSN Manager of the Year award in both the National League (NL) 
--and the American League (AL)? Give their full name and the teams that they were managing when 
--they won the award.

-- WITH winners as (
-- SELECT 
-- DISTINCT p.playerID


-- FROM
-- people AS p

-- INNER JOIN managers m using (playerID)
-- INNER JOIN teams t on (m.teamid=t.teamid AND m.yearID= t.yearID)
-- INNER JOIN awardsManagers aw on (p.playerID=aw.playerID AND aw.yearID=t.yearID)

-- WHERE aw.awardID is not null
-- AND aw.awardid='TSN Manager of the Year'
-- AND (aw.lgID='AL')

-- INTERSECT 


-- SELECT 
-- distinct p.playerID


-- FROM
-- people p

-- INNER JOIN managers m using (playerID)
-- INNER JOIN teams t on (m.teamid=t.teamid AND m.yearID= t.yearID)
-- INNER JOIN awardsManagers aw on (p.playerID=aw.playerID AND aw.yearID=t.yearID)

-- WHERE aw.awardID is not null
-- AND aw.awardid='TSN Manager of the Year'
-- AND (aw.lgID='NL'))

-- SELECT
-- aw.playerid
-- ,concat(p.nameGiven,' ',p.nameLast)
-- ,aw.yearid
-- ,t.name

-- FROM awardsmanagers aw

-- JOIN winners using (playerid)
-- JOIN managers m on (aw.playerid=m.playerid and aw.yearid=m.yearid)
-- JOIN teams t on (t.teamid=m.teamid and t.yearid=aw.yearid)
-- JOIN people p on aw.playerid=p.playerid

-- WHERE aw.awardid='TSN Manager of the Year' 




--10. Find all players who hit their career highest number of home runs in 2016. Consider only players
--who have played in the league for at least 10 years, and who hit at least one home run in 2016. Report 
--the players' first and last names and the number of home runs they hit in 2016.

-- with tenmax as (
-- 	with tenyear as (SELECT
-- 		concat(namefirst, ' ',namelast) as full_name
-- 		,playerid
-- 		FROM
-- 		people
		
-- 		JOIN batting b using (playerid)

-- 		WHERE EXTRACT(year from finalGame::date)-EXTRACT(year from debut::date)>=10
-- 		AND b.hr>0)
		
-- 		SELECT
-- 		distinct tenyear.playerid as id
-- 		,full_name
-- 		,b.yearid as year
-- 		,b.hr as hr
-- 		,max(b.hr) OVER (PARTITION BY tenyear.playerid ORDER BY tenyear.playerid) as player_max_hr
		
-- 		FROM
-- 		tenyear
-- 		JOIN batting b using (playerid))
		
-- 		SELECT
-- 		id
-- 		,full_name
-- 		,year
-- 		,player_max_hr
		
-- 		FROM
-- 		tenmax
-- 		WHERE
-- 		year = '2016' and hr=player_max_hr;

--**Open-ended questions**
--B1. Is there any correlation between number of wins and team salary? Use data from 2000 and later 
--to answer this question. As you do this analysis, keep in mind that salaries across the whole
--league tend to increase together, so you may want to look on a year-by-year basis.
