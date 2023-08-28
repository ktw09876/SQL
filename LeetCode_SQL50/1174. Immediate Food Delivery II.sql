-- 1174. Immediate Food Delivery II
select 
    round(sum(
      case
        when ORDER_DATE = CUSTOMER_PREF_DELIVERY_DATE then 1 -- 주문이 즉시 이루어진 경우 1
        else 0 -- 즉시 이루어지지 못하고 미뤄졌으면 0
       end
    ) / count(*) * 100, 2) as immediate_percentage -- 전체 주문 중 주문이 즉시 이루어진 경우의 비율
  from (
    select a.*
        , count(1) over(partition by customer_id order by order_date) as order_cnt -- 고객별 주문 날짜를 확인 후 
      from Delivery a
  ) a
 where
    order_cnt = 1 -- 그 중 첫번째 주문 내역만 가져옴