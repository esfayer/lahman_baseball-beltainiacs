/* #1 What range of years for baseball games played does the provided database cover?
SELECT
min(year)
,max(year)

FROM
homegames

A: 1871-2016

#2 Find the name and height of the shortest player in the database.
How many games did he play in? What is the name of the team for which he played?


SELECT 
playerID
,nameFirst
,nameLast
,height
FROM
people

ORDER BY height


A: Eddie Gaedel @ 43 inches with playerID = 'gaedeed01' with 1 game
for St. Louis Browns 

SELECT *

FROM
appearances

JOIN teams USING (teamID)

WHERE playerid = 'gaedeed01'

9. Which managers have won the TSN Manager of the Year award in both the
National League (NL) and the American League (AL)? Give their full name
and the teams that they were managing when they won the award.

A:
full names and teams:
James Richard Leyland (ID 'leylaji99') - Pittsburgh Pirates and Detroit Tigers 
David Allen Johnson (ID 'johnsda02') - Baltimore Orioles and Washington Nationals

teams: 




WITH winners as (
SELECT 
DISTINCT p.playerID
--,concat(p.nameGiven,' ',p.nameLast)
--,aw.awardID
--,aw.yearID
--,t.teamID
--,t.name as team_name


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
--,concat(p.nameGiven,' ',p.nameLast)
--,aw.awardID
--,aw.yearID
--,t.teamID
--,t.name


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
,aw.yearid
,t.name

FROM awardsmanagers aw

JOIN winners using (playerid)
JOIN managers m on (aw.playerid=m.playerid and aw.yearid=m.yearid)
JOIN teams t on (t.teamid=m.teamid and t.yearid=aw.yearid)

WHERE aw.awardid='TSN Manager of the Year' 

10.
Find all players who hit their career highest number of home runs in 2016.
Consider only players who have played in the league for at least 10 years,
and who hit at least one home run in 2016. Report the players' first and
last names and the number of home runs they hit in 2016.



WITH 16_max as (
	SELECT
	p.playerid
	,max(b.hr)
	--,b.yearid
	
	FROM
	people p
	JOIN batting b using (playerid)
	GROUP BY 1
	
	)



SELECT
p.playerid
--,b.yearid
,max(b.HR)


FROM
people p

INNER JOIN batting b using (playerid)

WHERE
	b.hr>0
	--AND max(b.HR) = 
	AND b.yearid = '2016'
	AND p.playerid IN
		(SELECT
		playerid
		FROM
		people

		WHERE EXTRACT(year from finalGame::date)-EXTRACT(year from debut::date)>=10)


GROUP BY 1
*/

--people who have been playing for 10 years and have hit any homeruns
with tenyear as (SELECT
		playerid
		FROM
		people
		
		JOIN batting b using (playerid)

		WHERE EXTRACT(year from finalGame::date)-EXTRACT(year from debut::date)>=10
		AND b.hr>0)
		
		SELECT
		distinct tenyear.playerid
		,b.yearid
		,b.hr
		
		FROM
		tenyear
		JOIN batting b using (playerid)


--people who have hit a homerun in 2016
SELECT
	p.playerid
	,b.yearid
	,max(b.hr)
	