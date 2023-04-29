
create or replace PROCEDURE my_new_job_proc( -- 생성 or 기존의 프로시저를 바꿈 'or REPLACE' 는 확인 후 사용해야 함, 사용자.프로시저 명
    p_job_id IN jobs.job_id%TYPE, -- 'p_job_id' 라는 매개변수를 선언하는 데 'jobs' 테이블의 'job_id' 컬럼과 동일한 데이터 타입을 갖는다
    p_job_title IN jobs.job_title%TYPE,
    p_min_salary IN jobs.min_salary%TYPE,
    p_max_salary IN jobs.max_salary%TYPE
)
IS -- 변수 선언
    cnt NUMBER := 0;
BEGIN -- 실행될 내용
    SELECT COUNT(job_id) INTO cnt -- select 한 COUNT(job_id) 를 cnt 에 담는다
      FROM jobs 
     WHERE job_id = p_job_id;
     
    IF cnt != 0 THEN -- 만약 select 한 COUNT(job_id)에 값이 있으면
    
        -- update 를 실행하고
        UPDATE jobs 
        SET 
            job_title = p_job_title,
            min_salary = p_min_salary,
            max_salary = p_max_salary
        WHERE
            job_id = p_job_id;
        dbms_output.enable; -- 다음 행 문장을 출력
        dbms_output.put_line('해당 값을 update 했습니다' || ' ' ||'job_id'||'='||''||p_job_id||'');
    ELSE -- 만약 select 한 COUNT(job_id)에 값이 없으면
    
        -- insert 를 실행한다
        INSERT INTO jobs(job_id, job_title, min_salary, max_salary) 
        VALUES(p_job_id, p_job_title, p_min_salary, p_max_salary);
        dbms_output.enable;
        dbms_output.put_line('해당 값을 insert 했습니다' || ' ' ||'job_id'||'='||''||p_job_id||'');
    END IF;
END;

call my_new_job_proc('IT2', 'Developer', 41000, 20000);