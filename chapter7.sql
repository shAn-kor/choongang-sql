-- INSERT 
-- 테이블 구조를 빠르게 확인하는 방법
DESC EMPLOYEES; -- DESCRIPT 약자

INSERT INTO DEPARTMENTS VALUES(280, 'DEVELOPER', NULL, 1700);
SELECT * FROM DEPARTMENTS;

-- DML문은 트랜잭션이 항상 기록되는데, ROLLBACK이용해서 되돌릴 수 있다.
ROLLBACK;

-- 2ND (컬럼명만 지정 가능)
INSERT INTO DEPARTMENTS(DEPARTMENT_ID, DEPARTMENT_NAME, LOCATION_ID) VALUES(280, 'DEVELOPER', 1700);
ROLLBACK;

-- INSERT 구문도 서브쿼리 된다. (많이 사용하지는 않음)
INSERT INTO DEPARTMENTS(DEPARTMENT_ID, DEPARTMENT_NAME) 
       VALUES ((SELECT MAX(DEPARTMENT_ID) FROM DEPARTMENTS)+10, 'DEV');
ROLLBACK;

-- INSERT 구문의 서브쿼리 (여러 값)
CREATE TABLE EMPS AS (SELECT * FROM EMPLOYEES WHERE 1=2); -- 테이블 구조 복사
SELECT * FROM EMPS;
INSERT INTO EMPS(EMPLOYEE_ID, LAST_NAME, EMAIL, HIRE_DATE, JOB_ID)
(SELECT EMPLOYEE_ID, LAST_NAME, EMAIL, HIRE_DATE, JOB_ID FROM EMPLOYEES WHERE JOB_ID='SA_MAN');
SELECT*FROM EMPS;
COMMIT; -- 트랜잭션을 반영함

-----------------------------------------------------------------------------
-- UPDATE
-- 업데이트 구문 사용 전, SELECT로 해당 값이 고유한지 확인후 업데이트
UPDATE EMPS SET SALARY=1000, COMMISSION_PCT=0.1 WHERE EMPLOYEE_ID=148; -- KEY를 조건에 적는 것이 일반적
SELECT * FROM EMPS;
UPDATE EMPS SET SALARY=NVL(SALARY, 0) +1000 WHERE EMPLOYEE_ID >= 145;

-- 업데이트 구문의 서브쿼리
-- 1ST (단일값 서브쿼리)
UPDATE EMPS SET SALARY = (SELECT SALARY FROM EMPLOYEES WHERE EMPLOYEE_ID=100) WHERE EMPLOYEE_ID=148;

-- 2ND (여러값 서브쿼리)
UPDATE EMPS SET (SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID) = 
(SELECT SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID FROM EMPLOYEES WHERE EMPLOYEE_ID=100) 
WHERE EMPLOYEE_ID=148;

-- 3RD (WHERE 절에도 가능)
UPDATE EMPS
SET SALARY = 1000
WHERE EMPLOYEE_ID IN (SELECT EMPLOYEE_ID FROM EMPLOYEES WHERE JOB_ID='IT_PROG');

---------------------------------------------------------------------------------
-- DELETE
-- 트랜잭션이 있긴 하지만, 삭제하기전에 반드시 SELECT 문으로 삭제 조건에 해당하는 데이터를 꼭 확인하는 습관을 들이자
SELECT * FROM EMPS;
DELETE FROM EMPS WHERE EMPLOYEE_ID=148; -- KEY를 통해 지우는 편이 좋다.
DELETE FROM EMPS WHERE EMPLOYEE_ID IN (SELECT EMPLOYEE_ID FROM EMPLOYEES WHERE DEPARTMENT_ID=80); -- 내부 쿼리도 이용 가능
ROLLBACK;

-- 테이블이 연관관계 제약을 갖고 있다면, 지우지지 않는다.
-- FK는 반드시 PK에 있는 값이어야 한다.
DELETE FROM DEPARTMENTS WHERE DEPARTMENT_ID=100;


----------------------------------------------------------------------------------
-- MERGE - 타겟 테이블에 데이터가 있으면 업데이트, 없으면 INSERT 구문 수행
MERGE INTO EMPS A
USING (SELECT * FROM EMPLOYEES WHERE JOB_ID='IT_PROG') B
ON (A.EMPLOYEE_ID=B.EMPLOYEE_ID)
WHEN MATCHED THEN
-- UPDATE 다음 테이블 이름 생략가능, 위에 있기 때문
   UPDATE SET A.SALARY=B.SALARY, 
              A.COMMISSION_PCT=B.COMMISSION_PCT,
              A.HIRE_DATE=SYSDATE
WHEN NOT MATCHED THEN
   -- INTO 생략 가능
   INSERT (EMPLOYEE_ID, LAST_NAME, EMAIL, HIRE_DATE, JOB_ID)
   VALUES (B.EMPLOYEE_ID, B.LAST_NAME, B.EMAIL, B.HIRE_DATE, B.JOB_ID);

SELECT * FROM EMPS;
-- MERGE 로 값 추가, 서브쿼리 절에 DUAL 테이블 사용
MERGE INTO EMPS A
USING DUAL
ON (A.EMPLOYEE_ID=107) -- 조건
WHEN MATCHED THEN
   UPDATE SET A.SALARY=10000,
              A.COMMISSION_PCT=0.1,
              A.DEPARTMENT_ID=100
WHEN NOT MATCHED THEN
   INSERT (EMPLOYEE_ID, LAST_NAME, EMAIL, HIRE_DATE, JOB_ID)
   VALUES (107, 'HONG', 'EXAMPLE', SYSDATE, 'DBA');
   
   
------------------------------------------------------------------------------
DROP TABLE EMPS;
-- CTAS(CREATE TABLE AS SELECT) 테이블 구조 복사, WHERE 조건 절에 FALSE 조건 넣는다.
CREATE TABLE EMPS AS (SELECT*FROM EMPLOYEES WHERE 1=2);

-------------------------------------------------------------------------------
--문제 1.
--DEPTS테이블을 데이터를 포함해서 생성하세요.
--DEPTS테이블의 다음을 INSERT 하세요.
DROP TABLE DEPTS;
CREATE TABLE DEPTS AS (SELECT * FROM DEPARTMENTS);
INSERT INTO DEPTS VALUES(280, '개발', (null), 1800);
INSERT INTO DEPTS VALUES(290, '회계부', (null), 1800);
INSERT INTO DEPTS VALUES(300, '재정', 301, 1800);
INSERT INTO DEPTS VALUES(310, '인사', 302, 1800);
INSERT INTO DEPTS VALUES(320, '영업', 303, 1700);
SELECT * FROM DEPTS;

--문제 2.
--DEPTS테이블의 데이터를 수정합니다
--1. department_name 이 IT Support 인 데이터의 department_name을 IT bank로 변경
UPDATE DEPTS SET DEPARTMENT_NAME='IT_bank' WHERE DEPARTMENT_ID=210;
--2. department_id가 290인 데이터의 manager_id를 301로 변경
UPDATE DEPTS SET MANAGER_ID=301 WHERE DEPARTMENT_ID=290;
--3. department_name이 IT Helpdesk인 데이터의 부서명을 IT Help로 , 매니저아이디를 303으로, 지역아이디를
--1800으로 변경하세요
UPDATE DEPTS SET DEPARTMENT_NAME='IT_Help', MANAGER_ID=303, LOCATION_ID=1800 WHERE DEPARTMENT_ID=230;
--4. 이사, 부장, 과장, 대리 의 매니저아이디를 301로 한번에 변경하세요.
UPDATE DEPTS SET MANAGER_ID=301 WHERE DEPARTMENT_ID >= 290;

--문제 3.
--삭제의 조건은 항상 primary key로 합니다, 여기서 primary key는 department_id라고 가정합니다.
--1. 부서명 영업부를 삭제 하세요
DELETE FROM DEPTS WHERE DEPARTMENT_ID=320;
--2. 부서명 NOC를 삭제하세요
DELETE FROM DEPTS WHERE DEPARTMENT_ID=220;

--문제4
--1. Depts 사본테이블에서 department_id 가 200보다 큰 데이터를 삭제해 보세요.
DELETE FROM DEPTS WHERE DEPARTMENT_ID > 200;
--2. Depts 사본테이블의 manager_id가 null이 아닌 데이터의 manager_id를 전부 100으로 변경하세요.
UPDATE DEPTS SET MANAGER_ID=100 WHERE MANAGER_ID IS NOT NULL;

--3. Depts 테이블은 타겟 테이블 입니다.
--4. Departments테이블은 매번 수정이 일어나는 테이블이라고 가정하고 Depts와 비교하여
--일치하는 경우 Depts의 부서명, 매니저ID, 지역ID를 업데이트 하고, 새로유입된 데이터는 그대로 추가해주는 merge문을 작성하세요.
MERGE INTO DEPTS A
USING DEPARTMENTS D
ON (A.DEPARTMENT_ID=D.DEPARTMENT_ID)
WHEN MATCHED THEN
   UPDATE SET A.DEPARTMENT_NAME=D.DEPARTMENT_NAME,
              A.MANAGER_ID=D.MANAGER_ID,
              A.LOCATION_ID=D.LOCATION_ID
WHEN NOT MATCHED THEN
   INSERT (DEPARTMENT_NAME, MANAGER_ID, LOCATION_ID)
   VALUES (D.DEPARTMENT_NAME, D.MANAGER_ID, D.LOCATION_ID);

--문제 5
--1. jobs_it 사본 테이블을 생성하세요 (조건은 min_salary가 6000보다 큰 데이터만 복사합니다)
--2. jobs_it 테이블에 아래 데이터를 추가하세요
--3. obs_it은 타겟 테이블 입니다
--jobs테이블은 매번 수정이 일어나는 테이블이라고 가정하고 jobs_it과 비교하여
--min_salary컬럼이 0보다 큰 경우 기존의 데이터는 min_salary, max_salary를 업데이트 하고 새로 유입된
--데이터는 그대로 추가해주는 merge문을 작성하세요.
CREATE TABLE JOBS_IT AS (SELECT * FROM JOBS WHERE MIN_SALARY > 6000);
INSERT INTO JOBS_IT VALUES('IT_DEV', '아이티개발팀', 6000, 20000);
INSERT INTO JOBS_IT VALUES('NET_DEV', '네트워크개발팀', 5000, 20000);
INSERT INTO JOBS_IT VALUES('SEC_DEV', '보안개발팀', 6000, 19000);

MERGE INTO JOBS_IT A
USING (SELECT * FROM JOBS WHERE MIN_SALARY > 0) J
ON (J.JOB_ID=A.JOB_ID)
WHEN MATCHED THEN
   UPDATE SET A.MIN_SALARY=J.MIN_SALARY,
              A.MAX_SALARY=J.MAX_SALARY
WHEN NOT MATCHED THEN
   INSERT VALUES (J.JOB_ID, J.JOB_TITLE, J.MIN_SALARY, J.MAX_SALARY);







