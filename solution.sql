-- Netflix Project
DROP TABLE IF EXISTS netflix;

CREATE TABLE netflix(
	show_id VARCHAR(20),
	type VARCHAR(50),
	title VARCHAR(150),
	director VARCHAR(208),
	casts VARCHAR(1000),
	country VARCHAR(50),
	date_added VARCHAR(50),
	release_year INT,
	rating VARCHAR(20),
	duration VARCHAR(50),
	listed_in VARCHAR(50),
	description VARCHAR(250)
);

SELECT * FROM netflix;

SELECT COUNT(*) AS total_content
FROM netflix;

SELECT DISTINCT TYPE
FROM netflix;

-- 15 Business Problem

--1. Count the number of Movies vs TV Shows

SELECT type,
COUNT(*) AS total_content
FROM netflix
GROUP BY type;


--2. Find the most common rating for movies and TV shows

SELECT type,rating,
COUNT(*) AS count_rating,
RANK() OVER(PARTITION BY TYPE ORDER BY COUNT(*)DESC) AS ranking
FROM netflix
GROUP BY type,rating;



--3. List all movies released in a specific year (e.g., 2020)

SELECT * FROM netflix
	WHERE TYPE='Movie'
	AND release_year=2020;


--4. Find the top 5 countries with the most content on Netflix

SELECT
	UNNEST(STRING_TO_ARRAY(country,',')) AS new_country,
	COUNT(show_id) AS total_content
FROM netflix
GROUP BY new_country
ORDER BY total_content DESC
LIMIT 5;
	

--5. Identify the longest movie or TV show duration

SELECT * FROM netflix
	WHERE type = 'Movie'
	AND duration =(SELECT MAX(duration) FROM netflix);


--6. Find content added in the last 5 years

SELECT *
FROM netflix
WHERE To_Date(date_added,'Month,DD,YYYY') >= current_date - INTERVAL '5years';
	

--7.Find all the movies/TV shows by director 'Rajiv Chilaka'!

SELECT * FROM netflix
	WHERE director ILIKE '%Rajiv Chilaka%';

	
8.List all TV shows with more than 5 seasons

SELECT * FROM netflix
	WHERE type = 'TV Show'
	AND split_part(duration, ' ', 1)::numeric > 5;


--9.Count the number of content items in each genre

SELECT 
    UNNEST(string_to_array(listed_in,',')) AS genre,
    COUNT(Show_id) AS total_content
FROM netflix
GROUP BY genre;


--10.Find each year and the average numbers of content release by India on netflix,return top 5 year with highest avg content release! 

SELECT 
	EXTRACT(YEAR FROM to_date(date_added,'Month,DD,YYYY')) AS Year,
	COUNT(*) AS yearly_content,
	ROUND(
	COUNT(*)::NUMERIC/(SELECT COUNT(*)FROM netflix
	WHERE country = 'India')::NUMERIC * 100,2) AS avg_content_per_year
FROM netflix
WHERE country = 'India'
GROUP BY year;


--11. List all movies that are documentaries

SELECT * FROM netflix
	WHERE listed_in ILIKE '%Documentaries%';


--12. Find all content without a director

SELECT * FROM netflix
	WHERE director IS NULL;


--13. Find how many movies actor 'Salman Khan' appeared in last 10 years!

SELECT * FROM netflix
	WHERE casts ILIKE '%Salman Khan%'
	AND release_year >= EXTRACT(YEAR FROM CURRENT_DATE)-10;


--14. Find the top 10 actors who have appeared in the highest number of movies produced in India.

SELECT 
	UNNEST(STRING_TO_ARRAY(casts, ',')) AS new_casts,
	COUNT(*) AS total_content
	FROM netflix
	WHERE country ILIKE '%india'
	GROUP BY new_casts
	ORDER BY total_content  DESC
	LIMIT 10;


--15.Categorize the content based on the presence of the keywords 'kill' and 'violence' in
--the description field. Label content containing these keywords as 'Bad' and all other content as 'Good'. Count how many items fall into each category.

SELECT 
    CASE 
        WHEN LOWER(description) ILIKE '%kill%' 
          OR LOWER(description) ILIKE '%violence%' 
        THEN 'Bad_Content'
        ELSE 'Good_Content'
    END AS category,
    COUNT(*) AS total_items
FROM netflix
GROUP BY category;













