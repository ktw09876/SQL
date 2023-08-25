-- 1517. Find Users With Valid E-Mails
-- 정규표현식을 활용한 이메일 형식 찾기
select *                  
  from Users
 where
    REGEXP_LIKE(mail, '(^[A-Za-z])([A-Za-z0-9._-]*)@leetcode\.com')