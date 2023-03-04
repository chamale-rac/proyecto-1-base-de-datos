----------------------------------------
-- 1)
----------------------------------------
WITH matches_per_season_all_teams AS (SELECT team_api_id, season, SUM(num_of_matches) as total_num_of_matches
                                      FROM ((SELECT away_team_api_id as team_api_id, season, count(*) as num_of_matches
                                             FROM match
                                             GROUP BY away_team_api_id, season)
                                            UNION ALL
                                            (SELECT home_team_api_id as team_api_id, season, count(*) as num_of_matches
                                             FROM match
                                             GROUP BY home_team_api_id, season)) AS team_mathces
                                      GROUP BY team_api_id, season)
SELECT t.team_long_name, season, total_num_of_matches
FROM matches_per_season_all_teams mpsat
         JOIN team t ON t.team_api_id = mpsat.team_api_id
ORDER BY (t.team_long_name, season);

----------------------------------------
-- 2)
----------------------------------------
WITH goals_per_season_and_league_all_teams AS (SELECT team_api_id,
                                                      season,
                                                      league_id,
                                                      SUM(goals)         as total_goals,
                                                      SUM(against_goals) as total_against_goals
                                               FROM ((SELECT away_team_api_id    as team_api_id,
                                                             season,
                                                             league_id,
                                                             SUM(away_team_goal) as goals,
                                                             SUM(home_team_goal) as against_goals
                                                      FROM match
                                                      GROUP BY away_team_api_id, season, league_id)
                                                     UNION ALL
                                                     (SELECT home_team_api_id    as team_api_id,
                                                             season,
                                                             league_id,
                                                             SUM(home_team_goal) as goals,
                                                             SUM(away_team_goal) as against_goals
                                                      FROM match
                                                      GROUP BY home_team_api_id, season, league_id)) AS teams_goals_stats
                                               GROUP BY team_api_id, season, league_id)
SELECT t.team_long_name,
       season,
       l.name,
       total_goals,
       total_against_goals,
       (total_goals - total_against_goals) AS difference,
       RANK() OVER (
           PARTITION BY season, league_id
           ORDER BY (total_goals - total_against_goals) DESC
           )                                  difference_rank
FROM goals_per_season_and_league_all_teams gpsalat
         JOIN team t ON t.team_api_id = gpsalat.team_api_id
         JOIN league l on l.id = gpsalat.league_id;

----------------------------------------
-- 3)
----------------------------------------
WITH win_prob AS ((SELECT home_team_api_id as team_id,
                          season,
                          league_id,
                          AVG(B365H)       AS B365W_AVG,
                          AVG(BWH)         AS BWW_AVG,
                          AVG(LBH)         AS LBW_AVG,
                          AVG(PSH)         AS PSW_AVG,
                          AVG(WHH)         AS WHW_AVG,
                          AVG(SJH)         AS SJW_AVG,
                          AVG(VCH)         AS VCW_AVG,
                          AVG(GBH)         AS GBW_AVG,
                          AVG(BSH)         AS BSW_AVG
                   FROM match
                   GROUP BY home_team_api_id, season, league_id))
SELECT team_long_name,
       *
FROM win_prob wp
         JOIN team t ON wp.team_id = t.team_api_id
WHERE B365W_AVG > 0
  AND BWW_AVG > 0
  AND LBW_AVG > 0
  AND PSW_AVG > 0
  AND WHW_AVG > 0
  AND SJW_AVG > 0
  AND VCW_AVG > 0
  AND GBW_AVG > 0
  AND BSW_AVG > 0;

----------------------------------------
-- 4)
----------------------------------------
WITH quotes_avg AS ((SELECT home_team_api_id as team_id,
                            season,
                            league_id,
                            AVG(B365H)       AS B365W_AVG,
                            AVG(BWH)         AS BWW_AVG,
                            AVG(LBH)         AS LBW_AVG,
                            AVG(PSH)         AS PSW_AVG,
                            AVG(WHH)         AS WHW_AVG,
                            AVG(SJH)         AS SJW_AVG,
                            AVG(VCH)         AS VCW_AVG,
                            AVG(GBH)         AS GBW_AVG,
                            AVG(BSH)         AS BSW_AVG
                     FROM match
                     GROUP BY home_team_api_id, season, league_id))
SELECT team_long_name,
       team_api_id,
       season,
       league_id,
       (100 / B365W_AVG + 100 / BWW_AVG + 100 / LBW_AVG + 100 / PSW_AVG + 100 / WHW_AVG + 100 / SJW_AVG +
        100 / VCW_AVG + 100 / GBW_AVG + 100 / BSW_AVG) / 9 AS win_prob_avg,
       RANK() OVER (
           ORDER BY ((100 / B365W_AVG + 100 / BWW_AVG + 100 / LBW_AVG + 100 / PSW_AVG + 100 / WHW_AVG + 100 / SJW_AVG +
                      100 / VCW_AVG + 100 / GBW_AVG + 100 / BSW_AVG) / 9) DESC
           )                                               AS win_prob_rank
FROM quotes_avg qa
         JOIN team t ON qa.team_id = t.team_api_id
WHERE B365W_AVG > 0
  AND BWW_AVG > 0
  AND LBW_AVG > 0
  AND PSW_AVG > 0
  AND WHW_AVG > 0
  AND SJW_AVG > 0
  AND VCW_AVG > 0
  AND GBW_AVG > 0
  AND BSW_AVG > 0;

----------------------------------------
-- 5)
----------------------------------------
WITH last_team_game AS(
-- Query que regresa el partido mas reciente de todos los equipos registrados, no importando si jugo de local o visita
    SELECT team, MAX(date) AS last_game_date
    FROM(
        SELECT *
        FROM(
        SELECT match.home_team_api_id AS team,
           MAX(date) AS date
        FROM match
        GROUP BY match.home_team_api_id
    ) AS home_last_match
    UNION (
        SELECT match.away_team_api_id AS team,
           MAX(date) AS date
        FROM match
        GROUP BY match.away_team_api_id
    )
    ) AS all_teams
    GROUP BY team
),
team_players_id AS(
-- Query que concatena los ids de todos los jugadores de cada equipo registrado en match, no importando si es local o visita
    SELECT home_team_api_id AS team_id,
       CONCAT(
           home_player_1,'&, ',
           home_player_2,'&, ',
           home_player_3,'&, ',
           home_player_4,'&, ',
           home_player_5,'&, ',
           home_player_6,'&, ',
           home_player_7,'&, ',
           home_player_8,'&, ',
           home_player_9,'&, ',
           home_player_10,'&, ',
           home_player_11,'&'
        ) AS players_ids,
        date
    FROM match
    UNION(
        SELECT away_team_api_id AS team_id,
            CONCAT(
               away_player_1,'&, ',
               away_player_2,'&, ',
               away_player_3,'&, ',
               away_player_4,'&, ',
               away_player_5,'&, ',
               away_player_6,'&, ',
               away_player_7,'&, ',
               away_player_8,'&, ',
               away_player_9,'&, ',
               away_player_10,'&, ',
               away_player_11,'&'
        ) AS players_ids,
        date
        FROM match
    )
),
team_and_players_updated AS (
-- Query que agrega las columnas de los ids de los jugadores por equipo no importando si son local o visita
    SELECT team_id, players_ids, last_game_date
    FROM last_team_game
    INNER JOIN team_players_id
        ON last_team_game.last_game_date = team_players_id.date
        AND last_team_game.team = team_players_id.team_id
),
best_players AS(
-- Query que devuelve los mejores jugadores segun las estadisticas de player_attributes
    SELECT player_attributes.player_api_id, player.player_name, overall_rating
    FROM player_attributes
    JOIN player ON player_attributes.player_api_id = player.player_api_id
    WHERE (player_attributes.player_api_id, player_attributes.date) IN (SELECT player_api_id, MAX(date) as date
                                FROM player_attributes
                                GROUP BY player_api_id)
        AND overall_rating IS NOT NULL
    ORDER BY overall_rating DESC
    --LIMIT 34
),
player_id_filtered AS(
-- Query que realiza un INNER JOIN para poder identificar en que equipos se encuentra cada jugador gracias a la funcion LIKE y la concatenacion en el Query *team_players_id*
    SELECT player_api_id, player_name, overall_rating, team_id, last_game_date
    FROM team_and_players_updated
    INNER JOIN best_players
        ON team_and_players_updated.players_ids LIKE CONCAT('%',best_players.player_api_id,'&%')
),
players_date_updated AS(
-- QUERY que filtra el ultimo partido jugado de cada jugador
    SELECT player_api_id, MAX(last_game_date) AS last_played_date
    FROM player_id_filtered
    GROUP BY  player_api_id
),
players_team_pertain AS(
-- Query que hace un INNNER JOIN para unir los jugadores con su ultimo partido jugado, debido a que se generan repetidos
    -- porque un jugador pudo haber jugado el ultimo partido de dos equipos distintos,
    -- Esto pasa con Cristiano Ronaldo, Neymar y Diego Godin.
    SELECT players_date_updated.player_api_id, player_name, overall_rating, team_id, team.team_long_name, players_date_updated.last_played_date
    FROM players_date_updated
    INNER JOIN player_id_filtered
        ON players_date_updated.player_api_id = player_id_filtered.player_api_id
        AND players_date_updated.last_played_date = player_id_filtered.last_game_date
    INNER JOIN team
        ON team_id = team.team_api_id
    LIMIT 30
),
goals_per_season_and_league_all_teams AS (
    SELECT team_api_id,
        season,
        league_id,
        SUM(goals) as total_goals,
        SUM(against_goals) as total_against_goals
    FROM ((SELECT away_team_api_id as team_api_id,
                    season,
                    league_id,
                    SUM(away_team_goal) as goals,
                    SUM(home_team_goal) as against_goals
            FROM match
            GROUP BY away_team_api_id, season, league_id)
            UNION ALL
            (SELECT home_team_api_id    as team_api_id,
                    season,
                    league_id,
                    SUM(home_team_goal) as goals,
                    SUM(away_team_goal) as against_goals
            FROM match
            GROUP BY home_team_api_id, season, league_id)) AS teams_goals_stats
    GROUP BY team_api_id, season, league_id
),
team_ranking_per_league AS (
    SELECT t.team_long_name,
        season,
        l.name AS league_name,
        total_goals,
        total_against_goals,
        (total_goals - total_against_goals) AS difference,
        RANK() OVER (
            PARTITION BY season, league_id
            ORDER BY (total_goals - total_against_goals) DESC
            )                                  difference_rank
    FROM goals_per_season_and_league_all_teams gpsalat
            JOIN team t ON t.team_api_id = gpsalat.team_api_id
            JOIN league l on l.id = gpsalat.league_id
),
best_teams_of_last_season AS (
SELECT *
FROM team_ranking_per_league
WHERE season = (
    SELECT MAX(season)
    FROM team_ranking_per_league
    )
    AND difference_rank = (
        SELECT MIN(difference_rank)
        FROM team_ranking_per_league
    )
),
best_players_in_best_teams AS (
    SELECT player_name, overall_rating, best_teams_of_last_season.team_long_name AS team_name, season, league_name
    FROM players_team_pertain
    FULL JOIN best_teams_of_last_season
        ON players_team_pertain.team_long_name = best_teams_of_last_season.team_long_name
    WHERE player_name IS NOT NULL
    ORDER BY overall_rating DESC NULLS LAST
)
SELECT *
FROM best_players_in_best_teams;

----------------------------------------
-- 6)
----------------------------------------
WITH team_total_faults AS (SELECT team_api_id, SUM(num_faults) AS total_faults
                           FROM ((SELECT match.home_team_api_id  AS team_api_id,
                                         SUM(faults.home_faults) AS num_faults
                                  FROM match
                                           RIGHT JOIN faults ON match.match_api_id = faults.match_api_id
                                  GROUP BY match.home_team_api_id)
                                 UNION ALL
                                 (SELECT match.away_team_api_id  AS team_api_id,
                                         SUM(faults.away_faults) AS num_faults
                                  FROM match
                                           RIGHT JOIN faults ON match.match_api_id = faults.match_api_id
                                  GROUP BY match.away_team_api_id)) AS alias
                           GROUP BY team_api_id)
SELECT team_long_name, total_faults
FROM team_total_faults ttf
         JOIN team t ON ttf.team_api_id = t.team_api_id;

----------------------------------------
-- 7)
----------------------------------------
WITH goals_per_season_and_league_all_teams AS (SELECT team_api_id,
                                                      season,
                                                      league_id,
                                                      SUM(goals)         as total_goals,
                                                      SUM(against_goals) as total_against_goals
                                               FROM ((SELECT away_team_api_id    as team_api_id,
                                                             season,
                                                             league_id,
                                                             SUM(away_team_goal) as goals,
                                                             SUM(home_team_goal) as against_goals
                                                      FROM match
                                                      GROUP BY away_team_api_id, season, league_id)
                                                     UNION ALL
                                                     (SELECT home_team_api_id    as team_api_id,
                                                             season,
                                                             league_id,
                                                             SUM(home_team_goal) as goals,
                                                             SUM(away_team_goal) as against_goals
                                                      FROM match
                                                      GROUP BY home_team_api_id, season, league_id)) AS teams_goals_stats
                                               GROUP BY team_api_id, season, league_id),
     team_rank_per_season_and_league AS (SELECT t.team_long_name,
                                                t.team_api_id,
                                                season,
                                                l.name,
                                                total_goals,
                                                total_against_goals,
                                                (total_goals - total_against_goals) AS difference,
                                                RANK() OVER (
                                                    PARTITION BY season, league_id
                                                    ORDER BY (total_goals - total_against_goals) DESC
                                                    )                                  difference_rank
                                         FROM goals_per_season_and_league_all_teams gpsalat
                                                  JOIN team t ON t.team_api_id = gpsalat.team_api_id
                                                  JOIN league l on l.id = gpsalat.league_id),
     best_teams AS (SELECT DISTINCT team_api_id
                    FROM team_rank_per_season_and_league
                    WHERE difference_rank = 1)
SELECT ROUND(STDDEV(buildUpPlaySpeed), 2)       AS stddev_buildUpPlaySpeed,
       ROUND(STDDEV(buildUpPlayDribbling), 2)   AS buildUpPlayDribbling,
       ROUND(STDDEV(buildUpPlayPassing), 2)     AS buildUpPlayPassing,
       ROUND(STDDEV(chanceCreationPassing), 2)  AS stddev_chanceCreationPassing,
       ROUND(STDDEV(chanceCreationCrossing), 2) AS stddev_chanceCreationCrossing,
       ROUND(STDDEV(chanceCreationShooting), 2) AS stddev_chanceCreationShooting,
       ROUND(STDDEV(defencePressure), 2)        AS stddev_defencePressure,
       ROUND(STDDEV(defenceAggression), 2)      AS stddev_defenceAggression,
       ROUND(STDDEV(defenceTeamWidth), 2)       AS stddev_defenceTeamWidth
FROM team_attributes
WHERE team_api_id IN (SELECT best_teams.team_api_id
                      FROM best_teams);

