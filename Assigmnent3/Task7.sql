USE fantasy_nba;


-- M1: INSERT ... SELECT
-- Create an initial waiver entry for all teams in a given league
INSERT INTO Waiver (waiverPriority, waiverType, transactionDate, teamID)
SELECT
    10          AS waiverPriority,
    'Initial'   AS waiverType,
    CURDATE()   AS transactionDate,
    ft.teamID   AS teamID
FROM FantasyTeam ft
WHERE ft.leagueID = 1
  AND NOT EXISTS (
      SELECT 1 FROM Waiver w WHERE w.teamID = ft.teamID
  );

-- M2: UPDATE multiple rows at once using a JOIN
UPDATE FantasyTeam ft
JOIN WeeklyMatchup wm ON ft.teamID = wm.winner
SET ft.fantasyPoints = ft.fantasyPoints + 50
WHERE wm.weekNumber = 1;

-- M3: DELETE using a WHERE condition
DELETE FROM InjuryReport
WHERE expectedReturnDate IS NOT NULL
  AND expectedReturnDate < CURDATE();
