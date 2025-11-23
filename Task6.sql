USE fantasy_nba;

-- ============================================================
-- TASK 6: SELECT QUERIES (7 TOTAL)
-- ============================================================

-- Q1: List all leagues with how many fantasy teams they have
-- Features: JOIN + GROUP BY + aggregate
SELECT
    l.leagueID,
    l.leagueName,
    COUNT(ft.teamID) AS numTeams
FROM League_LeaderBoard l
LEFT JOIN FantasyTeam ft
    ON l.leagueID = ft.leagueID
GROUP BY l.leagueID, l.leagueName
ORDER BY numTeams DESC, l.leagueName;

-- ------------------------------------------------------------

-- Q2: Show all fantasy teams with their owner username & email
-- Features: JOIN over 3 tables
SELECT
    ft.teamID,
    ft.teamName,
    ft.fantasyPoints,
    u.username AS ownerUsername,
    u.email    AS ownerEmail,
    l.leagueName
FROM FantasyTeam ft
JOIN `User` u
    ON ft.userID = u.userID
JOIN League_LeaderBoard l
    ON ft.leagueID = l.leagueID
ORDER BY l.leagueName, ft.fantasyPoints DESC, ft.teamName;

-- ------------------------------------------------------------

-- Q3: Top 10 players by total points scored, with their fantasy team
-- Features: JOIN + ORDER BY + LIMIT
SELECT
    p.playerID,
    p.firstName,
    p.lastName,
    p.pointScored,
    p.assist,
    p.steals,
    ft.teamName
FROM NBAPlayers p
LEFT JOIN FantasyTeam ft
    ON p.teamID = ft.teamID
ORDER BY p.pointScored DESC
LIMIT 10;

-- ------------------------------------------------------------

-- Q4: Players whose total points are above the global average
-- Features: Scalar subquery in WHERE
SELECT
    p.playerID,
    p.firstName,
    p.lastName,
    p.pointScored
FROM NBAPlayers p
WHERE p.pointScored >
      (SELECT AVG(pointScored) FROM NBAPlayers)
ORDER BY p.pointScored DESC;

-- ------------------------------------------------------------

-- Q5: Teams that have at least one waiver transaction
-- Features: EXISTS subquery
SELECT
    ft.teamID,
    ft.teamName
FROM FantasyTeam ft
WHERE EXISTS (
    SELECT 1
    FROM Waiver w
    WHERE w.teamID = ft.teamID
)
ORDER BY ft.teamName;

-- ------------------------------------------------------------

-- Q6: Weekly matchup results with team names and winner team
-- Features: Multiple JOINs + CASE expression
SELECT
    wm.weekNumber,
    wm.matchupID,
    t1.teamName AS team1,
    wm.score1,
    t2.teamName AS team2,
    wm.score2,
    tw.teamName AS winnerTeam,
    CASE
        WHEN wm.score1 > wm.score2 THEN t1.teamName
        WHEN wm.score2 > wm.score1 THEN t2.teamName
        ELSE 'Tie'
    END AS computedWinnerLabel
FROM WeeklyMatchup wm
LEFT JOIN FantasyTeam t1 ON wm.team1ID = t1.teamID
LEFT JOIN FantasyTeam t2 ON wm.team2ID = t2.teamID
LEFT JOIN FantasyTeam tw ON wm.winner  = tw.teamID
ORDER BY wm.weekNumber, wm.matchupID;

-- ------------------------------------------------------------

-- Q7: Players with injury reports and days until expected return
-- Features: JOIN + date function + ORDER BY
SELECT
    p.playerID,
    p.firstName,
    p.lastName,
    ir.status,
    ir.severity,
    ir.bodyPart,
    ir.expectedReturnDate,
    DATEDIFF(ir.expectedReturnDate, CURDATE()) AS daysUntilReturn
FROM InjuryReport ir
JOIN NBAPlayers p
    ON ir.playerID = p.playerID
ORDER BY
    ir.expectedReturnDate,
    ir.severity DESC;
