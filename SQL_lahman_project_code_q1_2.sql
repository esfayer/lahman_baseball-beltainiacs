 #1 What range of years for baseball games played does the provided database cover?
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
