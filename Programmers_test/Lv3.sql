--oracle Lv3 ���ǿ� �´� ����� ���� ��ȸ�ϱ�
SELECT
    user_id,
    nickname,
    city||' '||street_address1||' '||street_address2 AS "��ü�ּ�",
    regexp_replace(tlno, '(02|.{3})(.+)(.{4})', '\1-\2-\3') AS "��ȭ��ȣ" -- (���� ������ȣ(02) �Ǵ� ���ڿ� �� 3�ڸ�)(������ ���ڿ�)(���ڿ� �� 4�ڸ�)
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


-- Lv3 ��� ������ ������ ���
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


-- Lv3 ���ã�Ⱑ ���� ���� �Ĵ� ���� ����ϱ�
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


-- Lv3 ������ ��� ã��
SELECT B.animal_id, B.NAME
  FROM animal_ins A, animal_outs B
 WHERE A.animal_id(+) = B.animal_id
   AND A.animal_id IS NULL
ORDER BY animal_id
;


-- Lv3 ī�װ� �� ���� �Ǹŷ� �����ϱ�
SELECT
    CATEGORY,
    SUM(sales) AS total_sales
  FROM book A, book_sales B
 WHERE A.book_id = B.book_id
   AND to_char(sales_date, 'YYYY-MM') = '2022-01'
GROUP BY CATEGORY
ORDER BY CATEGORY
;



