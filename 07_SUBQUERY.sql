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
SELECT DEPT_CODE
FROM EMPLOYEE
WHERE EMP_NAME = '노옹철'; -- 'D9'

-- 2) 부서코드가 'D9'인 직원이 이름, 부서코드 조회 (메인쿼리)
SELECT EMP_NAME, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9';

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










































