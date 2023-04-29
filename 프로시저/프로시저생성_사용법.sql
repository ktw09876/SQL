
create or replace PROCEDURE my_new_job_proc( -- ���� or ������ ���ν����� �ٲ� 'or REPLACE' �� Ȯ�� �� ����ؾ� ��, �����.���ν��� ��
    p_job_id IN jobs.job_id%TYPE, -- 'p_job_id' ��� �Ű������� �����ϴ� �� 'jobs' ���̺��� 'job_id' �÷��� ������ ������ Ÿ���� ���´�
    p_job_title IN jobs.job_title%TYPE,
    p_min_salary IN jobs.min_salary%TYPE,
    p_max_salary IN jobs.max_salary%TYPE
)
IS -- ���� ����
    cnt NUMBER := 0;
BEGIN -- ����� ����
    SELECT COUNT(job_id) INTO cnt -- select �� COUNT(job_id) �� cnt �� ��´�
      FROM jobs 
     WHERE job_id = p_job_id;
     
    IF cnt != 0 THEN -- ���� select �� COUNT(job_id)�� ���� ������
    
        -- update �� �����ϰ�
        UPDATE jobs 
        SET 
            job_title = p_job_title,
            min_salary = p_min_salary,
            max_salary = p_max_salary
        WHERE
            job_id = p_job_id;
        dbms_output.enable; -- ���� �� ������ ���
        dbms_output.put_line('�ش� ���� update �߽��ϴ�' || ' ' ||'job_id'||'='||''||p_job_id||'');
    ELSE -- ���� select �� COUNT(job_id)�� ���� ������
    
        -- insert �� �����Ѵ�
        INSERT INTO jobs(job_id, job_title, min_salary, max_salary) 
        VALUES(p_job_id, p_job_title, p_min_salary, p_max_salary);
        dbms_output.enable;
        dbms_output.put_line('�ش� ���� insert �߽��ϴ�' || ' ' ||'job_id'||'='||''||p_job_id||'');
    END IF;
END;

call my_new_job_proc('IT2', 'Developer', 41000, 20000);