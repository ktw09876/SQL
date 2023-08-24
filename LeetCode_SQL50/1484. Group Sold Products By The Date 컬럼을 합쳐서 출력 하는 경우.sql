-- 1484. Group Sold Products By The Date
-- 컬럼을 합쳐서 출력 하는 함수 LISTAGG([합칠 컬럼명], [구분자]) WITHIN GROUP(ORDER BY [정렬 컬럼명])
-- 중복값의 경우 
-- 19c 이상: LISTAGG(DISTINCT product, ',') WITHIN GROUP(ORDER BY product)
-- 19c 미만
-- 정규표현식을 사용하거나: REGEXP_REPLACE(LISTAGG(product, ',') WITHIN GROUP(ORDER BY product), '([^,]+)(,\1)*(,|$)', '\1\3') products
-- from 절을 distinct 서브쿼리 사용: 아래 해당 쿼리
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