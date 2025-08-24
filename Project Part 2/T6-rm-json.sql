/*****PLEASE ENTER YOUR DETAILS BELOW*****/
--T6-rm-json.sql

--Student ID: 33878897
--Student Name: Muhammad Mubashir Shah

/* Comments for your marker:
   - Generates a JSON array of team documents, each containing team metadata and member list.
   - Uses TO_CHAR for date formatting and NVL for null fields.
*/

-- Generate one JSON document per team
SELECT JSON_ARRAYAGG(
    JSON_OBJECT(
        '_id' VALUE t.team_id,
        'carn_name' VALUE c.carn_name,
        'carn_date' VALUE TO_CHAR(t.carn_date, 'DD-Mon-YYYY'),
        'team_name' VALUE t.team_name,
        'team_leader' VALUE JSON_OBJECT(
            'name' VALUE TRIM(ldr.comp_fname || ' ' || ldr.comp_lname),
            'phone' VALUE ldr.comp_phone,
            'email' VALUE ldr.comp_email
        ),
        'team_no_of_members' VALUE COUNT(e_member.entry_no),
        'team_members' VALUE JSON_ARRAYAGG(
            JSON_OBJECT(
                'competitor_name' VALUE TRIM(mbr.comp_fname || ' ' || mbr.comp_lname),
                'competitor_phone' VALUE mbr.comp_phone,
                'event_type' VALUE et.eventtype_desc,
                'entry_no' VALUE e_member.entry_no,
                'starttime' VALUE NVL(TO_CHAR(e_member.entry_starttime, 'HH24:MI:SS'), '-'),
                'finishtime' VALUE NVL(TO_CHAR(e_member.entry_finishtime, 'HH24:MI:SS'), '-'),
                'elapsedtime' VALUE NVL(TO_CHAR(e_member.entry_elapsedtime, 'HH24:MI:SS'), '-')
            ) ORDER BY e_member.entry_no
        ) FORMAT JSON
    ) FORMAT JSON
)
FROM team t
JOIN carnival c ON t.carn_date = c.carn_date
JOIN entry e_ldr ON t.entry_no = e_ldr.entry_no AND t.event_id = e_ldr.event_id
JOIN competitor ldr ON e_ldr.comp_no = ldr.comp_no
LEFT JOIN entry e_member ON t.team_id = e_member.team_id
LEFT JOIN competitor mbr ON e_member.comp_no = mbr.comp_no
LEFT JOIN event ev ON e_member.event_id = ev.event_id
LEFT JOIN eventtype et ON ev.eventtype_code = et.eventtype_code
GROUP BY t.team_id, c.carn_name, t.carn_date, t.team_name, 
         ldr.comp_fname, ldr.comp_lname, ldr.comp_phone, ldr.comp_email
ORDER BY t.team_id;