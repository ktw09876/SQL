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

-- Lv4 년, 월, 성별 별 상품 구매 회원 수 구하기
-- GROUP BY 사용
SELECT
      to_char(B.sales_date, 'YYYY') AS YEAR
    , TO_NUMBER(to_char(B.sales_date, 'fmMM')) AS MONTH -- '01, 02'와 같은 형태가 아닌 '1, 2'와 같은 형태로 출력
    , A.gender
    , COUNT(DISTINCT B.user_id) AS USERS
  FROM 
    user_info A
    INNER JOIN online_sale B ON A.user_id = B.user_id
 WHERE
    A.gender IS NOT NULL
GROUP BY
      to_char(B.sales_date, 'YYYY')
    , TO_NUMBER(to_char(B.sales_date, 'fmMM')) --  정렬을 위해서 다시 숫자형태로 변환
    , A.gender
ORDER BY 
    1, 2, 3
;

-- 같은 문제 GROUP BY 미사용
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


--Lv4 그룹별 조건에 맞는 식당 목록 출력하기
SELECT 
      MEMBER_NAME
    , review_text
    , to_char(review_date, 'YYYY-MM-DD') AS review_date
  FROM (
    SELECT
        COUNT(1) OVER(PARTITION BY mp.member_id) AS id_cnt -- COUNT(MP.MEMBER_ID)의 경우 WHERE절에 사용 불가
      , mp.MEMBER_NAME
      , rr.*
      FROM 
        member_profile mp
        INNER JOIN rest_review rr ON mp.member_id = rr.member_id
)
 WHERE id_cnt = ( --COUNT(MEMBER_ID)가 가장 많이 작성한 리뷰 COUNT와 같은 대상
    SELECT 
        MAX(id_cnt) --가장 많이 작성한 리뷰 COUNT
      FROM (
        SELECT
              member_id
            , COUNT(member_id) AS id_cnt -- COUNT(1) OVER(PARTITION BY MEMBER_ID) 모두 사용할 수 있지만 서브쿼리에서 정렬을 한 번 더 하게되는 PARTITION BY는 피하는게 좋은거 같다 성능비교 해보고 싶다
            -- , COUNT(1) OVER(PARTITION BY MEMBER_ID) AS ID_CNT              
          FROM rest_review
        GROUP BY member_id
    )
)
ORDER BY
    3, 2
;


--Lv4 서울에 위치한 식당 목록 출력하기
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
    RI.address LIKE '서울%'
GROUP BY
      RI.rest_id
    , RI.rest_name
    , RI.food_type
    , RI.favorites
    , RI.address
ORDER BY
    score DESC, RI.favorites DESC
;


--Lv4 5월 식품들의 총매출 조회하기
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

--같은 문제 WITH절 사용
WITH 생산품목 AS(
    SELECT 
          product_id
        , SUM(amount) AS amount
      FROM food_order
     WHERE to_char(produce_date,'YYYY-MM') = '2022-05'
    GROUP BY product_id
)
SELECT A.product_id, B.product_name, A.amount*B.price AS total_sales
  FROM 
    생산품목 A
    INNER JOIN food_product B ON A.product_id = B.product_id
ORDER BY A.amount*B.price DESC, product_id
;


--Lv4 식품분류별 가장 비싼 식품의 정보 조회하기
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
    category IN('과자', '국', '김치', '식용유')
ORDER BY 2 DESC
;


