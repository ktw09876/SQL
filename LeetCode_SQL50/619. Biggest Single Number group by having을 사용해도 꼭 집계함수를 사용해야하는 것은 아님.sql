-- 619. Biggest Single Number
-- group by having�� ����ص� �� �����Լ��� ����ؾ��ϴ� ���� �ƴϴ�
-- group by having�� ��������� �����Լ��� ������� �ʴ� ���
-- ���������� ���� ���µ� ��� �����ϴ���
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
 