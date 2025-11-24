-- Netflix Data Analysis using SQL
-- Solutions of 15 business problems

--1. Count the number of Movies vs TV Shows

SELECT type,
COUNT(*) AS total_content
FROM netflix
GROUP BY type;


--2. Number of movies released per year

SELECT release_year, COUNT(*) AS movie_count
FROM netflix
WHERE type = 'Movie'
GROUP BY release_year
ORDER BY release_year;

-- Objective: yearly trends in movie production on Netflix.


--3. Top 10 directors by number of titles

SELECT director, COUNT(*) AS total_titles
FROM netflix
WHERE director IS NOT NULL
GROUP BY director
ORDER BY total_titles DESC
LIMIT 10;

-- Objective: identifies the most prolific directors on Netflix based on the number of titles they have contributed.


--4. Find the most common rating for movies and TV shows

SELECT type,rating,
COUNT(*) AS count_rating,
RANK() OVER(PARTITION BY TYPE ORDER BY COUNT(*)DESC) AS ranking
FROM netflix
GROUP BY type,rating;


--5. List all movies released in a specific year (e.g., 2020)

SELECT * FROM netflix
	WHERE TYPE='Movie'
	AND release_year=2020;


--6. Find the top 5 countries with the most content on Netflix

SELECT
	UNNEST(STRING_TO_ARRAY(country,',')) AS new_country,
	COUNT(show_id) AS total_content
FROM netflix
GROUP BY new_country
ORDER BY total_content DESC
LIMIT 5;
	

--7. What percentage of content is family/kids oriented?

SELECT
  SUM(CASE WHEN LOWER(listed_in) LIKE '%children%' OR LOWER(listed_in) LIKE '%kids%' OR LOWER(listed_in) LIKE '%family%' THEN 1 ELSE 0 END) AS kids_count,
  COUNT(*) AS total,
  ROUND(100.0 * SUM(CASE WHEN LOWER(listed_in) LIKE '%children%' OR LOWER(listed_in) LIKE '%kids%' OR LOWER(listed_in) LIKE '%family%' THEN 1 ELSE 0 END) / COUNT(*), 2) AS pct_kids
FROM netflix;

-- Objective: Gauge family/kids focus for subscriber segmentation.


--8. Identify the longest movie or TV show duration

SELECT * FROM netflix
	WHERE type = 'Movie'
	AND duration =(SELECT MAX(duration) FROM netflix);


--9. Find content added in the last 5 years

SELECT * FROM netflix
WHERE To_Date(date_added,'Month,DD,YYYY') >= current_date - INTERVAL '5years';
	

--10.Find all the movies/TV shows by director 'Rajiv Chilaka'!

SELECT * FROM netflix
	WHERE director ILIKE '%Rajiv Chilaka%';

	
--11.List all TV shows with more than 5 seasons

SELECT * FROM netflix
	WHERE type = 'TV Show'
	AND split_part(duration, ' ', 1)::numeric > 5;


--12.Count the number of content items in each genre

SELECT 
    UNNEST(string_to_array(listed_in,',')) AS genre,
    COUNT(Show_id) AS total_content
FROM netflix
GROUP BY genre;


--13. What is the share of Originals vs Non-Originals (approx. by directors or lack thereof)?

SELECT 
  CASE WHEN director IS NULL OR director LIKE '%Netflix%' THEN 'Likely Original' ELSE 'Likely Licensed' END AS origin,
  COUNT(*) AS cnt
FROM netflix
GROUP BY origin;

--Objective: Estimate how much is Netflix-original content (proxy).


--14.Find each year and the average numbers of content release by India on netflix,return top 5 year with highest avg content release! 

SELECT 
	EXTRACT(YEAR FROM to_date(date_added,'Month,DD,YYYY')) AS Year,
	COUNT(*) AS yearly_content,
	ROUND(
	COUNT(*)::NUMERIC/(SELECT COUNT(*)FROM netflix
	WHERE country = 'India')::NUMERIC * 100,2) AS avg_content_per_year
FROM netflix
WHERE country = 'India'
GROUP BY year;


--15. List all movies that are documentaries

SELECT * FROM netflix
	WHERE listed_in ILIKE '%Documentaries%';


--16. Find all content without a director

SELECT * FROM netflix
	WHERE director IS NULL;


--17. Find how many movies actor 'Salman Khan' appeared in last 10 years!

SELECT * FROM netflix
	WHERE casts ILIKE '%Salman Khan%'
	AND release_year >= EXTRACT(YEAR FROM CURRENT_DATE)-10;


--18. Find the top 10 actors who have appeared in the highest number of movies produced in India.

SELECT 
	UNNEST(STRING_TO_ARRAY(casts, ',')) AS new_casts,
	COUNT(*) AS total_content
	FROM netflix
	WHERE country ILIKE '%india'
	GROUP BY new_casts
	ORDER BY total_content  DESC
	LIMIT 10;


--19.Categorize the content based on the presence of the keywords 'kill' and 'violence' in the description field.
--Label content containing these keywords as 'Bad' and all other content as 'Good'. Count how many items fall into each category.

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


--20. Does Netflix focus more on recent releases or older content?

SELECT 
    CASE 
        WHEN release_year >= 2018 THEN 'Recent'
        WHEN release_year BETWEEN 2000 AND 2017 THEN 'Moderate'
        ELSE 'Old'
    END AS age_group,
    COUNT(*) AS total_titles
FROM netflix
GROUP BY age_group
ORDER BY total_titles DESC;

--Objective: Measure how modern the catalog is; streaming platforms prefer new content.




-- End of reports

