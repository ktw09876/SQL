/*
1164. Product Price at a Given Date
rk=1 ������ on���� ������ where���� �������� ���� �޶����� ���
����Ŭ ������� Ȯ��
from - on - join - where - group by - having - select - order by
*/
SELECT DISTINCT
      p1.product_id
    , NVL(p2.new_price,10) AS price 
  FROM 
    products p1 
    LEFT JOIN (
       SELECT  
             product_id
           , new_price
           , change_date
           , DENSE_RANK() OVER (PARTITION BY product_id ORDER BY change_date DESC ) AS rk
         FROM products
        WHERE change_date<=TO_DATE('2019-08-16','yyyy-mm-dd')
  )p2  ON p1.product_id=p2.product_id AND rk=1 
--  where
--     rk=1 

-- rk = 1�� ����� ���͸� �� ���̺��� left join ����� �̷��� ���� ��
SELECT DISTINCT
      p1.product_id
    , NVL(p2.new_price,10) AS price 
  FROM 
    products p1 
    LEFT JOIN (
      SELECT *
        FROM (
            SELECT  
                  product_id
                , new_price
                , change_date
                , DENSE_RANK() OVER (PARTITION BY product_id ORDER BY change_date DESC ) AS rk
              FROM products
             WHERE change_date<=TO_DATE('2019-08-16','yyyy-mm-dd')
        )
       WHERE
          rk=1
  )p2  ON p1.product_id=p2.product_id
