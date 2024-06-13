-- 집합연산자
/*
UNION - 합집합, 중복X
UNION ALL - 합집합, 중복 허용
INTERSECT - 교집합
MINUS - 차집합

컬럼 개수가 일치해야 집합 연산자 사용이 가능하다.
*/
SELECT FIRST_NAME, HIRE_DATE FROM EMPLOYEES WHERE HIRE_DATE LIKE '%04%'
UNION
SELECT FIRST_NAME, HIRE_DATE FROM EMPLOYEES WHERE DEPARTMENT_ID = 20;
---------------------------------------------------------------------
SELECT FIRST_NAME, HIRE_DATE FROM EMPLOYEES WHERE HIRE_DATE LIKE '%04%'
UNION ALL
SELECT FIRST_NAME, HIRE_DATE FROM EMPLOYEES WHERE DEPARTMENT_ID = 20;
---------------------------------------------------------------------
SELECT FIRST_NAME, HIRE_DATE FROM EMPLOYEES WHERE HIRE_DATE LIKE '%04%'
INTERSECT
SELECT FIRST_NAME, HIRE_DATE FROM EMPLOYEES WHERE DEPARTMENT_ID = 20;
---------------------------------------------------------------------
SELECT FIRST_NAME, HIRE_DATE FROM EMPLOYEES WHERE HIRE_DATE LIKE '%04%'
MINUS
SELECT FIRST_NAME, HIRE_DATE FROM EMPLOYEES WHERE DEPARTMENT_ID = 20;
---------------------------------------------------------------------

-- 집합연산자는 DUAL 같은 가상 데이터를 만들어서 합칠 수 있다.
SELECT 200, 'HONG', '서울시' FROM DUAL
UNION 
SELECT 300, 'LEE', '경기도' FROM DUAL
UNION 
SELECT EMPLOYEE_ID, LAST_NAME, '서울시' FROM EMPLOYEES;


---------------------------------------------------------------------
-- 분석함수
-- 분석함수() OVER (정렬 방법)
SELECT 
    FIRST_NAME,
    SALARY,
    RANK() OVER(ORDER BY SALARY DESC) AS 중복순서계산, -- 중복 순위 계산
    DENSE_RANK() OVER(ORDER BY SALARY DESC) AS 중복없는등수, -- 중복 순위 계산 X
    ROW_NUMBER() OVER (ORDER BY SALARY DESC) AS 일련번호,
    ROWNUM AS 조회순서 -- 조회가 된 순서
FROM EMPLOYEES;

-- ROWNUM 은 ORDER 시킬 때 결과가 바뀐다.
SELECT ROWNUM,
FIRST_NAME,
SALARY
FROM EMPLOYEES
ORDER BY SALARY DESC;