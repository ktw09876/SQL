-- 1193. Monthly Transactions I
-- case������ ���� ���ڷ� ���� �� ���踦 �� �� ����
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