/*
처음으로 cross join에 대한 개념을 접해봤음
group by count(*)할 때 null인 데이터를 count 0으로 출력하는 예제임
cross join후 중복되는 행은 on절에서 join조건으로 제어한다.
*/
--LeetCode SQL50 - Students and Examinations
select
      st.student_id
    , st.student_name 
    , su.subject_name
    , count(ex.student_id) as attended_exams 
  from 
    Students st 
    cross join Subjects su 
    left outer join Examinations ex 
  on 
        st.student_id = ex.student_id 
    and su.subject_name = ex.subject_name
group by
      st.student_id
    , st.student_name 
    , su.subject_name
order by 1, 3
