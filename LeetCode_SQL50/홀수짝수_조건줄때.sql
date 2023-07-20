/*
오라클에서 홀수나 짝수 데이터를 조건으로 주고 싶을 때
흔히 아는 나머지 연산자(%)는 오라클에서 지원하지 않음
    Ex)WHERE ID % 2 = 1(X)
    
MOD()를 이용하자 
    Ex)MOD(ID, 2) = 1
*/
SELECT *
  FROM Cinema
 WHERE
       MOD(ID, 2) = 1
   AND description <> 'boring'
ORDER BY rating DESC
;