-- 1517. Find Users With Valid E-Mails
-- ����ǥ������ Ȱ���� �̸��� ���� ã��
select *                  
  from Users
 where
    -- ^[A-Za-z]: ���۹��ڰ� ���� �빮��, �ҹ��ڷ� ����
    -- [A-Za-z0-9._-]*: �ι�° ���ں��� ���� �빮��, �ҹ���, ����, '.', '_', '-'�� 0�� �̻� ���� �� �ִ�
    -- @leetcode\.com: @leetcode.com�� ����
    REGEXP_LIKE(mail, '(^[A-Za-z])([A-Za-z0-9._-]*)@leetcode\.com')