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

-- Lv4 ��������/�¶��� �Ǹ� ������ �����ϱ�
SELECT 
      to_char(sales_date, 'YYYY-MM-DD') AS sales_date
    , product_id
    , user_id
    , sales_amount
  FROM (
SELECT
      sales_date
    , product_id
    , user_id
    , sales_amount
  FROM online_sale 
UNION ALL
SELECT
      sales_date
    , product_id
    , NULL AS user_id
    , sales_amount
  FROM offline_sale  
)
 WHERE
    to_char(sales_date, 'YYYY-MM') = '2022-03'
ORDER BY 1, 2, 3
;

-- Lv4 ��, ��, ���� �� ��ǰ ���� ȸ�� �� ���ϱ�
-- GROUP BY ���
SELECT
      to_char(B.sales_date, 'YYYY') AS YEAR
    , TO_NUMBER(to_char(B.sales_date, 'fmMM')) AS MONTH -- '01, 02'�� ���� ���°� �ƴ� '1, 2'�� ���� ���·� ���
    , A.gender
    , COUNT(DISTINCT B.user_id) AS USERS
  FROM 
    user_info A
    INNER JOIN online_sale B ON A.user_id = B.user_id
 WHERE
    A.gender IS NOT NULL
GROUP BY
      to_char(B.sales_date, 'YYYY')
    , TO_NUMBER(to_char(B.sales_date, 'fmMM')) --  ������ ���ؼ� �ٽ� �������·� ��ȯ
    , A.gender
ORDER BY 
    1, 2, 3
;

-- ���� ���� GROUP BY �̻��
SELECT DISTINCT
      YEAR
    , MONTH
    , T.gender
    , COUNT(1) OVER(PARTITION BY T.YEAR,T.MONTH, T.gender) AS USERS 
  FROM (
    SELECT DISTINCT 
          A.gender
        , A.user_id
        , to_char(B.sales_date, 'YYYY') AS YEAR
        , TO_NUMBER(to_char(B.sales_date, 'fmMM')) AS MONTH
      FROM 
        user_info A
        INNER JOIN online_sale B ON A.user_id = B.user_id 
     WHERE A.gender IS NOT NULL
  ) T
ORDER BY YEAR ASC, MONTH ASC, gender ASC
;


--Lv4 �׷캰 ���ǿ� �´� �Ĵ� ��� ����ϱ�
SELECT 
      MEMBER_NAME
    , review_text
    , to_char(review_date, 'YYYY-MM-DD') AS review_date
  FROM (
    SELECT
        COUNT(1) OVER(PARTITION BY mp.member_id) AS id_cnt -- COUNT(MP.MEMBER_ID)�� ��� WHERE���� ��� �Ұ�
      , mp.MEMBER_NAME
      , rr.*
      FROM 
        member_profile mp
        INNER JOIN rest_review rr ON mp.member_id = rr.member_id
)
 WHERE id_cnt = ( --COUNT(MEMBER_ID)�� ���� ���� �ۼ��� ���� COUNT�� ���� ���
    SELECT 
        MAX(id_cnt) --���� ���� �ۼ��� ���� COUNT
      FROM (
        SELECT
              member_id
            , COUNT(member_id) AS id_cnt -- COUNT(1) OVER(PARTITION BY MEMBER_ID) ��� ����� �� ������ ������������ ������ �� �� �� �ϰԵǴ� PARTITION BY�� ���ϴ°� ������ ���� ���ɺ� �غ��� �ʹ�
            -- , COUNT(1) OVER(PARTITION BY MEMBER_ID) AS ID_CNT              
          FROM rest_review
        GROUP BY member_id
    )
)
ORDER BY
    3, 2
;


--Lv4 ���￡ ��ġ�� �Ĵ� ��� ����ϱ�
SELECT
      RI.rest_id
    , RI.rest_name
    , RI.food_type
    , RI.favorites
    , RI.address
    , round(AVG(review_score), 2) AS score
  FROM 
    rest_info RI
    INNER JOIN rest_review rr ON RI.rest_id = rr.rest_id
 WHERE
    RI.address LIKE '����%'
GROUP BY
      RI.rest_id
    , RI.rest_name
    , RI.food_type
    , RI.favorites
    , RI.address
ORDER BY
    score DESC, RI.favorites DESC
;


--Lv4 5�� ��ǰ���� �Ѹ��� ��ȸ�ϱ�
SELECT
      fp.product_id
    , fp.product_name
    , SUM(fp.price * fo.amount) AS total_sales
  FROM 
    food_product fp
    INNER JOIN food_order fo ON fp.product_id = fo.product_id
 WHERE
    to_char(fo.produce_date, 'MM') = '05'
GROUP BY
      fp.product_id
    , fp.product_name
ORDER BY
    total_sales DESC, fp.product_id
;

--���� ���� WITH�� ���
WITH ����ǰ�� AS(
    SELECT 
          product_id
        , SUM(amount) AS amount
      FROM food_order
     WHERE to_char(produce_date,'YYYY-MM') = '2022-05'
    GROUP BY product_id
)
SELECT A.product_id, B.product_name, A.amount*B.price AS total_sales
  FROM 
    ����ǰ�� A
    INNER JOIN food_product B ON A.product_id = B.product_id
ORDER BY A.amount*B.price DESC, product_id
;


--Lv4 ��ǰ�з��� ���� ��� ��ǰ�� ���� ��ȸ�ϱ�
SELECT 
      category
    , price	 AS max_price
    , product_name
  FROM food_product
 WHERE (category, price) IN(
    SELECT category, MAX(price)
        FROM food_product
    GROUP BY category
)
   AND
    category IN('����', '��', '��ġ', '�Ŀ���')
ORDER BY 2 DESC
;


