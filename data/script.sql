--finding avg strikeouts & home runs per game during for every decade from 1920 - 2016

SELECT round(SUM(hr::numeric)/SUM(ghome::numeric),2) AS avg_hr_1920sgame,
	   round(SUM(so::numeric)/SUM(ghome::numeric),2) AS avg_so_1920sgame,
FROM teams
WHERE ghome IS NOT NULL AND yearid BETWEEN 1920 AND 1929;
--avg hr = 0.80, avg so = 5.63

--below is attempting to categorize into decade
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




-----Q6-----
with total_sb_attempts AS (select playerid as p_id, sb, cs, (sb+cs) AS attempts
						   from batting
						   where cs is not null and sb is not null
						   group by playerid, sb, cs
						   having sb > 19)
						 	   
select people.namefirst, people.namelast, (batting.sb/total_sb_attempts.attempts) as avg_sb
from batting inner join total_sb_attempts on batting.sb = total_sb_attempts.sb
			 inner join people using (playerid)
where yearid = 2016 and batting.sb is not null
group by people.namefirst, people.namelast, avg_sb


