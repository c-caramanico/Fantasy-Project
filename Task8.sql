USE fantasy_nba;

-- V1: View combining teams and player stats (aggregated)
CREATE OR REPLACE VIEW vw_team_player_stats AS
SELECT
    ft.teamID,
    ft.teamName,
    COUNT(p.playerID)                 AS numPlayers,
    SUM(p.pointScored)                AS totalPoints,
    SUM(p.assist)                     AS totalAssists,
    SUM(p.steals)                     AS totalSteals
FROM FantasyTeam ft
LEFT JOIN NBAPlayers p ON ft.teamID = p.teamID
GROUP BY ft.teamID, ft.teamName;

SELECT * FROM vw_team_player_stats;

-- Intentional failure to demonstrate non-updatable view
INSERT INTO vw_team_player_stats (teamID, teamName, numPlayers, totalPoints, totalAssists, totalSteals)
VALUES (999, 'Test Team', 0, 0, 0, 0);
