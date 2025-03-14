/*
 * DCL (Data Control Language) : 데이터를 다루기 위한 권한을 다루는 언어
 * 
 * - 계정에 DB, DB객체에 대한 접근 권한을
 * 	 부여(GRANT)하고 회수(REVOKE)하는 언어
 * 
 * * 권한의 종류
 * 
 * 1) 시스템 권한 : DB접속, 객체 생성 권한
 * 		
 * 		CREATE SESSION   : 데이터베이스 접속 권한
 * 		CREATE TABLE     : 테이블 생성 권한
 * 		CREATE VIEW      : 뷰 생성 권한
 *    CREATE SEQUENCE  : 시퀀스 생성권한
 * 		CREATE PROCEDURE : 함수(프로시져) 생성 권한
 * 		CREATE USER		 	 : 사용자(계정) 생성 권한
 * 		
 * 		DROP USER 		 	 : 사용자(계정) 삭제 권한
 * 
 * 2) 객체 권한 : 특정 객체를 조작할 수 있는 권한
 * 
 * 		권한 종류 			설정 객체
 * 
 * 		SELECT           TABLE, VIEW, SEQUENCE
 *    INSERT           TABLE, VIEW
 * 		UPDATE			 		 TABLE, VIEW
 * 		DELETE					 TABLE, VIEW
 * 		ALTER			 			 TABLE, SEQUENCE (수정 권환 - 구조 변경)
 * 		REFERENCES 		 	 TABLE					 (참조권한 - 외래키(FK) 설정할 권한)
 * 		INDEX			 			 TABLE					 (인덱스 생성 권한)
 * 		EXECUTE			     PROCEDURE			 (실행 권한 - 프로시저(함수)를 실행할 권한)
 * 
 * */


/*
 * USER - 계정 (사용자)
 * 
 * * 관리자 계정 : 데이터베이스의 생성과 관리를 담당하는 계정.
 * 					모든 권한과 책임을 가지는 계정.
 * 					ex) sys(최고관리자), system(sys에서 권한 몇개가 제외된 관리자)
 * 
 * 
 * * 사용자 계정 : 데이터베이스에 대하여 질의, 갱신, 보고서 작성 등의
 * 					작업을 수행할 수 있는 계정으로
 * 					업무에 필요한 최소한의 권한만을 가지는것을 원칙으로 한다.
 * 					ex) kh, workbook 등
 
 * 
 * */

-- 1. (sys) 사용자 계정 생성
ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;
--> 예전 SQL 방식 허용 (계정명을 간단히 작성 가능)

--[작성법]
-- CREATE USER 사용자명 IDENTIFIED BY 비밀번호;
CREATE USER smh_sample IDENTIFIED BY 1234;

-- 2. 새 연결(접속) 추가
-- ORA-01045: 사용자 SMH_SAMPLE는 CREATE SESSION 권한을 가지고있지 않음; 로그온이 거절되었습니다
--> 접속 권한

-- 3. 접속 권한 부여 (sys -> 사용자 계정)
-- [권한 부여 작성법]
-- GRANT 권한, 권한, 권한... TO 사용자명;
GRANT CREATE SESSION TO smh_sample;

-- 4. 다시 연결 --> 성공!

-- 5. (sample) 테이블 생성
CREATE TABLE TB_TEST(
	PK_COL NUMBER PRIMARY KEY,
	CONTENT VARCHAR2(100)
);
-- SQL Error [1031] [42000]: ORA-01031: 권한이 불충분합니다
-- CREATE TABLE : 테이블 생성 권한
-- + 데이터를 저장할 수 있는 공간(TABLESPACE) 할당

-- 6. (sys) 테이블 생성 권한 부여 + TABLESPACE 할당
GRANT CREATE TABLE TO smh_sample;

ALTER USER smh_sample DEFAULT 
TABLESPACE SYSTEM QUOTA UNLIMITED ON SYSTEM;

-- 7. (sample) 테이블 다시 생성
CREATE TABLE TB_TEST(
	PK_COL NUMBER PRIMARY KEY,
	CONTENT VARCHAR2(100)
);

--------------------------------------------------------

-- ROLE(역할) : 권한 묶음
--> 묶어둔 권한(ROLE) 특정 계정에 부여
--> 해당 계정은 지정된 권한을 이용해서 특정 역할을 갖게된다.

-- CONNECT / RESOURCE : 사용자에게 부여할 수 있는 기본적인 시스템 역할.

-- CONNECT : DB 접속 관련 권한을 묶어둔 ROLE
--> CREATE SESSION , ALTER SESSION.. 

-- RESOURCE : DB 사용을 위한 기본 객체 생성 권한을 묶어둔 ROLE
--> CREATE TABLE, CREATE SEQUENCE,..

-- (sys) sample 계정에 CONNECT, RESOURCE ROLE 부여
GRANT CONNECT, RESOURCE TO cmh_sample;


-----------------------------------------------------

-- /* 객체 권한 */

-- kh / sample 사용자 계정끼리 서로 객체 접근 권한 부여

-- 1. (sample) kh 계정의 EMPLOYEE 테이블 조회
SELECT * FROM EMPLOYEE;
-- ORA-00942: 테이블 또는 뷰가 존재하지 않습니다
--> 접근 권한이 없어서 조회 불가

-- 2. (kh) sample 계정에 EMPLOYEE 테이블 조회 권한 부여
-- [객체 권한 부여 방법]
-- GRANT 객체권한 ON 객체명 TO 사용자명;
GRANT SELECT ON EMPLOYEE TO cmh_sample;


-- 3. (sample) 다시 kh 계정의 EMPLOYEE 조회
SELECT * FROM kh.EMPLOYEE; --> 조회 잘 된다!
SELECT * FROM kh.DEPTARTMENT; --> 조회 안된다
--> 위에서 kh가 EMPLOYEE 조회하는 권한만 주었기 때문에..



-- 4. (kh) sample 계정에 부여했던 EMPLOYEE 
-- 테이블 조회 권한 회수(REVOKE)

-- [권한 회수 작성법]
-- REVOKE 객체권한 ON 객체명 FROM 사용자명;
REVOKE SELECT ON EMPLOYEE FROM cmh_sample;

-- 5. (sample) EMPLOYEE 조회해보기
SELECT * FROM kh.EMPLOYEE; --> 조회 안된다.















































