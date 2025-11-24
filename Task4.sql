
-- TASK 4: Basic Data Insertions
-- Insert a league, 20 users, 20 managers, 20 fantasy teams,
-- one NBA player, an injury report, and initial waivers.

USE fantasy_nba;

-- Insert 1: Insert a league
INSERT INTO League_LeaderBoard
    (leagueName, statType, weight, seasonYear, maxTeams,
     leaderBoardID, standings, lastUpdated, managerID)
VALUES
    ('AISE Fantasy League', 'points', 1.00, 2025, 20,
     1001, NULL, NOW(), NULL);

-- MULTI-ROW INSERT 
-- Insert 2: Insert 20 users (one per fantasy team owner)
INSERT INTO `User`
    (email, username, password, role, leagueID)
VALUES
    ('owner1@example.com',  'owner1',  'Password!23', 'manager', 1),
    ('owner2@example.com',  'owner2',  'Password!23', 'manager', 1),
    ('owner3@example.com',  'owner3',  'Password!23', 'manager', 1),
    ('owner4@example.com',  'owner4',  'Password!23', 'manager', 1),
    ('owner5@example.com',  'owner5',  'Password!23', 'manager', 1),
    ('owner6@example.com',  'owner6',  'Password!23', 'manager', 1),
    ('owner7@example.com',  'owner7',  'Password!23', 'manager', 1),
    ('owner8@example.com',  'owner8',  'Password!23', 'manager', 1),
    ('owner9@example.com',  'owner9',  'Password!23', 'manager', 1),
    ('owner10@example.com', 'owner10', 'Password!23', 'manager', 1),
    ('owner11@example.com', 'owner11', 'Password!23', 'manager', 1),
    ('owner12@example.com', 'owner12', 'Password!23', 'manager', 1),
    ('owner13@example.com', 'owner13', 'Password!23', 'manager', 1),
    ('owner14@example.com', 'owner14', 'Password!23', 'manager', 1),
    ('owner15@example.com', 'owner15', 'Password!23', 'manager', 1),
    ('owner16@example.com', 'owner16', 'Password!23', 'manager', 1),
    ('owner17@example.com', 'owner17', 'Password!23', 'manager', 1),
    ('owner18@example.com', 'owner18', 'Password!23', 'manager', 1),
    ('owner19@example.com', 'owner19', 'Password!23', 'manager', 1),
    ('owner20@example.com', 'owner20', 'Password!23', 'manager', 1);


-- Insert 3: Insert 20 managers (one per user)
INSERT INTO Manager
    (userID, email, username, password, role, desiredSettings)
VALUES
    (1,  'owner1@example.com',  'owner1',  'Password!23', 'manager', 'Aggressive trading'),
  
-- MULTI-ROW INSERT 
-- Insert 20 fantasy teams in league 1, one per user
-- Assumes FantasyTeam table is empty so teamID 1..20 map in this order.
INSERT INTO FantasyTeam
    (teamName, teamAbbreviation, waiverPriority, fantasyPoints,
     leagueID, tradeID, matchupID, userID)
VALUES
    -- Each team belongs to a different userID (1..20)
    ('Christian Ballers',       'CBL',  1, 0, 1, NULL, NULL, 1),
    ('Nathan Ninjas',           'NNJ',  2, 0, 1, NULL, NULL, 2),
    ('Ben Buckets',             'BBK',  3, 0, 1, NULL, NULL, 3),
    ('Akshayan Aces',           'AAC',  4, 0, 1, NULL, NULL, 4),
    ('Cadeau Crushers',         'CCR',  5, 0, 1, NULL, NULL, 5),
    ('Hayimana Hawks',          'HHK',  6, 0, 1, NULL, NULL, 6),
    ('Chu Chargers',            'CHU',  7, 0, 1, NULL, NULL, 7),
    ('Chiu Champs',             'CHI',  8, 0, 1, NULL, NULL, 8),
    ('Thunderous Tacos',        'TTC',  9, 0, 1, NULL, NULL, 9),
    ('Backboard Bandits',       'BBD', 10, 0, 1, NULL, NULL, 10),
    ('Rim Rattlers',            'RRT', 11, 0, 1, NULL, NULL, 11),
    ('Splash Zone Snipers',     'SZS', 12, 0, 1, NULL, NULL, 12),
    ('Alley-Oop Alchemists',    'AOA', 13, 0, 1, NULL, NULL, 13),
    ('Baseline Bruisers',       'BLB', 14, 0, 1, NULL, NULL, 14),
    ('Pick-and-Roll Pirates',   'PRP', 15, 0, 1, NULL, NULL, 15),
    ('Triple-Double Titans',    'TDT', 16, 0, 1, NULL, NULL, 16),
    ('Zone Breaker Zebras',     'ZBZ', 17, 0, 1, NULL, NULL, 17),
    ('Fastbreak Falcons',       'FBF', 18, 0, 1, NULL, NULL, 18),
    ('Crunch Time Cobras',      'CTC', 19, 0, 1, NULL, NULL, 19),
    ('Glass Cleaner Gorillas',  'GCG', 20, 0, 1, NULL, NULL, 20);



-- Insert one NBA player on teamID = 1 (Christian Ballers)

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


-- INSERT ... SELECT (Interesting Insert #2)
-- Automatically create waiver entries for every team in league 1

INSERT INTO Waiver (waiverPriority, waiverType, transactionDate, teamID)
SELECT
    10           AS waiverPriority,
    'Initial'    AS waiverType,
    CURDATE()    AS transactionDate,
    teamID
FROM FantasyTeam
WHERE leagueID = 1;

-- SELECTs for screenshots (Task 4 PDF evidence)

SELECT * FROM League_LeaderBoard;
SELECT * FROM `User`;
SELECT * FROM Manager;
SELECT * FROM FantasyTeam;
SELECT * FROM NBAPlayers;
SELECT * FROM InjuryReport;
SELECT * FROM Waiver;

-- End of Task 4
