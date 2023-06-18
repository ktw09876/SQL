SELECT eqp_id, param_id, tag_name, tag_desc, full_address, param_code,
        CASE 
            WHEN eid_pid > 1 -- eqp_id, param_id �� ���� ���
            THEN CASE
                    WHEN eid_pid_desc > 1 -- eqp_id, param_id, desc. �� ���� ���
                    THEN CASE
                            WHEN eid_pid_desc_addr > 1 --eqp_id, param_id, desc., full_address�� ���� ���
                            THEN 'FULL_ADDRESS �� ���� ��� = �±� ����'
                            WHEN eid_pid_desc_addr = 1  --eqp_id, param_id, desc.�� ���� full_address�� �ٸ� ���
                            THEN 'param_code ����'
                            ELSE 'Ȯ�� �ʿ�'
                         END
                    WHEN eid_pid_desc = 1 --eqp_id, param_id�� ���� desc.�� �ٸ� ���
                    THEN CASE 
                            WHEN eid_pid_pcode > 1 --eqp_id, param_id, param_code�� ������ desc.�� �ٸ� ���
                            THEN '���� Ȯ�� ��'
                            ELSE 'Ȯ�� �ʿ�'
                          END
                    ELSE 'Ȯ�� �ʿ�'
                  END
            ELSE 'eqp_id 1���� param_id�� 1�� = OK'
         END AS msg
  FROM ( --DESC.�� ������ȭ �Ǿ��ִ� �����ʹ� replace�� ���� ������ ��ȯ
    SELECT A.*
            ,COUNT(1) OVER(PARTITION BY eqp_id, param_id ) AS eid_pid --eqp_id, param_id�� ���� ���
            ,COUNT(1) OVER(PARTITION BY eqp_id, param_id, REPLACE(regexp_replace(tag_desc, 'PWR|�Ŀ�', 'POWER'), '����', 'OVER')) AS eid_pid_desc --eqp_id, param_id, desc.�� ���� ���
            ,COUNT(1) OVER(PARTITION BY eqp_id, param_id, REPLACE(regexp_replace(tag_desc, 'PWR|�Ŀ�', 'POWER'), '����', 'OVER'),full_address) AS eid_pid_desc_addr --eqp_id, param_id, desc., full_address�� ���� ���
            ,COUNT(1) OVER(PARTITION BY eqp_id, param_id, param_code) AS eid_pid_pcode --eqp_id, param_id, param_code�� ���� ���
            ,COUNT(1) OVER(PARTITION BY eqp_id, param_id, REPLACE(regexp_replace(tag_desc, 'PWR|�Ŀ�', 'POWER'), '����', 'OVER'), param_code) AS eid_pid_desc_pcode --eqp_id, param_id, desc., param_code�� ���� ���
      FROM tt_mapping A
) A
-- WHERE 
--    eid_pid > 1 -- eqp_id �� param_id �� 2�� �̻��� ��� ��ȸ
;
