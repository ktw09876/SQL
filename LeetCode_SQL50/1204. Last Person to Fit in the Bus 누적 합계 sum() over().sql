-- 1204. Last Person to Fit in the Bus ���� �հ� sum() over()
select 
    person_name 
  from Queue
 where Turn = (
    select max(Turn) -- ���� ������ ����
      from (
        select a.*
            , sum(Weight) over(order by turn) as wei_sum -- �����հ踦 ����
          from Queue a
      )
    where
        wei_sum < 1001 -- �����հ谡 1001 ������ ���
 )