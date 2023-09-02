/*
1341. Movie Rating where���� rowNum = 1
���� ������ ���
�������� ���� ���� ����� ã�� ����� ���� ��� �ٽ� �������� ������ �ؼ� ù��° ����� ã�� ����
where���� ������ �Լ��� ����ؼ� ���������� ��������
*/
select 
    name as results
  from (
    select
          a.*
        , row_number() over(partition by cnt order by name) as num -- ��ȭ�� ���� ��� count�� ���� ������� name���� ���� �� ��ȣ �ο�
      from (
        select 
              ur.name
            , count(1) over(partition by mr.user_id order by ur.name) as cnt -- ��ȭ�� ���� ��� count
          from 
            MovieRating mr
            inner join Users ur on mr.user_id = ur.user_id
      ) a
  )
 where
       num = 1 -- ��ȭ�� ���� ��� count�� ���� ����� �߿��� 1��
   and cnt = ( -- ��ȭ�� ���� ��� count�� ���� ū ���
    select 
        max(usid_cnt) -- ��ȭ�� ���� ��� �� ���� ���� count
      from (
          select 
                ur.name
              , count(1) over(partition by mr.user_id order by ur.name) as usid_cnt -- ��ȭ�� ���� ��� count
            from 
              MovieRating mr
              inner join Users ur on mr.user_id = ur.user_id
        ) a
    )
    
Union all

select 
    title as results
  from (
    select
          a.*
        , row_number() over(partition by avg_rat order by title) as rat_num -- ��� ������ ���� ��� ���� title �������� ���Ŀ� ��ȣ �ο�
      from (
        select 
              title
            , avg(rating) as avg_rat -- ��� ����
          from 
            MovieRating mr
            inner join Movies mv on mr.movie_id = mv.movie_id
        where
            CREATED_AT between '2020-02-01' and '2020-02-28' -- ��¥����: 2020�� 2��
        group by title
      ) a
  )
 where
    rat_num = 1 -- ��� ������ ���� ��� �� ���������� ���� ���� ���
   and avg_rat = ( -- ��� ������ 2020�� 2�� ���� ���� ��� ������ ��ġ�ϴ� ���
    select 
        max(avg_rat) -- 2020�� 2�� ���� ���� ��� ����
      from (
        select
              title
            , avg(rating) as avg_rat -- ��� ����
          from 
            MovieRating mr
            inner join Movies mv on mr.movie_id = mv.movie_id 
        where
          mr.created_at between '2020-02-01' and '2020-02-28' -- ��¥����: 2020�� 2��
        group by 
              title
      )
   )

/* 
�ٸ� ���
���� ����� ���� ���� ����� ã�� �� max()�� count(1) over()�� ������� �ʰ� 
group by
order by�� �� �س���
where���� rowNum = 1�� ����� �� ����
*/
select name results
  from (
    select 
          u.user_id
        , u.name
        , count(distinct movie_id) mv_cnt
      from 
        MovieRating m
        inner join Users u on u.user_id = m.user_id
    group by u.user_id, u.name
    order by mv_cnt desc, u.name
  )
 where rowNum = 1

union all

select title results
  from(
    select 
          m2.movie_id
        , m2.title
        , avg(m1.rating) avg_rt
      from 
        MovieRating m1
        inner join Movies m2 on m1.movie_id = m2.movie_id
     where to_char(m1.created_at, 'YYYY-MM') = '2020-02'
    group by m2.movie_id, m2.title
    order by avg_rt desc, m2.title
)
where rowNum = 1