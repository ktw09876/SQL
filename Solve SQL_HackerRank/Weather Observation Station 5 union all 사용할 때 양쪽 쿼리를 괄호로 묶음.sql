/*
Weather Observation Station 5
sql 사이트에  따라 union all을 사용할 때 양쪽 쿼리를 괄호로 묶어야 실행되기도 한다
*/
(
select *
  from (
    select
          city
        , length(city) as len
      from station
    order by 2, 1
  )
 where
    rowNum = 1
    
) union all (
    
select *
  from (
    select
          city
        , length(city) as len
      from station
    order by 2 desc, 1
  )
 where
    rowNum = 1
)
;