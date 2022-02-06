use Social_Buzz
Select * from [Content reaction]
Select * from [Content Category]
select * from Duration
select * from scores
select * from Age
-----------------------------------------------------------------------------------------------------
-- RENAMING THE COLUMN NAME .

Select * from [Content Category]
sp_rename '[Content Category].Type','Category_type'

Select * from [Content reaction]
sp_rename '[Content reaction].Type','Reaction_type'
sp_rename '[Content reaction].Datetime','Date_time'

------------------------------------------------------------------------------------------------------------

-- JOINING THE TABLES TOGETHER.

Select [Content reaction].[Content ID],[Content reaction].Reaction_type,[Content reaction].Date_time
,[Content reaction].[User ID],[Content Category].Category_type,[Content Category].Category
,Duration.Duration,Scores.Score,Scores.Sentiment,age.Age
from [Content reaction]
left join [Content Category]
on [Content reaction].[Content ID]=[Content Category].[Content ID]
left join  Duration
on Duration.[User ID]=[Content reaction].[User ID]
left join Scores
on Scores.Type=[Content reaction].Reaction_type
left join Age
on Age.[User ID] = [Content reaction].[User ID]

----------------------------------------------------------------------------------------------------------

-- CREATING A TEMPORARY TABLE.

DROP TABLE IF EXISTS Socialbuzz_Reaction_Analysis
CREATE TABLE Socialbuzz_Reaction_Analysis
(
[Content ID] varchar(200),
Reaction_type varchar(100),
Date_time datetime,
[User ID] varchar(200),
Category_type varchar(100),
Category varchar(100),
Duration int,
Score int,
Sentiment varchar(100),
Age int
)
 
 INSERT INTO Socialbuzz_Reaction_Analysis

 Select [Content reaction].[Content ID],[Content reaction].Reaction_type,[Content reaction].Date_time
,[Content reaction].[User ID],[Content Category].Category_type,[Content Category].Category
,Duration.Duration,Scores.Score,Scores.Sentiment,age.Age
from [Content reaction]
left join [Content Category]
on [Content reaction].[Content ID]=[Content Category].[Content ID]
left join  Duration
on Duration.[User ID]=[Content reaction].[User ID]
left join Scores
on Scores.Type=[Content reaction].Reaction_type
left join Age
on Age.[User ID] = [Content reaction].[User ID]

SELECT * FROM Socialbuzz_Reaction_Analysis

--------------------------------------------------------------------------------------------------

-- Cleaning the Socialbuzz_Reaction_Analysis

SELECT * FROM Socialbuzz_Reaction_Analysis 

SELECT Reaction_type , [User ID]
FROM Socialbuzz_Reaction_Analysis
WHERE Reaction_type is null

DELETE FROM Socialbuzz_Reaction_Analysis
WHERE Reaction_type is null

SELECT Reaction_type ,[user id ],Duration,Age
from Socialbuzz_Reaction_Analysis
WHERE [User id] is null

UPDATE  Socialbuzz_Reaction_Analysis
SET [User ID]='Not Available'
Where [User ID] is null

UPDATE  Socialbuzz_Reaction_Analysis
SET Age=0
Where Age is null

-------------------------------------------------------------------------------------------------

-- Calculations
-- As per the Analysis the Animals category is the most popular category of content.
SELECT Category,SUM(Score) as Total_Score 
FROM Socialbuzz_Reaction_Analysis
Group by Category
ORDER BY Total_Score desc

-- TEMPORARY TABLE FOR THE AGGREGATE SCORES
DROP TABLE if exists Aggregate_scores_categories
CREATE TABLE Aggregate_scores_categories
(
Category varchar(100),
Total_Score int
)
INSERT INTO Aggregate_scores_categories
SELECT Category,SUM(Score) as Total_Score 
FROM Social_Buzz
Group by Category
ORDER BY Total_Score desc
SELECT * FROM Aggregate_scores_categories
---------------------------------------------------------------------------------------------------
-- CREATING A VIEW FOR LATER VISUALIZATION
CREATE View Social_buzz as
select * from Socialbuzz_Reaction_Analysis
select * from Social_buzz

DROP VIEW IF EXISTS Aggregate_scores
Create view Aggregate_scores as
select * from Aggregate_scores_categories
select * from Aggregate_scores

---------------------------------------------------------------------------------------------------------
-- updating the error made with duplicates.

Select * from social_buzz
UPDATE Social_buzz
SET Category = 'soccer'
where category='"soccer"'

SELECT Category,SUM(Score) as Total_Score 
FROM Social_buzz
Group by Category
ORDER BY Total_Score desc
-----------------------------------------------------------------------------------------------
-- QUERYING THE DATASET (Social_buzz)

Select distinct(Category) from Social_Buzz

select category,reaction_type,count(Reaction_type) as count_types
from Social_Buzz
group by reaction_type , category
order by category,count_types desc
-- In the Animals Category which is liked by most of the people.
--The reaction type that's been reacted often is scared.

--Duration of time spent in mins in each category.
-- 81230 mins is spent by the users on the Animals Category Content.
SELECT * FROM Social_buzz

Select Category,Sum(duration) as Total_Duration_spent_on_each_Category_mins
FROM Social_buzz
GROUP BY Category
Order by Total_Duration_spent_on_each_Category_mins desc