CREATE OR REPLACE PROCEDURE test_ocdm53c1.pr_make_drug_era()
	LANGUAGE plpgsql
AS $procedure$
DECLARE-- 변수 
	source_t record;
	target_t record;
	cnt int4;
	next_drug_era_id int4; -- 다음에 drug_era에 인서트할 인덱스 번호 
	last_drug_era_id int4; -- 이전에 drug_era에 인서트했던 인덱스 번호
commit_gap int4 := 20000; -- 몇 개의 로우마다 커밋할 지  
BEGIN
	TRUNCATE TABLE test_ocdm53c1.drug_era;-- test_ocdm53c1.drug_era테이블 초기화
	ALTER SEQUENCE test_ocdm53c1.test_index2 RESTART WITH1;-- 시퀀스 번호를 1로 초기화
	SELECT count(*) INTO cnt FROM test_ocdm53c1.drug_era; -- cnt에 test_ocdm53c1.drug_era count(*)를 할당
	
	FOR source_t IN
		SELECT a.*
			,CASE WHEN drug_exposure_start_date - lag_end_date < 0 THEN 0 -- 음수인 경우는 0으로 치환
				  ELSE drug_exposure_start_date - lag_end_date - 1
			   END AS gap_days
		  FROM(
			SELECT
				 drug_exposure_id
				,person_id
				,drug_concept_id
				,drug_exposure_start_date
				,drug_exposure_end_date
				,LAG(drug_exposure_end_date) OVER(PARTITION BY person_id, drug_concept_id ORDER BY drug_exposure_start_date) AS lag_end_date
			FROM test_ocdm53c1.drug_exposure a -- 431,357
		) a
	LOOP
	
		IF cnt = 0 THEN--test_ocdm53c1.drug_era의 데이터가 없으면: 인서트
			SELECT nextval('test_ocdm53c1.test_index2') INTO next_drug_era_id;
			INSERT INTO test_ocdm53c1.drug_era VALUES( -- source_t의 1개 행을 test_ocdm53c1.drug_era에 인서트
				 next_drug_era_id
				,source_t.person_id
				,source_t.drug_concept_id
				,source_t.drug_exposure_start_date
				,coalesce(source_t.drug_exposure_end_date, source_t.drug_exposure_start_date)
				,1
				,0
			);
			
			SELECT count(*) INTO cnt FROM test_ocdm53c1.drug_era;
			RAISE NOTICE 'test_ocdm53c1.drug_era count(*) = %, insert 완료', cnt;
		ELSE -- test_ocdm53c1.condition_era의 데이터가 1개 이상 이면
			SELECT lastval() INTO last_drug_era_id;
			
			IF source_t.lag_end_date + 30 < source_t.drug_exposure_start_date OR source_t.lag_end_date IS NULL THEN -- drug_end_date 이후 30일이 넘어서 재방문이면
				SELECT nextval('test_ocdm53c1.test_index2') INTO next_drug_era_id;-- 인덱스 1 증가 후 
				INSERT INTO test_ocdm53c1.drug_era VALUES( -- 인서트
					 next_drug_era_id
					,source_t.person_id
					,source_t.drug_concept_id
					,source_t.drug_exposure_start_date
					,coalesce(source_t.drug_exposure_end_date, source_t.drug_exposure_start_date)
					,1
					,0
				)
				;
				
				RAISE NOTICE'% - 30 >= %, %, %: 인서트 완료', source_t.drug_exposure_end_date, source_t.lag_end_date, source_t.drug_exposure_id, next_drug_era_id;
				SELECT count(*) INTO cnt FROM test_ocdm53c1.drug_era;
				
				IF cnt % commit_gap = 0 THEN-- test_ocdm53c1.condition_era의 count(*)이 10000/ 20000/ ... 2만개마다
					COMMIT;-- commit한다
					RAISE NOTICE'count(*) = %: 커밋 완료', cnt;
				END IF;
			ELSE -- drug_end_date 이후 30일이 넘기 전에 즉, 마지막 drug_end_date 이후 30일이 지나기 전에 재방문한 경우
				UPDATE 
					test_ocdm53c1.drug_era
				SET
					 drug_era_end_date = coalesce(source_t.drug_exposure_end_date, source_t.drug_exposure_start_date) --end_date를 업데이트/ null이면 start_date로 업데이트
					,drug_exposure_count = drug_exposure_count + 1--방문한 count + 1로 업데이트
					,gap_days = gap_days + source_t.gap_days -- gap_days 업데이트
				WHERE
					drug_era_id = last_drug_era_id-- 그 전에 방문했던 기록을 업데이트
				;
				
				SELECT * INTO target_t FROM test_ocdm53c1.drug_era;
				RAISE NOTICE '% - 30 < or  %, drug_exposure_id:%, drug_era_id:%, last_drug_era_id:% 업데이트 완료', source_t.drug_exposure_end_date, source_t.lag_end_date, source_t.drug_exposure_id, target_t.drug_era_id, last_drug_era_id;
			END IF;
		END IF;
	END LOOP;
END;
$procedure$
;
