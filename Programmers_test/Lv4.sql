--Lv4 특정 기간동안 대여 가능한 자동차들의 대여비용 구하기
SELECT DISTINCT
    C.car_id,
    C.car_type,
    (C.daily_fee * 30) - (C.daily_fee * 30 * discount_rate/100) AS fee -- 대여금액
  FROM (
    SELECT A.*
      FROM car_rental_company_car A, car_rental_company_rental_history B
     WHERE
            A.car_id = B.car_id
        AND A.car_type IN('세단', 'SUV')
        AND A.car_id NOT IN(
            SELECT car_id
              FROM car_rental_company_rental_history
             WHERE --날짜조건
                   to_char(start_date, 'YYYY-MM') <= '2022-11' 
               AND to_char(end_date, 'YYYY-MM') >= '2022-11'
        )
) C, car_rental_company_discount_plan D
 WHERE
        C.car_type = D.car_type
    AND D.duration_type = '30일 이상'
    AND (C.daily_fee * 30) - (C.daily_fee * 30 * discount_rate/100) BETWEEN 500000 AND 1999999 --대여금액 조건
ORDER BY fee DESC, C.car_type, C.car_id DESC
;

-- Lv4 자동차 대여 기록 별 대여 금액 구하기
SELECT 
    B.history_id
    , round(A.daily_fee * ((100 - nvl(C.discount_rate, 0))/100) * (B.end_date - B.start_date+1), 0) AS fee
  FROM 
    car_rental_company_car A 
    INNER JOIN car_rental_company_rental_history B ON A.car_id = B.car_id
    LEFT OUTER JOIN car_rental_company_discount_plan C ON A.car_type = C.car_type
    AND CASE -- ON 절에 CASE문을 사용할 수 있더라
        WHEN B.end_date - B.start_date+1 >= 90 THEN '90일 이상'
        WHEN B.end_date - B.start_date+1 >= 30 THEN '30일 이상'
        WHEN B.end_date - B.start_date+1 >= 7 THEN '7일 이상'
        ELSE NULL
     END = C.duration_type
 WHERE
    A.car_type = '트럭'
ORDER BY
    2 DESC, 1 DESC
;

-- Lv4 오프라인/온라인 판매 데이터 통합하기
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

-- Lv4 년, 월, 성별 별 상품 구매 회원 수 구하기
SELECT 
      YEAR
    , TO_NUMBER(MONTH) AS MONTH
    , GENDER
    , COUNT(DISTINCT USER_ID) AS USERS
  FROM (
    SELECT
          TO_CHAR(B.SALES_DATE, 'YYYY') AS YEAR
        , TO_CHAR(B.SALES_DATE, 'fmMM') AS MONTH -- '01, 02'와 같은 형태가 아닌 '1, 2'와 같은 형태로 출력
        , A.GENDER
        , B.USER_ID
      FROM 
        USER_INFO A
        INNER JOIN ONLINE_SALE B ON A.USER_ID = B.USER_ID
     WHERE
        A.GENDER IS NOT NULL
)
GROUP BY
      YEAR
    , TO_NUMBER(MONTH) --  정렬을 위해서 다시 숫자형태로 변환
    , GENDER
ORDER BY 
    1, 2, 3
;


