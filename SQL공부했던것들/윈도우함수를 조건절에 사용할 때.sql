-- WHERE���� ������ �Լ��� ������ �� �� �ٷ� ���� ���ϴϱ� ���������� ���

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
; -- ORA-30483: ������ �Լ��� ���⿡ ����� �� �����ϴ�

SELECT 
      *
  FROM(
    SELECT 
          col1
        , col2
        , LEAD(col2) OVER(ORDER BY 1) AS lead_col2 --������ �Լ��� ��Ī�� �ְ�
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
 WHERE col2 <> lead_col2 --�� ��Ī�� �̿��ϸ� �����ϰ� ������ �� �� �ִ�
; 