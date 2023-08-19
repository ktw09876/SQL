-- 1633. Percentage of Users Attended a Contest
-- select���� ���������� ����ϴ� ���
SELECT 
      rg.contest_id
    , round(COUNT(us.user_id) / (SELECT COUNT(*) FROM  USERS) * 100, 2) AS percentage 
  FROM 
    USERS us
    INNER JOIN REGISTER rg ON us.user_id = rg.user_id
GROUP BY rg.contest_id
ORDER BY 2 DESC, 1