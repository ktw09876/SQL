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



