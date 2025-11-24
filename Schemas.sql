-- SCHEMAS of Netflix

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