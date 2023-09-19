-- 185. Department Top Three Salaries dense_rank()
select
      name as Department 
    , dp_name as Employee 
    , salary
  from (
    select el.*, dp.name as dp_name
        , dense_rank() over(partition by dp.id order by el.salary desc) as rnk -- 부서 별로 그룹화, salary 내림차순 정렬, salary이 동일한 경우 동일한 순위 부여, rank() 대신 dense_rank() 사용
      from 
        Employee el
        inner join Department dp on el.departmentId = dp.id
  )
 where
    rnk < 4