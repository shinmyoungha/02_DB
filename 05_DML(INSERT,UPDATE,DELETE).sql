-- ** DML(Data Manipulation Language)

-- 테이블에 값을 삽입하거나(INSERT), 수정하거나(UPDATE), 삭제(DELETE) 하는 구문

-- 주의 : 혼자서 COMMIT, ROLLBACK 수행 하지 말 것!
-- 윈도우 > 설정 > 연결 > 연결유형 Auto commit by default 체크 해제 되어있는지 다시 확인!

-- 테스트용 테이블 생성
CREATE TABLE EMPLOYEE2 AS SELECT * FROM EMPLOYEE;
CREATE TABLE DEPARTMENT2 AS SELECT * FROM DEPARTMENT;

SELECT * FROM EMPLOYEE2;
SELECT * FROM DEPARTMENT2;

---------------------------------------------------------------------------------------

-- 1. INSERT

-- 테이블에 새로운 행을 추가하는 구문

-- 1) INSERT INTO 테이블명 VALUES(데이터, 데이터, 데이터..)
-- 테이블에 있는 모든 컬럼에 대한 값을 INSERT 할 때 사용.
-- 단, 컬럼의 순서를 지켜서 VALUES에 값을 기입해야함.
SELECT * FROM EMPLOYEE2;

INSERT INTO EMPLOYEE2 
VALUES('900', '홍길동', '991215-1234567', 'hong_gd@or.kr', 
  '01011111111', 'D1', 'J7', 'S3', 4300000, 0.2,
  200, SYSDATE, NULL, 'N');

SELECT * FROM EMPLOYEE2
WHERE EMP_ID = '900';

ROLLBACK; -- 홍길동 사라짐



-- 2) INSERT INTO 테이블명 (컬럼명1, 컬럼명2, 컬럼명3..)
-- 		VALUES(데이터1, 데이터2, 데이터3..);
-- 테이블에 내가 선택한 컬럼에 대한 값만 INSERT 할 때 사용
-- 선택 안된 컬럼은 값이 NULL이 들어감 (DEFAULT 존재 시 DEFAULT 설정한 값이 삽입됨)

INSERT INTO EMPLOYEE2 (EMP_ID, EMP_NAME, EMP_NO, EMAIL, PHONE,
  DEPT_CODE, JOB_CODE, SAL_LEVEL, SALARY)
VALUES ('900', '홍길동', '991215-1234567', 'hong_gd@or.kr', 
'01011111111', 'D1', 'J7', 'S3', 4300000);

SELECT * FROM EMPLOYEE2
WHERE EMP_ID = '900';


COMMIT; -- 홍길동 데이터 영구저장

ROLLBACK; -- ROLLBACK 수행해봄

SELECT * FROM EMPLOYEE2
WHERE EMP_ID = '900';
-- 조회 다시해봄(영구저장 되었기 떄문에 롤백해도 되돌리기 안됨)

----------------------------------------------------------------------------

-- INSERT 시 VALUES 대신 서브쿼리 이용하여 삽입하기

CREATE TABLE EMP_01(
	EMP_ID NUMBER,
	EMP_NAME VARCHAR2(30),
	DEPT_TITLE VARCHAR2(20)
);

SELECT * FROM EMP_01;

SELECT EMP_ID, EMP_NAME, DEPT_TITLE
FROM EMPLOYEE2
LEFT JOIN DEPARTMENT2 ON(DEPT_CODE = DEPT_ID);

-- 서브퀴리(SELECT) 결과를 EMP_01 테이블에 INSERT
--> SELECT 조회 결과의 데이터 타이브 컬럼 개수가
-- INSERT 하려는 테이블의 컬럼과 일치해야함

INSERT INTO EMP_01(
		SELECT EMP_ID, EMP_NAME, DEPT_TITLE
		FROM EMPLOYEE2
		LEFT JOIN DEPARTMENT2 ON(DEPT_CODE = DEPT_ID)
);

SELECT * FROM EMP_01;

---------------------------------------------------------------------

-- 2. UPDATE (내용을 바꾸던가 추가해서 최신화)
-- 테이블에 기록된 컬럼의 값을 수정하는 구문

-- [작성법]
/*
 * UPDATE 테이블명
 * SET 컬럼명 = 바꿀값
 * [WHERE 컬럼명 비교연산자 비교값];
 * 
 * --> WHERE 조건 중요!
 * 
 * */

-- DEPARTMENT2 테이블에서 DEPT_ID가 'D9'인 부서 정보 조회
SELECT * FROM DEPARTMENT2
WHERE DEPT_ID = 'D9';

-- DEPARTMENT2 테이블에서 DEPT_ID가 'D9'인 부서의
-- DEPT_TITLE을 '전략기획팀' 으로 수정
UPDATE DEPARTMENT2
SET DEPT_TITLE = '전략기획팀'
WHERE DEPT_ID = 'D9';

-- UPDATE 확인
SELECT * FROM DEPARTMENT2
WHERE DEPT_ID = 'D9';



-- EMPLOYEE2 테이블에서 BONUS를 받지 않는 사원의
-- BONUS를 0.1로 변경

SELECT * FROM EMPLOYEE2;

UPDATE EMPLOYEE2
SET BONUS = 0.1
WHERE BONUS IS NULL; -- 15개 행 수정

SELECT EMP_NAME, BONUS FROM EMPLOYEE2;

-------------------------------------------------------------

-- * 조건절을 설정하지 ㅏㅇㄶ고 UPDATE 구문 실행 시
-- 모든 행의 컬럼값이 변경 *

SELECT * FROM DEPARTMENT2;

UPDATE DEPARTMENT2
SET DEPT_TITLE = '기술연구팀';


ROLLBACK;

SELECT * FROM DEPARTMENT2;

-------------------------------------------------------------

-- * 여러 컬럼을 한번에 수정할 시 컴마(,) 로 컬럼을 구분하면 됨.
-- D9 / 총무부 --> D0 / 전략기획팀 변경

UPDATE DEPARTMENT2
SET DEPT_ID = 'D0',
DEPT_TITLE = '전략기획팀' -- WHERE 절 직전 컬럼 컴마 X 
WHERE DEPT_ID = 'D9'
AND DEPT_TITLE = '총무부';

SELECT * FROM DEPARTMENT2;


--------------------------------------------------------------------------------------

-- * UPDATE 시에도 서브쿼리 사용 가능

-- [작성법]
-- UPDATE 테이블명
-- SET 컬럼명 = (서브쿼리)


-- EMPLOYEE2 테이블에서 
-- 방명수 사원의 급여와 보너스율을
-- 유재식 사원과 동일하게 변경해주기로 함.
-- 이를 반영하는 UPDATE문을 서브쿼리를 이용하여 작성.

-- 유재식 급여 조회
SELECT SALARY FROM EMPLOYEE2
WHERE EMP_NAME = '유재식'; -- 3,400,000

-- 유재식 보너스율 조회
SELECT BONUS FROM EMPLOYEE2
WHERE EMP_NAME = '유재식'; -- 0.2

-- 방명수 급여, 보너스 수정
UPDATE EMPLOYEE2
SET SALARY = (SELECT SALARY FROM EMPLOYEE2
							WHERE EMP_NAME = '유재식'),
		BONUS = (SELECT BONUS FROM EMPLOYEE2
							WHERE EMP_NAME = '유재식')
WHERE EMP_NAME = '방명수';

SELECT EMP_NAME, SALARY, BONUS 
FROM EMPLOYEE2
WHERE EMP_NAME IN ('유재식', '방명수');



------------------------------------------------------------------


-- 3. MARGE (병합)
-- 구조가 같은 두 개의 테이블을 하나로 합치는 기능
-- 테이블에서 지정하는 조건의 값이 존재하면 UPDATE
-- 없으면 INSERT 됨

CREATE TABLE EMP_M01
AS SELECT * FROM EMPLOYEE;

CREATE TABLE EMP_M02
AS SELECT * FROM EMPLOYEE
WHERE JOB_CODE = 'J4';

SELECT * FROM EMP_M01;
SELECT * FROM EMP_M02;

INSERT INTO EMP_M02
VALUES(999, '곽두원', '561016-1234567', 'kwack_dw@OR,kr',
'01011112222', 'D9', 'J4', 'S1', 9000000, 0.5, NULL, SYSDATE, NULL, 'N');


SELECT * FROM EMP_M01; -- 23명
SELECT * FROM EMP_M02; -- 5명 (기존 4 + 신규 1)

UPDATE EMP_M02 SET SALARY = 0;

MERGE INTO EMP_M01 USING EMP_M02 ON(EMP_M01.EMP_ID = EMP_M02.EMP_ID)
WHEN MATCHED THEN
UPDATE SET
	EMP_M01.EMP_NAME = EMP_M02.EMP_NAME,
	EMP_M01.EMP_NO = EMP_M02.EMP_NO,
	EMP_M01.EMAIL = EMP_M02.EMAIL,
	EMP_M01.PHONE = EMP_M02.PHONE,
	EMP_M01.DEPT_CODE = EMP_M02.DEPT_CODE,
	EMP_M01.JOB_CODE = EMP_M02.JOB_CODE,
	EMP_M01.SAL_LEVEL = EMP_M02.SAL_LEVEL,
	EMP_M01.SALARY = EMP_M02.SALARY,
	EMP_M01.BONUS = EMP_M02.BONUS,
	EMP_M01.MANAGER_ID = EMP_M02.MANAGER_ID,
	EMP_M01.HIRE_DATE = EMP_M02.HIRE_DATE,
	EMP_M01.ENT_DATE = EMP_M02.ENT_DATE,
	EMP_M01.ENT_YN = EMP_M02.ENT_YN
WHEN NOT MATCHED THEN
INSERT VALUES(EMP_M02.EMP_ID, EMP_M02.EMP_NAME, EMP_M02.EMP_NO, EMP_M02.EMAIL, 
	         EMP_M02.PHONE, EMP_M02.DEPT_CODE, EMP_M02.JOB_CODE, EMP_M02.SAL_LEVEL, 	  	         
	         EMP_M02.SALARY, EMP_M02.BONUS, EMP_M02.MANAGER_ID, EMP_M02.HIRE_DATE, 
	         EMP_M02.ENT_DATE, EMP_M02.ENT_YN);




SELECT * FROM EMP_M01;

---------------------------------------------------------------------------------------------------------------------------

-- 4. DELETE
-- 테이블의 행을 삭제하는 구문

-- [작성법]
-- DELETE FROM 테이블명
-- [WHERE 조건설정];
-- 만약에 WHERE 조건을 설정하지 않으면 모든 행이 다 삭제됨!

COMMIT;

SELECT * FROM EMPLOYEE2
WHERE EMP_NAME = '홍길동';

-- 홍길동 삭제하기
DELETE FROM EMPLOYEE2 
WHERE EMP_NAME = '홍길동';

-- 삭제 확인
SELECT * FROM EMPLOYEE2
WHERE EMP_NAME = '홍길동';

ROLLBACK; -- 마지막 커밋 시점까지 돌아감

SELECT * FROM EMPLOYEE2
WHERE EMP_NAME = '홍길동'; -- 조회 결과 나옴



-- EMPLOYEE2 테이블 전체 삭제
DELETE FROM EMPLOYEE2;
-- WHERE 절 미작성시 모든 행을 다 삭제!

SELECT * FROM EMPLOYEE2;

ROLLBACK;

SELECT * FROM EMPLOYEE2;

-- DELETE 문에서도 서브쿼리 사용 가능!
DELETE FROM EMPLOYEE2 
WHERE EMP_ID IN(
	SELECT EMP_ID
	FROM EMPLOYEE2
	WHERE SALARY >= 3000000
);

ROLLBACK;


----------------------------------------------------------------------

-- 5. TRUNCATE(DML 아님. DDL 입니다!)
-- 테이블의 전체 행을 삭제하 DDL
-- DELETE 보다 수행속도 더 빠름
-- ROLLBACK을 통해 복구 할 수 없다.

-- TRUNCATE 테스트용 테이블 생성
CREATE TABLE EMPLOYEE3
AS SELECT * FROM EMPLOYEE2;

-- 생성 확인
SELECT * FROM EMPLOYEE3;


-- TRUNCATE 로 삭제
TRUNCATE TABLE EMPLOYEE3;

-- 삭제 확인
SELECT * FROM EMPLOYEE3; -- 삭제됨

ROLLBACK;

-- 롤백 후 복구 확인
SELECT * FROM EMPLOYEE3;

-- DELETE : 휴지통에 버리기
-- TRUNCATE : 완전 삭제





















