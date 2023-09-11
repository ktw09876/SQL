/* 
정규표현식 Weather Observation Station 9 모음으로 시작하지 않는 대상
!!! 모음으로 끝나지 않는 대상은? --> not regexp_like(city, '[a|e|i|o|u]$', 'i')
수정: 정규표현식에서 '|'를 이용해서 여러 문자를 표현하는 경우 정확한 결과가 나오지 않고 오류가 나는 경우가 종종 있어서
'|'를 사용하지 않는게 좋다
*/

select distinct
      city
  from station
 where
--    not regexp_like(city, '^[a|e|i|o|u]', 'i') -- ^: 시작 문자열, 여러개인 경우 []로 묶고 |를 사용, i: 대소문자를 구분하지 않는 옵션
    not regexp_like(city, '^[aeiou]', 'i') -- ^: 시작 문자열, 여러개인 경우 []로 묶고 |를 사용, i: 대소문자를 구분하지 않는 옵션
;