SELECT 
        CASE WHEN wl_home = 'W' THEN 1 ELSE 0 END AS wins,
        1 AS games,
        ROUND((fg3_pct_home - fg3_pct_away)::numeric, 2) AS fg3_disparity,
        CASE
            WHEN ROUND((fg3_pct_home - fg3_pct_away)::numeric, 2) >= 0.30 THEN '30%+'
            WHEN ROUND((fg3_pct_home - fg3_pct_away)::numeric, 2) >= 0.25 THEN '25%-30%'
            WHEN ROUND((fg3_pct_home - fg3_pct_away)::numeric, 2) >= 0.20 THEN '20%-25%'
            WHEN ROUND((fg3_pct_home - fg3_pct_away)::numeric, 2) >= 0.15 THEN '15%-20%'
            WHEN ROUND((fg3_pct_home - fg3_pct_away)::numeric, 2) >= 0.10 THEN '10%-15%'
            WHEN ROUND((fg3_pct_home - fg3_pct_away)::numeric, 2) >= 0.05 THEN '5%-10%'
            WHEN ROUND((fg3_pct_home - fg3_pct_away)::numeric, 2) >= 0 THEN '0%-5%'
            WHEN ROUND((fg3_pct_home - fg3_pct_away)::numeric, 2) >= -0.05 THEN '-5%-0%'
            WHEN ROUND((fg3_pct_home - fg3_pct_away)::numeric, 2) >= -0.10 THEN '-10% - -5%'
            WHEN ROUND((fg3_pct_home - fg3_pct_away)::numeric, 2) >= -0.15 THEN '-15% - -10%'
            WHEN ROUND((fg3_pct_home - fg3_pct_away)::numeric, 2) >= -0.20 THEN '-20% - -15%'
            WHEN ROUND((fg3_pct_home - fg3_pct_away)::numeric, 2) >= -0.25 THEN '-25% - -20%'
            WHEN ROUND((fg3_pct_home - fg3_pct_away)::numeric, 2) >= -0.30 THEN '-30% - -25%'
            WHEN ROUND((fg3_pct_home - fg3_pct_away)::numeric, 2) < -0.30 THEN '<-30%'
        END AS fg_disparity_group
    FROM nba_data.games
    WHERE game_date >= '2000-01-01'
),
aggregated AS (
    SELECT 
        fg_disparity_group,
        SUM(wins) AS total_wins,
        COUNT(*) AS total_games
    FROM groupings
    GROUP BY fg_disparity_group
)
SELECT
    fg_disparity_group,
    ROUND((total_wins::numeric / total_games), 2) AS win_pct
FROM aggregated
ORDER BY fg_disparity_group;