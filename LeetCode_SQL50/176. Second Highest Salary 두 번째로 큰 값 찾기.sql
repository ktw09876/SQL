-- 176. Second Highest Salary �� ��°�� ū �� ã��
select max(salary) as SecondHighestSalary -- 3. ���� ū salary��
  from Employee
 where
    salary < ( -- 2. ���� ū salary���� ���� �� �߿��� 
      select max(salary) -- 1. ���� ū salary
        from Employee
    )