-- WHERE절에 윈도우 함수로 조건을 걸 때 바로 주지 못하니까 서브쿼리를 써라

SELECT 
      col1
    , col2
    , LEAD(col2) OVER(ORDER BY 1)
  FROM (
    SELECT 1 AS col1, 1 AS col2, 2-2 AS col3 FROM dual
    UNION ALL
    SELECT 1 AS col1, 2 AS col2, 2-2 AS col3 FROM dual
    UNION ALL
    SELECT 1 AS col1, 1 AS col2, 2-2 AS col3 FROM dual
    UNION ALL
    SELECT 1 AS col1, 1 AS col2, 2-2 AS col3 FROM dual
  )
 WHERE col2 <> LEAD(col2) OVER(ORDER BY 1)
; -- ORA-30483: 윈도우 함수를 여기에 사용할 수 없습니다

SELECT 
      *
  FROM(
    SELECT 
          col1
        , col2
        , LEAD(col2) OVER(ORDER BY 1) AS lead_col2 --윈도우 함수에 별칭을 주고
      FROM (
        SELECT 1 AS col1, 1 AS col2, 2-2 AS col3 FROM dual
        UNION ALL
        SELECT 1 AS col1, 2 AS col2, 2-2 AS col3 FROM dual
        UNION ALL
        SELECT 1 AS col1, 1 AS col2, 2-2 AS col3 FROM dual
        UNION ALL
        SELECT 1 AS col1, 1 AS col2, 2-2 AS col3 FROM dual
      )
  )
 WHERE col2 <> lead_col2 --이 별칭을 이용하면 간편하게 조건을 줄 수 있다
; 