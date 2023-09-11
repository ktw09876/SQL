/*
Weather Observation Station 5
sql ����Ʈ��  ���� union all�� ����� �� ���� ������ ��ȣ�� ����� ����Ǳ⵵ �Ѵ�
*/
(
select *
  from (
    select
          city
        , length(city) as len
      from station
    order by 2, 1
  )
 where
    rowNum = 1
    
) union all (
    
select *
  from (
    select
          city
        , length(city) as len
      from station
    order by 2 desc, 1
  )
 where
    rowNum = 1
)
;