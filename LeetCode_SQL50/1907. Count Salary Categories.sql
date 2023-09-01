--1907. Count Salary Categories
select 
      ac2.category
    , count(account_id) as accounts_count 
  from (
    select 
          income
        , account_id
        , case
            when income < 20000 then 'Low Salary'
            when income between 20000 and 50000 then 'Average Salary'
            when income > 50000 then 'High Salary'
            else '확인 필요'
        end as category --income을 가지고 범위별로 category를 생성하고
      from 
        Accounts
  ) ac1
        right outer join ( -- category 항목이 없는 경우가 있기때문에 더미테이블과 right outer join
            select 'Low Salary' as category from dual union all
            select 'Average Salary' as category from dual union all
            select 'High Salary' as category from dual
        ) ac2 on ac1.category = ac2.category
group by ac2.category -- category 항목 별로 group by

-- where절을 사용하지 않은 다른 방법, 하지만 실행 시간이 1번보다 오래 걸림
-- select
--       ac2.category
--     , count(ac1.account_id) as accounts_count 
--   from 
--     Accounts ac1
--     right outer join ( -- category 항목이 없는 경우가 있기때문에 더미테이블과 right outer join
--             select 'Low Salary' as category from dual union all
--             select 'Average Salary' as category from dual union all
--             select 'High Salary' as category from dual
--         ) ac2 on 
--     case --서브쿼리를 줄이기 위해 on절에 case 조건절을 사용
--         when ac1.income < 20000 then 'Low Salary'
--         when ac1.income between 20000 and 50000 then 'Average Salary'
--         when ac1.income > 50000 then 'High Salary'
--         else '확인 필요'
--      end = ac2.category
-- group by ac2.category