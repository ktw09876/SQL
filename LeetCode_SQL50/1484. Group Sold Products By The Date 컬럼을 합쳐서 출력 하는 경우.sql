-- 1484. Group Sold Products By The Date
-- �÷��� ���ļ� ��� �ϴ� �Լ� LISTAGG([��ĥ �÷���], [������]) WITHIN GROUP(ORDER BY [���� �÷���])
-- �ߺ����� ��� 
-- 19c �̻�: LISTAGG(DISTINCT product, ',') WITHIN GROUP(ORDER BY product)
-- 19c �̸�
-- ����ǥ������ ����ϰų�: REGEXP_REPLACE(LISTAGG(product, ',') WITHIN GROUP(ORDER BY product), '([^,]+)(,\1)*(,|$)', '\1\3') products
-- from ���� distinct �������� ���: �Ʒ� �ش� ����
select
      to_char(sell_date, 'yyyy-mm-dd') as sell_date
    , count(distinct product) as num_sold 
    , LISTAGG(product, ',') WITHIN GROUP(ORDER BY product) as products
  from (
    select distinct *
      from Activities
  )
group by
      sell_date  
      
--Input: 
--+------------+------------+
--| sell_date  | product    |
--+------------+------------+
--| 2020-05-30 | Headphone  |
--| 2020-06-01 | Pencil     |
--| 2020-06-02 | Mask       |
--| 2020-05-30 | Basketball |
--| 2020-06-01 | Bible      |
--| 2020-06-02 | Mask       |
--| 2020-05-30 | T-Shirt    |
--+------------+------------+

--Output: 
--+------------+----------+------------------------------+
--| sell_date  | num_sold | products                     |
--+------------+----------+------------------------------+
--| 2020-05-30 | 3        | Basketball,Headphone,T-shirt |
--| 2020-06-01 | 2        | Bible,Pencil                 |
--| 2020-06-02 | 1        | Mask                         |
--+------------+----------+------------------------------+