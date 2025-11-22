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
