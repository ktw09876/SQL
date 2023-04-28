SELECT eqp_id, param_id, tag_name, tag_desc, full_address, param_code,
        CASE 
            WHEN eid_pid > 1 -- eqp_id, param_id �� ���� ���
            THEN CASE
                    WHEN eid_pid_desc > 1 -- tag_desc �� ���� ���
                    THEN CASE
                            WHEN eid_pid_desc_addr > 1 -- addr �� ���� ���
                            THEN 'FULL_ADDRESS �� ���� ��� = �±� ����'
                            WHEN eid_pid_desc_addr = 1  -- addr �� �ٸ� ���
                            THEN 'param_code ����'
                            ELSE 'Ȯ�� �ʿ�'
                         END
                    WHEN eid_pid_desc = 1 -- tag_desc �� �ٸ� ���
                    THEN CASE 
                            WHEN eid_pid_pcode > 1 -- desc �� �ٸ��� pcode �� ���� ���
                            THEN '���� Ȯ�� ��'
                            ELSE 'Ȯ�� �ʿ�'
                          END
                    ELSE 'Ȯ�� �ʿ�'
                  END
            ELSE 'Ȯ�� �ʿ�'
         END AS msg
  FROM (
    SELECT A.*
            ,COUNT(1) OVER(PARTITION BY eqp_id, param_id ) AS eid_pid
            ,COUNT(1) OVER(PARTITION BY eqp_id, param_id, REPLACE(regexp_replace(tag_desc, 'PWR|�Ŀ�', 'POWER'), '����', 'OVER')) AS eid_pid_desc
            ,COUNT(1) OVER(PARTITION BY eqp_id, param_id, REPLACE(regexp_replace(tag_desc, 'PWR|�Ŀ�', 'POWER'), '����', 'OVER'),full_address) AS eid_pid_desc_addr
            ,COUNT(1) OVER(PARTITION BY eqp_id, param_id, param_code) AS eid_pid_pcode
            ,COUNT(1) OVER(PARTITION BY eqp_id, param_id, REPLACE(regexp_replace(tag_desc, 'PWR|�Ŀ�', 'POWER'), '����', 'OVER'), param_code) AS eid_pid_desc_pcode
      FROM tt_mapping A
) A
 WHERE 
    eid_pid > 1 -- eqp_id �� param_id �� 2�� �̻��� ��� ��ȸ
;

