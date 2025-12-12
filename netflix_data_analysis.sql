--'Netflix' Project
DROP TABLE IF EXISTS netflix;

CREATE TABLE netflix(
	show_id	VARCHAR(6),
	type	VARCHAR(10),
	title	VARCHAR(150),
	director	VARCHAR(208),
	casts	VARCHAR(1000),
	country	VARCHAR(150),
	date_added	VARCHAR(50),
	release_year	INT,
	rating	VARCHAR(10),
	duration	VARCHAR(15),
	listed_in	VARCHAR(100),
	description	VARCHAR(250)
);

SELECT * FROM netflix;

SELECT COUNT(*) AS total_content
FROM netflix;

SELECT DISTINCT type
FROM netflix;

--15 Business Problems

--1. Count the Number of Movies vs TV Shows
SELECT
	type,
	COUNT(*) as total_content
FROM netflix
GROUP BY type;

--2. Find the Most Common Rating for Movies and TV Shows


SELECT
	UNNEST(STRING_TO_ARRAY(country,',')) AS new_country	
FROM netflix
GROUP BY new_country;

SELECT 
	type,
	rating
FROM
(SELECT
	type,
	ratin
	COUNT(*),
	RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) AS ranking
FROM netflix
GROUP BY 1,2)
AS t1
WHERE ranking=1;

--3. List All Movies Released in a Specific Year (e.g., 2020)
SELECT * 
FROM netflix
WHERE release_year=2020
AND type='Movie';

--4. Find the Top 5 Countries with the Most Content on Netflix

SELECT
	UNNEST(STRING_TO_ARRAY(country,',')) AS new_country	
FROM netflix
GROUP BY new_country;

SELECT 
	UNNEST(STRING_TO_ARRAY(country,',')) AS new_country,
	COUNT(show_id) AS total_content
FROM netflix
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

--5. Identify the Longest Movie
SELECT *
FROM netflix
WHERE
	type='Movie'
	AND
	duration=(SELECT MAX(duration) FROM netflix);

--6. Find Content Added in the Last 5 Years
SELECT CURRENT_DATE-INTERVAL '5 years';

SELECT 
	*
FROM netflix
WHERE 
	TO_DATE(date_added,'Month DD, YYYY')>=CURRENT_DATE-INTERVAL '5 years';

--7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'
SELECT *
FROM netflix
WHERE director ILIKE '%Rajiv Chilaka%';

--8. List All TV Shows with More Than 5 Seasons
SELECT *
FROM netflix
WHERE 
	TYPE='TV Show'
	AND
	SPLIT_PART(duration,' ',1)::numeric>5;

--9. Count the Number of Content Items in Each Genre
SELECT 
	UNNEST(STRING_TO_ARRAY(listed_in,',')) as genre,
	COUNT(show_id) as total_content
FROM netflix
GROUP BY 1;


/*10.Find each year and the average numbers of 
content release in India on netflix.
return top 5 year with highest avg content release!*/
SELECT 
	EXTRACT (YEAR FROM TO_DATE(date_added,'Month DD, YYYY')) as date,
	COUNT(*) AS yearly_content,
	ROUND(COUNT(*)::numeric/(SELECT COUNT(*) FROM netflix where country='India')*100) AS avg_content_year
FROM netflix
WHERE country='India'
GROUP BY 1
ORDER BY avg_content_year DESC
LIMIT 5;


--11. List All Movies that are Documentaries
SELECT *
FROM netflix 
WHERE listed_in LIKE '%Documentaries%';

--12. Find All Content Without a Director
SELECT *
FROM netflix
WHERE director IS NULL;

--13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years
SELECT *
FROM netflix
WHERE 
	casts ILIKE '%Salman Khan%'
	AND 
	release_year>EXTRACT (YEAR FROM CURRENT_DATE)-10;

--14. Find the Top 10 Actors Who Have Appeared in 
--the Highest Number of Movies Produced in India
SELECT 
	UNNEST(STRING_TO_ARRAY(casts,',')) AS characters,
	COUNT(*) AS movies_count
FROM netflix
WHERE country ILIKE '%India%'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;


--15. Categorize Content Based on the Presence of 
--'Kill' and 'Violence' Keywords
--Objective: Categorize content as 'Bad' if it 
--contains 'kill' or 'violence' and 'Good' otherwise. 
--Count the number of items in each category.
WITH new_table AS(
SELECT 
	*,
	CASE 
	WHEN description ILIKE '%kill' OR
	description ILIKE '%violence%' THEN 'Bad_Content'
	ELSE	'Good Content'
	END Category
FROM netflix
)
SELECT
	category,
	COUNT(*) AS total_content
FROM new_table
GROUP BY 1;