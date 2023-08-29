-- 1070. Product Sales Analysis III
-- ó�� row_number()�� �̿��ߴٰ� testcases���� ���� rank()�� row_number()�� ���� �� ã�ƺ���
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

-- �ٸ� ��� 
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