--570. Managers with at Least 5 Direct Reports
-- 테스트 case 중 일부가 에러 나는 경우
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

-- 모두 통과한 경우
SELECT e1.name
  FROM
    employee e1
    INNER JOIN (
        SELECT managerid
          FROM employee
        GROUP BY managerid
        HAVING COUNT(managerid) >= 5
    ) e2 ON e1.ID = e2.managerid
    
-- 어떤 차이가 있는건지 모르겠음..

