--���� 1.
--EMPLOYEES ���̺��� ��� ������� ��ձ޿����� ���� ������� �����͸� ��� �ϼ��� ( AVG(�÷�) ���)
SELECT *
    FROM EMPLOYEES
    WHERE SALARY > (SELECT AVG(SALARY) FROM EMPLOYEES);
--EMPLOYEES ���̺��� ��� ������� ��ձ޿����� ���� ������� ���� ����ϼ���
SELECT COUNT(*)
FROM (
    SELECT FIRST_NAME
    FROM EMPLOYEES
    WHERE SALARY > (SELECT AVG(SALARY) FROM EMPLOYEES)
);
--EMPLOYEES ���̺��� job_id�� IT_PFOG�� ������� ��ձ޿����� ���� ������� �����͸� ����ϼ���.
SELECT *
FROM EMPLOYEES
WHERE SALARY > (SELECT AVG(SALARY) FROM EMPLOYEES WHERE JOB_ID='IT_PROG');

--���� 2.
--DEPARTMENTS���̺��� manager_id�� 100�� ����� department_id(�μ����̵�) ��
--EMPLOYEES���̺��� department_id(�μ����̵�) �� ��ġ�ϴ� ��� ����� ������ �˻��ϼ���.
SELECT *
FROM EMPLOYEES E
WHERE E.DEPARTMENT_ID IN (SELECT DEPARTMENT_ID FROM DEPARTMENTS D WHERE MANAGER_ID=100);

--���� 3.
--- EMPLOYEES���̺��� ��Pat���� manager_id���� ���� manager_id�� ���� ��� ����� �����͸� ����ϼ���
SELECT *
FROM EMPLOYEES
WHERE MANAGER_ID > ANY(SELECT MANAGER_ID FROM EMPLOYEES WHERE FIRST_NAME='Pat');
--- EMPLOYEES���̺��� ��James��(2��)���� manager_id�� ���� ��� ����� �����͸� ����ϼ���.
SELECT *
FROM EMPLOYEES
WHERE MANAGER_ID IN (SELECT MANAGER_ID FROM EMPLOYEES WHERE FIRST_NAME='James');
--- Steven�� ������ �μ��� �ִ� ������� ������ּ���.
SELECT *
FROM EMPLOYEES
WHERE DEPARTMENT_ID IN (SELECT DEPARTMENT_ID FROM EMPLOYEES WHERE FIRST_NAME='Steven');
--- Steven�� �޿����� ���� �޿��� �޴� ������� ����ϼ���.
SELECT *
FROM EMPLOYEES
WHERE SALARY > ANY (SELECT SALARY FROM EMPLOYEES WHERE FIRST_NAME='Steven');

--���� 4.
--EMPLOYEES���̺� DEPARTMENTS���̺��� left �����ϼ���
--����) �������̵�, �̸�(��, �̸�), �μ����̵�, �μ��� �� ����մϴ�.
--����) �������̵� ���� �������� ����
SELECT E.EMPLOYEE_ID �������̵�,
       CONCAT(E.FIRST_NAME, E.LAST_NAME) �̸�,
       D.DEPARTMENT_ID �μ����̵�,
       D.DEPARTMENT_NAME �μ���
FROM EMPLOYEES E
LEFT JOIN DEPARTMENTS D
ON E.DEPARTMENT_ID=D.DEPARTMENT_ID
ORDER BY E.EMPLOYEE_ID;

--���� 5.
--���� 4�� ����� (��Į�� ����)�� �����ϰ� ��ȸ�ϼ���
SELECT E.EMPLOYEE_ID �������̵�,
       CONCAT(E.FIRST_NAME, E.LAST_NAME) �̸�,
       (SELECT DEPARTMENT_ID FROM DEPARTMENTS D WHERE E.DEPARTMENT_ID=D.DEPARTMENT_ID) �μ����̵�,
       (SELECT DEPARTMENT_NAME FROM DEPARTMENTS D WHERE E.DEPARTMENT_ID=D.DEPARTMENT_ID) �μ���
FROM EMPLOYEES E;

--���� 6.
--DEPARTMENTS���̺� LOCATIONS���̺��� left �����ϼ���
--����) �μ����̵�, �μ��̸�, ��Ʈ��_��巹��, ��Ƽ �� ����մϴ�
--����) �μ����̵� ���� �������� ����
SELECT D.DEPARTMENT_ID �μ����̵�,
       D.DEPARTMENT_NAME �μ���,
       L.STREET_ADDRESS,
       L.CITY
FROM DEPARTMENTS D
LEFT JOIN LOCATIONS L
ON D.LOCATION_ID=L.LOCATION_ID;

--���� 7.
--���� 6�� ����� (��Į�� ����)�� �����ϰ� ��ȸ�ϼ���
SELECT D.DEPARTMENT_ID �μ����̵�,
       D.DEPARTMENT_NAME �μ���,
       (SELECT STREET_ADDRESS FROM LOCATIONS L WHERE D.LOCATION_ID=L.LOCATION_ID),
       (SELECT CITY FROM LOCATIONS L WHERE D.LOCATION_ID=L.LOCATION_ID)
FROM DEPARTMENTS D;

--���� 8.
--LOCATIONS���̺� COUNTRIES���̺��� ��Į�� ������ ��ȸ�ϼ���.
--����) �����̼Ǿ��̵�, �ּ�, ��Ƽ, country_id, country_name �� ����մϴ�
--����) country_name���� �������� ����
SELECT LOCATION_ID �����̼Ǿ��̵�,
       STREET_ADDRESS �ּ�,
       CITY ��Ƽ,
       (SELECT COUNTRY_ID FROM COUNTRIES C WHERE L.COUNTRY_ID=C.COUNTRY_ID),
       (SELECT COUNTRY_NAME FROM COUNTRIES C WHERE L.COUNTRY_ID=C.COUNTRY_ID) COUNTRY_NAME
FROM LOCATIONS L
ORDER BY COUNTRY_NAME;
----------------------------------------------------------------------------------------------------
--���� 9.
--EMPLOYEES���̺� ���� first_name�������� �������� �����ϰ�, 41~50��° �������� �� ��ȣ, �̸��� ����ϼ���
SELECT A.*
FROM (
    SELECT ROWNUM RN,
           E.FIRST_NAME
   FROM (
       SELECT *
       FROM EMPLOYEES
       ORDER BY FIRST_NAME DESC
    )E
)A
WHERE A.RN BETWEEN 41 AND 50;


--���� 10.
--EMPLOYEES���̺��� hire_date�������� �������� �����ϰ�, 31~40��° �������� �� ��ȣ, ���id, �̸�, ��ȣ, 
--�Ի����� ����ϼ���.
SELECT B.*
FROM(
    SELECT ROWNUM AS RN,
           A.*
    FROM (
        SELECT 
               EMPLOYEE_ID,
               FIRST_NAME,
               PHONE_NUMBER,
               HIRE_DATE
        FROM EMPLOYEES
        ORDER BY HIRE_DATE
    ) A
) B
WHERE B.RN BETWEEN 31 AND 40;

--���� 11.
--COMMITSSION�� ������ �޿��� ���ο� �÷����� ����� 10000���� ū ������� �̾� ������. (�ζ��κ並 ���� �˴ϴ�)
SELECT A.*
FROM (
   SELECT E.*, NVL2(COMMISSION_PCT, SALARY+SALARY*COMMISSION_PCT, SALARY) SAL
   FROM EMPLOYEES E
) A
WHERE A.SAL > 10000;

------------------------------------------------------------------------------------------------------------
--����12
--EMPLOYEES���̺�, DEPARTMENTS ���̺��� left�����Ͽ�, �Ի��� �������� �������� 10-20��° �����͸� ����մϴ�.
--����) rownum�� �����Ͽ� ��ȣ, �������̵�, �̸�, �Ի���, �μ��̸� �� ����մϴ�.
--����) hire_date�� �������� �������� ���� �Ǿ�� �մϴ�. rownum�� �������� �ȵǿ�.
SELECT B.*
FROM
(SELECT ROWNUM RN,
       A.*
FROM
(SELECT EMPLOYEE_ID,
       CONCAT(FIRST_NAME,LAST_NAME),
       HIRE_DATE,
       D.DEPARTMENT_NAME
FROM EMPLOYEES E
LEFT JOIN DEPARTMENTS D
ON E.DEPARTMENT_ID=D.DEPARTMENT_ID
ORDER BY HIRE_DATE)A)B
WHERE B.RN BETWEEN 10 AND 20;
SELECT B.*
FROM (
   SELECT ROWNUM RN,
          A.*,
          (SELECT DEPARTMENT_NAME FROM DEPARTMENTS D WHERE D.DEPARTMENT_ID=A.DEPARTMENT_ID)
   FROM (
      SELECT EMPLOYEE_ID,
             CONCAT(FIRST_NAME,LAST_NAME) NAME,
             HIRE_DATE,
             DEPARTMENT_ID
      FROM EMPLOYEES E
      ORDER BY HIRE_DATE
   ) A
) B
WHERE B.RN BETWEEN 10 AND 20;

--����13
--SA_MAN ����� �޿� �������� �������� ROWNUM�� �ٿ��ּ���.
--����) SA_MAN ������� ROWNUM, �̸�, �޿�, �μ����̵�, �μ����� ����ϼ���.
SELECT B.*,
       D.DEPARTMENT_ID,
       D.DEPARTMENT_NAME
FROM(
   SELECT ROWNUM RN,
          A.*
   FROM ( -- �ζ��� ������ ���̺� �ڸ� ���� ��
      SELECT FIRST_NAME,
             SALARY,
             DEPARTMENT_ID
      FROM EMPLOYEES
      WHERE JOB_ID='SA_MAN'
      ORDER BY SALARY DESC
   ) A
) B JOIN DEPARTMENTS D
ON B.DEPARTMENT_ID=D.DEPARTMENT_ID;

--����14
--DEPARTMENTS���̺��� �� �μ��� �μ���, �Ŵ������̵�, �μ��� ���� �ο��� �� ����ϼ���.
--����) �ο��� ���� �������� �����ϼ���.
--����) ����� ���� �μ��� ������� ���� �ʽ��ϴ�.
--��Ʈ) �μ��� �ο��� ���� ���Ѵ�. �� ���̺��� �����Ѵ�.

-- ������ ��
SELECT *
FROM DEPARTMENTS D
JOIN (SELECT COUNT(*) �����, 
       DEPARTMENT_ID
FROM EMPLOYEES GROUP BY DEPARTMENT_ID) E
ON D.DEPARTMENT_ID=E.DEPARTMENT_ID;

-- �� ��
SELECT D.DEPARTMENT_NAME, D.MANAGER_ID, A.CNT
FROM (
   SELECT E.DEPARTMENT_ID, 
          COUNT(E.DEPARTMENT_ID) CNT
   FROM EMPLOYEES E 
   WHERE E.DEPARTMENT_ID IS NOT NULL 
   GROUP BY E.DEPARTMENT_ID
) A JOIN DEPARTMENTS D
ON A.DEPARTMENT_ID=D.DEPARTMENT_ID
ORDER BY CNT DESC;

--����15
--�μ��� ��� �÷�, �ּ�, �����ȣ, �μ��� ��� ������ ���ؼ� ����ϼ���.
--����) �μ��� ����� ������ 0���� ����ϼ���
-- ������ ��
-- �μ��� ��� ����
SELECT TRUNC(AVG(SALARY)) ��տ���, DEPARTMENT_ID
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID;

SELECT D.*, L.STREET_ADDRESS, L.POSTAL_CODE, E.��տ��� 
FROM DEPARTMENTS D
LEFT JOIN LOCATIONS L
ON D.LOCATION_ID=L.LOCATION_ID
JOIN (SELECT TRUNC(AVG(SALARY)) ��տ���, DEPARTMENT_ID
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID) E
ON D.DEPARTMENT_ID=E.DEPARTMENT_ID;

-- �� ��
SELECT A.DEPARTMENT_ID,
       A.NAME,
       A.MANAGER_ID,
       A.STREET_ADDRESS,
       A.POSTCODE,
       NVL2(AVG(A.SALARY), TRUNC(AVG(A.SALARY)), 0) AVERAGE
FROM (
SELECT D.DEPARTMENT_ID DEPARTMENT_ID,
       D.DEPARTMENT_NAME NAME,
       D.MANAGER_ID MANAGER_ID,
       L.LOCATION_ID LOCATION_ID,
       L.STREET_ADDRESS STREET_ADDRESS,
       L.POSTAL_CODE POSTCODE,
       E.SALARY
   FROM DEPARTMENTS D JOIN LOCATIONS L
   ON D.LOCATION_ID=L.LOCATION_ID
   LEFT JOIN EMPLOYEES E
   ON D.DEPARTMENT_ID=E.DEPARTMENT_ID
)A
GROUP BY A.DEPARTMENT_ID, A.NAME, A.MANAGER_ID, A.STREET_ADDRESS, A.POSTCODE;

--����16
--���� 15����� ���� DEPARTMENT_ID�������� �������� �����ؼ� ROWNUM�� �ٿ� 1-10������ ������
--����ϼ���
SELECT C.*
FROM (
   SELECT ROWNUM AS RN,
          B.*
   FROM ( SELECT A.DEPARTMENT_ID,
          A.NAME,
          A.MANAGER_ID,
          A.STREET_ADDRESS,
          A.POSTCODE,
          NVL2(AVG(A.SALARY), TRUNC(AVG(A.SALARY)), 0) AVERAGE
         FROM (
         SELECT D.DEPARTMENT_ID DEPARTMENT_ID,
                D.DEPARTMENT_NAME NAME,
                D.MANAGER_ID MANAGER_ID,
                L.LOCATION_ID LOCATION_ID,
                L.STREET_ADDRESS STREET_ADDRESS,
                L.POSTAL_CODE POSTCODE,
                E.SALARY
            FROM DEPARTMENTS D JOIN LOCATIONS L
            ON D.LOCATION_ID=L.LOCATION_ID
            LEFT JOIN EMPLOYEES E
            ON D.DEPARTMENT_ID=E.DEPARTMENT_ID
         )A
         GROUP BY A.DEPARTMENT_ID, A.NAME, A.MANAGER_ID, A.STREET_ADDRESS, A.POSTCODE
         ORDER BY A.DEPARTMENT_ID DESC
   ) B
) C
WHERE C.RN < 11;