-- ================================================================
-- TASK 4: Basic Data Insertions
-- Three “interesting” INSERTs + supporting rows
-- ================================================================
USE fantasy_nba;

SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE League_LeaderBoard;
TRUNCATE TABLE FantasyTeam;
TRUNCATE TABLE Manager;
TRUNCATE TABLE `User`;
TRUNCATE TABLE NBAPlayers;
TRUNCATE TABLE InjuryReport;
TRUNCATE TABLE Waiver;
SET FOREIGN_KEY_CHECKS = 1;

-- ------------------------------------------------
-- Insert 1: Insert a league
-- ------------------------------------------------
INSERT INTO League_LeaderBoard
    (leagueName, statType, weight, seasonYear, maxTeams,
     leaderBoardID, standings, lastUpdated, managerID)
VALUES
    ('AISE Fantasy League', 'points', 1.00, 2025, 12,
     1001, NULL, NOW(), NULL);

-- ------------------------------------------------
-- Insert 2: Insert a user in that league
-- ------------------------------------------------
INSERT INTO `User`
    (email, username, password, role, leagueID)
VALUES
    ('christian@example.com', 'christian', 'password123',
     'manager', 1);

-- ------------------------------------------------
-- Insert 3: Insert a manager for that user
-- ------------------------------------------------
INSERT INTO Manager
    (userID, email, username, password, role, desiredSettings)
VALUES
    (1, 'christian@example.com', 'christian', 'password123',
     'manager', 'High scoring league');

-- ------------------------------------------------
-- Base Fantasy Team (teamID will be 1)
-- ------------------------------------------------
INSERT INTO FantasyTeam
    (teamName, teamAbbreviation, waiverPriority, fantasyPoints,
     leagueID, tradeID, matchupID, userID)
VALUES
    ('Christian Ballers', 'CBL', 1, 0,
     1, NULL, NULL, 1);


-- Insert one NBA player on teamID = 1

INSERT INTO NBAPlayers
    (firstName, lastName, position, team, blocks, pointScored,
     gamesPlayed, turnover, assist, fgMade, fgAttempt, ftMade,
     ftAttempt, steals, fgPercentage, ftPercentage, teamID)
VALUES
    ('LeBron', 'James', 'SF', 'LAL', 20, 1500,
     60, 200, 500, 500, 1000, 300, 400, 100,
     50.0, 75.0, 1);

-- Injury report for playerID = 1

INSERT INTO InjuryReport
    (status, severity, bodyPart, expectedReturnDate, playerID)
VALUES
    ('Out', 'High', 'Ankle', '2025-12-01', 1);

-- ------------------------------------------------
-- MULTI-ROW INSERT (Interesting Insert #1)
-- ------------------------------------------------
INSERT INTO FantasyTeam
    (teamName, teamAbbreviation, waiverPriority, fantasyPoints,
     leagueID, tradeID, matchupID, userID)
VALUES
    ('Christian Ballers', 'CBL', 1, 0, 1, NULL, NULL, 1),
    ('Nathan Ninjas',     'NNJ', 2, 0, 1, NULL, NULL, 1),
    ('Ben Buckets',       'BBK', 3, 0, 1, NULL, NULL, 1),
    ('Akshayan Aces',     'AAC', 4, 0, 1, NULL, NULL, 1),
    ('Cadeau Crushers',   'CCR', 5, 0, 1, NULL, NULL, 1),
    ('Hayimana Hawks',    'HHK', 6, 0, 1, NULL, NULL, 1),
    ('Chu Chargers',      'CHU', 7, 0, 1, NULL, NULL, 1),
    ('Chiu Champs',       'CHI', 8, 0, 1, NULL, NULL, 1),
	('Thunderous Tacos',       'TTC', 9, 0, 1, NULL, NULL, 1),
    ('Backboard Bandits',      'BBD',10, 0, 1, NULL, NULL, 1),
    ('Rim Rattlers',           'RRT',11, 0, 1, NULL, NULL, 1),
    ('Splash Zone Snipers',    'SZS',12, 0, 1, NULL, NULL, 1),
    ('Alley-Oop Alchemists',   'AOA',13, 0, 1, NULL, NULL, 1),
    ('Baseline Bruisers',      'BLB',14, 0, 1, NULL, NULL, 1),
    ('Pick-and-Roll Pirates',  'PRP',15, 0, 1, NULL, NULL, 1),
    ('Triple-Double Titans',   'TDT',16, 0, 1, NULL, NULL, 1),
    ('Zone Breaker Zebras',    'ZBZ',17, 0, 1, NULL, NULL, 1),
    ('Fastbreak Falcons',      'FBF',18, 0, 1, NULL, NULL, 1),
    ('Crunch Time Cobras',     'CTC',19, 0, 1, NULL, NULL, 1),
    ('Glass Cleaner Gorillas', 'GCG',20, 0, 1, NULL, NULL, 1);

-- ------------------------------------------------
-- INSERT ... SELECT (Interesting Insert #2)
-- Automatically create waiver entries for every team in league 1
-- ------------------------------------------------
INSERT INTO Waiver (waiverPriority, waiverType, transactionDate, teamID)
SELECT
    10           AS waiverPriority,
    'Initial'    AS waiverType,
    CURDATE()    AS transactionDate,
    teamID
FROM FantasyTeam
WHERE leagueID = 1;

-- ------------------------------------------------
-- End of Task 4
-- ------------------------------------------------
