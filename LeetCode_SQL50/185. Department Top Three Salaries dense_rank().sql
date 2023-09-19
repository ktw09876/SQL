-- 185. Department Top Three Salaries dense_rank()
select
      name as Department 
    , dp_name as Employee 
    , salary
  from (
    select el.*, dp.name as dp_name
        , dense_rank() over(partition by dp.id order by el.salary desc) as rnk -- �μ� ���� �׷�ȭ, salary �������� ����, salary�� ������ ��� ������ ���� �ο�, rank() ��� dense_rank() ���
      from 
        Employee el
        inner join Department dp on el.departmentId = dp.id
  )
 where
    rnk < 4