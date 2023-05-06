CREATE TABLE Tournament
(
  endDate TIMESTAMP NOT NULL,
  id VARCHAR NOT NULL,
  startDate TIMESTAMP NOT NULL,
  name VARCHAR NOT NULL,
  prizePool INT,
  PRIMARY KEY (id)
);

CREATE TABLE Team
(
  name VARCHAR NOT NULL,
  id VARCHAR NOT NULL,
  building VARCHAR,
  room VARCHAR,
  website VARCHAR,
  email VARCHAR,
  PRIMARY KEY (id)
);

CREATE TABLE Person
(
  lastName VARCHAR NOT NULL,
  middleName VARCHAR NOT NULL,
  firstName VARCHAR NOT NULL,
  dateOfBirth TIMESTAMP NOT NULL,
  email VARCHAR NOT NULL,
  kfupm_id VARCHAR NOT NULL,
  national_id VARCHAR NOT NULL,
  uid VARCHAR NOT NULL,
  PRIMARY KEY (kfupm_id),
  UNIQUE (national_id)
);

CREATE TABLE Referee
(
  referee_id VARCHAR NOT NULL,
  kfupm_id VARCHAR NOT NULL,
  PRIMARY KEY (referee_id),
  FOREIGN KEY (kfupm_id) REFERENCES Person(kfupm_id)
);

CREATE TABLE kfupmMember
(
  national_id VARCHAR NOT NULL,
  department VARCHAR NOT NULL,
  kfupm_id VARCHAR NOT NULL,
  PRIMARY KEY (kfupm_id),
  FOREIGN KEY (kfupm_id) REFERENCES Person(kfupm_id),
  UNIQUE (national_id)
);

CREATE TABLE Field
(
  id VARCHAR NOT NULL,
  building VARCHAR NOT NULL,
  room VARCHAR NOT NULL,
  width NUMERIC,
  length NUMERIC,
  crowdSize INT,
  name VARCHAR NOT NULL,
  PRIMARY KEY (id)
);

CREATE TABLE Team_contactNumbers
(
  contactNumbers VARCHAR NOT NULL,
  teamId VARCHAR NOT NULL,
  PRIMARY KEY (contactNumbers, teamId),
  FOREIGN KEY (teamId) REFERENCES Team(id)
);

CREATE TABLE Person_phoneNumbers
(
  number VARCHAR(10) NOT NULL,
  kfupm_id VARCHAR NOT NULL,
  PRIMARY KEY (number, kfupm_id),
  FOREIGN KEY (kfupm_id) REFERENCES Person(kfupm_id)
);

CREATE TABLE Team_Compete_in_Tourney
(
  teamId VARCHAR NOT NULL,
  TourneyId VARCHAR NOT NULL,
  FOREIGN KEY (teamId) REFERENCES Team(id),
  FOREIGN KEY (TourneyId) REFERENCES Tournament(id)
);

CREATE TABLE managed_team
(
  startedAt TIMESTAMP NOT NULL,
  endedAt TIMESTAMP,
  manager_id VARCHAR NOT NULL,
  team_id VARCHAR NOT NULL,
  FOREIGN KEY (manager_id) REFERENCES kfupmMember(kfupm_id),
  FOREIGN KEY (team_id) REFERENCES Team(id)
);

CREATE TABLE coached_team
(
  startedAt TIMESTAMP NOT NULL,
  endedAt TIMESTAMP,
  team_id VARCHAR NOT NULL,
  coach_id VARCHAR NOT NULL,
  FOREIGN KEY (team_id) REFERENCES Team(id),
  FOREIGN KEY (coach_id) REFERENCES kfupmMember(kfupm_id)
);

CREATE TABLE Player
(
  number INT NOT NULL,
  kfupm_id VARCHAR NOT NULL,
  PRIMARY KEY (kfupm_id),
  FOREIGN KEY (kfupm_id) REFERENCES kfupmMember(kfupm_id)
);

CREATE TABLE Match
(
  startDate TIMESTAMP NOT NULL,
  match_id VARCHAR NOT NULL,
  endDate TIMESTAMP,
  matchType VARCHAR NOT NULL,
  points INT,
  tourney_id VARCHAR NOT NULL,
  field_id VARCHAR NOT NULL,
  referee_id VARCHAR NOT NULL,
  PRIMARY KEY (match_id),
  FOREIGN KEY (tourney_id) REFERENCES Tournament(id),
  FOREIGN KEY (field_id) REFERENCES Field(id),
  FOREIGN KEY (referee_id) REFERENCES Referee(referee_id)
);

CREATE TABLE Match_Player
(
  isMVP BOOLEAN NOT NULL,
  field_type VARCHAR NOT NULL,
  startAt TIMESTAMP,
  endAt TIMESTAMP,
  kfupm_id VARCHAR NOT NULL,
  playFor VARCHAR NOT NULL,
  match_id VARCHAR NOT NULL,
  PRIMARY KEY (kfupm_id),
  FOREIGN KEY (kfupm_id) REFERENCES Player(kfupm_id),
  FOREIGN KEY (playFor) REFERENCES Team(id),
  FOREIGN KEY (match_id) REFERENCES Match(match_id)
);

CREATE TABLE shots
(
  time TIMESTAMP NOT NULL,
  isGoal BOOLEAN NOT NULL,
  shotType VARCHAR NOT NULL,
  distanceFromGoal NUMERIC,
  Match_id VARCHAR NOT NULL,
  shotBy VARCHAR NOT NULL,
  assistedBy VARCHAR,
  shotOn VARCHAR NOT NULL,
  forTeam VARCHAR NOT NULL,
  againstTeam VARCHAR NOT NULL,
  PRIMARY KEY (time, Match_id, shotBy),
  FOREIGN KEY (Match_id) REFERENCES Match(match_id),
  FOREIGN KEY (shotBy) REFERENCES Match_Player(kfupm_id),
  FOREIGN KEY (assistedBy) REFERENCES Match_Player(kfupm_id),
  FOREIGN KEY (shotOn) REFERENCES Match_Player(kfupm_id),
  FOREIGN KEY (forTeam) REFERENCES Team(id),
  FOREIGN KEY (againstTeam) REFERENCES Team(id)
);

CREATE TABLE Compete_in_match
(
  matchesPlayed INT NOT NULL,
  points INT NOT NULL,
  totalWon INT NOT NULL,
  team_id VARCHAR NOT NULL,
  match_id VARCHAR NOT NULL,
  PRIMARY KEY (team_id, match_id),
  FOREIGN KEY (team_id) REFERENCES Team(id),
  FOREIGN KEY (match_id) REFERENCES Match(match_id)
);

CREATE TABLE card
(
  cardType VARCHAR NOT NULL,
  takenAt TIMESTAMP NOT NULL,
  kfupm_id VARCHAR NOT NULL,
  RefereeId VARCHAR NOT NULL,
  match_id VARCHAR NOT NULL,
  team_id VARCHAR NOT NULL,
  tournament_id VARCHAR NOT NULL,
  FOREIGN KEY (kfupm_id) REFERENCES Match_Player(kfupm_id),
  FOREIGN KEY (RefereeId) REFERENCES Referee(referee_id),
  FOREIGN KEY (match_id) REFERENCES Match(match_id),
  FOREIGN KEY (team_id) REFERENCES Team(id),
  FOREIGN KEY (tournament_id) REFERENCES Tournament(id)
);

CREATE TABLE player_play_in_team
(
  joinedAt TIMESTAMP NOT NULL,
  leavedAt TIMESTAMP,
  kfupm_id VARCHAR NOT NULL,
  team_id VARCHAR NOT NULL,
  FOREIGN KEY (kfupm_id) REFERENCES Player(kfupm_id),
  FOREIGN KEY (team_id) REFERENCES Team(id)
);

CREATE TABLE player_in_out
(
  happenedAt TIMESTAMP NOT NULL,
  match_id VARCHAR NOT NULL,
  team_id VARCHAR NOT NULL,
  playerLeaving VARCHAR NOT NULL,
  playerJoining VARCHAR NOT NULL,
  FOREIGN KEY (match_id) REFERENCES Match(match_id),
  FOREIGN KEY (team_id) REFERENCES Team(id),
  FOREIGN KEY (playerLeaving) REFERENCES Player(kfupm_id),
  FOREIGN KEY (playerJoining) REFERENCES Player(kfupm_id)
);