-- 1517. Find Users With Valid E-Mails
-- ����ǥ������ Ȱ���� �̸��� ���� ã��
select *                  
  from Users
 where
    REGEXP_LIKE(mail, '(^[A-Za-z])([A-Za-z0-9._-]*)@leetcode\.com')