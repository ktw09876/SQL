-- 1174. Immediate Food Delivery II
select 
    round(sum(
      case
        when ORDER_DATE = CUSTOMER_PREF_DELIVERY_DATE then 1 -- �ֹ��� ��� �̷���� ��� 1
        else 0 -- ��� �̷������ ���ϰ� �̷������� 0
       end
    ) / count(*) * 100, 2) as immediate_percentage -- ��ü �ֹ� �� �ֹ��� ��� �̷���� ����� ����
  from (
    select a.*
        , count(1) over(partition by customer_id order by order_date) as order_cnt -- ���� �ֹ� ��¥�� Ȯ�� �� 
      from Delivery a
  ) a
 where
    order_cnt = 1 -- �� �� ù��° �ֹ� ������ ������