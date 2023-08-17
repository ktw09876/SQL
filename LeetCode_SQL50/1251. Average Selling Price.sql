-- 1251. Average Selling Price
SELECT 
      pr.product_id
    , round(SUM(pr.price * un.units) / SUM(un.units), 2) AS average_price -- �� �����Լ����� ���굵 �����ϴ���
  FROM 
    prices pr
    INNER JOIN unitssold un ON pr.product_id = un.product_id
WHERE
    un.purchase_date BETWEEN pr.start_date AND pr.end_date
GROUP BY pr.product_id
;