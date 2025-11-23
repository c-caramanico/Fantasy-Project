-- Optional: create & use a database for your project
CREATE DATABASE IF NOT EXISTS fantasy_nba;
USE fantasy_nba;

-- =========================================================
-- 1. USER
-- Logical: User(userID, email, username, password, role, leagueID)
-- PK: userID
-- Alt key: email
-- FK (later): leagueID -> League_LeaderBoard(leagueID)
-- =========================================================
CREATE TABLE `User` (
    userID      INT AUTO_INCREMENT,
    email       VARCHAR(255) NOT NULL,
    username    VARCHAR(100) NOT NULL,
    password    VARCHAR(255) NOT NULL,
    role        VARCHAR(50)  NOT NULL,
    leagueID    INT,
    PRIMARY KEY (userID),
    UNIQUE KEY uq_user_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =========================================================
-- 2. MANAGER
-- Logical: Manager(managerID, userID, email, username, password, role, desiredSettings)
-- PK: managerID
-- (Your logical model doesn’t declare FKs, but userID clearly links to User)
-- =========================================================
CREATE TABLE Manager (
    managerID        INT AUTO_INCREMENT,
    userID           INT,
    email            VARCHAR(255) NOT NULL,
    username         VARCHAR(100) NOT NULL,
    password         VARCHAR(255) NOT NULL,
    role             VARCHAR(50)  NOT NULL,
    desiredSettings  TEXT,
    PRIMARY KEY (managerID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =========================================================
-- 3. LEAGUE_LEADERBOARD
-- Logical: League_LeaderBoard(leagueID, leagueName, statType, weight,
--          seasonYear, maxTeams, leaderBoardID, standings, lastUpdated, managerID)
-- PK: leagueID
-- Alt key: leaderBoardID
-- FK: managerID -> Manager(managerID)
-- =========================================================
CREATE TABLE League_LeaderBoard (
    leagueID       INT AUTO_INCREMENT,
    leagueName     VARCHAR(100) NOT NULL,
    statType       VARCHAR(50),
    weight         DECIMAL(5,2),
    seasonYear     YEAR,
    maxTeams       INT,
    leaderBoardID  INT,
    standings      TEXT,
    lastUpdated    DATETIME,
    managerID      INT,
    PRIMARY KEY (leagueID),
    UNIQUE KEY uq_leaderBoardID (leaderBoardID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =========================================================
-- 4. FANTASYTEAM
-- Logical: FantasyTeam(teamID, teamName, teamAbbreviation, waiverPriority,
--          fantasyPoints, leagueID, tradeID, matchupID, userID)
-- PK: teamID
-- FKs (later): leagueID -> League_LeaderBoard, tradeID -> Trade,
--              matchupID -> WeeklyMatchup, userID -> User
-- =========================================================
CREATE TABLE FantasyTeam (
    teamID            INT AUTO_INCREMENT,
    teamName          VARCHAR(100) NOT NULL,
    teamAbbreviation  VARCHAR(10),
    waiverPriority    INT,
    fantasyPoints     INT DEFAULT 0,
    leagueID          INT,
    tradeID           INT,
    matchupID         INT,
    userID            INT,
    PRIMARY KEY (teamID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =========================================================
-- 5. WEEKLYMATCHUP
-- Logical: weeklyMatchup(matchupID, weekNumber, team1ID, team2ID,
--          score1, score2, winner, leagueID)
-- PK: matchupID
-- FK: leagueID -> League_LeaderBoard(leagueID)
-- winner is derived but we keep it as a stored attribute
-- =========================================================
CREATE TABLE WeeklyMatchup (
    matchupID   INT AUTO_INCREMENT,
    weekNumber  INT NOT NULL,
    team1ID     INT,
    team2ID     INT,
    score1      INT DEFAULT 0,
    score2      INT DEFAULT 0,
    winner      INT,       -- could store teamID of winner
    leagueID    INT,
    PRIMARY KEY (matchupID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =========================================================
-- 6. NBAPLAYERS
-- Logical: NBAPlayers(..., teamID)
-- PK: playerID
-- FK: teamID -> FantasyTeam(teamID)
-- fgPercentage, ftPercentage are marked as derived in your model
-- =========================================================
CREATE TABLE NBAPlayers (
    playerID       INT AUTO_INCREMENT,
    firstName      VARCHAR(50) NOT NULL,
    lastName       VARCHAR(50) NOT NULL,
    position       VARCHAR(10),
    team           VARCHAR(50),
    blocks         INT DEFAULT 0,
    pointScored    INT DEFAULT 0,
    gamesPlayed    INT DEFAULT 0,
    turnover       INT DEFAULT 0,
    assist         INT DEFAULT 0,
    fgMade         INT DEFAULT 0,
    fgAttempt      INT DEFAULT 0,
    ftMade         INT DEFAULT 0,
    ftAttempt      INT DEFAULT 0,
    steals         INT DEFAULT 0,
    fgPercentage   DECIMAL(5,2),
    ftPercentage   DECIMAL(5,2),
    teamID         INT,
    PRIMARY KEY (playerID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =========================================================
-- 7. INJURYREPORT
-- Logical: InjuryReport(injuryReportID, status, severity,
--          bodyPart, expectedReturnDate, playerID)
-- PK: injuryReportID
-- FK: playerID -> NBAPlayers(playerID)
-- (Your text had a small typo in the attribute name; using injuryReportID)
-- =========================================================
CREATE TABLE InjuryReport (
    injuryReportID      INT AUTO_INCREMENT,
    status              VARCHAR(50),
    severity            VARCHAR(50),
    bodyPart            VARCHAR(50),
    expectedReturnDate  DATE,
    playerID            INT NOT NULL,
    PRIMARY KEY (injuryReportID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =========================================================
-- 8. WAIVER
-- Logical: Waiver(waiverID, waiverPriority, waiverType, transactionDate, teamID)
-- PK: waiverID
-- FK: teamID -> FantasyTeam(teamID)
-- =========================================================
CREATE TABLE Waiver (
    waiverID        INT AUTO_INCREMENT,
    waiverPriority  INT,
    waiverType      VARCHAR(50),
    transactionDate DATE,
    teamID          INT,
    PRIMARY KEY (waiverID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =========================================================
-- 9. TRADE
-- Logical: Trade(teamID, playerID, tradeID, tradeDate, tradeStatus)
-- PK: teamID, playerID, tradeID
-- FKs: teamID -> FantasyTeam(teamID), playerID -> NBAPlayers(playerID)
-- FantasyTeam also has tradeID referencing Trade(tradeID); to support that
-- we add a UNIQUE constraint on tradeID.
-- =========================================================
CREATE TABLE Trade (
    tradeID      INT NOT NULL,
    teamID       INT NOT NULL,
    playerID     INT NOT NULL,
    tradeDate    DATE,
    tradeStatus  VARCHAR(20),
    PRIMARY KEY (teamID, playerID, tradeID),
    UNIQUE KEY uq_tradeID (tradeID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =========================================================
-- FOREIGN KEYS (added after all tables exist to avoid circular issues)
-- =========================================================

-- Manager.userID -> User.userID  (not in your text, but clearly intended)
ALTER TABLE Manager
    ADD CONSTRAINT fk_Manager_User
    FOREIGN KEY (userID)
    REFERENCES `User`(userID);

-- League_LeaderBoard.managerID -> Manager.managerID
ALTER TABLE League_LeaderBoard
    ADD CONSTRAINT fk_League_Manager
    FOREIGN KEY (managerID)
    REFERENCES Manager(managerID);

-- User.leagueID -> League_LeaderBoard.leagueID
ALTER TABLE `User`
    ADD CONSTRAINT fk_User_League
    FOREIGN KEY (leagueID)
    REFERENCES League_LeaderBoard(leagueID);

-- FantasyTeam.leagueID -> League_LeaderBoard.leagueID
ALTER TABLE FantasyTeam
    ADD CONSTRAINT fk_FantasyTeam_League
    FOREIGN KEY (leagueID)
    REFERENCES League_LeaderBoard(leagueID);

-- FantasyTeam.userID -> User.userID
ALTER TABLE FantasyTeam
    ADD CONSTRAINT fk_FantasyTeam_User
    FOREIGN KEY (userID)
    REFERENCES `User`(userID);

-- FantasyTeam.matchupID -> WeeklyMatchup.matchupID
ALTER TABLE FantasyTeam
    ADD CONSTRAINT fk_FantasyTeam_Matchup
    FOREIGN KEY (matchupID)
    REFERENCES WeeklyMatchup(matchupID);

-- FantasyTeam.tradeID -> Trade.tradeID (via unique key)
ALTER TABLE FantasyTeam
    ADD CONSTRAINT fk_FantasyTeam_Trade
    FOREIGN KEY (tradeID)
    REFERENCES Trade(tradeID);

-- WeeklyMatchup.leagueID -> League_LeaderBoard.leagueID
ALTER TABLE WeeklyMatchup
    ADD CONSTRAINT fk_WeeklyMatchup_League
    FOREIGN KEY (leagueID)
    REFERENCES League_LeaderBoard(leagueID);

-- NBAPlayers.teamID -> FantasyTeam.teamID
ALTER TABLE NBAPlayers
    ADD CONSTRAINT fk_NBAPlayers_FantasyTeam
    FOREIGN KEY (teamID)
    REFERENCES FantasyTeam(teamID);

-- InjuryReport.playerID -> NBAPlayers.playerID
ALTER TABLE InjuryReport
    ADD CONSTRAINT fk_InjuryReport_Player
    FOREIGN KEY (playerID)
    REFERENCES NBAPlayers(playerID);

-- Waiver.teamID -> FantasyTeam.teamID
ALTER TABLE Waiver
    ADD CONSTRAINT fk_Waiver_FantasyTeam
    FOREIGN KEY (teamID)
    REFERENCES FantasyTeam(teamID);

-- Trade.teamID -> FantasyTeam.teamID
ALTER TABLE Trade
    ADD CONSTRAINT fk_Trade_FantasyTeam
    FOREIGN KEY (teamID)
    REFERENCES FantasyTeam(teamID);

-- Trade.playerID -> NBAPlayers.playerID
ALTER TABLE Trade
    ADD CONSTRAINT fk_Trade_Player
    FOREIGN KEY (playerID)
    REFERENCES NBAPlayers(playerID);
