WITH lagged AS (

SELECT
player_name,
season,
pts,
LAG(pts, 1) OVER (
PARTITION BY player_name ORDER BY season)
AS pts_last_season,
LEAD(pts, 1) OVER (
PARTITION BY player_name ORDER BY season)
AS pts_next_season
FROM bootcamp.nba_player_seasons

),
did_change AS (
SELECT *, CASE WHEN pts >= 20 AND pts_last_season >= 20 THEN 0 ELSE 1 END as pts_stayed_above_20
FROM lagged
)

SELECT *,
SUM(pts_stayed_above_20) OVER( PARTITION BY player_name
ORDER BY season
ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
AS streak_identifier
FROM did_change 

