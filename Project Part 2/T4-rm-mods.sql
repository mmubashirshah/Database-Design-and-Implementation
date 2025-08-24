--****PLEASE ENTER YOUR DETAILS BELOW****
--T4-rm-mods.sql

--Student ID: 33878897
--Student Name: Muhammad Mubashir Shah

/* Comments for your marker:

Assumptions:
- A completed event is defined as an entry with a non-NULL entry_finishtime.
- The carnival is identified by carn_date (DATE), not carnival_id.
- comp_no is the correct FK to link competitor to entry.
- We allow multiple charities per competitor per carnival via new table.

*/

--(a)
-- Drop the column if it exists
ALTER TABLE competitor DROP COLUMN comp_completed_events;

-- Then re-add and populate
ALTER TABLE competitor ADD comp_completed_events NUMBER(3) DEFAULT 0;

COMMENT ON COLUMN competitor.comp_completed_events IS
    'Number of events completed by this competitor (entry_finishtime not null)';

-- Recalculate and populate
UPDATE competitor c
   SET
    comp_completed_events = (
        SELECT COUNT(*)
          FROM entry e
         WHERE e.comp_no = c.comp_no
           AND e.entry_finishtime IS NOT NULL
    );

-- (b) 
-- Drop table if it already exists
DROP TABLE competitor_charity CASCADE CONSTRAINTS PURGE;

-- Create new table to handle charity percentages per competitor and carnival
CREATE TABLE competitor_charity (
    comp_no    NUMBER(5) NOT NULL,
    carn_date  DATE NOT NULL,
    char_id    NUMBER(5) NOT NULL,
    percentage NUMBER(3,0) NOT NULL,
    CONSTRAINT competitor_charity_pk PRIMARY KEY ( comp_no,
                                                   carn_date,
                                                   char_id ),
    CONSTRAINT competitor_charity_fk1 FOREIGN KEY ( comp_no )
        REFERENCES competitor ( comp_no ),
    CONSTRAINT competitor_charity_fk2 FOREIGN KEY ( carn_date )
        REFERENCES carnival ( carn_date ),
    CONSTRAINT competitor_charity_fk3 FOREIGN KEY ( char_id )
        REFERENCES charity ( char_id ),
    CONSTRAINT competitor_charity_pct_chk CHECK ( percentage BETWEEN 0 AND 100 )
);

COMMENT ON COLUMN competitor_charity.comp_no IS
    'Competitor number (FK to competitor)';
COMMENT ON COLUMN competitor_charity.carn_date IS
    'Date of the carnival (FK to carnival)';
COMMENT ON COLUMN competitor_charity.char_id IS
    'Charity ID (FK to charity)';
COMMENT ON COLUMN competitor_charity.percentage IS
    'Percentage of funds donated to this charity by this competitor';

-- Insert for RSPCA (70%) with duplicate check
INSERT INTO competitor_charity (
    comp_no,
    carn_date,
    char_id,
    percentage
)
    SELECT *
      FROM (
        SELECT (
            SELECT comp_no
              FROM competitor
             WHERE comp_fname = 'Jackson'
               AND comp_lname = 'Bull'
        ),
               (
                   SELECT carn_date
                     FROM carnival
                    WHERE carn_name = 'RM Winter Series Caulfield 2025'
               ),
               (
                   SELECT char_id
                     FROM charity
                    WHERE char_name = 'RSPCA'
               ),
               70
          FROM dual
    )
     WHERE NOT EXISTS (
        SELECT 1
          FROM competitor_charity
         WHERE comp_no = (
                SELECT comp_no
                  FROM competitor
                 WHERE comp_fname = 'Jackson'
                   AND comp_lname = 'Bull'
            )
           AND carn_date = (
            SELECT carn_date
              FROM carnival
             WHERE carn_name = 'RM Winter Series Caulfield 2025'
        )
           AND char_id = (
            SELECT char_id
              FROM charity
             WHERE char_name = 'RSPCA'
        )
    );

-- Insert for Beyond Blue (30%) with duplicate check
INSERT INTO competitor_charity (
    comp_no,
    carn_date,
    char_id,
    percentage
)
    SELECT *
      FROM (
        SELECT (
            SELECT comp_no
              FROM competitor
             WHERE comp_fname = 'Jackson'
               AND comp_lname = 'Bull'
        ),
               (
                   SELECT carn_date
                     FROM carnival
                    WHERE carn_name = 'RM Winter Series Caulfield 2025'
               ),
               (
                   SELECT char_id
                     FROM charity
                    WHERE char_name = 'Beyond Blue'
               ),
               30
          FROM dual
    )
     WHERE NOT EXISTS (
        SELECT 1
          FROM competitor_charity
         WHERE comp_no = (
                SELECT comp_no
                  FROM competitor
                 WHERE comp_fname = 'Jackson'
                   AND comp_lname = 'Bull'
            )
           AND carn_date = (
            SELECT carn_date
              FROM carnival
             WHERE carn_name = 'RM Winter Series Caulfield 2025'
        )
           AND char_id = (
            SELECT char_id
              FROM charity
             WHERE char_name = 'Beyond Blue'
        )
    );

-- View results
SELECT *
  FROM competitor_charity
 ORDER BY comp_no,
          carn_date;

COMMIT;