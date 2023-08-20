-- 1193. Monthly Transactions I
-- case문으로 값을 숫자로 변경 후 집계를 할 수 있음
select
      to_char(trans_date, 'yyyy-mm') as month
    , country 
    , count(state) as trans_count
    , sum(case
            when state = 'approved' then 1
            else 0 
           end) as approved_count
    , sum(amount) as trans_total_amount 
    , sum(case
            when state = 'approved' then amount 
            else 0
           end) as approved_total_amount 
  from Transactions
group by 
      to_char(trans_date, 'yyyy-mm')
    , country
order by 1