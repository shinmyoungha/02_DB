/* VIEW
 * 
 * 	- 논리적 가상 테이블
 * 	-> 테이블 모양을 하고는 있지만, 실제로 값을 저장하고 있진 않음.
 * 
 *  - SELECT문의 실행 결과(RESULT SET)를 저장하는 객체
 * 
 * 
 * ** VIEW 사용 목적 **
 *  1) 복잡한 SELECT문을 쉽게 재사용하기 위해.
 *  2) 테이블의 진짜 모습을 감출 수 있어 보안상 유리.
 * 
 * ** VIEW 사용 시 주의 사항 **
 * 	1) 가상의 테이블(실체 X)이기 때문에 ALTER 구문 사용 불가.
 * 	2) VIEW를 이용한 DML(INSERT,UPDATE,DELETE)이 가능한 경우도 있지만
 *     제약이 많이 따르기 때문에 조회(SELECT) 용도로 대부분 사용.
 * 
 * 
 *  ** VIEW 작성법 **
 *  CREATE [OR REPLACE] [FORCE | NOFORCE] VIEW 뷰이름 [컬럼 별칭]
 *  AS 서브쿼리(SELECT문)
 *  [WITH CHECK OPTION]
 *  [WITH READ OLNY];
 * 
 * 
 * 
 *  1) OR REPLACE 옵션 : 
 * 		기존에 동일한 이름의 VIEW가 존재하면 이를 변경
 * 		없으면 새로 생성
 * 
 *  2) FORCE | NOFORCE 옵션 : 
 *    FORCE : 서브쿼리에 사용된 테이블이 존재하지 않아도 뷰 생성
 *    NOFORCE(기본값): 서브쿼리에 사용된 테이블이 존재해야만 뷰 생성
 *    
 *  3) 컬럼 별칭 옵션 : 조회되는 VIEW의 컬럼명을 지정
 * 
 *  4) WITH CHECK OPTION 옵션 : 
 * 		옵션을 지정한 컬럼의 값을 수정 불가능하게 함.
 * 
 *  5) WITH READ OLNY 옵션 :
 * 		뷰에 대해 SELECT만 가능하도록 지정.
 * */

/* VIEW 를 생성하기 위해서는 권한이 필요하다 ! */

--(SYS 관리자 계정 접속)
ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;
-- > 계정명이 언급되는 상황에서는 이 구문 필수적으로 진행!

--> VIEW 생성 권한 부여
GRANT CREATE VIEW TO kh;

-- SQL Error [1031] [42000]: ORA-01031: 권한이 불충분합니다
-- KH 계정으로 접속
-- VIEW 구문 실행
CREATE VIEW V_EMP
AS SELECT * FROM EMPLOYEE;
-- VIEW 생성 구문 기초 문법


SELECT * FROM V_EMP;


-- 사번, 이름, 부서명, 직급명 조회하기 위한 VIEW 생성
--> OR REPLACE 옵션을 사용
CREATE OR REPLACE VIEW V_EMP
AS 
SELECT EMP_ID 사번, EMP_NAME 이름,
NVL(DEPT_TITLE, '없음') 부서명, JOB_NAME 직급명
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
ORDER BY 사번 ASC;
-- SQL Error [955] [42000]: ORA-00955: 기존의 객체가 이름을 사용하고 있습니다.


SELECT * FROM V_EMP;


-- V_EMP에서 대리 직원들을 이름 오름차순으로 조회
-- VIEW 조회 결과로 보이는 컬럼명을 이용해야한다!
SELECT * FROM V_EMP
WHERE 직급명 = '대리'
ORDER BY 이름;

--------------------------------------------------------------------------------

/* VIEW를 이용해서 DML 사용하기 + 문제점 확인 */

-- DEPARTMENT 테이블을 복사한 DEPT_COPY2 생성(테이블로 생성)
CREATE TABLE DEPT_COPY2
AS SELECT * FROM DEPARTMENT;


-- DEPT_COPY2 테이블에서 DEPT_ID, LOCATION_ID 컬럼만 이용해
-- V_DCOPY2 VIEW 생성
CREATE OR REPLACE VIEW V_DCOPY2
AS SELECT DEPT_ID, LOCATION_ID FROM DEPT_COPY2;


-- V_DCOPY2 VIEW 생성 확인
SELECT * FROM V_DCOPY2;

-- 원본 테이블
SELECT * FROM DEPT_COPY2;


-- V_DCOPY2 VIEW를 이용해서 INSERT 수행
INSERT INTO V_DCOPY2
VALUES ('D0', 'L2');
-- 가상 테이블인 VIEW 인데도 INSERT 가 성공함!

SELECT * FROM V_DCOPY2;
-- D0 L2

SELECT * FROM DEPT_COPY2;

-- VIEW에 INSERT를 수행했지만
-- VIEW 생성 시 사용한 원본 테이블에
-- 값이 함께 INSERT 됨을 확인!!!


--> 모든 값이 INSERT 된것이 아니라
-- VIEW를 생성할 때 사용된 컬럼에만 데이터가 삽ㅇ비되었고
-- 사용되자 않은 컬럼(DEPT_TITLE)에는 NULL 이 들어감!
--> NULL은 DB의 무결성을 약하게 만드는 주요 원인
-- 가능하면 의도되지 않은 NULL은 존재하지 않게 해야한다

/* 무결성 : 데이터베이스에서 데이터를 정확하고일관되게
 *        유지하기 위한 중요한 개념.
 * 
 * 데이터의 정확성, 일관성, 신뢰성을 보장함
 * */


/* WITH READ ONLY 옵션 사용하기 */

-- 왜 사용할까?
--> VIEW를 이용해서 DML(INSERT/UPDATE/DELETE) 막기 위해서!


CREATE OR REPLACE VIEW V_DCOPY2
AS SELECT DEPT_ID, LOCATION_ID 
FROM DEPT_COPY2
WITH READ ONLY; -- 읽기 전용

-- INSERT 수행
INSERT INTO V_DCOPY2
VALUES('D0', 'L3');
--SQL Error [42399] [99999]: ORA-42399: 읽기 전용 뷰에서는 DML 작업을 수행할 수 없습니다.

/* SEQUENCE(순서, 연속)
 * - 순차적으로 일정한 간격의 숫자(번호)를 발생시키는 객체
 *   (번호 생성기)
 * 
 * *** SEQUENCE 왜 사용할까?? ***
 * PRIMARY KEY(기본키) : 테이블 내 각 행을 구별하는 식별자 역할
 * 						 NOT NULL + UNIQUE의 의미를 가짐
 * 
 * PK가 지정된 컬럼에 삽입될 값을 생성할 때 SEQUENCE를 이용하면 좋다!
 * 
 *   [작성법]
  CREATE SEQUENCE 시퀀스이름
  [STRAT WITH 숫자] -- 처음 발생시킬 시작값 지정, 생략하면 1이 기본
  [INCREMENT BY 숫자] -- 다음 값에 대한 증가치, 생략하면 1이 기본
  [MAXVALUE 숫자 | NOMAXVALUE(기본값)] -- 발생시킬 최대값 지정, 생략하면 기본값은 10^27 - 1 (즉, 매우 큰 값)입니다 / NOMAXVALUE를 사용하면 최대값 제한이 없음을 의미
  [MINVALUE 숫자 | NOMINVALUE(기본값)] -- 최소값 지정 , 기본값은 -10^26 /  NOMINVALUE를 사용하면 최소값 제한이 없음을 의미
  [CYCLE | NOCYCLE] -- 값 순환 여부 지정 , 기본값은 NOCYCLE
		-- CYCLE: 값이 최대값에 도달하면 다시 최소값부터 순환
		-- NOCYCLE: 값을 순환하지 않고, 최대값에 도달하면 오류를 발생시킴
  
  [CACHE 시퀀스개수 | NOCACHE] -- 기본값은 20
	-- 시퀀스의 캐시 메모리는 할당된 크기만큼 미리 다음 값들을 생성해 저장해둠
	--> 시퀀스 호출 시 미리 저장되어진 값들을 가져와 반환하므로 
	--  매번 시퀀스를 생성해서 반환하는 것보다 DB속도가 향상됨.
 * 
 * 
 * ** 사용법 **
 * 
 * 1) 시퀀스명.NEXTVAL : 다음 시퀀스 번호를 얻어옴.
 * 						 (INCREMENT BY 만큼 증가된 수)
 * 						 단, 생성 후 처음 호출된 시퀀스인 경우
 * 						 START WITH에 작성된 값이 반환됨.
 * 
 * 2) 시퀀스명.CURRVAL : 현재 시퀀스 번호를 얻어옴.
 * 						 단, 시퀀스가 생성 되자마자 호출할 경우 오류 발생.
 * 						== 마지막으로 호출한 NEXTVAL 값을 반환
 * */




/* 시퀀스 생성하기 */

CREATE SEQUENCE SEQ_TEST_NO
START WITH 100 -- 시작번호 100
INCREMENT BY 5 -- NEXTVAL 호출되면 5씩 증가
MAXVALUE 150	 -- 증가 가능한 최대값 150
NOMINVALUE	 	 -- 최소값 없음
NOCYCLE				 -- 반복 안함
NOCACHE;			 -- 미리 만들어둘 시퀀스 번호 없음

/* 시퀀스 삭제하기 */
DROP SEQUENCE SEQ_TEST_NO;

-- 시퀀스 테이블할 테이블 생성
CREATE TABLE TB_TEST(
	TEST_NO NUMBER PRIMARY KEY,
	TEST_NAME VARCHAR2(30) NOT NULL
);

-- 현재 시퀀스 번호 확인
SELECT SEQ_TEST_NO.CURRVAL FROM DUAL;
-- SQL Error [8002] [72000]: ORA-08002: 시퀀스 SEQ_TEST_NO.CURRVAL은 이 세션에서는 정의 되어 있지 않습니다
--> CURRVAL의 정확한 의미는
-- 가장 최근에 호출된 NEXTVAL의 값을 반환함을 뜻함
--> NEXTVAL을 호출한적이 없어서 오류 발생!

--> 해결방법 : NEXTVAL 호출하기
SELECT SEQ_TEST_NO.NEXTVAL FROM DUAL;
-- 시퀀스 생성 후 첫 NEXTVAL == START WITH 값인 100

SELECT SEQ_TEST_NO.CURRVAL FROM DUAL; -- 100

-- NEXTVAL 를 호출할 때 마다
-- INCREMENT BY에 작성된 수 만큼 증가하는지 확인
SELECT SEQ_TEST_NO.NEXTVAL FROM DUAL;
-- 처음 : 100
-- 1회 : 105
-- 2회 : 110
-- 3회 : 115
-- 4회 : 120

-- TB_TEST 테이블에 PK값을 SEQ_TEST_NO 시퀀스로 생성하기
INSERT INTO TB_TEST 
VALUES (SEQ_TEST_NO.NEXTVAL, '짱구'); -- 125

INSERT INTO TB_TEST 
VALUES (SEQ_TEST_NO.NEXTVAL, '철수'); -- 130

INSERT INTO TB_TEST 
VALUES (SEQ_TEST_NO.NEXTVAL, '유리'); -- 135

SELECT * FROM TB_TEST;




--------------------------------------------------------------------

-- UPDATE 에서 시퀀스 사용하기
-- '짱구'의 PK 컬럼값을
-- SEQ_TEST_NO 시퀀스의 다음 생성값으로 변경하기

UPDATE TB_TEST
SET TEST_NO = SEQ_TEST_NO.NEXTVAL
WHERE TEST_NAME = '짱구';
-- SQL Error [8004] [72000]: ORA-08004: 시퀀스 SEQ_TEST_NO.NEXTVAL exceeds MAXVALUE은 사례로 될 수 없습니다
-- MAXVALUE 150보다 더 증가할 수 없다!

SELECT * FROM TB_TEST;

-----------------------------------------------------------------------

-- SEQUENCE 변경 (ALTER)
--> START WITH 뺴고 모두 변경 가능!!

/*
 * [작성법]
 * ALTER SEQUENCE 시퀀스 이름
 * [INCREMENT BY 숫자]
 * [MAXVALUE 숫자 | NOMAXVALUE]
 * [MINVALUE 숫자 | NOMINVALUE] 
 * [CYCLE | NOCYCLE] 
 * [CACHE 숫지 | NOCACHE]
 * 
 * 
 * */

-- SEQ_TEST_NO 의 MAXVALUE 값을 200으로 수정
ALTER SEQUENCE SEQ_TEST_NO
MAXVALUE 200;


-- 200까지 증가 시켜서 변경 확인
SELECT SEQ_TEST_NO.NEXTVAL FROM DUAL;


------------------------------------------

-- VIEW, SEQUENCE 삭제

-- V_DCOPY2 VIEW 삭제
DROP VIEW V_DCOPY2;

-- SEQ_TEST_NO SEQIENCE 삭제
DROP SEQUENCE SEQ_TEST_NO;

/* INDEX(색인)
 * - SQL 구문 중 SELECT 처리 속도를 향상 시키기 위해 
 *   컬럼에 대하여 생성하는 객체
 * 
 * - 인덱스 내부 구조는 B* 트리(B-star tree) 형식으로 되어있음.
 * 
 *  
 * 
 * ** INDEX의 장점 **
 * - 이진 트리 형식으로 구성되어 자동 정렬 및 검색 속도 증가.
 * 
 * - 조회 시 테이블의 전체 내용을 확인하며 조회하는 것이 아닌
 *   인덱스가 지정된 컬럼만을 이용해서 조회하기 때문에
 *   시스템의 부하가 낮아짐.
 * 
 * 
 * ** 인덱스의 단점 **
 * - 데이터 변경(INSERT,UPDATE,DELETE) 작업 시 
 * 	 이진 트리 구조에 변형이 일어남
 *    -> DML 작업이 빈번한 경우 시스템 부하가 늘어 성능이 저하됨.
 * 
 * - 인덱스도 하나의 객체이다 보니 별도 저장공간이 필요(메모리 소비)
 * 
 * - 인덱스 생성 시간이 필요함.
 * 
 * 
 * 
 *  [작성법]
 *  CREATE [UNIQUE] INDEX 인덱스명
 *  ON 테이블명 (컬럼명[, 컬럼명 | 함수명]);
 * 
 *  DROP INDEX 인덱스명;
 * 
 * 
 *  ** 인덱스가 자동 생성되는 경우 **

 *  -> PK ,FK, UNIQUE 제약조건이 설정된 컬럼에 대해 
 *    UNIQUE INDEX가 자동 생성된다. 

 * PK에 자동 생성되는 이유 : 기본 키는 중복을 허용하지 않고, NOT NULL이어야 하기 때문이다.
 * UNIQUE 제약조건 설정 컬럼에서 자동생성 되는 이유 : 중복을 허용하지 않는 고유 값을 보장해야하기 때문이다.
 * */


SELECT ROWID,EMP_ID,EMP_NAME
FROM EMPLOYEE;
-- ROWID : 오라클에서 각 행의 고유한 주소를 나타내는 기상 컬럼(물리적 주소)
-- 인덱스가 ROWID 저장함.
-- 인덱스는 컬럼의 값과 해당행의 ROWID를 매핑해서 저장함.
-- 컬럼값 -> 해당 행의 ROWID를 빠르게 찾아낼 수 있다!

-- 현재 사용자에 생성된 인덱스 목록 조회
SELECT INDEX_NAME, TABLE_NAME, UNIQUENESS, STATUS
FROM USER_INDEXE;

-- EMPLOYEE 테이블의 EMP_NAME 컬럼에 인덱스 생성
CREATE INDEX IDX_EMP_NAME
ON EMPLOYEE (EMP_NAME);
--> EMPLOYEE 테이블의 EMP_NAME 컬럼에 대해 빠른 검색이 가능

/*
 * 인덱스명 : IDX_EMP_NAME
 * 테이블명 : EMPLOYEE
 * 컬럼명 : EMP_NAME
 * 목적 : EMP_NAME 이용한 컬럼 검색 속도 향상
 * */

-- EMPLOYEE 테이블의 EMAIL 컬럼에 UNIQUE INDEX 생성
CREATE UNIQUE INDEX IDX_UNIQUE_EMAIL
ON EMPLOYEE (EMAIL);

-- UNIQUE INDEX는 중복 방지
-- EMAIL 컬럼에는 중복되자 않는 고유한 값만 허용
--> 잘못된 EMAIL 삽입 시 오류 발생




--------------------------------------------------------------------

-- 인덱스 성능 확인용 테이블 생성
CREATE TABLE TB_IDX_TEST (
	TEST_NO NUMBER PRIMARY KEY, -- 자동으로 UNIQUE INDEX 생성됨
	TEST_ID VARCHAR2(20) NOT NULL
);


-- TB_IDX_TEST 테이블에 
-- 샘플데이터 100만개 삽입 (PL/SQL 사용)
-- * PL/SQL이란?
-- 오라클 데이터베이스에서 사용하는 절차적 확장 언어
-- 변수, 조건문(IF/CASE), 반복문(LOOP,WHILE) 사용 가능
BEGIN
	FOR I IN 1..1000000 -- I 는 1부터 100만까지 반복
	LOOP
		INSERT INTO TB_IDX_TEST
		VALUES(I, 'TEST' || I); -- || : 이어쓰기
	END LOOP;
	
	COMMIT; -- 모든 삽입 작업을 커밋
END;

SELECT COUNT(*) FROM TB_IDX_TEST; -- 100만개 행이 삽입됨을 확인

-- 인덱스를 사용해서 검색하는 방법
--> WHERE 절에 INDEX가 적용된 컬럼을 언급하기

/* 인덱스 X */
-- TEST_ID 가 'TEST500000' 인 행 조회하기
SELECT * FROM TB_IDX_TEST
WHERE TEST_ID = 'TEST500000';


/* 인덱스 O */
-- TEST_NO가 500000인 행을 조회하기
SELECT * FROM TB_IDX_TEST
WHERE TEST_NO = 500000;

-- 보통 10~30배 차이






































