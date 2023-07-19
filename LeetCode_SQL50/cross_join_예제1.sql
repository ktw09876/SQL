/*
ó������ cross join�� ���� ������ ���غ���
group by count(*)�� �� null�� �����͸� count 0���� ����ϴ� ������
cross join�� �ߺ��Ǵ� ���� on������ join�������� �����Ѵ�.
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
