-- 1731. The Number of Employees Which Report to Each Employee
-- self join
select
      el1.employee_id 
    , el1.name
    , count(el2.employee_id) as reports_count 
    , round(avg(el2.age), 0) as average_age
  from 
    Employees el1
    inner join Employees el2 on el1.employee_id = el2.reports_to 
group by 
      el1.employee_id  
    , el1.name
order by
    el1.employee_id 
