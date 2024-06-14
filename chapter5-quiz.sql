--���� 1.
---EMPLOYEES ���̺��, DEPARTMENTS ���̺��� DEPARTMENT_ID�� ����Ǿ� �ֽ��ϴ�.
---EMPLOYEES, DEPARTMENTS ���̺��� ������� �̿��ؼ�
--���� INNER , LEFT OUTER, RIGHT OUTER, FULL OUTER ���� �ϼ���. (�޶����� ���� ���� Ȯ��)
SELECT *
FROM EMPLOYEES E
JOIN DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENTS_ID;

SELECT *
FROM EMPLOYEES E
LEFT JOIN DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENTS_ID;

SELECT *
FROM EMPLOYEES E
RIGHT JOIN DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENTS_ID;

SELECT *
FROM EMPLOYEES E
FULL JOIN DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENTS_ID;

--���� 2.
---EMPLOYEES, DEPARTMENTS ���̺��� INNER JOIN�ϼ���
--����)employee_id�� 200�� ����� �̸�, department_id�� ����ϼ���
--����)�̸� �÷��� first_name�� last_name�� ���ļ� ����մϴ�
SELECT
    E.FIRST_NAME,
    D.DEPARTMENT_ID
FROM EMPLOYEES E
JOIN DEPARTMENTS D ON E.DEPARTMENT_ID=D.DEPARTMENT_ID
WHERE E.EMPLOYEE_ID=200;

--���� 3.
---EMPLOYEES, JOBS���̺��� INNER JOIN�ϼ���
--����) ��� ����� �̸��� �������̵�, ���� Ÿ��Ʋ�� ����ϰ�, �̸� �������� �������� ����
--HINT) � �÷����� ���� ����� �ִ��� Ȯ��
SELECT
    E.FIRST_NAME,
    E.EMPLOYEE_ID,
    J.JOB_TITLE
FROM EMPLOYEES E
JOIN JOBS J ON E.JOB_ID=J.JOB_ID
ORDER BY E.FIRST_NAME;

--���� 4.
----JOBS���̺�� JOB_HISTORY���̺��� LEFT_OUTER JOIN �ϼ���.
SELECT *
FROM JOBS J
LEFT JOIN JOB_HISTORY H USING(JOB_ID);

--���� 5.
----Steven King�� �μ����� ����ϼ���.
SELECT D.DEPARTMENT_NAME
FROM EMPLOYEES E
JOIN DEPARTMENTS D ON E.DEPARTMENT_ID=D.DEPARTMENT_ID
WHERE E.FIRST_NAME='Steven' AND E.LAST_NAME = 'King';

--���� 6.
----EMPLOYEES ���̺�� DEPARTMENTS ���̺��� Cartesian Product(Cross join)ó���ϼ���
SELECT *
FROM EMPLOYEES
CROSS JOIN DEPARTMENTS;

--����
--���� 7.
----EMPLOYEES ���̺�� DEPARTMENTS ���̺��� �μ���ȣ�� �����ϰ� SA_MAN ������� �����ȣ, �̸�, 
--�޿�, �μ���, �ٹ����� ����ϼ���. (Alias�� ���)
SELECT
    E.EMPLOYEE_ID AS �����ȣ,
    E.FIRST_NAME AS �̸�,
    E.SALARY AS �޿�,
    D.DEPARTMENT_NAME AS �μ���,
    L.STREET_ADDRESS AS �ٹ���
FROM EMPLOYEES E
JOIN DEPARTMENTS D ON E.DEPARTMENT_ID=D.DEPARTMENT_ID
JOIN LOCATIONS L ON D.LOCATION_ID=L.LOCATION_ID
WHERE E.JOB_ID='SA_MAN';

--���� 8.
---- employees, jobs ���̺��� ���� �����ϰ� job_title�� 'Stock Manager', 'Stock Clerk'�� ���� ������
--����ϼ���.
SELECT *
FROM EMPLOYEES E
JOIN JOBS J ON E.JOB_ID=J.JOB_ID
WHERE J.JOB_TITLE='Stock Manager' or J.JOB_TITLE='Stock Clerk';

--���� 9.
---- departments ���̺��� ������ ���� �μ��� ã�� ����ϼ���. LEFT OUTER JOIN ���
SELECT D.DEPARTMENT_NAME
FROM DEPARTMENTS D
LEFT JOIN EMPLOYEES E ON D.DEPARTMENT_ID=E.DEPARTMENT_ID
WHERE D.MANAGER_ID IS NULL;

--���� 10. 
---join�� �̿��ؼ� ����� �̸��� �� ����� �Ŵ��� �̸��� ����ϼ���
--��Ʈ) EMPLOYEES ���̺�� EMPLOYEES ���̺��� �����ϼ���.
SELECT
    E1.FIRST_NAME,
    E2.FIRST_NAME
FROM EMPLOYEES E1
JOIN EMPLOYEES E2 ON E1.MANAGER_ID=E2.EMPLOYEE_ID;

--���� 11. 
----6. EMPLOYEES ���̺��� left join�Ͽ� ������(�Ŵ���)��, �Ŵ����� �̸�, �Ŵ����� �޿� ���� ����ϼ���
----�Ŵ��� ���̵� ���� ����� �����ϰ� �޿��� �������� ����ϼ���
SELECT 
    E1.FIRST_NAME AS �����,
    E1.SALARY AS ����޿�,
    E2.FIRST_NAME AS �Ŵ���,
    E2.SALARY AS �Ŵ���_�޿�
FROM EMPLOYEES E1
LEFT JOIN EMPLOYEES E2 ON E1.MANAGER_ID=E2.EMPLOYEE_ID
WHERE E1.MANAGER_ID IS NOT NULL
ORDER BY E1.SALARY DESC;

--���ʽ� ���� 12.
--���������̽�(William smith)�� ���޵�(�����)�� ���ϼ���.
SELECT 
    CONCAT(E3.FIRST_NAME || ' > ', 
        CONCAT(E2.FIRST_NAME || ' > ', E1.FIRST_NAME)
    ) AS ���
FROM EMPLOYEES E1
JOIN EMPLOYEES E2 ON E1.MANAGER_ID=E2.EMPLOYEE_ID
JOIN EMPLOYEES E3 ON E2.MANAGER_ID=E3.EMPLOYEE_ID
WHERE CONCAT(E1.FIRST_NAME, E1.LAST_NAME)='WilliamSmith';
