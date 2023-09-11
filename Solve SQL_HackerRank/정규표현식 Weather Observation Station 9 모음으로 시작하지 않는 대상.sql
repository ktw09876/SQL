/* 
����ǥ���� Weather Observation Station 9 �������� �������� �ʴ� ���
!!! �������� ������ �ʴ� �����? --> not regexp_like(city, '[a|e|i|o|u]$', 'i')
*/

select distinct
      city
  from station
 where
    not regexp_like(city, '^[a|e|i|o|u]', 'i') -- ^: ���� ���ڿ�, �������� ��� []�� ���� |�� ���, i: ��ҹ��ڸ� �������� �ʴ� �ɼ�
;