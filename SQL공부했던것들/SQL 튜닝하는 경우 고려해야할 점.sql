/*
SQL 튜닝?

WHERE 조건을 걸 때
	1)가급적 동등 연산자(=)를 사용하는 것이 좋다
	2)LIKE, IN, IS NULL 의 경우 인덱스 효율이 떨어진다 특히 Like '%문자열%'의 경우 인덱스를 타지 않고 풀스캔이 된다 --> '문자열%'의 형태로 사용하자
	3)인덱스 순서대로 조건을 거는 것이 좋다
	4)생성되어 있는 인덱스를 모두 사용하는 것이 좋다
	5)인덱스 컬럼에 변형을 했을 때(SUBSTR()/DECODE/…) 인덱스를 타지 않음 --> 풀스캔
	6)HAVING 절 보다는 WHERE 절에서 조건을 필터링 하자
	7)DISTINCT의 경우 내부적으로 정렬을 하기 때문에 Data가 많을 수록 느려진다 --> 가급적 사용하지 말자
	8)IN, NOT IN 대신 EXISTS, NOT EXISTS를 사용하자
    9)JOIN 을 할 때 ROW 가 많다면 WHERE 조건을 이용해 필요한 DATA만 가져와서 JOIN하자
*/