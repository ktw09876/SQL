/*
����Ŭ���� Ȧ���� ¦�� �����͸� �������� �ְ� ���� ��
���� �ƴ� ������ ������(%)�� ����Ŭ���� �������� ����
    Ex)WHERE ID % 2 = 1(X)
    
MOD()�� �̿����� 
    Ex)MOD(ID, 2) = 1
*/
SELECT *
  FROM Cinema
 WHERE
       MOD(ID, 2) = 1
   AND description <> 'boring'
ORDER BY rating DESC
;