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



