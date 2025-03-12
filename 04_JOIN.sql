/*
[JOIN 용어 정리]
  오라클                                   SQL : 1999표준(ANSI)
----------------------------------------------------------------------------------------------------------------
등가 조인                                   내부 조인(INNER JOIN), JOIN USING / ON
                                         + 자연 조인(NATURAL JOIN, 등가 조인 방법 중 하나)
----------------------------------------------------------------------------------------------------------------
포괄 조인                              왼쪽 외부 조인(LEFT OUTER), 오른쪽 외부 조인(RIGHT OUTER)
                                            + 전체 외부 조인(FULL OUTER, 오라클 구문으로는 사용 못함)
----------------------------------------------------------------------------------------------------------------
자체 조인, 비등가 조인                             JOIN ON
----------------------------------------------------------------------------------------------------------------
카테시안(카티션) 곱                        교차 조인(CROSS JOIN)
CARTESIAN PRODUCT


- 미국 국립 표준 협회(American National Standards Institute, ANSI) 미국의 산업 표준을 제정하는 민간단체.
- 국제표준화기구 ISO에 가입되어 있음.
*/
-----------------------------------------------------------------------------------------------------------------------------------------------------
-- JOIN
-- 하나 이상의 테이블에서 데이터를 조회하기 위해 사용.
-- 수행 결과는 하나의 Result Set으로 나옴.


-- (참고) JOIN은 서로 다른 테이블의 행을 하나씩 이어 붙이기 때문에
--       시간이 오래 걸리는 단점이 있다!


/*
- 관계형 데이터베이스에서 SQL을 이용해 테이블간 '관계'를 맺는 방법.


- 관계형 데이터베이스는 최소한의 데이터를 테이블에 담고 있어
  원하는 정보를 테이블에서 조회하려면 한 개 이상의 테이블에서
  데이터를 읽어와야 되는 경우가 많다.
  이 때, 테이블간 관계를 맺기 위한 연결고리 역할이 필요한데,
  두 테이블에서 같은 데이터를 저장하는 컬럼이 연결고리가됨.  
*/


-----------------------------------------------------------------------------------

-- 사번, 이름, 부서코드, 부서명 조회

-- 사번, 이름, 부서코드는 EMPLOYEE 테이블에서 조회 가능
SELECT EMP_ID, EMP_NAME, DEPT_CODE
FROM EMPLOYEE;

SELECT * FROM EMPLOYEE;

-- 부서명은 DEPARTMENT 테이블에서 조회 가능
SELECT * FROM DEPARTMENT;

-- EMPLOYEE 테이블의 DEPT_CODE와
-- DEPARTMENT 테이블의 DEPT_ID를 연결고리 지정
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID);

-- 1. 내부 조인 (INNER JOIN) ( == 등가조인(EQAUL JOIN))
--> 연결되는 컬럼의 값이 일치하는 행들만 조인됨.
--> 일치하는 값이 없는 행은 조인에서 제외됨.

-- 작성 방법은 크게 ANSI 구문과 오라클 구문으로 나뉘고
-- ANSI에서 USING 과 ON 을 쓰는 방법으로 나뉜다.

-- 1) 연결에 사용할 두 컬럼명이 다른 경우 

-- ANSI 
-- 연결에 사용할 컬럼명이 다른 경우(ON)을 사용
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID);

-- 오라클 (등가 조인)
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID;

-- DEPARTMENT테이블, LOCATION 테이블을 참조하여
-- 부서명, 지역명 조회

SELECT * FROM DEPARTMENT;
SELECT * FROM LOCATION;

-- ANSI 방식
SELECT DEPT_TITLE, LOCAL_NAME
FROM DEPARTMENT
JOIN LOCATION ON(LOCATION_ID = LOCAL_CODE);

-- 오라클 방식
SELECT DEPT_TITLE, LOCAL_NAME
FROM DEPARTMENT, LOCATION
WHERE LOCATION_ID = LOCAL_CODE;

-- 2) 연결에 사용할 두 컬럼명이 같은 경우

-- EMPLOYEE, JOB 테이블 참조하여
-- 사번, 이름, 직급코드, 직급명 조회

SELECT * FROM EMPLOYEE;
SELECT * FROM JOB;

-- ANSI 
-- 연결에 사용할 컬럼명이 같은 경우 USING(컬럼명) 을 사용할 수 있다
SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
FROM EMPLOYEE
/*INNER*/JOIN JOB USING(JOB_CODE);

-- 오라클 -> 테이블의 별칭 사용
SELECT EMP_ID, EMP_NAME, E.JOB_CODE, JOB_NAME
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE;
-- SQL Error [918] [42000]: ORA-00918: 열의 정의가 애매합니다

SELECT EMP_ID, EMP_NAME, EMPLOYEE.JOB_CODE, JOB_NAME
FROM EMPLOYEE, JOB
WHERE EMPLOYEE.JOB_CODE = JOB.JOB_CODE;

-- INNER JOIN (내부조인) 의 특징!
--> 연결에 사용된 컬럼의 값이 일치하지 않으면
--> 조회 결과에 포함되지 않는다!

---------------------------------------------------------------------

-- 2. 외부 조인(OUTER JOIN)

-- 두 테이블의 지정하는 컬럼값이 일치하지 않는 행도 조인에 포함 시킴
-- * OUTER JOIN을 반드시 명시해야 한다!

SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
FROM EMPLOYEE
/*INNER*/JOIN JOB USING(JOB_CODE);

-- 1) LEFT [OUTER] JOIN  : 합치기에 사용한 두 테이블 중 왼편에 기술된 테이블의
-- 컬럼수를 기준으로 JOIN 
--> 왼편에 작성된 테이블의 모든행이 결과에 포함되어야 한다.
-- (JOIN 이 안되는 행도 결과에 포함)

-- ANSI 표준
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE LEFT /*OUTER*/ JOIN DEPARTMENT
ON(DEPT_CODE = DEPT_ID); -- 23행(DEPT_CODE가 NULL인 하동운, 이오리 포함)

-- 오라클 구문
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID(+);
-- 반대쪽 테이블 컬럼에 (+) 기호 작성해야 한다!



-- 2) RIGHT [OUTER] JOIN : 합치기에 사용한 두 테이블 중
-- 오른편에 기술된 테이블의 컬럼 수를 기준으로 JOIN

-- ANSI 표준
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE RIGHT /*OUTER*/ JOIN DEPARTMENT
ON(DEPT_CODE = DEPT_ID);
-- 마케팅부, 국내영업부, 해외영업3부와 매칭되는 사원이 EMPLOYEE 테이블에 없음

-- 오라클 구문
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE(+) = DEPT_ID;


-- 3) FULL [OUTER] JOIN : 합치기에 사용한 두 테이블이 가진 모든 행을 결과에 포함
-- ** 오라클 구문 FULL OUTER JOIN 사용 못함 **

-- ANSI 표준
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE FULL JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);

-- 오라클 구문 (없음)
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE(+) = DEPT_ID(+);
-- SQL Error [1468] [72000]: ORA-01468: outer-join된 테이블은 1개만 지정할 수 있습니다

-------------------------------------------------------------------

-- 3. 교차 조인(CROSS JOIN)
-- 조인되는 테이블의 각 행들이 모두 매핑된 데이터가 검색되는 조회 방법 
--> JOIN 구문 잘못 작성하는경우 CROSS JOIN 의 결과가 조회됨

SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE CROSS JOIN DEPARTMENT;`

-------------------------------------------------------------------

-- 4. 비등가 조인(NONE EQUAL JOIN)

-- '=' 등호를 사용하지 않는 조인문
-- 지정한 컬럼값이 일치하는 경우가 아닌, 값의 범위에 포함되는 행들을 연결하는 방식

SELECT * FROM SAL_GRADE;

SELECT EMP_NAME, SAL_LEVEL FROM EMPLOYEE;

-- 사원의 급여에 따른 급여 등급 파악하기
SELECT EMP_NAME, SALARY, SAL_GRADE.SAL_LEVEL
FROM EMPLOYEE
JOIN SAL_GRADE ON(SALARY BETWEEN MIN_SAL AND MAX_SAL);
-- SQL Error [918] [42000]: ORA-00918: 열의 정의가 애매합니다


----------------------------------------------------------------------------

-- 5. 자체 조인(SELF JOIN)

-- 같은 테이블을 조인.
-- 자기 자신과 조인을 맺음.
-- TIP ! 같은 테이블 2개 있다고 생각하고 JOIN 진행
-- 테이블마다 별칭 작성(미작성시 열의 정의가 애매하다는 오류 발생)

-- 사번, 이름, 사수의 사번, 사수 이름 조회
-- 단, 사수가 없으면 '없음', '-' 조회

SELECT * FROM EMPLOYEE;
SELECT * FROM EMPLOYEE;

-- ANSI 표준
SELECT E1.EMP_ID 사번, E1.EMP_NAME 사원이름,
NVL(E1.MANAGER_ID, '없음') "사수의 사번",
NVL(E2.EMP_NAME, '-') "사수의 이름"
FROM EMPLOYEE E1
LEFT JOIN EMPLOYEE E2 ON (E1.MANAGER_ID = E2.EMP_ID);
-- SQL Error [918] [42000]: ORA-00918: 열의 정의가 애매합니다


-- 오라클 구문
SELECT E1.EMP_ID 사번, E1.EMP_NAME 사원이름,
NVL(E1.MANAGER_ID, '없음') "사수의 사번",
NVL(E2.EMP_NAME, '-') "사수의 이름"
FROM EMPLOYEE E1, EMPLOYEE E2
WHERE E1.MANAGER_ID = E2.EMP_ID(+);

------------------------------------------------------------------

-- 6. 자연조인(NATURAL JOIN)
-- 동일한 타입과 이름을 가진 컬럼이 있는 테이블간의
-- 조인을 간단히 표현하는 방법

-- 반드시 두 테이블간의 동일한 컬럼명, 타입을 가진 컬럼이 필요!

--> 없는데도 자연조인을 이용할 경우 교차조인 결과가 조회됨.

SELECT JOB_CODE FROM EMPLOYEE;
SELECT JOB_CODE FROM JOB;

SELECT EMP_NAME, JOB_NAME
FROM EMPLOYEE
--JOIN JOB USING(JOB_CODE);
NATURAL JOIN JOB;

SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE 
NATURAL JOIN DEPARTMENT;
-- EMPLOYEE DEPT_CODE
-- DEPARTMENT DEPT_ID
--> 잘못 조인하면 CROSS JOIN 결과 조회

---------------------------------------------------------------------------

-- 7. 다중 조인
-- N개의 테이블을 조인할 때 사용(순서 중요!!!)

-- 사원 이름, 부서명, 지역명 조회
-- EMP_NAME (EMPLOYEE)
-- DEPT_TITLE (DEPARTMENT)
-- LOCAL_NAME (LOCATION)

SELECT * FROM EMPLOYEE;
SELECT * FROM DEPARTMENT;
SELECT * FROM LOCATION;

-- ANSI 표준
SELECT EMP_NAME, DEPT_TITLE, LOCAL_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE);

-- 오라클 문법
SELECT EMP_NAME, DEPT_TITLE, LOCAL_NAME
FROM EMPLOYEE, DEPARTMENT, LOCATION
WHERE DEPT_CODE = DEPT_ID -- (EMPLOYEE + DEPARTMENT 조인)
AND LOCATION_ID = LOCAL_CODE; -- (EMPLOYEE + DEPARTMENT) + LOCATION 조인


-- [다중 조인 연습 문제]

-- 직급이 대리이면서 아시아 지역에 근무하는 직원 조회(ASIA 시작하는 지역명)
-- 사번, 이름, 직급명, 부서명, 근무지역명, 급여

-- EMPLOYEE
-- JOB
-- DEPARTMENT
-- LOCATION

SELECT * FROM EMPLOYEE;
SELECT * FROM DEPARTMENT;
SELECT * FROM LOCATION;
SELECT * FROM JOB;



SELECT EMP_ID, EMP_NAME, JOB_NAME, DEPT_TITLE, LOCAL_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE) -- EMPLOYEE + JOB
JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID) -- (EMPLOYEE + JOB) + DEPARTMENT
JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE) -- (EMPLOYEE + JOB + DEPARTMENT) + LOCATION
WHERE JOB_NAME = '대리'
AND LOCAL_NAME LIKE 'ASIA%';

-------------------------------------------------------------------

-- 연습문제
SELECT * FROM EMPLOYEE; -- 직원 
SELECT * FROM DEPARTMENT; -- 부서
SELECT * FROM JOB; -- 직급 
SELECT * FROM LOCATION; -- 지역

/* 1. 주민번호가 70년대 생이면서 성별이 여자이고, 성이 '전'씨인 직원들의
	 사원명, 주민번호, 부서명, 직급명을 조회하시오.
	 
	 EMP_NAME : 사원명
	 EMP_NO : 주민번호
	 DEPT_TITLE : 부서명
	 JOB_NAME : 직급명
*/
SELECT EMP_NAME, EMP_NO, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
JOIN JOB USING(JOB_CODE)
WHERE EMP_NO LIKE '7%' -- 70년대생
AND SUBSTR(EMP_NO, 8, 1) = '2' -- 여자
AND EMP_NAME LIKE '전%';



/* 2. 이름에 '형'자가 들어가는 직원들의 사번, 사원명, 직급명, 부서명을
	 조회하시오.
	
	  EMP_ID : 사번
	 EMP_NAME : 사원명
	 JOB_NAME : 직급명
	 DEPT_TITLE : 부서명
*/
SELECT EMP_ID, EMP_NAME, JOB_NAME, DEPT_TITLE
FROM EMPLOYEE 
NATURAL JOIN JOB
JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
WHERE EMP_NAME LIKE '%형%';


/* 3. 해외영업 1부, 2부에 근무하는 사원의 사원명, 직급명, 부서코드, 부서명을
	 조회하시오.
	 
	 EMP_NAME : 사원명
	 JOB_NAME : 직급명
	 DEPT_CODE : 부서코드
	 DEPT_TITLE : 부서명
*/
SELECT EMP_NAME, JOB_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE DEPT_TITLE LIKE '%1부'
DEPT_TITLE LIKE '%2부';


/* 4. 보너스포인트를 받는 직원들의 사원명, 보너스포인트, 부서명, 근무지역명을
	 조회하시오.
	 
	 EMP_NAME : 사원명
	 BONUS : 보너스
	 DEPT_TITLE : 부서명
	 LOCAL_NAME : 지역명
*/
SELECT EMP_NAME, BONUS, DEPT_TITLE, LOCAL_NAME
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
LEFT JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
WHERE BONUS IS NOT NULL;




/* 5. 부서가 있는 사원의 사원명, 직급명, 부서명, 지역명 조회
   
    EMP_NAME : 사원명
    JOB_NAME : 직급명
    DEPT_TITLE : 부서명
    LOCAL_NAME : 지역명
*/
SELECT EMP_NAME, JOB_NAME, DEPT_TITLE, LOCAL_NAME
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
JOIN DEPARTMENT ON(DEPT_ID = DEPT_CODE)
JOIN LOCATION ON(LOCATION_ID = LOCAL_CODE);



/* 6. 급여등급별 최소급여(MIN_SAL)를 초과해서 받는 직원들의 사원명, 직급명,
	 급여, 연봉(보너스포함)을 조회하시오. (연봉에 보너스포인트를 적용하시오.)
	 
	 EMP_NAME : 사원명 
	 JOB_NAME :직급명
	 SALARY : 급여
	 JOB_CODE : 
	 
*/
SELECT EMP_NAME, JOB_NAME, SALARY, 
SALARY * ( 1 + NVL(BONUS, 0) ) * 12 연봉
FROM EMPLOYEE 
JOIN SAL_GRADE USING (SAL_LEVEL)
JOIN JOB USING (JOB_CODE)
WHERE SALARY > MIN_SAL;




/* 7.한국(KO)과 일본(JP)에 근무하는 직원들의 사원명, 부서명, 지역명, 국가명을
	 조회하시오.
	 
	 EMP_NAME : 사원명
	 DEPT_TITLE : 부서명
	 LOCAL_NAME : 지역명 
	 NATIONAL_NAME : 국가명

*/
SELECT EMP_NAME 사원명, DEPT_TITLE 부서명,
LOCAL_NAME 지역명, NATIONAL_NAME 국가명
FROM EMPLOYEE
JOIN DEPARTMENT ON(DEPT_ID = DEPT_CODE)
JOIN LOCATION ON(LOCATION_ID = LOCAL_CODE)
JOIN "NATIONAL" USING(NATIONAL_CODE)
--WHERE NATIONAL_CODE IN ('KO', 'JP');
WHERE NATIONAL_NAME IN ('한국', '일본');




/* 8. 같은 부서에 근무하는 직원들의 사원명, 부서코드, 동료이름을
	 조회하시오.(SELF JOIN 사용)
	 
	 E.EMP_NAME : 사원명
	 E.DEPT_CODE : 부서코드
	 P.EMP_NAME : 동료이름
*/
SELECT E.EMP_NAME 사원명, E.DEPT_CODE 부서코드, P.EMP_NAME 동료이름
FROM EMPLOYEE E
JOIN EMPLOYEE P ON (E.DEPT_CODE = P.DEPT_CODE)
WHERE E.EMP_NAME != P.EMP_NAME
ORDER BY 사원명;




/* 9. 보너스포인트가 없는 직원들 중에서 직급코드가 J4와 J7인 직원들의 사원명,
	 직급명, 급여를 조회하시오. (단, JOIN, IN 사용할 것)
	 
	  EMP_NAME : 사원명 
	  JOB_NAME : 직급명
	  SALARY : 급여
*/
SELECT EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
NATURAL JOIN JOB
WHERE BONUS IS NULL
AND JOB_CODE IN ('J4', 'J7');










