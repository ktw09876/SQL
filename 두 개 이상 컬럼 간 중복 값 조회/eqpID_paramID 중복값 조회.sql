SELECT eqp_id, param_id, tag_name, tag_desc, full_address, param_code,
        CASE 
            WHEN eid_pid > 1 -- eqp_id, param_id 가 같은 경우
            THEN CASE
                    WHEN eid_pid_desc > 1 -- eqp_id, param_id, desc. 가 같은 경우
                    THEN CASE
                            WHEN eid_pid_desc_addr > 1 --eqp_id, param_id, desc., full_address가 같은 경우
                            THEN 'FULL_ADDRESS 가 같은 경우 = 태그 삭제'
                            WHEN eid_pid_desc_addr = 1  --eqp_id, param_id, desc.가 같고 full_address가 다른 경우
                            THEN 'param_code 수정'
                            ELSE '확인 필요'
                         END
                    WHEN eid_pid_desc = 1 --eqp_id, param_id가 같고 desc.가 다른 경우
                    THEN CASE 
                            WHEN eid_pid_pcode > 1 --eqp_id, param_id, param_code가 같은데 desc.는 다른 경우
                            THEN '로직 확인 건'
                            ELSE '확인 필요'
                          END
                    ELSE '확인 필요'
                  END
            ELSE 'eqp_id 1개에 param_id가 1개 = OK'
         END AS msg
  FROM ( --DESC.에 비정형화 되어있는 데이터는 replace로 같은 값으로 변환
    SELECT A.*
            ,COUNT(1) OVER(PARTITION BY eqp_id, param_id ) AS eid_pid --eqp_id, param_id가 같은 경우
            ,COUNT(1) OVER(PARTITION BY eqp_id, param_id, REPLACE(regexp_replace(tag_desc, 'PWR|파워', 'POWER'), '오버', 'OVER')) AS eid_pid_desc --eqp_id, param_id, desc.가 같은 경우
            ,COUNT(1) OVER(PARTITION BY eqp_id, param_id, REPLACE(regexp_replace(tag_desc, 'PWR|파워', 'POWER'), '오버', 'OVER'),full_address) AS eid_pid_desc_addr --eqp_id, param_id, desc., full_address가 같은 경우
            ,COUNT(1) OVER(PARTITION BY eqp_id, param_id, param_code) AS eid_pid_pcode --eqp_id, param_id, param_code가 같은 경우
            ,COUNT(1) OVER(PARTITION BY eqp_id, param_id, REPLACE(regexp_replace(tag_desc, 'PWR|파워', 'POWER'), '오버', 'OVER'), param_code) AS eid_pid_desc_pcode --eqp_id, param_id, desc., param_code가 같은 경우
      FROM tt_mapping A
) A
-- WHERE 
--    eid_pid > 1 -- eqp_id 와 param_id 가 2개 이상인 대상만 조회
;
