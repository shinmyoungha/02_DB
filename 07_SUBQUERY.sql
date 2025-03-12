/*
 * SUBQUERY (서브쿼리 == 내부쿼리) 
 * 
 * - 하나의 SQL문 안에 포함된 또다른 SQL문
 * - 메인쿼리(== 외부쿼리, 기존쿼리)를 위해 보조역할을 하는 쿼리문
 * 
 * -- 메인쿼리가 SELECT 문일 때
 * -- SELECT, FROM, WHERE, HAVING 절에서 사용 가능
 * 
 * 
 */

-- 서브쿼리 예시1.

-- 부서코드가 노옹철 사원과 같은 부서 소속의 직원의
-- 이름, 부서코드 조회


-- 1) 노옹철 사원의 부서코드 조회(서브쿼리 역할)
SELECT DEPT_CODE                   -- 부서코드 검색
FROM EMPLOYEE                      -- 직원 테이블에서
WHERE EMP_NAME = '노옹철'; -- 'D9'   -- 조건은 사원 이름이 노옹철

-- 2) 부서코드가 'D9'인 직원이 이름, 부서코드 조회 (메인쿼리)
SELECT EMP_NAME, DEPT_CODE         -- 사원 이름, 부서코드 검색
FROM EMPLOYEE                      -- 직원 테이블에서
WHERE DEPT_CODE = 'D9';            -- 조건은 부서코드가 D9

-- 3) 부서코드가 노옹철 사원과 같은 소속의 직원 명단 조회
--> 위의 2개의 단계를 하나의 쿼리로!!
SELECT EMP_NAME, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE = (SELECT DEPT_CODE
									 FROM EMPLOYEE
									 WHERE EMP_NAME = '노옹철');


-- 서브쿼리 예시2.
-- 전 직원의 평균 급여보다 많은 급여를 받고있는 직원의
-- 사번, 이름, 직급코드, 급여 조회

-- 1) 전 직원의 평균 급여 조회 (서브쿼리)
SELECT CEIL(AVG(SALARY))
FROM EMPLOYEE; -- 3,047,663

-- 2) 직원 중 급여가 3,047,663원 이상인 사원들의
-- 사번, 이름, 직급코드, 급여 조회 (메인쿼리)
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE 
WHERE SALARY >= 3047663;

-- 3) 위의 2단계를 하나의 쿼리로!
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE 
WHERE SALARY >= (SELECT CEIL(AVG(SALARY))
								 FROM EMPLOYEE);



-----------------------------------------------------------------------

/* 서브쿼리 유형
 * 
 * - 단일행 (단일열) 서브쿼리 : 서브쿼리의 조회 결과 값의 개수가 1개일 때
 * 
 * - 다중행 (단일열) 서브쿼리 : 서브쿼리의 조회 결과 값의 개수가 여러개일 때
 * 
 * - 다중열 서브쿼리 : 서브쿼리의 SELECT 절에 나열된 항목수가 여러개일 때
 * 
 * - 다중행 다중열 서브쿼리 : 조회 결과 행 수와 열 수가 여러개일 때
 * 
 * - 상(호연)관 서브쿼리 : 서브쿼리가 만든 결과 값을 메인쿼리가 비교 연산할 때
 *           메인쿼리 테이블의 값이 변경되면 
 * 					 서브쿼리의 결과값도 바뀌는 서브쿼리
 * 
 * - 스칼라 서브쿼리 : 상관 쿼리이면서 결과 값이 하나인 서브쿼리
 * 
 * ** 서브쿼리 유형에 따라 서브쿼리 앞에 붙는 연산자가 다름 ** 
 * 
 * */			


---------------------------------------------------------

-- 1. 단일행 서브쿼리 (SINGLE RIW SUBQUERY)
--  서브쿼리의 조회 결과 값의 개수가 1개인 서브쿼리
--  단일행 서브쿼리 앞에는 비교 연산자 사용
--  <, >, <=, >=, =, != / <> / ^=


-- 전 직원의 급여 평균보다 많은(초과) 급여를 받는 직원의
-- 이름, 직급명, 부서명, 급여를 직급 순으로 정렬하여 조회
SELECT * FROM JOB;
SELECT * FROM EMPLOYEE;
SELECT * FROM DEPARTMENT;

SELECT EMP_NAME, JOB_NAME, DEPT_TITLE, SALARY          -- 사원 이름, 직업명, 직급명, 급여
FROM EMPLOYEE                                          -- 사원 테이블
JOIN JOB USING(JOB_CODE)                               -- 조인한다 JOB 테이블이랑    USING(JOB_CODE) : 공통으로 있는 JOB_CODE기준으로
LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)           -- DEPARTMENT 테이블을 EMPLOYEE 테이블에 조인한다  ON(DEPT_CODE = DEPT_ID) : 부서 코드와 부서 아이디를 연결하는 조건
WHERE SALARY > (SELECT AVG(SALARY) FROM EMPLOYEE)      -- 조건문 : 급여가 직원의 평균 급여보다 많이 받냐
ORDER BY JOB_CODE;                                     -- 직급 코드
-- SELECT 절에 명시되지 않은 컬럼이라도
-- FROM, JOIN으로 인해 테이블상 존재하는 컬럼이라면
-- ORDER BY절 사용 가능!


-- 가장 적은 급여를 받는 직원의
-- 사번, 이름, 직급명, 부서코드, 급여, 입사일 조회


-- 서브쿼리 (가장 적은 급여 조회)
SELECT MIN(SALARY) FROM EMPLOYEE; -- 1,380,000

-- 메인쿼리 + 서브쿼리
SELECT EMP_ID, EMP_NAME, JOB_NAME, DEPT_CODE, SALARY, HIRE_DATE      -- 사원 번호, 사원 이름, 직급명, 부서코드, 급여, 입사일
FROM EMPLOYEE                                                        -- 사원 테이블
JOIN JOB USING(JOB_CODE)                                             -- 조인한다 잡 테이블이랑 기준은 JOB_CODE(직급코드)
WHERE SALARY = (SELECT MIN(SALARY) FROM EMPLOYEE);                   -- 조건문 : 급여 = 사원 테이블의 최소 급여
                                                                     
                                                                     
-- 노옹철 사원의 급여보다 많이(초과) 받는 직원의                                  
-- 사번, 이름, 부서명, 직급명, 급여 조회                                      

-- 서브쿼리 (노옹철 사원의 급여 조회)
SELECT SALARY                                                        -- 급여 검색
FROM EMPLOYEE                                                        -- 사원 테이블 
WHERE EMP_NAME = '노옹철';                                             -- 조건문 : 사원 이름이 노옹철

-- 메인쿼리
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, SALARY            -- 사원 번호, 사원 이름, 부서명, 직급명, 급여  검색
FROM EMPLOYEE                                                    -- 사원 테이블
JOIN JOB USING(JOB_CODE)                                         -- 조인한다 잡 테이블이랑 기준은 JOB_CODE(직급코드)
LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)                    -- DEPARTMENT 테이블을 EMPLOYEE 테이블에 조인한다. ON(DEPT_CODE = DEPT_ID) : 부서 코드와 부서 아이디를 연결하는 조건
WHERE SALARY > (SELECT SALARY                                    -- 조건문 : 급여가 노옹철 사원의 급여보다 많이(초과) 받는 직원
							 	FROM EMPLOYEE
							 	WHERE EMP_NAME = '노옹철');

SELECT * FROM DEPARTMENT;
SELECT * FROM JOB;


-- 부서별(부서가 없는 사람 포함) 급여의 합계 중
-- 가장 큰 부서의 부수명, 급여 합계를 조회

-- 1) 부서별 급여 합 중 가장 큰 값 조회 (서브쿼리)
SELECT MAX(SUM(SALARY))
FROM EMPLOYEE
GROUP BY DEPT_CODE; -- 17,700,000

-- 2) 부서별 급여합이 17,700,000인 부서의 부서명과 급여합 조회
SELECT DEPT_TITLE, SUM(SALARY)
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON(DEPT_ID = DEPT_CODE)
GROUP BY DEPT_TITLE
HAVING SUM(SALARY) = 17700000;

-- 3) 위의 두 쿼리를 합쳐 부서별 급여 합이 가장 큰 부서의
-- 부서명, 급여합 조회
SELECT DEPT_TITLE, SUM(SALARY)
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON(DEPT_ID = DEPT_CODE)
GROUP BY DEPT_TITLE
HAVING SUM(SALARY) = (SELECT MAX(SUM(SALARY))
											FROM EMPLOYEE
											GROUP BY DEPT_CODE);


-------------------------------------------------------------
-- 2. 다중행 서브쿼리(MULTI ROW SUBQUERY)
-- 서브쿼리 조회 결과 값의 개수가 여러행일 때

/*
 * >> 다중행 서브쿼리 앞에는 일반 비교연산자 사용 불가
 * 
 * -IN / NOT IN : 여러개의 결과값 중에서 한개라도 일치하는 값이 있다면
 * 								혹은 없다면 이라는 의미 (가장 많이 사용!)
 * 
 * - > ANY, < ANY : 여러개의 결과 값중에서 한개라도 큰 / 작은 경우
 * 							 --> 가장 작은 값보다 큰가? / 가장 큰 값보다 작은가?
 * 
 * -> ALL, < ALL : 여러개의 결과값의 모든 값보다 큰 / 작은 경우
 * 							--> 가장 큰 값보다 큰가? / 가장 작은 값보다 작은가?
 * 
 * 
 * EXISTS / NOT EXISTS : 값이 존재하는가? / 존재하지 않는가?
 *
 * 
 * */

-- 부서별 최고 급여를 받는 직원의
-- 이름, 직급, 부서, 급여를
-- 부서 오름차순으로 정렬하여 조회

-- 부서별 최고 급여 조회 (서브쿼리)
SELECT MAX(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE; -- 7행 1열 (다중행)

-- 메인쿼리 + 서브쿼리
SELECT EMP_NAME, JOB_CODE, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY IN (SELECT MAX(SALARY)
								 FROM EMPLOYEE
								 GROUP BY DEPT_CODE)
ORDER BY DEPT_CODE;


-- 사수에 해당하는 직원에 대해 조회
-- 사번, 이름, 부서명, 직급명, 구분(사수/사원) 조회

-- * 사수 == MANAGER_ID 컬럼에 작성된 사번인 사람
SELECT * FROM EMPLOYEE;

-- 1) 사수에 해당하는 사원번호 조회(서브쿼리)
SELECT DISTINCT MANAGER_ID
FROM EMPLOYEE
WHERE MANAGER_ID IS NOT NULL;

-- 2) 직원의 사번, 이름, 부서명, 직급명 조회하기 (메인쿼리)
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);

-- 3) 사수에 해당하는 직원에 대한 정보 추출 조회 (구분 '사수')
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, '사수' 구분
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE EMP_ID IN (SELECT DISTINCT MANAGER_ID
								 FROM EMPLOYEE
								 WHERE MANAGER_ID IS NOT NULL);

-- 4) 일반 직원에 해당하는 사원들 정보 조회(구분은 '사원')
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, '사원' 구분
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE EMP_ID NOT IN (SELECT DISTINCT MANAGER_ID
								 FROM EMPLOYEE
								 WHERE MANAGER_ID IS NOT NULL);

-- 5) 3, 4 의 조회 결과를 하나로 조회

-- 1. 집합 연산자(UNION 합집합) 사용하기
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, '사수' 구분
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE EMP_ID IN (SELECT DISTINCT MANAGER_ID
								 FROM EMPLOYEE
								 WHERE MANAGER_ID IS NOT NULL)
UNION 
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, '사원' 구분
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE EMP_ID NOT IN (SELECT DISTINCT MANAGER_ID
								 FROM EMPLOYEE
								 WHERE MANAGER_ID IS NOT NULL);

-- 2) 선택함수 사용
-- DECODE();
--> CASE WHEN 조건 1 THEN 값1 .. ELSE END

SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME,
CASE WHEN EMP_ID IN (SELECT DISTINCT MANAGER_ID
								 FROM EMPLOYEE
								 WHERE MANAGER_ID IS NOT NULL)
					 THEN '사수'
					 ELSE '사원'
			END 구분
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
ORDER BY EMP_ID;

-- 대리 직급의 직원들 중에서
-- 과장 직급의 최소 급여보다
-- 많이 받는 직원의
-- 사번, 이름, 직급명, 급여 조회

-- > ANY : 가장 작은 값보다 크냐?

-- 1) 직급이 대리인 지원들의 사번, 이름, 급여 조회(메인쿼리)
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '대리';

-- 2) 직급이 과장인 직원들의 급여 조회(서브쿼리)
SELECT SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '과장';

-- 3) 대리 직급의 직원들 중에서
-- 과장 직급의 최소 급여보다
-- 많이 받는 직원의
-- 사번, 이름, 직급명, 급여 조회

-- 방법 1) ANY 를 이용하기
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '대리'
AND SALARY > ANY (SELECT SALARY
								  FROM EMPLOYEE
								  JOIN JOB USING(JOB_CODE)
								  WHERE JOB_NAME = '과장');

-- 			> ANY : 가장 작은값보다 큰가?
-- > 과장 직급 최소급여보다 큰 급여를 받는 대리인가?

--      < ANY : 가장 큰 값보다 작은가?
-- > 과장 직급 최대급여보다 적은 급여를 받는 대리인가?



-- 대리 직급의 직원들 중에서
-- 과장 직급의 최소 급여보다
-- 많이 받는 직원의
-- 사번, 이름, 직급명, 급여 조회

-- 방법 2) MIN을 이용해서 단일행 서브쿼리로 만듦
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '대리'
AND SALARY > ( SELECT MIN(SALARY)
							 FROM EMPLOYEE
							 JOIN JOB USING(JOB_CODE)
							 WHERE JOB_NAME= '과장');

-- 차장 직급의 급여 중 가장 큰 값보다 많이 받는 과장 직급의 직원
-- 사번, 이름, 직급, 급여 조회

--    > ALL, < ALL : 가장 큰 값보다 크냐? / 가장 작은 값보다 작냐?

-- 서브쿼리
SELECT SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '차장';

-- 메인 쿼리 + 서브 쿼리
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '과장'
AND SALARY > ALL (SELECT SALARY
									FROM EMPLOYEE
									JOIN JOB USING(JOB_CODE)
									WHERE JOB_NAME = '차장');

-- 		 > ALL : 가장 큰 값보다 큰가?
--    > 차장 직급의 최대급여보다 많이 받는 과장인가?

--     < ALL : 가장 작은 값보다 작은가?
--    > 차장 직급의 최소급여보다 적게 받는 과장인가?


-- 서브쿼리 중첩 사용 (응용편!)

-- LOCATION 테이블에서 NATIONAL_CODE가 KO인 경우의 LOCAL_CODE와
-- DEPARTMENT 테이블의 LOCATION_ID와 동일한 DEPT_ID가
-- EMPLOYEE 테이블의 DEPT_CODE와 동일한 사원 조회해라.

-- 1) LOCATION 테이블에서 NATIONAL_CODE가 KO인 경우의 LOCAL_CODE 조회
SELECT LOCAL_CODE
FROM LOCATION
WHERE NATIONAL_CODE = 'KO'; -- L1 (단일행 서브쿼리)



-- 2) DEPARTMENT 테이블에서 위에 나온 결과(L1)와
-- 동일한 LOCATION_ID 가진 DEPT_ID 조회
SELECT DEPT_ID
FROM DEPARTMENT
WHERE LOCATION_ID = (SELECT LOCAL_CODE
										 FROM LOCATION
										 WHERE NATIONAL_CODE = 'KO'); -- 5행

-- 3) 최종적으로 EMPLOYEE 테이블에서 위의 결과들과 동일한 DEPT_CODE를 가진 사원 조회
SELECT EMP_NAME,DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE IN (SELECT DEPT_ID 
										FROM DEPARTMENT 
										WHERE LOCATION_ID = (SELECT LOCAL_CODE 
																				 FROM LOCATION 
																				 WHERE NATIONAL_CODE = 'KO'));

--------------------------------------------------------------

-- 3. (단일행) 다중열 서브쿼리
-- 서브쿼리 SELECT 절에 나열된 컬럼수가 여러개 일 때

-- 퇴사한 여직원과 같은 부터, 같은 직급에 해당하는
-- 사원의 이름, 직급코드, 부서코드, 입사일 조회

-- 1) 퇴사한 여직원 조회
SELECT DEPT_CODE, JOB_CODE
FROM EMPLOYEE
WHERE ENT_YN = 'Y'
AND SUBSTR(EMP_NO, 8, 1) = '2'; -- D8 J6 (이태림)

-- 2) 퇴사한 여직원과 같은 부서, 같은 직급 조회

-- 방법 1) 단일행 단일열 서브쿼리 2개를 사용해서 조회
SELECT DEPT_CODE
FROM EMPLOYEE
WHERE ENT_YN = 'Y'
AND SUBSTR(EMP_NO, 8, 1) = '2';

SELECT JOB_CODE
FROM EMPLOYEE
WHERE ENT_YN = 'Y'
AND SUBSTR(EMP_NO, 8, 1) = '2';

SELECT EMP_NAME, JOB_CODE, DEPT_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE DEPT_CODE = (SELECT DEPT_CODE
									 FROM EMPLOYEE
									 WHERE ENT_YN = 'Y'
									 AND SUBSTR(EMP_NO, 8, 1) = '2')
AND JOB_CODE = (SELECT JOB_CODE
								FROM EMPLOYEE
								WHERE ENT_YN = 'Y'
								AND SUBSTR(EMP_NO, 8, 1) = '2');



-- 방법 2) 다중열 서브쿼리 사용
-- WHERE 절에 작성된 컬럼 순서에 맞게
-- 서브쿼리의 조회된 컬럼과 비교하여 일치하는 행만 조회
-- 컬럼 순서가 중요
SELECT EMP_NAME, JOB_CODE, DEPT_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE (DEPT_CODE, JOB_CODE) = (SELECT DEPT_CODE, JOB_CODE
															 FROM EMPLOYEE
															 WHERE ENT_YN = 'Y'
															 AND SUBSTR(EMP_NO, 8, 1) = '2');


----------------------------- 연습 문제 ----------------------------------
SELECT * FROM EMPLOYEE;
SELECT * FROM DEPARTMENT;
SELECT * FROM JOB;
-- 1. 노옹철 사원과 같은 부서, 같은 직급인 사원을 조회(단, 노옹철 제외)
-- 사번, 이름, 부서코드, 직급코드, 부서명, 직급명
/*
 * EMP_ID : 사번
 * EMP_NAME : 이름
 * DEPT_CODE : 부서코드
 * JOB_CODE : 직급코드
 * DEPT_TITLE : 부서명
 * JOB_NAME : 직급명
 * */
SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
WHERE (DEPT_CODE, JOB_CODE) = (SELECT DEPT_CODE, JOB_CODE
															 FROM EMPLOYEE
															 WHERE EMP_NAME = '노옹철') 
AND EMP_NAME != '노옹철';



-- 2. 2000년도에 입사한 사원의 부서와 직급이 같은 사원을 조회
--    사번, 이름, 부서코드, 직급코드, 입사일
/*
 * EMP_ID : 사번
 * EMP_NAME : 이름
 * DEPT_CODE : 부서코드
 * JOB_CODE : 직급코드
 * DEPT_TITLE : 부서명
 * JOB_NAME : 직급명
 * HIRE_DATE : 입사일
 * */
SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE(DEPT_CODE, JOB_CODE) = (SELECT DEPT_CODE, JOB_CODE
															 FROM EMPLOYEE
															 WHERE EXTRACT(YEAR FROM HIRE_DATE) = 2000);



-- 3. 77년생 여자 사원과 동일한 부서이면서 동일한 사수를 가지고 있는 사원 조회
--    사번, 이름, 부서코드, 사수번호, 주민번호, 입사일

-- 서브쿼리
SELECT DEPT_CODE, MANAGER_ID
FROM EMPLOYEE
WHERE EMP_NO LIKE '77%'
AND SUBSTR(EMP_NO, 8, 1) = '2';

-- 메인쿼리 + 서브쿼리
SELECT EMP_ID, EMP_NAME, DEPT_CODE,
MANAGER_ID, EMP_NO, HIRE_DATE
FROM EMPLOYEE
WHERE (DEPT_CODE, MANAGER_ID) = (SELECT DEPT_CODE, MANAGER_ID
																 FROM EMPLOYEE
																 WHERE EMP_NO LIKE '77%'
																 AND SUBSTR(EMP_NO, 8, 1) = '2');					

-------------------------------------------------------------------------------------------

-- 4. 다중행 다중열 서브쿼리
-- 서브쿼리 조회 결과 행 수와 열 수가 여러개 일 때

-- 본인이 소속된 직급의 평균 급여를 받고있는 직원의
-- 사번, 이름, 직급코드, 급여 조회
-- 단, 급여와 급여 평균은 만원단위로 조회 TRUNC(컬럼명, -4) -- 절삭

-- 1) 직급별 평균 급여 (서브쿼리)
SELECT JOB_CODE, TRUNC(AVG(SALARY), -4)
FROM EMPLOYEE
GROUP BY JOB_CODE;

-- 2) 사번, 이름, 직급코드, 급여 조회 (메인쿼리 + 서브쿼리)
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE (JOB_CODE, SALARY) IN (SELECT JOB_CODE, TRUNC(AVG(SALARY), -4)
														 FROM EMPLOYEE
														 GROUP BY JOB_CODE);



----------------------------------------------------------------------------------------









															 
															 
															 