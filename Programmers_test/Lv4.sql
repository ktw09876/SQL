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
      TO_CHAR(SALES_DATE, 'YYYY-MM-DD') AS sales_date
    , PRODUCT_ID
    , USER_ID
    , SALES_AMOUNT
  FROM (
SELECT
      SALES_DATE
    , PRODUCT_ID
    , USER_ID
    , SALES_AMOUNT
  FROM ONLINE_SALE 
UNION ALL
SELECT
      SALES_DATE
    , PRODUCT_ID
    , NULL AS USER_ID
    , SALES_AMOUNT
  FROM OFFLINE_SALE  
)
 WHERE
    TO_CHAR(sales_date, 'YYYY-MM') = '2022-03'
ORDER BY 1, 2, 3
;

-- Lv4 ��, ��, ���� �� ��ǰ ���� ȸ�� �� ���ϱ�
-- GROUP BY ���
SELECT
      TO_CHAR(B.SALES_DATE, 'YYYY') AS YEAR
    , TO_NUMBER(TO_CHAR(B.SALES_DATE, 'fmMM')) AS MONTH -- '01, 02'�� ���� ���°� �ƴ� '1, 2'�� ���� ���·� ���
    , A.GENDER
    , COUNT(DISTINCT B.USER_ID) AS USERS
  FROM 
    USER_INFO A
    INNER JOIN ONLINE_SALE B ON A.USER_ID = B.USER_ID
 WHERE
    A.GENDER IS NOT NULL
GROUP BY
      TO_CHAR(B.SALES_DATE, 'YYYY')
    , TO_NUMBER(TO_CHAR(B.SALES_DATE, 'fmMM')) --  ������ ���ؼ� �ٽ� �������·� ��ȯ
    , A.GENDER
ORDER BY 
    1, 2, 3
;

-- ���� ���� GROUP BY �̻��
SELECT DISTINCT
      YEAR
    , MONTH
    , T.GENDER
    , COUNT(1) OVER(PARTITION BY T.YEAR,T.MONTH, T.GENDER) AS USERS 
  FROM (
    SELECT DISTINCT 
          A.GENDER
        , A.USER_ID
        , TO_CHAR(B.SALES_DATE, 'YYYY') AS YEAR
        , TO_NUMBER(TO_CHAR(B.SALES_DATE, 'fmMM')) AS MONTH
      FROM 
        USER_INFO A
        INNER JOIN ONLINE_SALE B ON A.USER_ID = B.USER_ID 
     WHERE A.GENDER IS NOT NULL
  ) T
ORDER BY YEAR ASC, MONTH ASC, GENDER ASC
;


--Lv4 �׷캰 ���ǿ� �´� �Ĵ� ��� ����ϱ�
SELECT 
      MEMBER_NAME
    , REVIEW_TEXT
    , TO_CHAR(REVIEW_DATE, 'YYYY-MM-DD') AS REVIEW_DATE
  FROM (
    SELECT
        COUNT(1) OVER(PARTITION BY MP.MEMBER_ID) AS ID_CNT -- COUNT(MP.MEMBER_ID)�� ��� WHERE���� ��� �Ұ�
      , MP.MEMBER_NAME
      , RR.*
      FROM 
        MEMBER_PROFILE MP
        INNER JOIN REST_REVIEW RR ON MP.MEMBER_ID = RR.MEMBER_ID
)
 WHERE ID_CNT = ( --COUNT(MEMBER_ID)�� ���� ���� �ۼ��� ���� COUNT�� ���� ���
    SELECT 
        MAX(ID_CNT) --���� ���� �ۼ��� ���� COUNT
      FROM (
        SELECT
              MEMBER_ID
            , COUNT(MEMBER_ID) AS ID_CNT -- COUNT(1) OVER(PARTITION BY MEMBER_ID) ��� ����� �� ������ ������������ ������ �� �� �� �ϰԵǴ� PARTITION BY�� ���ϴ°� ������ ���� ���ɺ� �غ��� �ʹ�
            -- , COUNT(1) OVER(PARTITION BY MEMBER_ID) AS ID_CNT              
          FROM REST_REVIEW
        GROUP BY MEMBER_ID
    )
)
ORDER BY
    3, 2
;


--Lv4 ���￡ ��ġ�� �Ĵ� ��� ����ϱ�
SELECT
      RI.REST_ID
    , RI.REST_NAME
    , RI.FOOD_TYPE
    , RI.FAVORITES
    , RI.ADDRESS
    , ROUND(AVG(REVIEW_SCORE), 2) AS SCORE
  FROM 
    REST_INFO RI
    INNER JOIN REST_REVIEW RR ON RI.REST_ID = RR.REST_ID
 WHERE
    RI.ADDRESS LIKE '����%'
GROUP BY
      RI.REST_ID
    , RI.REST_NAME
    , RI.FOOD_TYPE
    , RI.FAVORITES
    , RI.ADDRESS
ORDER BY
    SCORE DESC, RI.FAVORITES DESC
;


