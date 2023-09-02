/*
1341. Movie Rating where절에 rowNum = 1
내가 생각한 방법
집계결과가 가장 높은 대상을 찾고 결과가 같은 경우 다시 오름차순 정렬을 해서 첫번째 대상을 찾기 위해
where절에 윈도우 함수를 사용해서 서브쿼리가 많아졌음
*/
select 
    name as results
  from (
    select
          a.*
        , row_number() over(partition by cnt order by name) as num -- 영화를 평가한 사람 count가 같은 사람들을 name별로 정렬 후 번호 부여
      from (
        select 
              ur.name
            , count(1) over(partition by mr.user_id order by ur.name) as cnt -- 영화를 평가한 사람 count
          from 
            MovieRating mr
            inner join Users ur on mr.user_id = ur.user_id
      ) a
  )
 where
       num = 1 -- 영화를 평가한 사람 count가 같은 사람들 중에서 1번
   and cnt = ( -- 영화를 평가한 사람 count가 가장 큰 사람
    select 
        max(usid_cnt) -- 영화를 평가한 사람 중 가장 많은 count
      from (
          select 
                ur.name
              , count(1) over(partition by mr.user_id order by ur.name) as usid_cnt -- 영화를 평가한 사람 count
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
        , row_number() over(partition by avg_rat order by title) as rat_num -- 평균 평점이 같은 대상에 대해 title 오름차순 정렬에 번호 부여
      from (
        select 
              title
            , avg(rating) as avg_rat -- 평균 평점
          from 
            MovieRating mr
            inner join Movies mv on mr.movie_id = mv.movie_id
        where
            CREATED_AT between '2020-02-01' and '2020-02-28' -- 날짜조건: 2020년 2월
        group by title
      ) a
  )
 where
    rat_num = 1 -- 평균 평점이 같은 대상 중 사전순으로 가장 낮은 대상
   and avg_rat = ( -- 평균 평점이 2020년 2월 가장 높은 평균 평점와 일치하는 대상
    select 
        max(avg_rat) -- 2020년 2월 가장 높은 평균 평점
      from (
        select
              title
            , avg(rating) as avg_rat -- 평균 평점
          from 
            MovieRating mr
            inner join Movies mv on mr.movie_id = mv.movie_id 
        where
          mr.created_at between '2020-02-01' and '2020-02-28' -- 날짜조건: 2020년 2월
        group by 
              title
      )
   )

/* 
다른 방법
집계 결과가 가장 많은 대상을 찾을 때 max()나 count(1) over()를 사용하지 않고 
group by
order by를 다 해놓고
where절에 rowNum = 1을 사용할 수 있음
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