-- SELECT * FROM player_seasons;

-- CREATE TYPE season_stats AS (
-- 	season integer,
-- 	gp integer,
-- 	pts real,
-- 	reb real,
-- 	ast real
-- )

-- CREATE TABLE players (
--     player_name TEXT,
--     height TEXT,
--     college TEXT,
--     country TEXT,
--     draft_year TEXT,
--     draft_round TEXT,
--     draft_number TEXT,
--     season_stats season_stats[],
--  	current_season integer, 
--     PRIMARY KEY (player_name, current_season)
-- );

insert into players
With yesterday as (
	Select * from players
	where current_season = 1996
),
	today as (
	Select * from player_seasons
	where season = 1997
	)
Select 
	coalesce(t.player_name, y.player_name) as player_name,
	coalesce(t.height, y.height) as height,
	coalesce(t.college, y.college) as college,
	coalesce(t.country, y.country) as country,
	coalesce(t.draft_year, y.draft_year) as draft_year,
	coalesce(t.draft_round, y.draft_round) as draft_round,
	coalesce(t.draft_number, y.draft_number) as draft_number,
	CASE WHEN y.season_stats is null  
				then Array[Row(t.season,t.gp, t.pts,t.reb, t.ast)::season_stats]
		When t.season is not null then 
			y.season_stats || Array[Row(t.season,t.gp, t.pts,t.reb, t.ast)::season_stats]
		else y.season_stats 
	end as Seasons,
	Coalesce(t.season, y.current_Season +1 ) as current_Season
	

from today t full outer join yesterday y 
on t.player_name = y.player_name; 

Select * from players;
