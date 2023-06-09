--oracle Lv3 조건에 맞는 사용자 정보 조회하기
SELECT
    user_id,
    nickname,
    city||' '||street_address1||' '||street_address2 AS "전체주소",
    regexp_replace(tlno, '(02|.{3})(.+)(.{4})', '\1-\2-\3') AS "전화번호" -- (예외 지역번호(02) 또는 문자열 앞 3자리)(나머지 문자열)(문자열 뒤 4자리)
  FROM used_goods_user
 WHERE 
    user_id IN (   
                SELECT 
                    writer_id
                  FROM used_goods_board
                GROUP BY writer_id
                HAVING COUNT(*) > 2
            )
ORDER BY user_id DESC
;


-- Lv3 헤비 유저가 소유한 장소
SELECT *
  FROM places
 WHERE host_id IN(
                SELECT host_id
                  FROM places
                GROUP BY host_id
                HAVING COUNT(host_id) >= 2
            )
ORDER BY ID
;


-- Lv3 즐겨찾기가 가장 많은 식당 정보 출력하기
SELECT 
    food_type,
    rest_id,
    rest_name,
    favorites
  FROM rest_info 
 WHERE
    (food_type, favorites) IN(
        SELECT 
            food_type, MAX(favorites)
          FROM rest_info 
        GROUP BY food_type
    )
ORDER BY food_type DESC
;


-- Lv3 없어진 기록 찾기
SELECT B.animal_id, B.NAME
  FROM animal_ins A, animal_outs B
 WHERE A.animal_id(+) = B.animal_id
   AND A.animal_id IS NULL
ORDER BY animal_id
;


-- Lv3 카테고리 별 도서 판매량 집계하기
SELECT
    CATEGORY,
    SUM(sales) AS total_sales
  FROM book A, book_sales B
 WHERE A.book_id = B.book_id
   AND to_char(sales_date, 'YYYY-MM') = '2022-01'
GROUP BY CATEGORY
ORDER BY CATEGORY
;



