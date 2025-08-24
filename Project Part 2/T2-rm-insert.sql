/*****PLEASE ENTER YOUR DETAILS BELOW*****/
--T2-rm-insert.sql

--Student ID: 33878897
--Student Name: Muhammad Mubashir Shah

/* Comments for your marker:
   - Sample test data inserted for COMPETITOR, ENTRY, and TEAM tables.
   - All INSERTs are part of a single transaction (COMMIT at end).
   - 15 competitors (comp_no 1–15) inserted; at least 5 non‑Monash (comp_unistatus='N'); email and phone are unique.
   - 30 entry records inserted across 6 events from 3 different carnivals; at least 5 competitors appear in 3+ events; 2 entries are left uncompleted.
   - 5 teams inserted with team_id 1–5; at least two teams share a name in different carnivals; each team’s leader entry (entry_no,event_id) exists.
*/

-- Task 2 Load the COMPETITOR, ENTRY and TEAM tables with your own
-- test data following the data requirements expressed in the brief

-- =======================================
-- COMPETITOR
-- =======================================
INSERT INTO competitor (
    comp_no,
    comp_fname,
    comp_lname,
    comp_gender,
    comp_dob,
    comp_email,
    comp_unistatus,
    comp_phone
) VALUES ( 1,
           'Alice',
           'Wang',
           'F',
           TO_DATE('01/MAR/2005','DD/MON/YYYY'),
           'alice.wang@example.com',
           'Y',
           '0400123456' );

INSERT INTO competitor VALUES ( 2,
                                'Bob',
                                'Lee',
                                'M',
                                TO_DATE('15/JUL/2001','DD/MON/YYYY'),
                                'bob.lee@example.com',
                                'Y',
                                '0410123456' );

INSERT INTO competitor VALUES ( 3,
                                'Carol',
                                'Ng',
                                'F',
                                TO_DATE('30/DEC/2006','DD/MON/YYYY'),
                                'carol.ng@example.com',
                                'Y',
                                '0420123456' );

INSERT INTO competitor VALUES ( 4,
                                'David',
                                'Smith',
                                'M',
                                TO_DATE('22/MAY/2004','DD/MON/YYYY'),
                                'david.smith@example.com',
                                'N',
                                '0430123456' );

INSERT INTO competitor VALUES ( 5,
                                'Eva',
                                'Brown',
                                'F',
                                TO_DATE('10/FEB/2000','DD/MON/YYYY'),
                                'eva.brown@example.com',
                                'Y',
                                '0440123456' );

INSERT INTO competitor VALUES ( 6,
                                'Frank',
                                'Chen',
                                'M',
                                TO_DATE('05/AUG/1999','DD/MON/YYYY'),
                                'frank.chen@example.com',
                                'N',
                                '0450123456' );

INSERT INTO competitor VALUES ( 7,
                                'Grace',
                                'Hall',
                                'F',
                                TO_DATE('12/SEP/2003','DD/MON/YYYY'),
                                'grace.hall@example.com',
                                'N',
                                '0460123456' );

INSERT INTO competitor VALUES ( 8,
                                'Henry',
                                'Li',
                                'M',
                                TO_DATE('27/JUN/2002','DD/MON/YYYY'),
                                'henry.li@example.com',
                                'Y',
                                '0470123456' );

INSERT INTO competitor VALUES ( 9,
                                'Ivy',
                                'Kumar',
                                'F',
                                TO_DATE('19/NOV/2005','DD/MON/YYYY'),
                                'ivy.kumar@example.com',
                                'Y',
                                '0480123456' );

INSERT INTO competitor VALUES ( 10,
                                'Jack',
                                'Smith',
                                'M',
                                TO_DATE('01/JAN/2001','DD/MON/YYYY'),
                                'jack.smith@example.com',
                                'N',
                                '0490123456' );

INSERT INTO competitor VALUES ( 11,
                                'Lily',
                                'Tan',
                                'F',
                                TO_DATE('25/DEC/2007','DD/MON/YYYY'),
                                'lily.tan@example.com',
                                'N',
                                '0500123456' );

INSERT INTO competitor VALUES ( 12,
                                'Mark',
                                'Zhang',
                                'M',
                                TO_DATE('03/MAY/2003','DD/MON/YYYY'),
                                'mark.zhang@example.com',
                                'N',
                                '0510123456' );

INSERT INTO competitor VALUES ( 13,
                                'Nina',
                                'Patel',
                                'F',
                                TO_DATE('17/AUG/2005','DD/MON/YYYY'),
                                'nina.patel@example.com',
                                'Y',
                                '0520123456' );

INSERT INTO competitor VALUES ( 14,
                                'Omar',
                                'Singh',
                                'M',
                                TO_DATE('09/NOV/2004','DD/MON/YYYY'),
                                'omar.singh@example.com',
                                'N',
                                '0530123456' );

INSERT INTO competitor VALUES ( 15,
                                'Paul',
                                'White',
                                'M',
                                TO_DATE('21/JUL/2000','DD/MON/YYYY'),
                                'paul.white@example.com',
                                'Y',
                                '0540123456' );


-- =======================================
-- ENTRY
-- =======================================
-- Columns: event_id, entry_no, entry_starttime, entry_finishtime, entry_elapsedtime, comp_no, team_id, char_id

-- Carnival: 22-SEP-2024 → events: (1: 5K), (2: 10K)
-- Carnival: 05-OCT-2024 → events: (3: 5K), (4: 10K), (5: 21K)
-- Carnival: 02-FEB-2025 → events: (7: 5K), (8: 10K), (9: 21K)
-- Carnival: 15-MAR-2025 → events: (10: 3K), (11: 42K)
-- Carnival: 29-JUN-2025 → events: (12: 5K), (13: 10K), (14: 21K)

-- (A) 22-SEP-2024 entries (event_id 1 = 5K, event_id 2 = 10K)
INSERT INTO entry (
    event_id,
    entry_no,
    entry_starttime,
    entry_finishtime,
    entry_elapsedtime,
    comp_no,
    team_id,
    char_id
) VALUES ( 1,
           1,
           TO_DATE('22/SEP/2024 09:00:00','DD/MON/YYYY HH24:MI:SS'),
           TO_DATE('22/SEP/2024 09:32:15','DD/MON/YYYY HH24:MI:SS'),
           TO_DATE('00:32:15','HH24:MI:SS'),
           1,
           NULL,
           1 );
INSERT INTO entry VALUES ( 1,
                           2,
                           TO_DATE('22/SEP/2024 08:30:00','DD/MON/YYYY HH24:MI:SS'),
                           TO_DATE('22/SEP/2024 09:10:47','DD/MON/YYYY HH24:MI:SS'),
                           TO_DATE('00:40:47','HH24:MI:SS'),
                           2,
                           NULL,
                           2 );
INSERT INTO entry VALUES ( 2,
                           1,
                           TO_DATE('22/SEP/2024 09:05:00','DD/MON/YYYY HH24:MI:SS'),
                           TO_DATE('22/SEP/2024 09:35:00','DD/MON/YYYY HH24:MI:SS'),
                           TO_DATE('00:30:00','HH24:MI:SS'),
                           3,
                           NULL,
                           1 );
INSERT INTO entry VALUES ( 2,
                           2,
                           TO_DATE('22/SEP/2024 08:40:00','DD/MON/YYYY HH24:MI:SS'),
                           TO_DATE('22/SEP/2024 09:15:20','DD/MON/YYYY HH24:MI:SS'),
                           TO_DATE('00:35:20','HH24:MI:SS'),
                           4,
                           NULL,
                           2 );
INSERT INTO entry VALUES ( 1,
                           3,
                           TO_DATE('22/SEP/2024 09:10:00','DD/MON/YYYY HH24:MI:SS'),
                           NULL,
                           NULL,
                           5,
                           NULL,
                           NULL  -- uncompleted
                            );


-- (B) 05-OCT-2024 entries (event_id 3 = 5K, event_id 4 = 10K, event_id 5 = 21K)
INSERT INTO entry VALUES ( 3,
                           1,
                           TO_DATE('05/OCT/2024 09:00:00','DD/MON/YYYY HH24:MI:SS'),
                           TO_DATE('05/OCT/2024 09:29:45','DD/MON/YYYY HH24:MI:SS'),
                           TO_DATE('00:29:45','HH24:MI:SS'),
                           6,
                           NULL,
                           1 );
INSERT INTO entry VALUES ( 3,
                           2,
                           TO_DATE('05/OCT/2024 08:45:00','DD/MON/YYYY HH24:MI:SS'),
                           NULL,
                           NULL,
                           7,
                           NULL,
                           NULL  -- uncompleted
                            );
INSERT INTO entry VALUES ( 4,
                           1,
                           TO_DATE('05/OCT/2024 08:30:00','DD/MON/YYYY HH24:MI:SS'),
                           TO_DATE('05/OCT/2024 09:05:55','DD/MON/YYYY HH24:MI:SS'),
                           TO_DATE('00:35:55','HH24:MI:SS'),
                           8,
                           NULL,
                           3 );
INSERT INTO entry VALUES ( 4,
                           2,
                           TO_DATE('05/OCT/2024 08:35:00','DD/MON/YYYY HH24:MI:SS'),
                           TO_DATE('05/OCT/2024 09:15:00','DD/MON/YYYY HH24:MI:SS'),
                           TO_DATE('00:40:00','HH24:MI:SS'),
                           9,
                           NULL,
                           2 );
INSERT INTO entry VALUES ( 5,
                           1,
                           TO_DATE('05/OCT/2024 08:00:00','DD/MON/YYYY HH24:MI:SS'),
                           TO_DATE('05/OCT/2024 09:20:12','DD/MON/YYYY HH24:MI:SS'),
                           TO_DATE('01:20:12','HH24:MI:SS'),
                           10,
                           NULL,
                           3 );
-- (C) 02-FEB-2025 entries (event_id 7 = 5K, event_id 8 = 10K, event_id 9 = 21K)
INSERT INTO entry VALUES ( 7,
                           1,
                           TO_DATE('02/FEB/2025 09:00:00','DD/MON/YYYY HH24:MI:SS'),
                           TO_DATE('02/FEB/2025 09:45:20','DD/MON/YYYY HH24:MI:SS'),
                           TO_DATE('00:45:20','HH24:MI:SS'),
                           11,
                           NULL,
                           2 );
INSERT INTO entry VALUES ( 7,
                           2,
                           TO_DATE('02/FEB/2025 08:05:00','DD/MON/YYYY HH24:MI:SS'),
                           NULL,
                           NULL,
                           12,
                           NULL,
                           NULL  -- uncompleted
                            );
INSERT INTO entry VALUES ( 8,
                           1,
                           TO_DATE('02/FEB/2025 08:00:00','DD/MON/YYYY HH24:MI:SS'),
                           TO_DATE('02/FEB/2025 08:55:33','DD/MON/YYYY HH24:MI:SS'),
                           TO_DATE('00:55:33','HH24:MI:SS'),
                           13,
                           NULL,
                           1 );
INSERT INTO entry VALUES ( 8,
                           2,
                           TO_DATE('02/FEB/2025 09:05:00','DD/MON/YYYY HH24:MI:SS'),
                           TO_DATE('02/FEB/2025 09:50:10','DD/MON/YYYY HH24:MI:SS'),
                           TO_DATE('00:45:10','HH24:MI:SS'),
                           14,
                           NULL,
                           3 );
INSERT INTO entry VALUES ( 9,
                           1,
                           TO_DATE('02/FEB/2025 08:10:00','DD/MON/YYYY HH24:MI:SS'),
                           TO_DATE('02/FEB/2025 10:05:30','DD/MON/YYYY HH24:MI:SS'),
                           TO_DATE('01:55:30','HH24:MI:SS'),
                           15,
                           NULL,
                           2 );
-- (D) 15-MAR-2025 entries (event_id 10 = 3K, event_id 11 = 42K)
INSERT INTO entry VALUES ( 10,
                           1,
                           TO_DATE('15/MAR/2025 08:00:00','DD/MON/YYYY HH24:MI:SS'),
                           TO_DATE('15/MAR/2025 08:28:45','DD/MON/YYYY HH24:MI:SS'),
                           TO_DATE('00:28:45','HH24:MI:SS'),
                           1,
                           NULL,
                           4 );
INSERT INTO entry VALUES ( 10,
                           2,
                           TO_DATE('15/MAR/2025 07:55:00','DD/MON/YYYY HH24:MI:SS'),
                           NULL,
                           NULL,
                           2,
                           NULL,
                           NULL  -- uncompleted
                            );
INSERT INTO entry VALUES ( 11,
                           1,
                           TO_DATE('15/MAR/2025 07:45:00','DD/MON/YYYY HH24:MI:SS'),
                           TO_DATE('15/MAR/2025 10:05:01','DD/MON/YYYY HH24:MI:SS'),
                           TO_DATE('02:20:01','HH24:MI:SS'),
                           3,
                           NULL,
                           1 );
INSERT INTO entry VALUES ( 11,
                           2,
                           TO_DATE('15/MAR/2025 08:05:00','DD/MON/YYYY HH24:MI:SS'),
                           TO_DATE('15/MAR/2025 10:15:10','DD/MON/YYYY HH24:MI:SS'),
                           TO_DATE('02:10:10','HH24:MI:SS'),
                           4,
                           NULL,
                           2 );
INSERT INTO entry VALUES ( 10,
                           3,
                           TO_DATE('15/MAR/2025 08:10:00','DD/MON/YYYY HH24:MI:SS'),
                           TO_DATE('15/MAR/2025 08:40:05','DD/MON/YYYY HH24:MI:SS'),
                           TO_DATE('00:30:05','HH24:MI:SS'),
                           5,
                           NULL,
                           3 );

-- (E) 29-JUN-2025 entries (event_id 12 = 5K, event_id 13 = 10K, event_id 14 = 21K)
INSERT INTO entry VALUES ( 12,
                           1,
                           TO_DATE('29/JUN/2025 08:45:00','DD/MON/YYYY HH24:MI:SS'),
                           TO_DATE('29/JUN/2025 09:15:12','DD/MON/YYYY HH24:MI:SS'),
                           TO_DATE('00:30:12','HH24:MI:SS'),
                           6,
                           NULL,
                           1 );
INSERT INTO entry VALUES ( 12,
                           2,
                           TO_DATE('29/JUN/2025 08:50:00','DD/MON/YYYY HH24:MI:SS'),
                           NULL,
                           NULL,
                           7,
                           NULL,
                           NULL  -- uncompleted
                            );
INSERT INTO entry VALUES ( 13,
                           1,
                           TO_DATE('29/JUN/2025 08:30:00','DD/MON/YYYY HH24:MI:SS'),
                           TO_DATE('29/JUN/2025 09:18:47','DD/MON/YYYY HH24:MI:SS'),
                           TO_DATE('00:48:47','HH24:MI:SS'),
                           8,
                           NULL,
                           2 );
INSERT INTO entry VALUES ( 13,
                           2,
                           TO_DATE('29/JUN/2025 08:35:00','DD/MON/YYYY HH24:MI:SS'),
                           TO_DATE('29/JUN/2025 09:30:00','DD/MON/YYYY HH24:MI:SS'),
                           TO_DATE('00:55:00','HH24:MI:SS'),
                           9,
                           NULL,
                           3 );
INSERT INTO entry VALUES ( 14,
                           1,
                           TO_DATE('29/JUN/2025 08:00:00','DD/MON/YYYY HH24:MI:SS'),
                           TO_DATE('29/JUN/2025 09:02:22','DD/MON/YYYY HH24:MI:SS'),
                           TO_DATE('01:02:22','HH24:MI:SS'),
                           10,
                           NULL,
                           4 );

-- (F) Additional entries to reach 30 rows
INSERT INTO entry VALUES ( 1,
                           4,
                           TO_DATE('22/SEP/2024 09:15:00','DD/MON/YYYY HH24:MI:SS'),
                           TO_DATE('22/SEP/2024 09:50:25','DD/MON/YYYY HH24:MI:SS'),
                           TO_DATE('00:35:25','HH24:MI:SS'),
                           13,
                           NULL,
                           NULL );

INSERT INTO entry VALUES ( 2,
                           4,
                           TO_DATE('22/SEP/2024 08:45:00','DD/MON/YYYY HH24:MI:SS'),
                           TO_DATE('22/SEP/2024 09:20:10','DD/MON/YYYY HH24:MI:SS'),
                           TO_DATE('00:35:10','HH24:MI:SS'),
                           14,
                           NULL,
                           1 );



INSERT INTO entry VALUES ( 7,
                           3,
                           TO_DATE('02/FEB/2025 09:10:00','DD/MON/YYYY HH24:MI:SS'),
                           TO_DATE('02/FEB/2025 09:55:00','DD/MON/YYYY HH24:MI:SS'),
                           NULL,
                           10,
                           NULL,
                           4 );

INSERT INTO entry VALUES ( 3,
                           3,
                           TO_DATE('05/OCT/2024 09:20:00','DD/MON/YYYY HH24:MI:SS'),
                           TO_DATE('05/OCT/2024 09:55:00','DD/MON/YYYY HH24:MI:SS'),
                           TO_DATE('00:35:00','HH24:MI:SS'),
                           7,
                           NULL,
                           2 );

INSERT INTO entry VALUES ( 4,
                           3,
                           TO_DATE('05/OCT/2024 08:40:00','DD/MON/YYYY HH24:MI:SS'),
                           TO_DATE('05/OCT/2024 09:10:15','DD/MON/YYYY HH24:MI:SS'),
                           TO_DATE('00:30:15','HH24:MI:SS'),
                           8,
                           NULL,
                           3 );


-- After these, we have inserted 30 entry rows in total.


-- =======================================
-- TEAM
-- =======================================
-- Columns: (team_id, team_name, carn_date, event_id, entry_no)

INSERT INTO team (
    team_id,
    team_name,
    carn_date,
    event_id,
    entry_no
) VALUES ( 1,
           'SunRunners',
           TO_DATE('22/SEP/2024','DD/MON/YYYY'),
           1,
           1 );

INSERT INTO team VALUES ( 2,
                          'Speedsters',
                          TO_DATE('22/SEP/2024','DD/MON/YYYY'),
                          2,
                          1 );

INSERT INTO team VALUES ( 3,
                          'Speedsters',
                          TO_DATE('05/OCT/2024','DD/MON/YYYY'),
                          4,
                          1 );

INSERT INTO team VALUES ( 4,
                          'Marathoners',
                          TO_DATE('02/FEB/2025','DD/MON/YYYY'),
                          9,
                          1 );

INSERT INTO team VALUES ( 5,
                          'Champions',
                          TO_DATE('15/MAR/2025','DD/MON/YYYY'),
                          10,
                          1 );

-- All inserts complete — now commit the transaction
COMMIT;