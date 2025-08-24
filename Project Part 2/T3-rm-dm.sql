--****PLEASE ENTER YOUR DETAILS BELOW****
--T3-rm-dm.sql

--Student ID: 33878897
--Student Name: Muhammad Mubashir Shah

/* Comments for your marker:

Assumption: Sequences competitor_seq and team_seq do not exist or may exist; DROP errors are acceptable.
 
- Created sequences for COMPETITOR and TEAM tables
- Added competitors Keith Rose and Jackson Bull with proper case handling
- Managed team creation and event entries with case-insensitive comparisons:
  - Formed 'Super Runners' team for 10K event
  - Handled charity assignments with UPPER() comparisons
- Processed event changes:
  - Jackson downgraded to 5K with charity change
  - Keith withdrawal and team disbanding
- Fixed constraint violations by proper dependency resolution
- Ensured:
  - Case-insensitive string comparisons using UPPER()
  - Proper date handling with TO_DATE()
  - Transaction safety with COMMIT points

*/


--(a)
-- Drop sequences if they exist
DROP SEQUENCE competitor_seq;
DROP SEQUENCE team_seq;

-- Create sequence for COMPETITOR table (starts at 100, increments by 5)
CREATE SEQUENCE competitor_seq START WITH 100 INCREMENT BY 5;
-- Create sequence for TEAM table (starts at 100, increments by 5)
CREATE SEQUENCE team_seq START WITH 100 INCREMENT BY 5;

--(b)
INSERT INTO competitor (
    comp_no,
    comp_fname,
    comp_lname,
    comp_gender,
    comp_dob,
    comp_email,
    comp_unistatus,
    comp_phone
) VALUES ( competitor_seq.NEXTVAL,
           'Keith',
           'Rose',
           'M',
           TO_DATE('15/JUN/2003','DD/MON/YYYY'),
           'keith.rose@student.monash.edu',
           'Y',
           '0422141112' );

INSERT INTO competitor (
    comp_no,
    comp_fname,
    comp_lname,
    comp_gender,
    comp_dob,
    comp_email,
    comp_unistatus,
    comp_phone
) VALUES ( competitor_seq.NEXTVAL,
           'Jackson',
           'Bull',
           'M',
           TO_DATE('22/AUG/2004','DD/MON/YYYY'),
           'jackson.bull@student.monash.edu',
           'Y',
           '0422412524' );

-- Keith's entry in 10K event
INSERT INTO entry (
    event_id,
    entry_no,
    entry_starttime,
    entry_finishtime,
    entry_elapsedtime,
    comp_no,
    team_id,
    char_id
) VALUES ( (
    SELECT e.event_id
      FROM event e
      JOIN carnival c
    ON e.carn_date = c.carn_date
     WHERE upper(c.carn_name) = upper('RM Winter Series Caulfield 2025')
       AND upper(e.eventtype_code) = upper('10K')
),
           (
               SELECT nvl(
                   max(entry_no),
                   0
               ) + 1
                 FROM entry
                WHERE event_id = (
                   SELECT e.event_id
                     FROM event e
                     JOIN carnival c
                   ON e.carn_date = c.carn_date
                    WHERE upper(c.carn_name) = upper('RM Winter Series Caulfield 2025'
                    )
                      AND upper(e.eventtype_code) = upper('10K')
               )
           ),
           NULL,
           NULL,
           NULL,
           (
               SELECT comp_no
                 FROM competitor
                WHERE comp_phone = '0422141112'
           ),
           NULL,
           (
               SELECT char_id
                 FROM charity
                WHERE upper(char_name) = upper('Salvation Army')
           ) );

-- Create 'Super Runners' team with Keith as leader
INSERT INTO team (
    team_id,
    team_name,
    carn_date,
    event_id,
    entry_no
) VALUES ( team_seq.NEXTVAL,
           'Super Runners',
           (
               SELECT carn_date
                 FROM carnival
                WHERE upper(carn_name) = upper('RM Winter Series Caulfield 2025')
           ),
           (
               SELECT e.event_id
                 FROM event e
                 JOIN carnival c
               ON e.carn_date = c.carn_date
                WHERE upper(c.carn_name) = upper('RM Winter Series Caulfield 2025')
                  AND upper(e.eventtype_code) = upper('10K')
           ),
           (
               SELECT entry_no
                 FROM entry
                WHERE comp_no = (
                       SELECT comp_no
                         FROM competitor
                        WHERE comp_phone = '0422141112'
                   )
                  AND event_id = (
                   SELECT e.event_id
                     FROM event e
                     JOIN carnival c
                   ON e.carn_date = c.carn_date
                    WHERE upper(c.carn_name) = upper('RM Winter Series Caulfield 2025'
                    )
                      AND upper(e.eventtype_code) = upper('10K')
               )
           ) );

-- Assign Keith to 'Super Runners'
UPDATE entry
   SET
    team_id = (
        SELECT team_id
          FROM team
         WHERE upper(team_name) = upper('Super Runners')
           AND carn_date = (
            SELECT carn_date
              FROM carnival
             WHERE upper(carn_name) = upper('RM Winter Series Caulfield 2025')
        )
    )
 WHERE comp_no = (
        SELECT comp_no
          FROM competitor
         WHERE comp_phone = '0422141112'
    )
   AND event_id = (
    SELECT e.event_id
      FROM event e
      JOIN carnival c
    ON e.carn_date = c.carn_date
     WHERE upper(c.carn_name) = upper('RM Winter Series Caulfield 2025')
       AND upper(e.eventtype_code) = upper('10K')
);

-- Jackson's entry in 10K, join the team
INSERT INTO entry (
    event_id,
    entry_no,
    entry_starttime,
    entry_finishtime,
    entry_elapsedtime,
    comp_no,
    team_id,
    char_id
) VALUES ( (
    SELECT e.event_id
      FROM event e
      JOIN carnival c
    ON e.carn_date = c.carn_date
     WHERE upper(c.carn_name) = upper('RM Winter Series Caulfield 2025')
       AND upper(e.eventtype_code) = upper('10K')
),
           (
               SELECT nvl(
                   max(entry_no),
                   0
               ) + 1
                 FROM entry
                WHERE event_id = (
                   SELECT e.event_id
                     FROM event e
                     JOIN carnival c
                   ON e.carn_date = c.carn_date
                    WHERE upper(c.carn_name) = upper('RM Winter Series Caulfield 2025'
                    )
                      AND upper(e.eventtype_code) = upper('10K')
               )
           ),
           NULL,
           NULL,
           NULL,
           (
               SELECT comp_no
                 FROM competitor
                WHERE comp_phone = '0422412524'
           ),
           (
               SELECT team_id
                 FROM team
                WHERE upper(team_name) = upper('Super Runners')
                  AND carn_date = (
                   SELECT carn_date
                     FROM carnival
                    WHERE upper(carn_name) = upper('RM Winter Series Caulfield 2025')
               )
           ),
           (
               SELECT char_id
                 FROM charity
                WHERE upper(char_name) = upper('RSPCA')
           ) );

COMMIT;

--(c)
-- Delete Jackson's entry from 10K event
DELETE FROM entry
 WHERE comp_no = (
        SELECT comp_no
          FROM competitor
         WHERE comp_phone = '0422412524'
    )
   AND event_id = (
    SELECT e.event_id
      FROM event e
      JOIN carnival c
    ON e.carn_date = c.carn_date
     WHERE upper(c.carn_name) = upper('RM Winter Series Caulfield 2025')
       AND upper(e.eventtype_code) = upper('10K')
);

INSERT INTO entry (
    event_id,
    entry_no,
    entry_starttime,
    entry_finishtime,
    entry_elapsedtime,
    comp_no,
    team_id,
    char_id
) VALUES ( (
    SELECT e.event_id
      FROM event e
      JOIN carnival c
    ON e.carn_date = c.carn_date
     WHERE upper(c.carn_name) = upper('RM Winter Series Caulfield 2025')
       AND upper(e.eventtype_code) = upper('5K')
),
           (
               SELECT nvl(
                   max(entry_no),
                   0
               ) + 1
                 FROM entry
                WHERE event_id = (
                   SELECT e.event_id
                     FROM event e
                     JOIN carnival c
                   ON e.carn_date = c.carn_date
                    WHERE upper(c.carn_name) = upper('RM Winter Series Caulfield 2025'
                    )
                      AND upper(e.eventtype_code) = upper('5K')
               )
           ),
           NULL,
           NULL,
           NULL,
           (
               SELECT comp_no
                 FROM competitor
                WHERE comp_phone = '0422412524'
           ),
           (
               SELECT team_id
                 FROM team
                WHERE upper(team_name) = upper('Super Runners')
                  AND carn_date = (
                   SELECT carn_date
                     FROM carnival
                    WHERE upper(carn_name) = upper('RM Winter Series Caulfield 2025')
               )
           ),
           (
               SELECT char_id
                 FROM charity
                WHERE upper(char_name) = upper('Beyond Blue')
           ) );

COMMIT;

--(d)
-- 1) Jackson runs individually in 5K (remove from team)
UPDATE entry
   SET
    team_id = NULL
 WHERE comp_no = (
        SELECT comp_no
          FROM competitor
         WHERE comp_phone = '0422412524'
    )
   AND event_id = (
    SELECT e.event_id
      FROM event e
      JOIN carnival c
    ON e.carn_date = c.carn_date
     WHERE upper(c.carn_name) = upper('RM Winter Series Caulfield 2025')
       AND upper(e.eventtype_code) = upper('5K')
);

-- 2) Remove Keith from Super Runners team (break foreign key link)
UPDATE entry
   SET
    team_id = NULL
 WHERE comp_no = (
        SELECT comp_no
          FROM competitor
         WHERE comp_phone = '0422141112'
    )
   AND event_id = (
    SELECT e.event_id
      FROM event e
      JOIN carnival c
    ON e.carn_date = c.carn_date
     WHERE upper(c.carn_name) = upper('RM Winter Series Caulfield 2025')
       AND upper(e.eventtype_code) = upper('10K')
);

-- 3) Disband (delete) the Super Runners team
DELETE FROM team
 WHERE upper(team_name) = upper('Super Runners')
   AND carn_date = (
    SELECT carn_date
      FROM carnival
     WHERE upper(carn_name) = upper('RM Winter Series Caulfield 2025')
);

-- 4) Delete Keith’s 10K entry
DELETE FROM entry
 WHERE comp_no = (
        SELECT comp_no
          FROM competitor
         WHERE comp_phone = '0422141112'
    )
   AND event_id = (
    SELECT e.event_id
      FROM event e
      JOIN carnival c
    ON e.carn_date = c.carn_date
     WHERE upper(c.carn_name) = upper('RM Winter Series Caulfield 2025')
       AND upper(e.eventtype_code) = upper('10K')
);

COMMIT;