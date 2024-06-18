-- �������� (�÷��� ���� ������ ����, ����, ���� �� �̻��� �����ϱ� ���� ����
-- PRIMARY KEY - ���̺� ����Ű, �ߺ�X, NULL(X), PK�� ���̺��� 1��
-- NOT NULL - NULL ��� X
-- UNIQUE KEY - �ߺ� ��� X, NULL ���
-- FORIEGN KEY - �����ϴ� ���̺��� PK�� �־���� Ű, �ߺ� ���, NULL ���, �⺻Ű �ƴϸ� �ȵȴ�.
-- CHECK - �÷��� ������ ����

-- ��ü �������� Ȯ��
SELECT * FROM USER_CONSTRAINTS;

-- �� ���� ��������
CREATE TABLE DEPTS (
   DEPT_NO NUMBER(2)       CONSTRAINT DEPTS_DEPT_NO_PK PRIMARY KEY,
   DEPT_NAME VARCHAR(30)   CONSTRAINT DEPTS_DEPT_NAME_NN NOT NULL,
   DEPT_DATE DATE          DEFAULT SYSDATE, -- DEFAULT : �⺻�� (�������� �ƴ�)
   DEPT_PHONE VARCHAR(30)  CONSTRAINT DEPTS_DEPT_PHONE_UK UNIQUE,
   DEPT_GENDER CHAR(1)     CONSTRAINT DEPTS_DEPT_GENDER_CK CHECK(DEPT_GENDER IN ('F','M')),
   LOCA_ID NUMBER(4)       CONSTRAINT DEPTS_LOCA_ID_FK REFERENCES LOCATIONS(LOCATION_ID) -- �ܷ�Ű
);
DESC DEPTS;

INSERT INTO DEPTS(DEPT_NO, DEPT_NAME, DEPT_PHONE, DEPT_GENDER, LOCA_ID) 
VALUES (1, NULL, '010..', 'F', 1700); -- NOT NULL �������� ���� ���� �Ұ�

INSERT INTO DEPTS(DEPT_NO, DEPT_NAME, DEPT_PHONE, DEPT_GENDER, LOCA_ID) 
VALUES (1, 'HONG', '010..', 'X', 1700); -- CHECK ���� ����

INSERT INTO DEPTS(DEPT_NO, DEPT_NAME, DEPT_PHONE, DEPT_GENDER, LOCA_ID) 
VALUES (1, 'HONG', '010..', 'F', 100); -- ���� ���� ����, LOCATION_ID �� 100�� ����

INSERT INTO DEPTS(DEPT_NO, DEPT_NAME, DEPT_PHONE, DEPT_GENDER, LOCA_ID) 
VALUES (1, 'HONG', '010..', 'F', 1700); -- ����

--------------------------------------------------------------------------
DROP TABLE DEPTS;

-- ���̺� ���� �������� ����
CREATE TABLE DEPTS (
   DEPT_NO NUMBER(2),
   DEPT_NAME VARCHAR(30) NOT NULL, -- ���� NOT NULL�� �� �������� ����.
   DEPT_DATE DATE DEFAULT SYSDATE, -- DEFAULT : �⺻�� (�������� �ƴ�)
   DEPT_PHONE VARCHAR(30),
   DEPT_GENDER CHAR(1),
   LOCA_ID NUMBER(4),
   CONSTRAINT DEPTS_DEPT_NO_PK PRIMARY KEY(DEPT_NO, DEPT_NAME), -- ����Ű, ���̺� ���������� ���� ����
   CONSTRAINT DEPTS_DEPT_PHONE_UK UNIQUE (DEPT_PHONE),
   CONSTRAINT DEPTS_DEPT_GENDER_CK CHECK(DEPT_GENDER IN ('F','M')),
   CONSTRAINT DEPTS_LOCA_ID_FK FOREIGN KEY(LOCA_ID) 
      REFERENCES LOCATIONS(LOCATION_ID) -- �ܷ�Ű
);

----------------------------------------------------------------------------
CREATE TABLE DEPTS (
   DEPT_NO NUMBER(2),
   DEPT_NAME VARCHAR(30), -- ���� NOT NULL�� �� �������� ����.
   DEPT_DATE DATE DEFAULT SYSDATE, -- DEFAULT : �⺻�� (�������� �ƴ�)
   DEPT_PHONE VARCHAR(30),
   DEPT_GENDER CHAR(1),
   LOCA_ID NUMBER(4)
);
DESC DEPTS;
-- ALTER �� �������� �߰�
-- PK �߰�, ����Ű�� ����
ALTER TABLE DEPTS ADD CONSTRAINT DEPT_DEPT_NO PRIMARY KEY(DEPT_NO);

-- NOT NULL �� �� ���� (MODIFY) �� �߰�
ALTER TABLE DEPTS MODIFY DEPT_NAME VARCHAR2(30) NOT NULL;

-- UNIQUE
ALTER TABLE DEPTS ADD CONSTRAINT DEPT_DEPT_PHONE UNIQUE (DEPT_PHONE);

-- FK �߰�
ALTER TABLE DEPTS ADD CONSTRAINT DEPT_LOCA_ID_FK FOREIGN KEY (LOCA_ID)
   REFERENCES LOCATIONS(LOCATION_ID);
   
-- CHECK �߰�
ALTER TABLE DEPTS ADD CONSTRAINT DEPT_DEPT_GENDER_CK CHECK(DEPT_GENDER IN ('F', 'M'));

-- �������� ����
ALTER TABLE DEPTS DROP CONSTRAINT DEPT_DEPT_GENDER_CK;

-------------------------------------------------------------------------------
--����1.
--������ ���� ���̺��� �����ϰ� �����͸� insert�غ�����.
--���̺� ���������� �Ʒ��� �����ϴ�. 
--����) M_NAME �� ���������� 20byte, �ΰ��� ������� ����
--����) M_NUM �� ������ 5�ڸ�, PRIMARY KEY �̸�(mem_memnum_pk) 
--����) REG_DATE �� ��¥��, �ΰ��� ������� ����, UNIQUE KEY �̸�:(mem_regdate_uk)
--����) GENDER ���������� 1byte, CHECK���� (M, F)
--����) LOCA ������ 4�ڸ�, FOREIGN KEY ? ���� locations���̺�(location_id) �̸�:(mem_loca_loc_locid_fk)
--| M_NAME | M_NUM | REG_DATE | GENDER | LOCA |
--| --- | --- | --- | --- | --- |
--| AAA | 1 | 2018-07-01 | M | 1800 |
--| BBB | 2 | 2018-07-02 | F | 1900 |
--| CCC | 3 | 2018-07-03 | M | 2000 |
--| DDD | 4 | ���ó�¥ | M | 2000 |
CREATE TABLE TABLE1 (
   M_NAME VARCHAR(20) NOT NULL,
   M_NUM NUMBER(5) CONSTRAINT MEM_MEMNUM_PK PRIMARY KEY,
   REG_DATE DATE CONSTRAINT MEM_REGDATE_UK UNIQUE,
   GENDER CHAR(1) CONSTRAINT GENDER_CHK CHECK(GENDER IN ('F','M')),
   LOCA NUMBER(4) CONSTRAINT MEM_LOCA_LOC_LOCID_FK REFERENCES LOCATIONS(LOCATION_ID)
);
DESC TABLE1;
INSERT INTO TABLE1 VALUES('AAA', 1, '2018-07-01', 'M', 1800);
INSERT INTO TABLE1 VALUES('BBB', 2, '2018-07-02', 'F', 1900);
INSERT INTO TABLE1 VALUES('CCC', 3, '2018-07-03', 'M', 2000);
INSERT INTO TABLE1 VALUES('DDD', 4, SYSDATE, 'F', 2000);
SELECT * FROM TABLE1;

--����2.
--
--���� �뿩 �̷� ���̺��� �����Ϸ� �մϴ�.
--���� �뿩 �̷� ���̺���
--�뿩��ȣ(����) PK, ���⵵����ȣ(����), �뿩��(��¥), �ݳ���(��¥), �ݳ�����(Y/N)
--�� �����ϴ�.
--������ ���̺��� ������ ������.
CREATE TABLE TABLE2 (
   B_NUM NUMBER(4) CONSTRAINT B_NUM_PK PRIMARY KEY,
   BOOK_NUM VARCHAR(10) NOT NULL,
   B_DATE DATE DEFAULT SYSDATE,
   R_DATE DATE DEFAULT SYSDATE+7,
   R_CHK CHAR(1) CONSTRAINT  R_CHK_CHK CHECK(R_CHK IN ('Y','N'))
);