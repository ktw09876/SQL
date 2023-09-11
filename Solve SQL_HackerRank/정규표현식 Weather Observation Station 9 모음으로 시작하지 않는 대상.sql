/* 
정규표현식 Weather Observation Station 9 모음으로 시작하지 않는 대상
!!! 모음으로 끝나지 않는 대상은? --> not regexp_like(city, '[a|e|i|o|u]$', 'i')
*/

select distinct
      city
  from station
 where
    not regexp_like(city, '^[a|e|i|o|u]', 'i') -- ^: 시작 문자열, 여러개인 경우 []로 묶고 |를 사용, i: 대소문자를 구분하지 않는 옵션
;