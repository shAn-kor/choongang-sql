-- ������ (���������� �����ϴ� ��)
-- �ַ� PK�� ���� ����

-- HR ���� ������ ��� ��ȸ
SELECT * FROM USER_SEQUENCES;

-- ������ ����
CREATE SEQUENCE DEPTS_SEQ
   INCREMENT BY 1
   START WITH 1
   MAXVALUE 10
   NOCACHE -- ĳ�ÿ� ������ ���� ����
   NOCYCLE; -- �ִ밪 ���� �� ���� ����

DROP TABLE DEPTS;

CREATE TABLE DEPTS (
   DEPT_NO NUMBER(2) PRIMARY KEY,
   DEPT_NAME VARCHAR(30)
);

-- ������ ��� ��� 2����
SELECT DEPTS_SEQ.CURRVAL FROM DUAL; -- ���� ������ , NEXTVAL ���� ����Ǿ���
SELECT DEPTS_SEQ.NEXTVAL FROM DUAL; -- ���� ������ ��������ŭ ����

-- SEQUENCE ����
INSERT INTO DEPTS VALUES(DEPTS_SEQ.NEXTVAL, 'EXAMPLE'); -- ������ �� ���� �� �̻� �߰� �Ұ�
SELECT * FROM DEPTS;

-- ������ ����
ALTER SEQUENCE DEPTS_SEQ MAXVALUE 1000;
ALTER SEQUENCE DEPTS_SEQ INCREMENT BY 10;

-- �������� �̹� ��� ���� ��� DROP �ϸ� �ȵȴ�.
DROP SEQUENCE DEPTS_SEQ; -- �Ǳ�� �Ѵ�.

-- �������� �ʱ�ȭ�ؾ� �� ���
-- ������ �������� ������ ����� �ʱ�ȭ �ΰ� ó�� ���� �ִ�.
ALTER SEQUENCE DEPTS_SEQ INCREMENT BY -69;
ALTER SEQUENCE DEPTS_SEQ INCREMENT BY 1;

-----------------------------------------------------------------------------
-- ������ ���� (���߿� ���̺� ���� �� �����Ͱ� ��û ���ٸ� PK�� ������ ��� ���)
-- ���ڿ� PK (�⵵��-�Ϸù�ȣ)

CREATE TABLE DEPTS2 (
 DEPT_NO VARCHAR2(20) PRIMARY KEY,
 DEPT_NAME VARCHAR2(20)
 );
 INSERT INTO DEPTS2 VALUES(TO_CHAR(SYSDATE,'YYYY-MM')||LPAD(DEPTS_SEQ.NEXTVAL,6,0), 'EXAMPLE');
 SELECT * FROM DEPTS2;
 
 ---------------------------------------------------------------------------
 -- INDEX
 -- INDEX�� PK, UNIQUE�� �ڵ����� �����ǰ�, ��ȸ�� ������ �ϴ� HINT ����
 -- INDEX ������ �����ε���, ������ε��� �� �ִ�.
 -- UNIQUE�� �÷��� ���� �ε����� ���δ�.
 -- �Ϲ� �÷����� ����� �ε����� ���δ�.
 -- INDEX�� ��ȸ�� ������ ������, DML ������ ���� ���Ǵ� �÷��� ������ �������ϸ� �θ���.
 
 -- �ε��� ����
 CREATE TABLE EMPS_IT AS (SELECT * FROM EMPLOYEES);
 
 -- �ε��� ���� �� ��ȸ
 SELECT * FROM EMPS_IT WHERE FIRST_NAME='Nancy';
 
 -- ����� �ε��� ����
 CREATE INDEX EMPS_IT_IX ON EMPS_IT (FIRST_NAME);
 
 -- �ε��� ���� �� ��ȸ
 SELECT * FROM EMPS_IT WHERE FIRST_NAME='Nancy';
 
 
 -- �ε��� ���� (���̺� ���� ����)
DROP INDEX EMPS_IT_IX;

-- ���� �ε��� (������ �÷��� ���ÿ� �ε����� ����)
CREATE INDEX EMPS_IT_IX ON EMPLOYEES (FIRST_NAME, LAST_NAME);

SELECT * FROM EMPLOYEES WHERE FIRST_NAME='Nancy'; -- ��Ʈ ����
SELECT * FROM EMPLOYEES WHERE FIRST_NAME='Nancy' AND LAST_NAME='Greenberg'; -- ��Ʈ ����
SELECT * FROM EMPLOYEES WHERE LAST_NAME='Greenberg';-- ��Ʈ ����

-- �����ε��� (PK, UNIQUE���� �ڵ� ����)
-- CREATE UNIQUE INDEX �ε�����
