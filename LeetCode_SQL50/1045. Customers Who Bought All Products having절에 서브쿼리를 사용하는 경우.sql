-- 1045. Customers Who Bought All Products having절에 서브쿼리를 사용하는 경우
select
    customer_id
  from Customer
group by customer_id
having count(distinct product_key) = (select count(*) from Product) -- having절에 서브쿼리를 사용하는 경우
