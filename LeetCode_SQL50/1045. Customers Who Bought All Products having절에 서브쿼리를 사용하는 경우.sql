-- 1045. Customers Who Bought All Products having���� ���������� ����ϴ� ���
select
    customer_id
  from Customer
group by customer_id
having count(distinct product_key) = (select count(*) from Product) -- having���� ���������� ����ϴ� ���
