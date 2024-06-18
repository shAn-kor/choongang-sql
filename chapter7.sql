-- INSERT 
-- ���̺� ������ ������ Ȯ���ϴ� ���
DESC EMPLOYEES; -- DESCRIPT ����

INSERT INTO DEPARTMENTS VALUES(280, 'DEVELOPER', NULL, 1700);
SELECT * FROM DEPARTMENTS;

-- DML���� Ʈ������� �׻� ��ϵǴµ�, ROLLBACK�̿��ؼ� �ǵ��� �� �ִ�.
ROLLBACK;

-- 2ND (�÷��� ���� ����)
INSERT INTO DEPARTMENTS(DEPARTMENT_ID, DEPARTMENT_NAME, LOCATION_ID) VALUES(280, 'DEVELOPER', 1700);
ROLLBACK;

-- INSERT ������ �������� �ȴ�. (���� ��������� ����)
INSERT INTO DEPARTMENTS(DEPARTMENT_ID, DEPARTMENT_NAME) 
       VALUES ((SELECT MAX(DEPARTMENT_ID) FROM DEPARTMENTS)+10, 'DEV');
ROLLBACK;

-- INSERT ������ �������� (���� ��)
CREATE TABLE EMPS AS (SELECT * FROM EMPLOYEES WHERE 1=2); -- ���̺� ���� ����
SELECT * FROM EMPS;
INSERT INTO EMPS(EMPLOYEE_ID, LAST_NAME, EMAIL, HIRE_DATE, JOB_ID)
(SELECT EMPLOYEE_ID, LAST_NAME, EMAIL, HIRE_DATE, JOB_ID FROM EMPLOYEES WHERE JOB_ID='SA_MAN');
SELECT*FROM EMPS;
COMMIT; -- Ʈ������� �ݿ���

-----------------------------------------------------------------------------
-- UPDATE
-- ������Ʈ ���� ��� ��, SELECT�� �ش� ���� �������� Ȯ���� ������Ʈ
UPDATE EMPS SET SALARY=1000, COMMISSION_PCT=0.1 WHERE EMPLOYEE_ID=148; -- KEY�� ���ǿ� ���� ���� �Ϲ���
SELECT * FROM EMPS;
UPDATE EMPS SET SALARY=NVL(SALARY, 0) +1000 WHERE EMPLOYEE_ID >= 145;

-- ������Ʈ ������ ��������
-- 1ST (���ϰ� ��������)
UPDATE EMPS SET SALARY = (SELECT SALARY FROM EMPLOYEES WHERE EMPLOYEE_ID=100) WHERE EMPLOYEE_ID=148;

-- 2ND (������ ��������)
UPDATE EMPS SET (SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID) = 
(SELECT SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID FROM EMPLOYEES WHERE EMPLOYEE_ID=100) 
WHERE EMPLOYEE_ID=148;

-- 3RD (WHERE ������ ����)
UPDATE EMPS
SET SALARY = 1000
WHERE EMPLOYEE_ID IN (SELECT EMPLOYEE_ID FROM EMPLOYEES WHERE JOB_ID='IT_PROG');

---------------------------------------------------------------------------------
-- DELETE
-- Ʈ������� �ֱ� ������, �����ϱ����� �ݵ�� SELECT ������ ���� ���ǿ� �ش��ϴ� �����͸� �� Ȯ���ϴ� ������ ������
SELECT * FROM EMPS;
DELETE FROM EMPS WHERE EMPLOYEE_ID=148; -- KEY�� ���� ����� ���� ����.
DELETE FROM EMPS WHERE EMPLOYEE_ID IN (SELECT EMPLOYEE_ID FROM EMPLOYEES WHERE DEPARTMENT_ID=80); -- ���� ������ �̿� ����
ROLLBACK;

-- ���̺��� �������� ������ ���� �ִٸ�, �������� �ʴ´�.
-- FK�� �ݵ�� PK�� �ִ� ���̾�� �Ѵ�.
DELETE FROM DEPARTMENTS WHERE DEPARTMENT_ID=100;


----------------------------------------------------------------------------------
-- MERGE - Ÿ�� ���̺� �����Ͱ� ������ ������Ʈ, ������ INSERT ���� ����
MERGE INTO EMPS A
USING (SELECT * FROM EMPLOYEES WHERE JOB_ID='IT_PROG') B
ON (A.EMPLOYEE_ID=B.EMPLOYEE_ID)
WHEN MATCHED THEN
-- UPDATE ���� ���̺� �̸� ��������, ���� �ֱ� ����
   UPDATE SET A.SALARY=B.SALARY, 
              A.COMMISSION_PCT=B.COMMISSION_PCT,
              A.HIRE_DATE=SYSDATE
WHEN NOT MATCHED THEN
   -- INTO ���� ����
   INSERT (EMPLOYEE_ID, LAST_NAME, EMAIL, HIRE_DATE, JOB_ID)
   VALUES (B.EMPLOYEE_ID, B.LAST_NAME, B.EMAIL, B.HIRE_DATE, B.JOB_ID);

SELECT * FROM EMPS;
-- MERGE �� �� �߰�, �������� ���� DUAL ���̺� ���
MERGE INTO EMPS A
USING DUAL
ON (A.EMPLOYEE_ID=107) -- ����
WHEN MATCHED THEN
   UPDATE SET A.SALARY=10000,
              A.COMMISSION_PCT=0.1,
              A.DEPARTMENT_ID=100
WHEN NOT MATCHED THEN
   INSERT (EMPLOYEE_ID, LAST_NAME, EMAIL, HIRE_DATE, JOB_ID)
   VALUES (107, 'HONG', 'EXAMPLE', SYSDATE, 'DBA');
   
   
------------------------------------------------------------------------------
DROP TABLE EMPS;
-- CTAS(CREATE TABLE AS SELECT) ���̺� ���� ����, WHERE ���� ���� FALSE ���� �ִ´�.
CREATE TABLE EMPS AS (SELECT*FROM EMPLOYEES WHERE 1=2);

-------------------------------------------------------------------------------
--���� 1.
--DEPTS���̺��� �����͸� �����ؼ� �����ϼ���.
--DEPTS���̺��� ������ INSERT �ϼ���.
DROP TABLE DEPTS;
CREATE TABLE DEPTS AS (SELECT * FROM DEPARTMENTS);
INSERT INTO DEPTS VALUES(280, '����', (null), 1800);
INSERT INTO DEPTS VALUES(290, 'ȸ���', (null), 1800);
INSERT INTO DEPTS VALUES(300, '����', 301, 1800);
INSERT INTO DEPTS VALUES(310, '�λ�', 302, 1800);
INSERT INTO DEPTS VALUES(320, '����', 303, 1700);
SELECT * FROM DEPTS;

--���� 2.
--DEPTS���̺��� �����͸� �����մϴ�
--1. department_name �� IT Support �� �������� department_name�� IT bank�� ����
UPDATE DEPTS SET DEPARTMENT_NAME='IT_bank' WHERE DEPARTMENT_ID=210;
--2. department_id�� 290�� �������� manager_id�� 301�� ����
UPDATE DEPTS SET MANAGER_ID=301 WHERE DEPARTMENT_ID=290;
--3. department_name�� IT Helpdesk�� �������� �μ����� IT Help�� , �Ŵ������̵� 303����, �������̵�
--1800���� �����ϼ���
UPDATE DEPTS SET DEPARTMENT_NAME='IT_Help', MANAGER_ID=303, LOCATION_ID=1800 WHERE DEPARTMENT_ID=230;
--4. �̻�, ����, ����, �븮 �� �Ŵ������̵� 301�� �ѹ��� �����ϼ���.
UPDATE DEPTS SET MANAGER_ID=301 WHERE DEPARTMENT_ID >= 290;

--���� 3.
--������ ������ �׻� primary key�� �մϴ�, ���⼭ primary key�� department_id��� �����մϴ�.
--1. �μ��� �����θ� ���� �ϼ���
DELETE FROM DEPTS WHERE DEPARTMENT_ID=320;
--2. �μ��� NOC�� �����ϼ���
DELETE FROM DEPTS WHERE DEPARTMENT_ID=220;

--����4
--1. Depts �纻���̺��� department_id �� 200���� ū �����͸� ������ ������.
DELETE FROM DEPTS WHERE DEPARTMENT_ID > 200;
--2. Depts �纻���̺��� manager_id�� null�� �ƴ� �������� manager_id�� ���� 100���� �����ϼ���.
UPDATE DEPTS SET MANAGER_ID=100 WHERE MANAGER_ID IS NOT NULL;

--3. Depts ���̺��� Ÿ�� ���̺� �Դϴ�.
--4. Departments���̺��� �Ź� ������ �Ͼ�� ���̺��̶�� �����ϰ� Depts�� ���Ͽ�
--��ġ�ϴ� ��� Depts�� �μ���, �Ŵ���ID, ����ID�� ������Ʈ �ϰ�, �������Ե� �����ʹ� �״�� �߰����ִ� merge���� �ۼ��ϼ���.
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

--���� 5
--1. jobs_it �纻 ���̺��� �����ϼ��� (������ min_salary�� 6000���� ū �����͸� �����մϴ�)
--2. jobs_it ���̺� �Ʒ� �����͸� �߰��ϼ���
--3. obs_it�� Ÿ�� ���̺� �Դϴ�
--jobs���̺��� �Ź� ������ �Ͼ�� ���̺��̶�� �����ϰ� jobs_it�� ���Ͽ�
--min_salary�÷��� 0���� ū ��� ������ �����ʹ� min_salary, max_salary�� ������Ʈ �ϰ� ���� ���Ե�
--�����ʹ� �״�� �߰����ִ� merge���� �ۼ��ϼ���.
CREATE TABLE JOBS_IT AS (SELECT * FROM JOBS WHERE MIN_SALARY > 6000);
INSERT INTO JOBS_IT VALUES('IT_DEV', '����Ƽ������', 6000, 20000);
INSERT INTO JOBS_IT VALUES('NET_DEV', '��Ʈ��ũ������', 5000, 20000);
INSERT INTO JOBS_IT VALUES('SEC_DEV', '���Ȱ�����', 6000, 19000);

MERGE INTO JOBS_IT A
USING (SELECT * FROM JOBS WHERE MIN_SALARY > 0) J
ON (J.JOB_ID=A.JOB_ID)
WHEN MATCHED THEN
   UPDATE SET A.MIN_SALARY=J.MIN_SALARY,
              A.MAX_SALARY=J.MAX_SALARY
WHEN NOT MATCHED THEN
   INSERT VALUES (J.JOB_ID, J.JOB_TITLE, J.MIN_SALARY, J.MAX_SALARY);







