/*****PLEASE ENTER YOUR DETAILS BELOW*****/
--T1-rm-schema.sql

--Student ID: 33878897
--Student Name: Muhammad Mubashir Shah

/* Comments for your marker:
   - Created COMPETITOR, ENTRY, and TEAM tables precisely as per the Run Monash diagram.
   - Adjusted NULL/NOT NULL to match which attributes are mandatory vs. optional:
       ‑ COMPETITOR: comp_fname, comp_lname are optional; all others mandatory.
       ‑ ENTRY: event_id, entry_no, comp_no are mandatory; all other columns optional.
       ‑ TEAM: team_id, team_name, carn_date, event_id, entry_no are all mandatory.
   - Defined all column comments, PRIMARY KEYs, CHECKs, UNIQUEs.
   - Added FOREIGN KEY constraints at the end, following the assignment instructions.
*/

/* drop table statements - do not remove*/

DROP TABLE competitor CASCADE CONSTRAINTS PURGE;

DROP TABLE entry CASCADE CONSTRAINTS PURGE;

DROP TABLE team CASCADE CONSTRAINTS PURGE;

/* end of drop table statements*/

-- Task 1 Add Create table statements for the Missing TABLES below.
-- Ensure all column comments, and constraints (other than FK's)are included.
-- FK constraints are to be added at the end of this script

-- COMPETITOR
CREATE TABLE competitor (
    comp_no        NUMBER(5) NOT NULL,   -- Unique identifier for a competitor (PK)
    comp_fname     VARCHAR2(30) NULL,       -- Competitor’s first name (optional)
    comp_lname     VARCHAR2(30) NULL,       -- Competitor’s last name (optional)
    comp_gender    CHAR(1) NOT NULL,   -- Competitor’s gender (‘M’, ‘F’, ‘U’)
    comp_dob       DATE NOT NULL,   -- Competitor’s date of birth
    comp_email     VARCHAR2(50) NOT NULL,   -- Competitor’s email (unique, mandatory)
    comp_unistatus CHAR(1) NOT NULL,   -- ‘Y’ if Monash student/staff, else ‘N’
    comp_phone     CHAR(10) NOT NULL    -- Competitor’s phone number (unique, mandatory)
);

COMMENT ON COLUMN competitor.comp_no IS
    'Competitor unique identifier (PK)';
COMMENT ON COLUMN competitor.comp_fname IS
    'Competitor first name (optional)';
COMMENT ON COLUMN competitor.comp_lname IS
    'Competitor last name (optional)';
COMMENT ON COLUMN competitor.comp_gender IS
    'Competitor gender (M, F, U)';
COMMENT ON COLUMN competitor.comp_dob IS
    'Competitor date of birth';
COMMENT ON COLUMN competitor.comp_email IS
    'Competitor email address (unique, mandatory)';
COMMENT ON COLUMN competitor.comp_unistatus IS
    'Monash student/staff status (Y/N)';
COMMENT ON COLUMN competitor.comp_phone IS
    'Competitor phone number (unique, mandatory)';

-- Primary Key
ALTER TABLE competitor ADD CONSTRAINT competitor_pk PRIMARY KEY ( comp_no );

-- CHECK constraints on gender and unistatus
ALTER TABLE competitor
    ADD CONSTRAINT competitor_gender_ck
        CHECK ( comp_gender IN ( 'M',
                                 'F',
                                 'U' ) );

ALTER TABLE competitor
    ADD CONSTRAINT competitor_unistatus_ck CHECK ( comp_unistatus IN ( 'Y',
                                                                       'N' ) );

-- UNIQUE constraints on email and phone
ALTER TABLE competitor ADD CONSTRAINT competitor_email_uk UNIQUE ( comp_email );

ALTER TABLE competitor ADD CONSTRAINT competitor_phone_uk UNIQUE ( comp_phone );


--ENTRY
CREATE TABLE entry (
    event_id          NUMBER(6) NOT NULL,  -- Event id (surrogate primary key, mandatory)
    entry_no          NUMBER(5) NOT NULL,  -- Entry number (unique only within an event, mandatory)
    entry_starttime   DATE NULL,      -- Entrant’s start time (optional)
    entry_finishtime  DATE NULL,      -- Entrant’s finish time (optional)
    entry_elapsedtime DATE NULL,      -- Elapsed time (optional, hh24:mi:ss)
    comp_no           NUMBER(5) NOT NULL,  -- Competitor’s comp_no (FK, mandatory)
    team_id           NUMBER(3) NULL,      -- Team identifier (FK, if joined a team, optional)
    char_id           NUMBER(3) NULL       -- Charity supported (FK, optional)
);

COMMENT ON COLUMN entry.event_id IS
    'Event id (PK component, mandatory)';
COMMENT ON COLUMN entry.entry_no IS
    'Entry number (PK component, mandatory)';
COMMENT ON COLUMN entry.entry_starttime IS
    'Entrant start time (hh24:mi:ss, optional)';
COMMENT ON COLUMN entry.entry_finishtime IS
    'Entrant finish time (hh24:mi:ss, optional)';
COMMENT ON COLUMN entry.entry_elapsedtime IS
    'Calculated elapsed time (hh24:mi:ss, optional)';
COMMENT ON COLUMN entry.comp_no IS
    'Competitor number (FK to COMPETITOR, mandatory)';
COMMENT ON COLUMN entry.team_id IS
    'Team identifier (FK to TEAM, optional)';
COMMENT ON COLUMN entry.char_id IS
    'Charity ID (FK to CHARITY, optional)';

-- Primary Key: combination of event_id and entry_no
ALTER TABLE entry ADD CONSTRAINT entry_pk PRIMARY KEY ( event_id,
                                                        entry_no );


--TEAM
CREATE TABLE team (
    team_id   NUMBER(3) NOT NULL,  -- Team identifier (PK, mandatory)
    team_name VARCHAR2(30) NOT NULL,  -- Team name (unique per carnival, mandatory)
    carn_date DATE NOT NULL,  -- Carnival date (FK to CARNIVAL, mandatory)
    event_id  NUMBER(6) NOT NULL,  -- Event id (FK to EVENT, mandatory)
    entry_no  NUMBER(5) NOT NULL   -- Entry number of team leader (FK to ENTRY, mandatory)
);

COMMENT ON COLUMN team.team_id IS
    'Team unique identifier (PK, mandatory)';
COMMENT ON COLUMN team.team_name IS
    'Team name (unique within a carnival, mandatory)';
COMMENT ON COLUMN team.carn_date IS
    'Carnival date (FK to CARNIVAL, mandatory)';
COMMENT ON COLUMN team.event_id IS
    'Event id (FK to EVENT where team is formed, mandatory)';
COMMENT ON COLUMN team.entry_no IS
    'Entry number of the team leader (FK to ENTRY, mandatory)';

-- Primary Key on team_id
ALTER TABLE team ADD CONSTRAINT team_pk PRIMARY KEY ( team_id );

-- UNIQUE: team_name must be unique for each carnival
ALTER TABLE team ADD CONSTRAINT team_uq UNIQUE ( carn_date,
                                                 team_name );


-- Add all missing FK Constraints below here
-- ENTRY → COMPETITOR
ALTER TABLE entry
    ADD CONSTRAINT entry_comp_fk FOREIGN KEY ( comp_no )
        REFERENCES competitor ( comp_no );

-- ENTRY → EVENT
ALTER TABLE entry
    ADD CONSTRAINT entry_event_fk FOREIGN KEY ( event_id )
        REFERENCES event ( event_id );

-- ENTRY → TEAM
ALTER TABLE entry
    ADD CONSTRAINT entry_team_fk FOREIGN KEY ( team_id )
        REFERENCES team ( team_id );

-- ENTRY → CHARITY
ALTER TABLE entry
    ADD CONSTRAINT entry_charity_fk FOREIGN KEY ( char_id )
        REFERENCES charity ( char_id );

-- TEAM → CARNIVAL
ALTER TABLE team
    ADD CONSTRAINT team_carnival_fk FOREIGN KEY ( carn_date )
        REFERENCES carnival ( carn_date );

-- TEAM → EVENT
ALTER TABLE team
    ADD CONSTRAINT team_event_fk FOREIGN KEY ( event_id )
        REFERENCES event ( event_id );

-- TEAM → ENTRY (team leader’s entry is identified by entry_no & event_id)
ALTER TABLE team
    ADD CONSTRAINT team_leader_entry_fk
        FOREIGN KEY ( entry_no,
                      event_id )
            REFERENCES entry ( entry_no,
                               event_id );