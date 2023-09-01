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
            else 'Ȯ�� �ʿ�'
        end as category --income�� ������ �������� category�� �����ϰ�
      from 
        Accounts
  ) ac1
        right outer join ( -- category �׸��� ���� ��찡 �ֱ⶧���� �������̺�� right outer join
            select 'Low Salary' as category from dual union all
            select 'Average Salary' as category from dual union all
            select 'High Salary' as category from dual
        ) ac2 on ac1.category = ac2.category
group by ac2.category -- category �׸� ���� group by

-- where���� ������� ���� �ٸ� ���, ������ ���� �ð��� 1������ ���� �ɸ�
-- select
--       ac2.category
--     , count(ac1.account_id) as accounts_count 
--   from 
--     Accounts ac1
--     right outer join ( -- category �׸��� ���� ��찡 �ֱ⶧���� �������̺�� right outer join
--             select 'Low Salary' as category from dual union all
--             select 'Average Salary' as category from dual union all
--             select 'High Salary' as category from dual
--         ) ac2 on 
--     case --���������� ���̱� ���� on���� case �������� ���
--         when ac1.income < 20000 then 'Low Salary'
--         when ac1.income between 20000 and 50000 then 'Average Salary'
--         when ac1.income > 50000 then 'High Salary'
--         else 'Ȯ�� �ʿ�'
--      end = ac2.category
-- group by ac2.category