-- 서브쿼리 (SELECT 구문들의 특정 위치에 다시 SELECT가 들어가는 문장
-- 단일행 서브쿼리 - 서브쿼리의 결과가 1행인 서브쿼리

-- 낸시보다 급여가 높은 사람
-- 1. 낸시의 급여를 찾는다.
-- 2. 찾은 급여를 WHERE 절에 넣는다.
SELECT FIRST_NAME
FROM EMPLOYEES
WHERE SALARY > (SELECT SALARY
FROM EMPLOYEES
WHERE FIRST_NAME='Nancy');

-- 103번과 직업이 같은 사람
SELECT FIRST_NAME
FROM EMPLOYEES
WHERE JOB_ID = (SELECT JOB_ID FROM EMPLOYEES WHERE EMPLOYEE_ID=103);

-- 주의할 점 - 비교할 컬럼은 정확히 한개여야 한다.
SELECT *
FROM EMPLOYEES
WHERE JOB_ID = (SELECT *FROM EMPLOYEES WHERE EMPLOYEE_ID=103);

-- 주의할 점 - 여러행이 나오는 구문이라면, 다중행 서브쿼리 연산자를 써줘야 한다.
SELECT SALARY FROM EMPLOYEES WHERE FIRST_NAME='Steven';
SELECT *
FROM EMPLOYEES
WHERE SALARY >= (SELECT SALARY FROM EMPLOYEES WHERE FIRST_NAME='Steven');

--------------------------------------------------------------------------
-- 다중 행 서브쿼리 - 서브쿼리의 결과가 여러 행 리턴 되는 경우 (IN, ANY, ALL)
SELECT SALARY
FROM EMPLOYEES
WHERE FIRST_NAME='David';

-- 데이비드의 최소 급여보다 많이 받는 사람
SELECT FIRST_NAME
FROM EMPLOYEES
WHERE SALARY > ANY (SELECT SALARY
FROM EMPLOYEES
WHERE FIRST_NAME='David');

-- 데이비드의 최대 급여보다 적게 받는 사람
SELECT FIRST_NAME
FROM EMPLOYEES
WHERE SALARY < ANY (SELECT SALARY
FROM EMPLOYEES
WHERE FIRST_NAME='David');

-- 데이비드 최대 급여보다 많이 받는 사람
SELECT FIRST_NAME
FROM EMPLOYEES
WHERE SALARY > ALL (SELECT SALARY
FROM EMPLOYEES
WHERE FIRST_NAME='David');

-- 데이비드 최소 급여보다 적게 받는 사람
SELECT FIRST_NAME
FROM EMPLOYEES
WHERE SALARY < ALL (SELECT SALARY
FROM EMPLOYEES
WHERE FIRST_NAME='David');


-- IN 다중행 데이터 중, 일치하는 데이터
-- 데이비드와 부서가 같은 사람들
SELECT *
FROM EMPLOYEES
WHERE DEPARTMENT_ID IN (SELECT DEPARTMENT_ID
FROM EMPLOYEES
WHERE FIRST_NAME='David');


--------------------------------------------------------------------------
-- 스칼라 쿼리 - SELECT 문의 서브쿼리가 들어가는 경우 (JOIN 대체)
SELECT FIRST_NAME,
       D.DEPARTMENT_NAME
FROM EMPLOYEES E
LEFT JOIN DEPARTMENTS D
ON E.DEPARTMENT_ID=D.DEPARTMENT_ID;

-- 스칼라로 바꿔보기
SELECT FIRST_NAME,
       (SELECT DEPARTMENT_NAME
       FROM DEPARTMENTS D
       WHERE D.DEPARTMENT_ID=E.DEPARTMENT_ID) AS DEPARTMENT_NAME
FROM EMPLOYEES E;

-- 스칼라 쿼리는 다른 테이블의 1개의 컬럼을 가지고 올때, JOIN보다 구문이 깔끔하다.
SELECT FIRST_NAME,
       (SELECT JOB_TITLE FROM JOBS J WHERE E.JOB_ID=J.JOB_ID) JOB_TITLE
FROM EMPLOYEES E;
---
-- 한번에 하나의 칼럼을 가져오기 때문에 많은 열을 가져올때는 JOIN이 가독성이 낫다.
SELECT FIRST_NAME,
       (SELECT JOB_TITLE FROM JOBS J WHERE E.JOB_ID=J.JOB_ID) JOB_TITLE,
       (SELECT MIN_SALARY FROM JOBS J WHERE E.JOB_ID=J.JOB_ID) MIN_SALARY
FROM EMPLOYEES E;

-- 예시
-- FIRST ANME 컬럼, DEPARTMENT_NAME, JOB_TITLE을 동시에 SELECT
SELECT FIRST_NAME,
       (SELECT DEPARTMENT_NAME FROM DEPARTMENTS D WHERE E.DEPARTMENT_ID=D.DEPARTMENT_ID) DEPARTMENT_NAME,
       (SELECT JOB_TITLE FROM JOBS J WHERE E.JOB_ID=J.JOB_ID) JOB_TITLE
FROM EMPLOYEES E;

-------------------------------------------------------------------------------
-- 인라인 뷰 - FROM 절에 서브쿼리 절이 들어간다.
-- 인라인 뷰에서 (가상컬럼) 을 만들고, 그 컬럼에 대해서 조회해 나갈때 사용한다.

-- ROWNUM 은 조회된 순서에 대해 번호가 붙습니다.
SELECT ROWNUM,
       FIRST_NAME,
       SALARY
FROM EMPLOYEES
ORDER BY SALARY DESC;

-- ORDER를 먼저 시킨 결과에 대해 재조회
SELECT ROWNUM,
FIRST_NAME,
SALARY
FROM (SELECT FIRST_NAME,
       SALARY
FROM EMPLOYEES
ORDER BY SALARY DESC)
WHERE ROWNUM BETWEEN 11 AND 20; -- ROWNUM은 특징이 반드시 1부터 시작 (결과 없음)

-- ORDER BY 를 먼저 시킨 결과를 만들고, ROWNUM 가상열로 다시 만들고, 재조회
SELECT *
FROM (
    SELECT ROWNUM AS RN, -- 가상 열 (인위적으로 생성된 열)
           FIRST_NAME,
           SALARY
    FROM (
        SELECT FIRST_NAME,
               SALARY
        FROM EMPLOYEES
        ORDER BY SALARY DESC
    )
)
WHERE RN BETWEEN 11 AND 20; -- 안에서 RN으로 만들어진 가상열을 밖에서 사용할 수 있다.

-- 예시
-- 근속년수 5년째 되는 사람들만 출력하겠다.
SELECT *
FROM (SELECT FIRST_NAME,
       HIRE_DATE,
       TRUNC((SYSDATE-HIRE_DATE) / 365) AS 근속년수 -- 안에서 만든 가상열에 대해서 재조회 할때 인라인뷰가 사용됨
       FROM EMPLOYEES)
WHERE MOD(근속년수, 5)=0
ORDER BY 근속년수 DESC;

-- 인라인 뷰에서 테이블 앨리어스로 조회
SELECT ROWNUM AS RN,
       A.*
FROM  (SELECT E.*,
       TRUNC((SYSDATE-HIRE_DATE) / 365) AS 근속년수 -- 안에서 만든 가상열에 대해서 재조회 할때 인라인뷰가 사용됨
       FROM EMPLOYEES E
       ORDER BY 근속년수 DESC
) A;