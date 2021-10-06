-- Hot tip for everyone: It is possible to join on two columns in one join. Here's a made-up example.
-- SELECT *
-- FROM students
-- INNER JOIN courses
-- ON (students.id = course.student_id AND students.semester = courses.semester)



--1. What range of years for baseball games played does the provided database cover?
--1871-2016
-- SELECT team, year
-- FROM homegames
-- ORDER BY year DESC;


--2. Find the name and height of the shortest player in the database. How many games did he play in? 
--What is the name of the team for which he played?
--One game, lol
--Eddie Gaedel, 43 gaedeed01, team SLA, 1951

-- SELECT playerid, debut, finalgame
-- FROM people
-- WHERE playerid = 'gaedeed01';



--7.  From 1970 – 2016, what is the largest number of wins for a team that did not win the world series? 
--C

SELECT DISTINCT(name),
	   SUM(w) OVER(PARTITION BY teamid) AS total_wins
FROM teams
WHERE teamid IN
	  (SELECT name, wswin, yearid
FROM teams
WHERE wswin IS NOT NULL AND wswin::text='Y'
ORDER BY total_wins DESC;


--What is the smallest number of wins for a team that did win the world series? Doing this will probably 
--result in an unusually small number of wins for a world series champion – determine why this is the case. 
--Then redo your query, excluding the problem year. How often from 1970 – 2016 was it the case that a team 
--with the most wins also won the world series? What percentage of the time?





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



SELECT name, wswin, yearid
FROM teams
WHERE wswin IS NOT NULL AND wswin::text='Y'
