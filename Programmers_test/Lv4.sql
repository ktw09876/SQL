--Lv4 Ư�� �Ⱓ���� �뿩 ������ �ڵ������� �뿩��� ���ϱ�
SELECT DISTINCT
    C.car_id,
    C.car_type,
    (C.daily_fee * 30) - (C.daily_fee * 30 * discount_rate/100) AS fee -- �뿩�ݾ�
  FROM (
    SELECT A.*
      FROM car_rental_company_car A, car_rental_company_rental_history B
     WHERE
            A.car_id = B.car_id
        AND A.car_type IN('����', 'SUV')
        AND A.car_id NOT IN(
            SELECT car_id
              FROM car_rental_company_rental_history
             WHERE --��¥����
                   to_char(start_date, 'YYYY-MM') <= '2022-11' 
               AND to_char(end_date, 'YYYY-MM') >= '2022-11'
        )
) C, car_rental_company_discount_plan D
 WHERE
        C.car_type = D.car_type
    AND D.duration_type = '30�� �̻�'
    AND (C.daily_fee * 30) - (C.daily_fee * 30 * discount_rate/100) BETWEEN 500000 AND 1999999 --�뿩�ݾ� ����
ORDER BY fee DESC, C.car_type, C.car_id DESC
;

-- Lv4 �ڵ��� �뿩 ��� �� �뿩 �ݾ� ���ϱ�
SELECT 
    B.history_id
    , round(A.daily_fee * ((100 - nvl(C.discount_rate, 0))/100) * (B.end_date - B.start_date+1), 0) AS fee
  FROM 
    car_rental_company_car A 
    INNER JOIN car_rental_company_rental_history B ON A.car_id = B.car_id
    LEFT OUTER JOIN car_rental_company_discount_plan C ON A.car_type = C.car_type
    AND CASE -- ON ���� CASE���� ����� �� �ִ���
        WHEN B.end_date - B.start_date+1 >= 90 THEN '90�� �̻�'
        WHEN B.end_date - B.start_date+1 >= 30 THEN '30�� �̻�'
        WHEN B.end_date - B.start_date+1 >= 7 THEN '7�� �̻�'
        ELSE NULL
     END = C.duration_type
 WHERE
    A.car_type = 'Ʈ��'
ORDER BY
    2 DESC, 1 DESC
;


