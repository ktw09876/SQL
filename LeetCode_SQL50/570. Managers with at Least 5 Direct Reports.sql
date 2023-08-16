--570. Managers with at Least 5 Direct Reports
-- �׽�Ʈ case �� �Ϻΰ� ���� ���� ���
 SELECT NAME
   FROM employee
  WHERE ID = (
     SELECT managerid
       FROM (
         SELECT
             managerid, COUNT(*)
           FROM employee
         GROUP BY managerid
         HAVING COUNT(*) >= 5
       )
  )

-- ��� ����� ���
SELECT e1.name
  FROM
    employee e1
    INNER JOIN (
        SELECT managerid
          FROM employee
        GROUP BY managerid
        HAVING COUNT(managerid) >= 5
    ) e2 ON e1.ID = e2.managerid
    
-- � ���̰� �ִ°��� �𸣰���..

