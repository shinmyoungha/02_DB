DROP TABLE TB_MEMBER;
DROP TABLE TB_GRADE;
DROP TABLE TB_AREA;

CREATE TABLE "TB_MEMBER" (
	MEMBER_ID VARCHAR2(20),
	MEMBER_PWD VARCHAR2(20),
	MEMBER_NAME VARCHAR2(30),
	GRADE number(14),
	AREA_CODE number(20)
);

SELECT * FROM TB_MEMBER;

INSERT INTO "TB_MEMBER" (MEMBER_ID, MEMBER_PWD, MEMBER_NAME, GRADE, AREA_CODE)
VALUES ('hong01', 'pass01', '홍길동', 10, 02);

INSERT INTO "TB_MEMBER" (MEMBER_ID, MEMBER_PWD, MEMBER_NAME, GRADE, AREA_CODE)
VALUES ('leess99', 'pass02', '이순신', 10, 032);

INSERT INTO "TB_MEMBER" (MEMBER_ID, MEMBER_PWD, MEMBER_NAME, GRADE, AREA_CODE)
VALUES ('ss50000', 'pass03', '신사임당', 30, 031);

INSERT INTO "TB_MEMBER" (MEMBER_ID, MEMBER_PWD, MEMBER_NAME, GRADE, AREA_CODE)
VALUES ('iu93', 'pass04', '아이유', 30, 02);

INSERT INTO "TB_MEMBER" (MEMBER_ID, MEMBER_PWD, MEMBER_NAME, GRADE, AREA_CODE)
VALUES ('pcs1324', 'pass05', '박철수', 12, 031);

INSERT INTO "TB_MEMBER" (MEMBER_ID, MEMBER_PWD, MEMBER_NAME, GRADE, AREA_CODE)
VALUES ('you_js', 'pass06', '유재석', 10, 02);

INSERT INTO "TB_MEMBER" (MEMBER_ID, MEMBER_PWD, MEMBER_NAME, GRADE, AREA_CODE)
VALUES ('kyh9876', 'pass07', '김영희', 20, 031);

SELECT * FROM TB_MEMBER;



CREATE TABLE "TB_GRADE" (
	GRADE_CODE number(20),
	GRADE_NAME VARCHAR2(30)
);

SELECT * FROM TB_GRADE;

INSERT INTO "TB_GRADE" (GRADE_CODE, GRADE_NAME)
VALUES (10, '일반회원');

INSERT INTO "TB_GRADE" (GRADE_CODE, GRADE_NAME)
VALUES (20, '우수회원');

INSERT INTO "TB_GRADE" (GRADE_CODE, GRADE_NAME)
VALUES (30, '특별회원');


SELECT * FROM TB_GRADE;

CREATE TABLE "TB_AREA" (
	AREA_CODE number(20),
	AREA_NAME VARCHAR2(30)
);

INSERT INTO "TB_AREA" (AREA_CODE, AREA_NAME)
VALUES (02, '서울');

INSERT INTO "TB_AREA" (AREA_CODE, AREA_NAME)
VALUES (031, '경기');

INSERT INTO "TB_AREA" (AREA_CODE, AREA_NAME)
VALUES (032, '인천');

SELECT * FROM TB_AREA;

SELECT AREA_NAME 지역명, MEMBER_ID 아이디, MEMBER_NAME 이름, GRADE_NAME 등급명
FROM TB_MEMBER
JOIN TB_AREA USING (AREA_CODE)
JOIN TB_GRADE ON (GRADE = GRADE_CODE)
WHERE AREA_CODE = (
    SELECT AREA_CODE FROM TB_MEMBER
    WHERE MEMBER_NAME = '김영희')
ORDER BY 이름 ;









































CREATE TABLE "TB_MEMBER" (
	MEMBER_ID VARCHAR2(20),
	MEMBER_PWD VARCHAR2(20),
	MEMBER_NAME VARCHAR2(30),
	GRADE VARCHAR2(14),
	AREA_CODE VARCHAR2(20)
);

SELECT * FROM TB_MEMBER;

INSERT INTO "TB_MEMBER" (MEMBER_ID, MEMBER_PWD, MEMBER_NAME, GRADE, AREA_CODE)
VALUES ('hong01', 'pass01', '홍길동', 10, 02);

INSERT INTO "TB_MEMBER" (MEMBER_ID, MEMBER_PWD, MEMBER_NAME, GRADE, AREA_CODE)
VALUES ('leess99', 'pass02', '이순신', 10, 032);

INSERT INTO "TB_MEMBER" (MEMBER_ID, MEMBER_PWD, MEMBER_NAME, GRADE, AREA_CODE)
VALUES ('ss50000', 'pass03', '신사임당', 30, 031);

INSERT INTO "TB_MEMBER" (MEMBER_ID, MEMBER_PWD, MEMBER_NAME, GRADE, AREA_CODE)
VALUES ('iu93', 'pass04', '아이유', 30, 02);

INSERT INTO "TB_MEMBER" (MEMBER_ID, MEMBER_PWD, MEMBER_NAME, GRADE, AREA_CODE)
VALUES ('pcs1324', 'pass05', '박철수', 12, 031);

INSERT INTO "TB_MEMBER" (MEMBER_ID, MEMBER_PWD, MEMBER_NAME, GRADE, AREA_CODE)
VALUES ('you_js', 'pass06', '유재석', 10, 02);

INSERT INTO "TB_MEMBER" (MEMBER_ID, MEMBER_PWD, MEMBER_NAME, GRADE, AREA_CODE)
VALUES ('kyh9876', 'pass07', '김영희', 20, 031);

SELECT * FROM TB_MEMBER;



CREATE TABLE "TB_GRADE" (
	GRADE_CODE VARCHAR2(20),
	GRADE_NAME VARCHAR2(30)
);

SELECT * FROM TB_GRADE;

INSERT INTO "TB_GRADE" (GRADE_CODE, GRADE_NAME)
VALUES (10, '일반회원');

INSERT INTO "TB_GRADE" (GRADE_CODE, GRADE_NAME)
VALUES (20, '우수회원');

INSERT INTO "TB_GRADE" (GRADE_CODE, GRADE_NAME)
VALUES (30, '특별회원');


SELECT * FROM TB_GRADE;




CREATE TABLE "TB_AREA" (
	AREA_CODE VARCHAR2(20),
	AREA_NAME VARCHAR2(30)
);

INSERT INTO TB_AREA (AREA_CODE, AREA_NAME)
VALUES ('02', '서울');

INSERT INTO TB_AREA (AREA_CODE, AREA_NAME)
VALUES ('031', '경기');

INSERT INTO TB_AREA (AREA_CODE, AREA_NAME)
VALUES ('032', '인천');

SELECT * FROM TB_AREA;


SELECT AREA_NAME 지역명, MEMBER_ID 아이디, MEMBER_NAME 이름, GRADE_NAME 등급명
FROM TB_MEMBER
JOIN TB_GRADE ON(GRADE = GRADE_CODE)
JOIN TB_AREA ON (AREA_CODE = AREA_CODE)
WHERE AREA_CODE = (
    SELECT AREA_CODE FROM TB_MEMBER
    WHERE 이름 = '김영희')
ORDER BY 이름 DESC;
