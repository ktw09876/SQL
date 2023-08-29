-- 1070. Product Sales Analysis III
-- 처음 row_number()를 이용했다가 testcases에서 막힘 rank()와 row_number()의 차이 더 찾아보자
Select 
      product_id 
    , year as first_year 
    , quantity
    , price 
  from (
    Select 
          a.*
        , rank() over(partition by product_id order by year ) row_num
    from Sales a
)
 where row_num = 1 

-- 다른 방법 
-- select
--       a.product_id 
--     , a.year as first_year 
--     , a.quantity 
--     , a.price 
--   from 
--       Sales a
--       inner join (
--         select product_id, min(year) as min_year
--           from Sales
--         group by product_id
--       ) b 
--       on a.product_id = b.product_id
--       and a.year = b.min_year