-- 619. Biggest Single Number
-- group by having을 사용해도 꼭 집계함수를 사용해야하는 것은 아니다
-- group by having을 사용했지만 집계함수를 사용하지 않는 경우
-- 서브쿼리와 같은 형태도 사용 가능하더라
select
    max(num) as num
  from (
    select
        num
      from MyNumbers
    having count(*) = 1
    group by num
  )
  
  -- select
--     max(num) as num
--   from (
--     select
--         num
--       , count(num) over(partition by num) as num_cnt
--       from MyNumbers
--   )
--  where
--     num_cnt = 1
 