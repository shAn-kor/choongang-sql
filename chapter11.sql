-- 뷰
-- 뷰는 제한적인 데이터를 쉽게 보기위해서 미리 만들어논 가상테이블
-- 자주 사용되는 컬럼을 저장하면 관리가 용이하다
-- 뷰는 물리적으로 데이터가 저장된 것이 아니고, 원본테이블을 기반으로 한 가상테이블
SELECT * FROM EMP_DETAILS_VIEW; -- 미리 만들어진 뷰
SELECT * FROM user_sys_privs; -- 유저 권한 확인

-- 단순 뷰 (하나의 테이블로 생성된 뷰)
CREATE OR REPLACE VIEW VIEW_EMP
AS (
   SELECT EMPLOYEE_ID AS EMP_ID,
          FIRST_NAME || ' ' || LAST_NAME NAME,
          JOB_ID,
          SALARY
   FROM EMPLOYEES
   WHERE DEPARTMENT_ID=60
);
SELECT * FROM VIEW_EMP;

-- 복합 뷰 (두개 이상의 테이블로 생성된 뷰)
CREATE OR REPLACE VIEW VIEW_EMP_JOB
AS (
   SELECT E.EMPLOYEE_ID,
          FIRST_NAME || ' ' || LAST_NAME NAME,
          J.JOB_TITLE,
          D.DEPARTMENT_NAME
   FROM EMPLOYEES E
   JOIN DEPARTMENTS D
   ON E.DEPARTMENT_ID=D.DEPARTMENT_ID
   LEFT JOIN JOBS J
   ON J.JOB_ID=E.JOB_ID
);

SELECT *FROM VIEW_EMP_JOB;

-- 뷰를 이용하면, 데이터를 손쉽게 조회할 수 있다.
SELECT JOB_TITLE, COUNT(*) 사원수
FROM VIEW_EMP_JOB
GROUP BY JOB_TITLE;

-- 뷰의 수정
CREATE OR REPLACE VIEW VIEW_EMP_JOB
AS (
   SELECT E.EMPLOYEE_ID,
          FIRST_NAME || ' ' || LAST_NAME NAME,
          J.JOB_TITLE,
          J.MAX_SALARY,
          J.MIN_SALARY,
          D.DEPARTMENT_NAME
   FROM EMPLOYEES E
   JOIN DEPARTMENTS D
   ON E.DEPARTMENT_ID=D.DEPARTMENT_ID
   LEFT JOIN JOBS J
   ON J.JOB_ID=E.JOB_ID
);
SELECT * FROM VIEW_EMP_JOB;

-- 뷰의 삭제 DROP VIEW
DROP VIEW VIEW_EMP_JOB;

-- 단순뷰는 뷰를 통해서 INSERT, UPDATE가 가능한데 조건이 까다롭다. 제약사항이 있다.
SELECT * FROM VIEW_EMP;
-- NAME, EMP_ID가 가상열이기 때문에 INSERT가 들어가지 않음
INSERT INTO VIEW_EMP VALUES(108, 'HONG', 'IT_PROG', 10000);

-- 원본테이블의 NOT NULL 제약조건 위배되어 불가
INSERT INTO VIEW_EMP(JOB_ID, SALARY) VALUES ('IT_PROG', 10000);


-- 뷰의 옵션
-- WITH CHECK OPTION (WHERE 절에 있는 컬럼의 변경 금지)
-- WITH READ ONLY (SELECT 만 허용)
CREATE OR REPLACE VIEW VIEW_EMP
AS (
   SELECT EMPLOYEE_ID,
          FIRST_NAME,
          EMAIL,
          JOB_ID,
          DEPARTMENT_ID
   FROM EMPLOYEES
   WHERE DEPARTMENT_ID IN (60,70,80)
   
) 
--WITH READ ONLY
WITH CHECK OPTION; -- WHERE 조건 절의 값 변경 불가

UPDATE VIEW_EMP SET DEPARTMENT_ID = 10 WHERE EMPLOYEE_ID=103;