# Netlix Movies and TV Shows Data Analysis using SQL
![Netflix Logo](https://github.com/Anurag7215/netflix_sql_projects/blob/main/BrandAssets_Logos_01-Wordmark.jpg)


## Overview 
This project focuses on analyzing Netflix’s movies and TV shows using SQL. The aim is to uncover meaningful insights and answer key business questions based on the dataset. This README explains the purpose of the project, the problems we set out to solve, the SQL-based solutions used, the insights we discovered, and the final conclusions drawn from the analysis.


## Objective
* Understand how Netflix’s content is divided between movies and TV shows.
* Find out which ratings (like PG, TV-MA, etc.) are most common for both movies and TV shows.
* Review and analyze content based on when it was released, which countries it came from, and how long it is.
* Explore the dataset further by grouping content according to specific conditions or keywords (such as genres, themes, or terms found in descriptions).


## Dataset
Dataset Link: [Netflix-Movies-Dataset](https://www.kaggle.com/datasets/utkarshx27/movies-dataset)


## Schema
```sql
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
```
## Business Problems And Solution

### 1. Count the Number of Movies vs TV Shows.

```sql
SELECT type,
COUNT(*) AS total_content
FROM netflix
GROUP BY type;
```

Objective: Determine the disdtribution of content types on Netflix.

### 2. Number of movies released per year.

```sql
SELECT release_year, COUNT(*) AS movie_count
FROM netflix
WHERE type = 'Movie'
GROUP BY release_year
ORDER BY release_year;
```

Objective: yearly trends in movie production on Netflix.

### 3. Top 10 directors by number of Titles.

```sql
SELECT director, COUNT(*) AS total_titles
FROM netflix
WHERE director IS NOT NULL
GROUP BY director
ORDER BY total_titles DESC
LIMIT 10;
```

Objective: identifies the most prolific directors on Netflix based on the number of titles they have contributed.

### 4. Find the most common rating for movies and TV shows.

```sql
SELECT type,rating,
COUNT(*) AS count_rating,
RANK() OVER(PARTITION BY TYPE ORDER BY COUNT(*)DESC) AS ranking
FROM netflix
GROUP BY type,rating;
```

Objective:

### 5. List all movies released in a specific year (e.g., 2020).

``sql
SELECT * FROM netflix
	WHERE TYPE='Movie'
	AND release_year=2020;
	```

Objective: 

### 6. Find the top 5 countries with the most content on Netflix.

```sql
SELECT
	UNNEST(STRING_TO_ARRAY(country,',')) AS new_country,
	COUNT(show_id) AS total_content
FROM netflix
GROUP BY new_country
ORDER BY total_content DESC
LIMIT 5;
```

Objective: 

### 7. What percentage of content is family/kids oriented?

```sql
SELECT
  SUM(CASE WHEN LOWER(listed_in) LIKE '%children%' OR LOWER(listed_in) LIKE '%kids%' OR LOWER(listed_in) LIKE '%family%' THEN 1 ELSE 0 END) AS kids_count,
  COUNT(*) AS total,
  ROUND(100.0 * SUM(CASE WHEN LOWER(listed_in) LIKE '%children%' OR LOWER(listed_in) LIKE '%kids%' OR LOWER(listed_in) LIKE '%family%' THEN 1 ELSE 0 END) / COUNT(*), 2) AS pct_kids
FROM netflix;
```

Objective: Gauge family/kids focus for subscriber segmentation.

### 8. Identify the longest movie or TV show duration.

```sql
SELECT * FROM netflix
	WHERE type = 'Movie'
	AND duration =(SELECT MAX(duration) FROM netflix);
```

Objective:

### 9. Find content added in the last 5 years

```sql
SELECT *
FROM netflix
WHERE To_Date(date_added,'Month,DD,YYYY') >= current_date - INTERVAL '5years';
```

Objective:

### 10. Find all the movies/TV shows by director 'Rajiv Chilaka'!

```sql
SELECT * FROM netflix
	WHERE director ILIKE '%Rajiv Chilaka%';
```

Objective:

### 11. List all TV shows with more than 5 seasons

```sql
SELECT * FROM netflix
	WHERE type = 'TV Show'
	AND split_part(duration, ' ', 1)::numeric > 5;
```

Objective: 

### 12. Count the number of content items in each genre

```sql
SELECT 
    UNNEST(string_to_array(listed_in,',')) AS genre,
    COUNT(Show_id) AS total_content
FROM netflix
GROUP BY genre;
```

Objective: 

### 13. What is the share of Originals vs Non-Originals (approx. by directors or lack thereof)?

```sql
SELECT 
  CASE WHEN director IS NULL OR director LIKE '%Netflix%' THEN 'Likely Original' ELSE 'Likely Licensed' END AS origin,
  COUNT(*) AS cnt
FROM netflix
GROUP BY origin;
```

Objective: Estimate how much is Netflix-original content (proxy).

### 14. Find each year and the average numbers of content release by India on netflix,return top 5 year with highest avg content release! 

```sql
SELECT 
	EXTRACT(YEAR FROM to_date(date_added,'Month,DD,YYYY')) AS Year,
	COUNT(*) AS yearly_content,
	ROUND(
	COUNT(*)::NUMERIC/(SELECT COUNT(*)FROM netflix
	WHERE country = 'India')::NUMERIC * 100,2) AS avg_content_per_year
FROM netflix
WHERE country = 'India'
GROUP BY year;
```

Objective:

### 15. List all movies that are documentaries

```sql
SELECT * FROM netflix
	WHERE listed_in ILIKE '%Documentaries%';
```

Objective:

### 16. Find all content without a director

```sql
SELECT * FROM netflix
	WHERE director IS NULL;
```

Objective:

### 17. Find how many movies actor 'Salman Khan' appeared in last 10 years!

```sql
SELECT * FROM netflix
	WHERE casts ILIKE '%Salman Khan%'
	AND release_year >= EXTRACT(YEAR FROM CURRENT_DATE)-10;
```

Objective:

### 18. Find the top 10 actors who have appeared in the highest number of movies produced in India.

```sql
SELECT 
	UNNEST(STRING_TO_ARRAY(casts, ',')) AS new_casts,
	COUNT(*) AS total_content
	FROM netflix
	WHERE country ILIKE '%india'
	GROUP BY new_casts
	ORDER BY total_content  DESC
	LIMIT 10;
```

Objective:

### 19. 19.Categorize the content based on the presence of the keywords 'kill' and 'violence' in the description field. Label content containing these keywords as 'Bad' and all other content as 'Good'. Count how many items fall into each category.

```sql
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
```

Objective:

### 19. Does Netflix focus more on recent releases or older content?

```sql
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
```

Objective: Measure how modern the catalog is; streaming platforms prefer new content.
