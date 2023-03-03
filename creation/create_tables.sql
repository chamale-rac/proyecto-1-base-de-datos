CREATE TABLE country
(
    id   TEXT,
    name TEXT,
    PRIMARY KEY (id)
);

CREATE TABLE league
(
    id         TEXT,
    country_id TEXT,
    name       TEXT,
    PRIMARY KEY (id),
    FOREIGN KEY (country_id)
        REFERENCES country (id)
);

CREATE TABLE team
(
    id               TEXT,
    team_api_id      TEXT UNIQUE,
    team_fifa_api_id TEXT,
    team_long_name   TEXT,
    team_short_name   TEXT,
    PRIMARY KEY (id)
);

CREATE TABLE player
(
    id                 TEXT,
    player_api_id      TEXT UNIQUE ,
    player_name        TEXT,
    player_fifa_api_id TEXT,
    birthday           TIMESTAMP,
    height             NUMERIC,
    weight             INTEGER,
    PRIMARY KEY (id)
);

CREATE TABLE team_attributes
(
    id                             TEXT,
    team_fifa_api_id               TEXT,
    team_api_id                    TEXT,
    date                           TIMESTAMP,
    buildUpPlaySpeed               INTEGER,
    buildUpPlaySpeedClass          TEXT,
    buildUpPlayDribbling           INTEGER,
    buildUpPlayDribblingClass      TEXT,
    buildUpPlayPassing             INTEGER,
    buildUpPlayPassingClass        TEXT,
    buildUpPlayPositioningClass    TEXT,
    chanceCreationPassing          INTEGER,
    chanceCreationPassingClass     TEXT,
    chanceCreationCrossing         INTEGER,
    chanceCreationCrossingClass    TEXT,
    chanceCreationShooting         INTEGER,
    chanceCreationShootingClass    TEXT,
    chanceCreationPositioningClass TEXT,
    defencePressure                INTEGER,
    defencePressureClass           TEXT,
    defenceAggression              INTEGER,
    defenceAggressionClass         TEXT,
    defenceTeamWidth               INTEGER,
    defenceTeamWidthClass          TEXT,
    defenceDefenderLineClass       TEXT,
    PRIMARY KEY (id),
    FOREIGN KEY (team_api_id)
        REFERENCES team (team_api_id)
);

CREATE TABLE player_attributes
(
    id                  TEXT,
    player_fifa_api_id  TEXT,
    player_api_id       TEXT,
    date                TIMESTAMP,
    overall_rating      INTEGER,
    potential           INTEGER,
    crossing            INTEGER,
    finishing           INTEGER,
    heading_accuracy    INTEGER,
    short_passing       INTEGER,
    volleys             INTEGER,
    dribbling           INTEGER,
    curve               INTEGER,
    free_kick_accuracy  INTEGER,
    long_passing        INTEGER,
    ball_control        INTEGER,
    acceleration        INTEGER,
    sprint_speed        INTEGER,
    agility             INTEGER,
    reactions           INTEGER,
    balance             INTEGER,
    shot_power          INTEGER,
    jumping             INTEGER,
    stamina             INTEGER,
    strength            INTEGER,
    long_shots          INTEGER,
    aggression          INTEGER,
    interceptions       INTEGER,
    positioning         INTEGER,
    vision              INTEGER,
    penalties           INTEGER,
    marking             INTEGER,
    standing_tackle     INTEGER,
    sliding_tackle      INTEGER,
    gk_diving           INTEGER,
    gk_handling         INTEGER,
    gk_kicking          INTEGER,
    gk_positioning      INTEGER,
    gk_reflexes         INTEGER,
    preferred_foot      TEXT,
    attacking_work_rate TEXT,
    defensive_work_rate TEXT,
    PRIMARY KEY (id),
    FOREIGN KEY (player_api_id)
        REFERENCES player (player_api_id)
);

CREATE TABLE match
(
    id               TEXT,
    country_id       TEXT,
    league_id        TEXT,
    season           TEXT,
    stage            INTEGER,
    date            TIMESTAMP,
    match_api_id     TEXT,
    home_team_api_id TEXT,
    away_team_api_id TEXT,
    home_team_goal   INTEGER,
    away_team_goal   INTEGER,
    home_player_1    TEXT,
    home_player_2    TEXT,
    home_player_3    TEXT,
    home_player_4    TEXT,
    home_player_5    TEXT,
    home_player_6    TEXT,
    home_player_7    TEXT,
    home_player_8    TEXT,
    home_player_9    TEXT,
    home_player_10   TEXT,
    home_player_11   TEXT,
    away_player_1    TEXT,
    away_player_2    TEXT,
    away_player_3    TEXT,
    away_player_4    TEXT,
    away_player_5    TEXT,
    away_player_6    TEXT,
    away_player_7    TEXT,
    away_player_8    TEXT,
    away_player_9    TEXT,
    away_player_10   TEXT,
    away_player_11   TEXT,
    B365H            NUMERIC,
    B365D            NUMERIC,
    B365A            NUMERIC,
    BWH              NUMERIC,
    BWD              NUMERIC,
    BWA              NUMERIC,
    IWH              NUMERIC,
    IWD              NUMERIC,
    IWA              NUMERIC,
    LBH              NUMERIC,
    LBD              NUMERIC,
    LBA              NUMERIC,
    PSH              NUMERIC,
    PSD              NUMERIC,
    PSA              NUMERIC,
    WHH              NUMERIC,
    WHD              NUMERIC,
    WHA              NUMERIC,
    SJH              NUMERIC,
    SJD              NUMERIC,
    SJA              NUMERIC,
    VCH              NUMERIC,
    VCD              NUMERIC,
    VCA              NUMERIC,
    GBH              NUMERIC,
    GBD              NUMERIC,
    GBA              NUMERIC,
    BSH              NUMERIC,
    BSD              NUMERIC,
    BSA              NUMERIC,
    PRIMARY KEY (id),
    FOREIGN KEY (country_id)
        REFERENCES country (id),
    FOREIGN KEY (league_id)
        REFERENCES league (id),
    FOREIGN KEY (home_team_api_id)
        REFERENCES team (team_api_id),
    FOREIGN KEY (away_team_api_id)
        REFERENCES team (team_api_id),
    FOREIGN KEY (home_player_1)
        REFERENCES player (player_api_id),
    FOREIGN KEY (home_player_2)
        REFERENCES player (player_api_id),
    FOREIGN KEY (home_player_3)
        REFERENCES player (player_api_id),
    FOREIGN KEY (home_player_4)
        REFERENCES player (player_api_id),
    FOREIGN KEY (home_player_5)
        REFERENCES player (player_api_id),
    FOREIGN KEY (home_player_6)
        REFERENCES player (player_api_id),
    FOREIGN KEY (home_player_7)
        REFERENCES player (player_api_id),
    FOREIGN KEY (home_player_8)
        REFERENCES player (player_api_id),
    FOREIGN KEY (home_player_9)
        REFERENCES player (player_api_id),
    FOREIGN KEY (home_player_10)
        REFERENCES player (player_api_id),
    FOREIGN KEY (home_player_11)
        REFERENCES player (player_api_id),
    FOREIGN KEY (away_player_1)
        REFERENCES player (player_api_id),
    FOREIGN KEY (away_player_2)
        REFERENCES player (player_api_id),
    FOREIGN KEY (away_player_3)
        REFERENCES player (player_api_id),
    FOREIGN KEY (away_player_4)
        REFERENCES player (player_api_id),
    FOREIGN KEY (away_player_5)
        REFERENCES player (player_api_id),
    FOREIGN KEY (away_player_6)
        REFERENCES player (player_api_id),
    FOREIGN KEY (away_player_7)
        REFERENCES player (player_api_id),
    FOREIGN KEY (away_player_8)
        REFERENCES player (player_api_id),
    FOREIGN KEY (away_player_9)
        REFERENCES player (player_api_id),
    FOREIGN KEY (away_player_10)
        REFERENCES player (player_api_id),
    FOREIGN KEY (away_player_11)
        REFERENCES player (player_api_id)
);

CREATE TABLE faults (
    match_api_id TEXT,
    home_faults INTEGER,
    away_faults INTEGER
);
