-- 1517. Find Users With Valid E-Mails
-- 정규표현식을 활용한 이메일 형식 찾기
select *                  
  from Users
 where
    -- ^[A-Za-z]: 시작문자가 영어 대문자, 소문자로 시작
    -- [A-Za-z0-9._-]*: 두번째 문자부터 영어 대문자, 소문자, 숫자, '.', '_', '-'가 0개 이상 나올 수 있다
    -- @leetcode\.com: @leetcode.com로 끝남
    REGEXP_LIKE(mail, '(^[A-Za-z])([A-Za-z0-9._-]*)@leetcode\.com')