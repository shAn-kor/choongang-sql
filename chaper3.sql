-- 문자열 함수
SELECT * FROM DUAL; -- DUAL : 가상 테이블, SQL문을 간단하게 연습하기 위함
SELECT LOWER('HELLO WORLD') FROM DUAL; 
SELECT LOWER(FIRST_NAME), UPPER(FIRST_NAME), INITCAP(FIRST_NAME) FROM EMPLOYEES;

-- 문자열 길이 LENGTH()
SELECT FIRST_NAME, LENGTH(FIRST_NAME) FROM EMPLOYEES;
SELECT FIRST_NAME, INSTR(FIRST_NAME, 'a') FROM EMPLOYEES; -- a가 있는 위치 반환, 없으면 0 반환

-- 문자열 자르기
SELECT FIRST_NAME, SUBSTR(FIRST_NAME, 3) FROM EMPLOYEES; -- 3미만 절삭
SELECT FIRST_NAME, SUBSTR(FIRST_NAME, 3, 3) FROM EMPLOYEES; -- 3 부터 3글자

-- 문자열 합치기
SELECT FIRST_NAME || LAST_NAME FROM EMPLOYEES;
SELECT CONCAT(FIRST_NAME, LAST_NAME) FROM EMPLOYEES;

-- LPAD, RPAD - 범위 지정하고, 특정 문자로 채운다.
SELECT LPAD('ABC',10, '*') FROM DUAL;
SELECT LPAD(FIRST_NAME, 10, '*') FROM EMPLOYEES;
SELECT RPAD(FIRST_NAME, 10, '*') FROM EMPLOYEES;

-- LTRIM, RTRIM, TRIM - 문자열 공백 제거 또는 문자 삭제
SELECT TRIM('              HELLO WORLD               ') FROM DUAL;
SELECT LTRIM('              HELLO WORLD               ') FROM DUAL;
SELECT RTRIM('              HELLO WORLD               ') FROM DUAL;
SELECT LTRIM('HELLO WORLD', 'HEL') FROM DUAL;
SELECT RTRIM('HELLO WORLD', 'LD') FROM DUAL;

-- LTRIM, RTRIM 의 경우 중간에서 문자 삭제는 안된다.
SELECT LTRIM('HELLO WORLD', 'WOR') FROM DUAL;
SELECT RTRIM('HELLO WORLD', 'HEL') FROM DUAL;

-- REPLACE 문자열 변경
SELECT REPLACE('서울 대구 대전 부산 찍고', ' ', '->') FROM DUAL; -- 공백을 -> 로 변경
SELECT REPLACE('서울 대구 대전 부산 찍고', ' ', '') FROM DUAL; -- 공백 제거

-------------------------------------------------------------
--문제 1.
--EMPLOYEES 테이블 에서 이름, 입사일자 컬럼으로 변경해서 이름순으로 오름차순 출력 합니다.
--조건 1) 이름 컬럼은 first_name, last_name을 붙여서 출력합니다.
--조건 2) 입사일자 컬럼은 xx/xx/xx로 저장되어 있습니다. xxxxxx형태로 변경해서 출력합니다.
SELECT CONCAT(FIRST_NAME, LAST_NAME) AS NAME, REPLACE(HIRE_DATE, '/', '') FROM EMPLOYEES ORDER BY NAME;

--문제 2.
--EMPLOYEES 테이블 에서 phone_numbe컬럼은 ###.###.####형태로 저장되어 있다
--여기서 처음 세 자리 숫자 대신 서울 지역변호 (02)를 붙여 전화 번호를 출력하도록 쿼리를 작성하세요
SELECT CONCAT('02',SUBSTR(PHONE_NUMBER, 4)) FROM EMPLOYEES;

--문제 3. EMPLOYEES 테이블에서 JOB_ID가 it_prog인 사원의 이름(first_name)과 급여(salary)를 출력하세요.
--조건 1) 비교하기 위한 값은 소문자로 입력해야 합니다.(힌트 : lower 이용)
--조건 2) 이름은 앞 3문자까지 출력하고 나머지는 *로 출력합니다. 
--이 열의 열 별칭은 name입니다.(힌트 : rpad와 substr 또는 substr 그리고 length 이용)
--조건 3) 급여는 전체 10자리로 출력하되 나머지 자리는 *로 출력합니다. 
--이 열의 열 별칭은 salary입니다.(힌트 : lpad 이용)
SELECT RPAD(SUBSTR(FIRST_NAME,1,3),LENGTH(FIRST_NAME),'*') AS name, 
    LPAD(SALARY,10,'*') AS salary FROM EMPLOYEES
    WHERE LOWER(JOB_ID)='it_prog';

