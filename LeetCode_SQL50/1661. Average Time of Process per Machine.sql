--1661. Average Time of Process per Machine
SELECT 
      machine_id 
    , round(AVG(lead_time-TIMESTAMP), 3) AS processing_time 
  FROM (
    SELECT A.*
        , lead_time - TIMESTAMP 
      FROM (
        SELECT A.*
            , LEAD(TIMESTAMP) OVER(PARTITION BY machine_id, process_id ORDER BY TIMESTAMP) AS lead_time
        FROM activity A
      ) A
     WHERE
        lead_time IS NOT NULL
  ) A
GROUP BY machine_id
;