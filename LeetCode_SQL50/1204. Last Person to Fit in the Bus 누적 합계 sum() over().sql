-- 1204. Last Person to Fit in the Bus 누적 합계 sum() over()
select 
    person_name 
  from Queue
 where Turn = (
    select max(Turn) -- 가장 마지막 순번
      from (
        select a.*
            , sum(Weight) over(order by turn) as wei_sum -- 누적합계를 구함
          from Queue a
      )
    where
        wei_sum < 1001 -- 누적합계가 1001 이하인 대상
 )