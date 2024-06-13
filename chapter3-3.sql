-- 변환함수

-- 형변환함수
-- 자동형변환을 제공해준다. (문자와 숫자, 문자와 날짜)
SELECT * FROM EMPLOYEES WHERE SALARY >= '10000'; -- 문자 -> 숫자 자동 형변환
SELECT * FROM EMPLOYEES WHERE HIRE_DATE >= '08/01/01';
SELECT * FROM EMPLOYEES WHERE HIRE_DATE >= '080101';

-- 강제형변환
-- TO_CHAR > 날짜를 문자
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD HH:MI:SS') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD AM HH:MI:SS') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'YY년 MM월 DD일') FROM DUAL; -- 년, 월, 일 은 날짜 포맷이 아니라 에러
SELECT TO_CHAR(SYSDATE, 'YY"년" MM"월" DD"일"') FROM DUAL; -- 날짜 포맷이 아닌 문자는 " "로 묶어준다

-- TO_CHAR > 숫자를 문자
SELECT TO_CHAR(20000, '999999999') AS RESULT FROM DUAL; -- 9자리 문자로 표현
SELECT TO_CHAR(20000, '099999999') AS RESULT FROM DUAL; -- 9자리, 빈자리 0으로 채움
SELECT TO_CHAR(20000, '999') AS RESULT FROM DUAL; -- 자리수가 부족하면 # 으로 처리된다.
SELECT TO_CHAR(20000.123, '999999.9999') AS RESULT FROM DUAL; -- 정수 6자리, 실수 4자리
SELECT TO_CHAR(20000, '$9999999') AS RESULT FROM DUAL;
SELECT TO_CHAR(200000, 'L9,999,999') AS RESULT FROM DUAL;

-- 오늘 환율 1372.17원, SALARY 값 원화로 표현
SELECT FIRST_NAME, TO_CHAR(SALARY * 1372.17, 'L999,999,999,999,999') AS WON FROM EMPLOYEES;

-- TO_DATE 문자를 날짜로
SELECT TO_DATE('2024 06 13', 'YYYY MM DD') FROM DUAL; -- 날짜 포맷에 맞춰 정확히 적으면 된다.
SELECT TO_DATE('20240613', 'YYYYMMDD') FROM DUAL;
SELECT SYSDATE-TO_DATE('20240613', 'YYYYMMDD') FROM DUAL;
SELECT TO_DATE('2024년 06월 13일', 'YYYY"년" MM"월" DD"일"') FROM DUAL; -- 날짜 포맷 문자 아니라면 " " 로 감싸준다.
SELECT TO_DATE('24-06-13 11시 30분 23초', 'YYYY-MM-DD HH"시" MI"분" SS"초"') FROM DUAL;

--
SELECT TO_CHAR(TO_DATE('240613', 'YYMMDD'), 'YYYY"년"MM"월"DD"일"') FROM DUAL;

-- TO_NUMBER 문자를 숫자로, 자동형변환 안될때 사용
SELECT '4000' - 3000 FROM DUAL; -- 자동형변환
SELECT '4,000' - 3000 FROM DUAL; -- 자동형변환 안됨
SELECT TO_NUMBER('4,000', '9,999') - 3000 FROM DUAL; -- 명시적 형변환 후 연산
SELECT TO_NUMBER() FROM DUAL;

-- NVL NULL 처리 함수
SELECT NVL (1000, 0), NVL(NULL, 0) FROM DUAL;
SELECT NULL + 1000 FROM DUAL; -- NULL 이 들어간 연산은 NULL 이 나옴

SELECT FIRST_NAME, SALARY, COMMISSION_PCT, SALARY + SALARY*NVL(COMMISSION_PCT, 0) AS TOTAL FROM EMPLOYEES;

-- NVL2 (대상값, 널이 아닌 경우, 널인경우)
SELECT NVL2(NULL, 'NOT NULL', 'YES NULL') FROM DUAL;
SELECT FIRST_NAME, SALARY, COMMISSION_PCT, 
        NVL2(COMMISSION_PCT, SALARY + SALARY * COMMISSION_PCT, SALARY) AS TOTAL 
        FROM EMPLOYEES;

-- COALESCE (값, 값, 값......) NULL 이 아닌 첫 번째 값을 반환 시켜줌
SELECT COALESCE(1,2,3) FROM DUAL;
SELECT COALESCE(NULL, 2, 3, 4) FROM DUAL;
SELECT COALESCE(NULL, NULL, NULL, 3, NULL) FROM DUAL;
SELECT COALESCE(NULL, NULL) FROM DUAL;
SELECT COALESCE(COMMISSION_PCT, 0) FROM EMPLOYEES; -- NVL과 같음

-- DECODE (대상값, 비교값, 결과값, 비교값, 결과값 ....., DEFAULT)
SELECT DECODE('A', 'A', 'A입니다') FROM DUAL;
SELECT DECODE('X', 'A', 'A입니다', 'A가아님') FROM DUAL;
SELECT DECODE('B', 'A', 'A입니다', 'B', 'B입니다', 'C', 'C입니다', '문자가아님') FROM DUAL;

SELECT JOB_ID, DECODE(JOB_ID, 
    'IT_PROG', SALARY * 1.1,
    'AD_VP', SALARY * 1.2,
    'FI_MGR', SALARY * 1.3,
    SALARY) AS 급여
FROM EMPLOYEES;


-- CASE~WHEN~THEN ELSE END (SWITCH 문과 비슷)
SELECT FIRST_NAME, JOB_ID,
    CASE JOB_ID  -- 비교 조건은 CASE에 적는다.
        WHEN 'IT_PROG' THEN SALARY * 1.1
        WHEN 'AD_VP' THEN SALARY * 1.2
        WHEN 'FI_MGR' THEN SALARY *1.3
        ELSE SALARY
    END AS 급여
FROM EMPLOYEES;

SELECT LAST_NAME, JOB_ID,
    CASE
        WHEN JOB_ID = 'IT_PROG' THEN SALARY * 1.1 -- 조건을 WHEN 절에서도 쓸 수 있다.
        WHEN JOB_ID = 'AD_VP' THEN SALARY * 1.2
        WHEN JOB_ID = 'FI_MGR' THEN SALARY *1.3
        ELSE SALARY
    END AS 급여
FROM EMPLOYEES;

-------------------------------------------------------------------------------------
SELECT * FROM EMPLOYEES;
--문제 1.
--현재일자를 기준으로 EMPLOYEE테이블의 입사일자(hire_date)를 참조해서 근속년수가 10년 이상인
--사원을 다음과 같은 형태의 결과를 출력하도록 쿼리를 작성해 보세요. 
--조건 1) 근속년수가 높은 사원 순서대로 결과가 나오도록 합니다.
SELECT 
    EMPLOYEE_ID AS 사원번호, 
    CONCAT(FIRST_NAME, LAST_NAME) AS 사원명,
    HIRE_DATE AS 입사일자,
    TRUNC((SYSDATE - HIRE_DATE)/365) AS 근속년수
FROM EMPLOYEES
WHERE TRUNC((SYSDATE - HIRE_DATE)/365) >= 10
ORDER BY 근속년수 DESC;
--
--문제 2.
--EMPLOYEE 테이블의 manager_id컬럼을 확인하여 first_name, manager_id, 직급을 출력합니다.
--100이라면 ‘부장’ 
--120이라면 ‘과장’
--121이라면 ‘대리’
--122라면 ‘주임’
--나머지는 ‘사원’ 으로 출력합니다.
--조건 1) 부서가 50인 사람들을 대상으로만 조회합니다
--조건 2) DECODE구문으로 표현해보세요.
SELECT FIRST_NAME, MANAGER_ID, 
    DECODE(MANAGER_ID,
    100, '부장',
    120, '과장',
    121, '대리',
    122, '주임',
    '사원') AS 직급
FROM EMPLOYEES
WHERE DEPARTMENT_ID=50;
--조건 3) CASE구문으로 표현해보세요.
SELECT FIRST_NAME, MANAGER_ID, 
    CASE MANAGER_ID
    WHEN 100 THEN '부장'
    WHEN 120 THEN '과장'
    WHEN 121 THEN '대리'
    WHEN 122 THEN '주임'
    ELSE '사원'
    END AS 직급
FROM EMPLOYEES
WHERE DEPARTMENT_ID=50;
--
--문제 3. 
--EMPLOYEES 테이블의 이름, 입사일, 급여, 진급대상 을 출력합니다.
--조건1) HIRE_DATE를 XXXX년XX월XX일 형식으로 출력하세요. 
--조건2) 급여는 커미션값이 퍼센트로 더해진 값을 출력하고, 1300을 곱한 원화로 바꿔서 출력하세요.
--조건3) 진급대상은 5년 마다 이루어 집니다. 근속년수가 5의 배수라면 진급대상으로 출력합니다.
--조건4) 부서가 NULL이 아닌 데이터를 대상으로 출력합니다.
--```
SELECT 
    FIRST_NAME AS 이름,
    TO_CHAR(HIRE_DATE, 'YYYY"년"MM"월"DD"일"') AS 입사일, 
    TO_CHAR(
        NVL2(COMMISSION_PCT, SALARY+SALARY*COMMISSION_PCT, SALARY)*1300, 'L999,999,999'
    ) AS 급여,
    DECODE(
        MOD(TRUNC((SYSDATE - HIRE_DATE)/365), 5), 
        0, '진급대상',
        ' '
    ) AS 진급대상
FROM EMPLOYEES
WHERE DEPARTMENT_ID IS NOT NULL;
