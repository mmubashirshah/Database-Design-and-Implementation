--*****PLEASE ENTER YOUR DETAILS BELOW*****
--T5-rm-plsql.sql

--Student ID: 33878897
--Student Name: Muhammad Mubashir Shah

/* Comments for your marker:

   - Function calc_elapsed_time returns a DATE representing hh24:mi:ss elapsed between two DATEs.
   - Trigger trg_entry_elapsed populates entry_elapsedtime automatically whenever a finish time is provided.
   - Procedure prc_entry_registration handles single competitor registration with team creation or joining and charity assignment.

*/


--(a)
-- Write your create function statemet,
-- finish it with a slash(/) followed by a blank line

-- Function to calculate elapsed time between start and finish
CREATE OR REPLACE FUNCTION calc_elapsed_time (
    p_start_time  IN DATE,
    p_finish_time IN DATE
) RETURN DATE IS
BEGIN
    RETURN TO_DATE ( '00:00:00','HH24:MI:SS' ) + ( p_finish_time - p_start_time );
END calc_elapsed_time;
/

-- Test Harness for (a)
DECLARE
    v_start   DATE := TO_DATE ( '01/JAN/2025 08:00:00','DD/MON/YYYY HH24:MI:SS' );
    v_finish  DATE := TO_DATE ( '01/JAN/2025 09:15:30','DD/MON/YYYY HH24:MI:SS' );
    v_elapsed DATE;
BEGIN
    v_elapsed := calc_elapsed_time(
        v_start,
        v_finish
    );
    dbms_output.put_line('Elapsed: ' || to_char(
        v_elapsed,
        'HH24:MI:SS'
    ));
END;
/



--(b)
-- Write your create trigger statement,
-- finish it with a slash(/) followed by a blank line

-- Trigger to auto-calculate elapsed time on entry insert or update
CREATE OR REPLACE TRIGGER trg_entry_elapsed BEFORE
    INSERT OR UPDATE OF entry_finishtime ON entry
    FOR EACH ROW
BEGIN
    IF
        :new.entry_finishtime IS NOT NULL
        AND :new.entry_starttime IS NOT NULL
    THEN
        :new.entry_elapsedtime := calc_elapsed_time(
            :new.entry_starttime,
            :new.entry_finishtime
        );
    END IF;
END trg_entry_elapsed;
/

-- Test Harness for (b)
-- Insert a test entry to verify trigger
INSERT INTO entry (
    event_id,
    entry_no,
    entry_starttime,
    entry_finishtime,
    comp_no
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
           TO_DATE('29/JUN/2025 10:00:00','DD/MON/YYYY HH24:MI:SS'),
           TO_DATE('29/JUN/2025 10:45:15','DD/MON/YYYY HH24:MI:SS'),
           (
               SELECT comp_no
                 FROM competitor
                WHERE comp_phone = '0422412524'
           ) );
-- Verify elapsed is set by trigger
SELECT to_char(
    entry_elapsedtime,
    'HH24:MI:SS'
) AS elapsed
  FROM entry
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

--(c)
-- Write your create procedure statement,
-- finish it with a slash(/) followed by a blank line

-- Procedure for registering an entry
CREATE OR REPLACE PROCEDURE prc_entry_registration (
    p_comp_no       IN competitor.comp_no%TYPE,
    p_carnival_name IN carnival.carn_name%TYPE,
    p_event_desc    IN eventtype.eventtype_desc%TYPE,
    p_team_name     IN team.team_name%TYPE,
    p_char_name     IN charity.char_name%TYPE,
    p_entry_no      OUT entry.entry_no%TYPE
) IS
    v_carn_date DATE;
    v_event_id  NUMBER;
    v_char_id   NUMBER;
    v_team_id   NUMBER;
    v_exists    NUMBER;
BEGIN
    -- Find carnival date
    SELECT carn_date
      INTO v_carn_date
      FROM carnival
     WHERE upper(carn_name) = upper(p_carnival_name);

    -- Find event_id by description
    SELECT e.event_id
      INTO v_event_id
      FROM event e
      JOIN eventtype t
    ON e.eventtype_code = t.eventtype_code
     WHERE upper(t.eventtype_desc) = upper(p_event_desc)
       AND e.carn_date = v_carn_date;

    -- Find charity_id
    SELECT char_id
      INTO v_char_id
      FROM charity
     WHERE upper(char_name) = upper(p_char_name);

    -- Check team existence
    SELECT COUNT(*)
      INTO v_exists
      FROM team
     WHERE upper(team_name) = upper(p_team_name)
       AND carn_date = v_carn_date;

    IF v_exists = 0 THEN
        -- New team: register entry
        SELECT nvl(
            max(entry_no),
            0
        ) + 1
          INTO p_entry_no
          FROM entry
         WHERE event_id = v_event_id;

        INSERT INTO entry (
            event_id,
            entry_no,
            comp_no,
            char_id
        ) VALUES ( v_event_id,
                   p_entry_no,
                   p_comp_no,
                   v_char_id );

        -- Create and assign new team
        v_team_id := team_seq.nextval;
        INSERT INTO team (
            team_id,
            team_name,
            carn_date,
            event_id,
            entry_no
        ) VALUES ( v_team_id,
                   p_team_name,
                   v_carn_date,
                   v_event_id,
                   p_entry_no );

        UPDATE entry
           SET
            team_id = v_team_id
         WHERE event_id = v_event_id
           AND entry_no = p_entry_no;
    ELSE
        -- Existing team: join
        SELECT team_id
          INTO v_team_id
          FROM team
         WHERE upper(team_name) = upper(p_team_name)
           AND carn_date = v_carn_date;

        SELECT nvl(
            max(entry_no),
            0
        ) + 1
          INTO p_entry_no
          FROM entry
         WHERE event_id = v_event_id;

        INSERT INTO entry (
            event_id,
            entry_no,
            comp_no,
            team_id,
            char_id
        ) VALUES ( v_event_id,
                   p_entry_no,
                   p_comp_no,
                   v_team_id,
                   v_char_id );
    END IF;

    COMMIT;
    dbms_output.put_line('Registered entry number: ' || p_entry_no);
EXCEPTION
    WHEN no_data_found THEN
        raise_application_error(
            -20001,
            'Invalid carnival, event, or charity'
        );
END prc_entry_registration;
/

-- Test Harness for (c)
DECLARE
    v_new_entry entry.entry_no%TYPE;
    v_comp_no   competitor.comp_no%TYPE;
BEGIN
    SELECT comp_no
      INTO v_comp_no
      FROM competitor
     WHERE comp_phone = '0422141112';

    prc_entry_registration(
        p_comp_no       => v_comp_no,
        p_carnival_name => 'RM Winter Series Caulfield 2025',
        p_event_desc    => '5 Km Run',
        p_team_name     => 'Test Team',
        p_char_name     => 'Amnesty International',
        p_entry_no      => v_new_entry
    );

    dbms_output.put_line('New entry: ' || v_new_entry);
END;
/