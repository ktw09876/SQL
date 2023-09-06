-- 176. Second Highest Salary 두 번째로 큰 값 찾기
select max(salary) as SecondHighestSalary -- 3. 가장 큰 salary값
  from Employee
 where
    salary < ( -- 2. 가장 큰 salary보다 작은 값 중에서 
      select max(salary) -- 1. 가장 큰 salary
        from Employee
    )