WITH counts as (
SELECT 

wl_home,
fg3_pct_home,
fg3_pct_away,
CASE WHEN wl_home = 'W' AND fg3_pct_home > fg3_pct_away THEN 1 ELSE 0 END AS better_3_won,
CASE WHEN wl_home = 'L' AND fg3_pct_home < fg3_pct_away THEN 1 ELSE 0 END AS better_3_won2,
CASE WHEN wl_home = 'W'	AND fg3_pct_home < fg3_pct_away THEN 1 ELSE 0 END as worse_3_won,
CASE WHEN wl_home = 'L' AND fg3_pct_home > fg3_pct_away THEN 1 ELSE 0 END as worse_3_won2

FROM nba_data.games WHERE game_date >= '2000-01-01')

SELECT

(SUM(better_3_won) + SUM(better_3_won2)) better_3_victors,
(SUM(worse_3_won) + SUM(worse_3_won2)) worse_3_victors,
COUNT(*) AS total_games,
ROUND((SUM(better_3_won) + SUM(better_3_won2))::numeric/COUNT(*),2) AS better_3_pct
FROM counts